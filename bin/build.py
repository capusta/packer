#! /usr/bin/env python
import argparse
from logging.handlers import RotatingFileHandler
import logging
import sys
import time
import os
import platform
import json
"""
    Generates a virtualbox image
"""
if len(sys.argv) == 1:
    print "Please use -h for usage"
    print "Using defaults: --hostname devbox --codename trusty"
    time.sleep(2)

logger = logging.getLogger("Rotating Log")
logger.setLevel(logging.INFO)
handler = RotatingFileHandler('logs/build.log',maxBytes=10*1024,backupCount=5)
logger.addHandler(handler)

def log(s):
    print(time.strftime("%y-%m-%d:%H-%M: ")+ s)
    logger.info(time.strftime("%y-%m-%d:%H-%M: ")+ s)

## some global variables to help with ubuntu devs
md5command=''
md5sum=''
myOS=''
if (os.name == 'posix' and platform.system() == 'Darwin'):
    # Set up any mac variables here
    log("System is mac")
    myOS       = 'mac'
    md5command = 'md5'
else:
    # Set up Linux? variables here
    log("System is Ubuntu")
    myOS       = 'Debian'
    md5command = 'md5sum'

parser = argparse.ArgumentParser()
parser.add_argument("--hostname", nargs=1,   help='Set the hostname of the box, default is  devbox', default=['devbox'])
parser.add_argument("--download", nargs='?', help='Download the ISO From Ubuntu', default=False)
parser.add_argument("--codename", nargs='?', help="Choose between xenial and trusty", default='trusty')
args = vars(parser.parse_args());

import subprocess
log("Using hostname %s" % args['hostname'][0])

# NO case in python :(
CODENAME=args['codename']
if CODENAME == 'trusty32':
    DWBASE = 'http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-i386/current/images/netboot'
    DWFILE = 'mini.iso'
    # Our teimplates in ./http dir use the codename without the arch
    CODENAME = 'trusty'
elif 'trusty' in CODENAME:
    # Default case for trusty
    DWBASE = 'http://releases.ubuntu.com/14.04'
    DWFILE = 'ubuntu-14.04.5-server-amd64.iso'
    CODENAME = 'trusty'
elif CODENAME == 'xenial32':
    DWBASE = 'http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-i386/current/images/netboot'
    DWFILE = 'mini.iso'
    CODENAME = 'xenial'
else:
    DWBASE = 'http://releases.ubuntu.com/16.04'
    DWFILE = 'ubuntu-16.04.2-server-amd64.iso'
    CODENAME = 'xenial'

if args['download'] == None:
    log("Downloading Image")
    p2 = subprocess.Popen(['which','wget'])
    p2.communicate()[0]
    if p2.returncode == 1:
        log("Cannot find wget - make sure to install wget 'brew install wget' if this is a mac")
        exit()
    # TODO: account for other operating systems
    P = subprocess.Popen(['wget', '-v', '-N', '-P', 'iso', '--progress=bar', DWBASE+"/"+DWFILE])
    P = subprocess.Popen([md5command, 'iso/'+DWFILE])
    print P.communicate()[1]
try:
    log('Checking md5sum for %s' % DWFILE)
    if myOS == 'Debian':
        log("System is Debian, using %s command" % md5command)
        MD5SUM = subprocess.check_output([md5command, 'iso/'+DWFILE]).split(' ')[0].strip()
except:
    log("Unable to do md5 on the iso file %s, is it downloaded?" % DWFILE)
    sys.exit(1)

# JSON variable file is generated dynamically before packer validation
SHARED_VARS = {'hostname': args['hostname'][0]} # Hostname is different all the time
SHARED_VARS['iso_checksum'] = MD5SUM            # Dynamic checksum so packer doesnt freak out
SHARED_VARS['iso_file'] = DWFILE                # We might be using different ISO files

# We might have packer hiding in our local bin directory
ADD_PATH = os.getcwd()+'/bin:'
log("Adding %s to path" % ADD_PATH)
MY_ENV = os.environ.copy()
MY_ENV["PATH"] = ADD_PATH + MY_ENV["PATH"]

# Generating var file in json format - consumed by packer
with open('http/ubuntu.vars', 'w') as outfile:
    json.dump(SHARED_VARS, outfile)

log("Validating ubuntu template")
p = subprocess.Popen(['packer','validate','-var-file=http/ubuntu.vars','http/'+args['codename']+'.json'], env=MY_ENV, shell=True)
p.communicate()[0]
log("Validation of template return: %d" % p.returncode)

# The actual build of devbox
log("Starting Packer build")
sys.exit(1)
p = subprocess.Popen(['packer','build','-force','-on-error=abort',
                      '-var-file=http/ubuntu.vars','http/'+args['codename']+'.json'])
