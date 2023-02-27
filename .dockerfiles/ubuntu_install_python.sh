#!/bin/bash -e
#
# Install python in an Ubuntu container.
#

export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true

if [ $(lsb_release -r -s) == "18.04" ]; then
    apt-get -y install software-properties-common
    add-apt-repository ppa:deadsnakes/ppa
    apt-get update
    apt-get -y install python3-venv python3.8-dev python3.8-venv
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 1
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2
else
    apt-get -y install python3-dev python3-venv
fi
