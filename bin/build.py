#! /usr/bin/env python
"""
    Generates a virtualbox image, provisioned with ansible
"""
import argparse
from logging.handlers import RotatingFileHandler
import logging
import sys
import time
import os
import platform
import json
import subprocess

if len(sys.argv) == 1:
    print "Please use -h for usage"
    print "Using defaults: --hostname devbox --codename xenial"
    time.sleep(2)

LOGGER = logging.getLogger("Rotating Log")
LOGGER.setLevel(logging.INFO)
HANDLER = RotatingFileHandler('logs/build.log', maxBytes=10*1024, backupCount=5)
LOGGER.addHandler(HANDLER)

def log(MSG):
    print time.strftime("%y-%m-%d:%H-%M: ") + MSG
    LOGGER.info(time.strftime("%y-%m-%d:%H-%M: ")+ MSG)

## some global variables to help with ubuntu devs
md5command = ''
md5sum = ''
myOS = ''
if (os.name == 'posix' and platform.system() == 'Darwin'):
    log("Mac OS Detected")
    myOS = 'mac'
    md5command = 'md5'
else:
    log("Debian (Ubuntu) detected")
    myOS = 'Debian'
    md5command = 'md5sum'

parser = argparse.ArgumentParser()
parser.add_argument("--hostname", nargs=1,   help='Set the hostname of the box, default is devbox', default=['devbox'])
parser.add_argument("--download", nargs='?', help='Download the ISO based on the codename', default=False)
parser.add_argument("--codename", nargs='?', help="Choose between xenial and trusty", default='xenial')
args = vars(parser.parse_args());

# JSON variable file is generated dynamically before packer validation
SHARED_VARS = {}
# Hostname is different all the time
SHARED_VARS['vm_name'] = args['hostname'][0]

# NO case in python :(
CODENAME = args['codename']
if CODENAME == 'xenial':
    DWBASE = 'http://releases.ubuntu.com/16.04/'
    DWFILE = 'ubuntu-16.04.2-server-amd64.iso'
elif 'xenial-mini' in CODENAME:
    DWBASE = 'http://ports.ubuntu.com/dists/xenial/main/installer-powerpc/current/images/powerpc64/netboot/',
    DWFILE = 'mini.iso'
    CODENAME = 'xenial'

# Might use different codenames to use different builds
SHARED_VARS['codename'] = CODENAME.strip()
SHARED_VARS['iso_name'] = DWFILE                # We might be using different ISO files

log("Starting build process for %s (%s)" % (args['hostname'][0],CODENAME))

if args['download'] is None:
    log("Downloading %s" % DWBASE + DWFILE)
    P2 = subprocess.Popen(['which', 'wget'])
    P2.communicate()[0]
    if P2.returncode == 1:
        log("Cannot find wget - make sure to install wget 'brew install wget' if this is a mac")
        exit()
    # TODO: account for other operating systems
    P = subprocess.Popen(['wget', '-v', '-N', '-P', 'iso', '--progress=bar', DWBASE+"/"+DWFILE])
    P = subprocess.Popen([md5command, 'iso/'+DWFILE])

log('Checking md5sum for %s' % DWFILE)
try:
    MD5SUM = subprocess.check_output([md5command, 'iso/'+DWFILE])
    SHARED_VARS['iso_checksum_type'] = 'md5'
    if myOS == 'Debian':
        log("Debian code is Not implemented yet")
        #TODO: Add support to extract checksum
        sys.exit(1)
    if myOS == 'mac':
        MD5SUM = MD5SUM.split("=")[1].strip()
except:
    log("Unable to do md5 on the iso file %s, is it downloaded?" % DWFILE)
    sys.exit(1)

SHARED_VARS['iso_checksum'] = MD5SUM            # Dynamic checksum so packer doesnt freak out

# We might have packer hiding in our local bin directory
ADD_PATH = os.getcwd()+'/bin:'
MY_ENV = os.environ.copy()
MY_ENV["PATH"] = ADD_PATH + MY_ENV["PATH"]

# Generating var file in json format - consumed by packer
VARFILE = 'http/vars'
with open(VARFILE, 'w') as outfile:
    json.dump(SHARED_VARS, outfile)

PACKER_TEMPLATE = 'http/'+SHARED_VARS['codename']+'.json'
MYPACKER = subprocess.check_output(['which', 'packer']).strip()
log("Validating %s with %s " % (PACKER_TEMPLATE, MYPACKER))

P = subprocess.Popen(['packer', 'validate', '-var-file='+VARFILE, PACKER_TEMPLATE], stdout=subprocess.PIPE)
P.communicate()
if P.returncode == 1:
    log("%s validation error.  Exit %d" % (PACKER_TEMPLATE, P.returncode))
    sys.exit(P.returncode)
else:
    log("Validation of %s return: %d" % (PACKER_TEMPLATE, P.returncode))

# The actual build of devbox
log("Starting Packer build")
P = subprocess.Popen(['packer', 'build', '-force', '-on-error=abort', '-var-file='+VARFILE, PACKER_TEMPLATE])
