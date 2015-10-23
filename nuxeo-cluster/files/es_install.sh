#!/bin/bash

chsh -s /bin/bash es
wget -q -O /tmp/elasticsearch.zip https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-${ES_VERSION}.zip || exit 1
mkdir -p /opt/es
unzip -d /opt/es /tmp/elasticsearch.zip
ln -s /opt/es/elasticsearch-${ES_VERSION} /opt/es/elasticsearch
chown -R es /opt/es
echo >> /opt/es/elasticsearch/config/elasticsearch.yml
printf 'cluster.name: %s\n' ${ES_CLUSTER} >> /opt/es/elasticsearch/config/elasticsearch.yml
printf 'cloud.aws.region: %s\n' ${REGION} >> /opt/es/elasticsearch/config/elasticsearch.yml
printf 'discovery.type: ec2\n' >> /opt/es/elasticsearch/config/elasticsearch.yml
printf 'discovery.ec2.groups: %s\n' ${ES_SG} >> /opt/es/elasticsearch/config/elasticsearch.yml
printf 'cloud.node.auto_attributes: true\n' >> /opt/es/elasticsearch/config/elasticsearch.yml
cd /opt/es/elasticsearch
res=$(bin/plugin -install org.elasticsearch/elasticsearch-cloud-aws/${ES_PLUGIN_VERSION})
if [ \"$?\" -ne \"0\" ]; then
    echo "Failed to install aws plugin: ${res}"
    exit 1
fi

