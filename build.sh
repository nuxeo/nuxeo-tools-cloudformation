#!/bin/bash

cd $(dirname $0)

# Make FT templates from release templates

sed 's/Nuxeo_single/NuxeoFT_single/g' templates/Nuxeo.template > templates/NuxeoFT.template
sed 's/Nuxeo_single/NuxeoFT_single/g' userdata/Nuxeo_single > userdata/NuxeoFT_single
sed 's/Nuxeo_single/NuxeoFT_single/g' scripts/Nuxeo_single > scripts/NuxeoFT_single
sed -i -e '/trusty releases/a echo "deb http:\/\/apt.nuxeo.org\/ trusty fasttracks" >> \/etc\/apt\/sources.list.d\/nuxeo.list' scripts/NuxeoFT_single

# Build

if [ ! -d venv ]; then
    virtualenv venv
fi

. venv/bin/activate

pip install boto

python build/make_templates.py

deactivate

