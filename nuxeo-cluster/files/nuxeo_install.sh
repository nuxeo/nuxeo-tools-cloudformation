#!/bin/bash -e

export PATH="/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin"

chsh -s /bin/bash nuxeo

export DEBIAN_FRONTEND=noninteractive
apt-get -y install python-requests python-lxml

# Setup dirs
mkdir -p /opt/nuxeo
cd /opt/nuxeo
mkdir -p conf data tmp

# Install distrib
/tmp/get-nuxeo-distribution -o /tmp/nuxeo-distribution.zip -v ${NUXEO_VERSION}
mkdir deploytmp
pushd deploytmp
unzip -q /tmp/nuxeo-distribution.zip
dist=$(/bin/ls -1 | head -n 1)
mv $dist ../
popd
rm -rf deploytmp
ln -s $dist server
chmod +x server/bin/nuxeoctl
mv server/bin/nuxeo.conf conf/nuxeo.conf


