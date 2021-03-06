#!/bin/bash

set -e

if [ `id -u` -ne 0 ]; then
    echo 'Must be run as root'
    exit 1
fi

# Directory containing the script, so that we can call other scripts
#DIR="$(dirname "$(readlink -f "${0}")")" # not supported on OSX
DIR="$( cd "$( dirname "${0}" )" && pwd )"

if [ -z ${1+x} ]; then
    DISTRO=ubuntu
else
    DISTRO=$1
fi

DEBUG=''
# if --debug is given in the list of arguments
if [[ " $* " =~ " --debug " ]]; then
    set -x
    DEBUG="--debug"
fi

# Using colons makes using lxc-cli inconvenient, and using periods makes it
# an invalid hostname, so just use all dashes
TS=`date +%F-%H-%M-%S-%N`
CNAME=swift-runway-$TS

echo $CNAME

$DIR/make_base_container.sh $DISTRO $CNAME $DEBUG

$DIR/setup_and_run_ansible_on_guest.sh $CNAME $DEBUG
