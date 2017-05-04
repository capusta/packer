[![Build Status](https://travis-ci.org/capusta/packer.svg?branch=master)](https://travis-ci.org/capusta/packer)

Run ./build -n hostname --os (ubuntu|centos)

##### Download the intial images
If running outside of a virtual environment:
```./bin/build.py --download --codename trusty32```

##### Running the newly-downloaded images
``` ./bin/build.py --codename trusty32```
