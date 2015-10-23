#!/bin/bash -e

mkdir -p /usr/lib/jvm 
curl -o/tmp/jdk-8-linux-x64.tgz -L --insecure --header 'Cookie: oraclelicense=accept-securebackup-cookie' 'http://download.oracle.com/otn-pub/java/jdk/8u40-b26/jdk-8u40-linux-x64.tar.gz'
tar xzf /tmp/jdk-8-linux-x64.tgz -C /usr/lib/jvm
rm /tmp/jdk-8-linux-x64.tgz
ln -s /usr/lib/jvm/jdk1.8.0_40 /usr/lib/jvm/java-8
update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-8/jre/bin/java 1081
update-alternatives --set java /usr/lib/jvm/java-8/jre/bin/java

