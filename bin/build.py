#! /usr/bin/env python
"""
    Generates a virtualbox image, provisioned with ansible
"""
import argparse
import sys
import os
import platform
import json
import subprocess

# Modify the default template behavior so we can use % marks in our template
# without having it clash with bash-native $ variable expansion
import string
class CustomTemplate(string.Template):
    delimiter = '%'
    idpattern = '[a-z0-9_]*'

##### Import relative files
import common

parser = argparse.ArgumentParser()
parser.add_argument("--hostname", nargs=1,   help='VM Hostname, default is devbox', default=['devbox'])
parser.add_argument("-d","--download", help='Download the ISO based on the codename', default=False)
parser.add_argument("-c","--codename", nargs=1, help="Choose between xenial and zesty", default=['zesty'])
parser.add_argument("-u","--user",     nargs=1, help="Primary VM user", default=['vagrant'])
args = vars(parser.parse_args());

##### Quick check CLI Arguments
if len(sys.argv) == 1:
    subprocess.call(["python","bin/build.py","-h"])
    sys.exit(0)

md5command = ''
md5sum = ''
myOS = ''
if os.name == 'posix' and platform.system() == 'Darwin':
    common.log("Mac OS Detected")
    myOS = 'mac'
    md5command = 'md5'
else:
    common.log("Debian (Ubuntu) detected")
    myOS = 'Debian'
    md5command = 'md5sum'

# JSON variable file is generated dynamically before packer validation
# We will dump this variable to json var file
SHARED_VARS = {}

# Hostname is different all the time
SHARED_VARS['vm_name'] = args['hostname'][0]
SHARED_VARS['output_directory'] = 'build'
SHARED_VARS['vm_user'] = args['user'][0]
# Need to get the operator so we can copy over the ssh directory (if it exists)
SHARED_VARS['home_dir'] = os.path.expanduser("~")
SHARED_VARS['root_password'] = None

# NO case in python :(
CODENAME = args['codename'][0]
# Might use different codenames to use different builds
SHARED_VARS['codename'] = CODENAME

if CODENAME == 'xenial':
    DWBASE = 'http://releases.ubuntu.com/16.04/'
    DWFILE = 'ubuntu-16.04.2-server-amd64.iso'
elif CODENAME == 'zesty':
    DWBASE = 'http://releases.ubuntu.com/17.04/'
    DWFILE = 'ubuntu-17.04-server-amd64.iso'

SHARED_VARS['iso_name'] = DWFILE                # We might be using different ISO files
common.log("Starting build process for %s (%s) user %s" % (SHARED_VARS['vm_name'],CODENAME,SHARED_VARS['vm_user']))

if args['download'] is None:
    common.log("Downloading %s" % DWBASE + DWFILE)
    P2 = subprocess.Popen(['which', 'wget'])
    P2.communicate()[0]
    if P2.returncode == 1:
        common.log("Cannot find wget - make sure it is installed")
        sys.exit(1)
    # TODO: account for other operating systems
    P = subprocess.Popen(['wget', '-v', '-N', '-P', 'iso', '--progress=bar', DWBASE+"/"+DWFILE])
    P = subprocess.Popen([md5command, 'iso/'+DWFILE])

try:
    common.log('Checking md5sum for %s' % DWFILE)
    MD5SUM = subprocess.check_output(['openssl','md5', 'iso/'+DWFILE])
    SHARED_VARS['iso_checksum_type'] = 'md5'
    if myOS == 'Debian':
        common.log("Debian code is Not implemented yet")
        #TODO: Add support to extract checksum
        sys.exit(1)
    if myOS == 'mac':
        MD5SUM = MD5SUM.split("=")[1].strip()
except:
    common.log("Unable to do md5 on the iso file %s, is it downloaded?" % DWFILE)
    sys.exit(1)

SHARED_VARS['iso_checksum'] = MD5SUM            # Dynamic checksum so packer doesnt freak out
common.log("Updated http/vars with MD5 sum: {0}".format(MD5SUM))

# We might have packer hiding in our local bin directory
ADD_PATH = os.getcwd()+'/bin:'
MY_ENV = os.environ.copy()
MY_ENV["PATH"] = ADD_PATH + MY_ENV["PATH"]

# -------------------------------------------------------
# Generating var file in json format - consumed by packer
VARFILE = 'http/vars'
with open(VARFILE, 'w') as outfile:
    json.dump(SHARED_VARS, outfile)

# -------------------------------------------------------

# -------------------------------------------------------
# Generating Vagrant file - consumed by packer
VAGRANTFILE = 'http/Vagrantfile'
src = CustomTemplate(open('http/Vagrantfile.template').read())
result = src.substitute(SHARED_VARS)
f = open('http/Vagrantfile','w')
f.write(result)
f.close

# Checking packer binaries
PACKER_TEMPLATE = 'http/'+SHARED_VARS['codename']+'.json'
MYPACKER = subprocess.check_output(['which', 'packer']).strip()
common.log("Validating %s with %s " % (PACKER_TEMPLATE, MYPACKER))

cmd = [MYPACKER, 'validate', '-var-file='+VARFILE, PACKER_TEMPLATE]
common.log("Running command: {0}".format(' '.join(cmd)))
P = subprocess.Popen(cmd, stdout=subprocess.PIPE)
P.communicate()

if P.returncode == 1:
    common.log("%s validation error.  Exit %d" % (PACKER_TEMPLATE, P.returncode))
    sys.exit(P.returncode)
else:
    common.log("Validation of %s return: %d" % (PACKER_TEMPLATE, P.returncode))

# The actual build of devbox
common.log("Starting Packer build")
P = subprocess.Popen([MYPACKER, 'build', '-force', '-on-error=ask', '-var-file='+VARFILE, PACKER_TEMPLATE])
