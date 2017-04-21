#! /usr/bin/env python
import argparse
from logging.handlers import RotatingFileHandler
import logging
import sys
import time
import os
import platform
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
    myOS       = 'mac'
    md5command = 'md5'
else:
    # Set up Linux? variables here
    myOS       = 'Debian'
    md5command = 'md5sum'

parser = argparse.ArgumentParser()
parser.add_argument("--hostname", nargs=1,   help='Set the hostname of the box, default is  devbox', default=['devbox'])
parser.add_argument("--download", nargs='?', help='Download the ISO From Ubuntu', default=False)
parser.add_argument("--codename", nargs='?', help="Choose between xenial and trusty", default='trusty')
args = vars(parser.parse_args());

import subprocess
log("Using hostname %s" % args['hostname'][0])

if args['codename'] == 'trusty':
    dwBase='http://releases.ubuntu.com/14.04/'
    dwURL = 'ubuntu-14.04.5-server-amd64.iso'
else:
    dwBase = 'http://releases.ubuntu.com/16.04/'
    dwURL = 'ubuntu-16.04.2-server-amd64.iso'

if args['download'] == None:
    log("Downloading Image")
    p2 = subprocess.Popen(['which','wget'])
    p2.communicate()[0]
    if p2.returncode == 1:
        log("Cannot find wget - make sure to install wget 'brew install wget' if this is a mac")
        exit()
    # TODO: account for other operating systems
    p = subprocess.Popen(['wget','-v','-N','-P','iso','--progress=bar',dwBase+dwURL])
    p = subprocess.Popen([md5command,'iso/'+dwURL])
    print p.communicate()[1]

try:
    log('Checking md5sum for %s' % dwURL)
    md5sum = subprocess.check_output([md5command,'iso/'+dwURL]).split('=')[1].strip()
except:
    log("Unable to do md5 on the iso file, is it downloaded?")

SHARED_VARS={'hostname': args['hostname'][0]}
SHARED_VARS['iso_checksum'] = md5sum

# Generating var file in json format - consumed by packer
import json
with open('http/ubuntu.vars', 'w') as outfile:
    json.dump(SHARED_VARS, outfile)

log("Validating ubuntu template")
p = subprocess.Popen(['packer','validate','-var-file=http/ubuntu.vars','http/'+args['codename']+'.json'])
p.communicate()[0]
log("Validation of template return: %d" % p.returncode)

# The actual build of devbox
log("Starting Packer build")
p = subprocess.Popen(['packer','build','-force','-on-error=abort',
                      '-var-file=http/ubuntu.vars','http/'+args['codename']+'.json'])
