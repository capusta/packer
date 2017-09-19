#! /bin/bash

# Install ansible for further provisioning
apt-get install software-properties-common && \
apt-add-repository ppa:ansible/ansible && \
apt-get update && \
apt-get -y install ansible python-pip
pip install docker-py python-consul