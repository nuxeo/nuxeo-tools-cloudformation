#!/usr/bin/env python

import os, sys, time, string, re, shutil, json, boto, boto.s3.key

# Local dirs
TEMPLATES = "templates"
USERDATA = "userdata"
SCRIPTS = "scripts"
TARGET = "target"

# S3 dirs
S3TEMPLATES = "templates"
S3SCRIPTS = "scripts"
S3BUCKET = "nuxeo"

# Common pattern used for replacement
nxvar = re.compile("@@([^@]*)@@")

# Generate timestamp to use for published files versioning
TS = time.strftime("%Y%m%d-%H%M%S")

# Change directory to one level above where the script resides
os.chdir(os.path.join(os.path.dirname(sys.argv[0]), ".."))

# Create/cleanup directory for result files
if os.path.isdir(TARGET):
    shutil.rmtree(TARGET)
os.mkdir(TARGET)
os.mkdir(os.path.join(TARGET, S3TEMPLATES))
os.mkdir(os.path.join(TARGET, S3SCRIPTS))

# List all " template templates"
tpllist = os.listdir(TEMPLATES)

# Process each template
for tpl in tpllist:

    print "*** Template:", tpl
    tplfile = os.path.join(TEMPLATES, tpl)
    outfile = os.path.join(TARGET, S3TEMPLATES, tpl) # "latest"
    outfile_with_ts = outfile+"-"+TS

    # Read the template
    file = open(tplfile, "r")
    tpldata = file.read()
    file.close()

    # Find the UserData script to use
    udlist = nxvar.findall(tpldata)
    if len(udlist) == 0:
        print "No UserData script in template file - publish as is"
        shutil.copyfile(tplfile, outfile)
        shutil.copyfile(outfile, outfile_with_ts)
    else:
        for ud in udlist:
            print "UserData:", ud
            udfile = os.path.join(USERDATA, ud)
            # Read the UserData script
            file = open(udfile, "r")
            uddata = file.read()
            file.close()
            # Find scripts called by the UserData one
            slist = nxvar.findall(uddata)
            for s in slist:
                print "Script:", s
                # Copy each timestamped script to publish dir
                sfile = os.path.join(SCRIPTS, s)
                outsfile_nots = os.path.join(TARGET, S3SCRIPTS, s)
                outsfile = outsfile_nots+"-"+TS
                shutil.copyfile(sfile, outsfile_nots)
                shutil.copyfile(sfile, outsfile)
                # Replace filename in UserData
                uddata = string.replace(uddata, "@@"+s+"@@", s+"-"+TS)
            # Encode UserData and replace in template
            tpldata = string.replace(tpldata, "@@"+ud+"@@", json.dumps(uddata))
        # Write resulting template
        file = open(outfile, "w")
        file.write(tpldata)
        file.close()
        shutil.copyfile(outfile, outfile_with_ts)

# Copy to S3
try:
    s3 = boto.connect_s3()
except:
    print "Could not connect to S3 - are your credentials in the environment?"
    sys.exit(-1)

try:
    bucket = s3.get_bucket(S3BUCKET)
except:
    bucket = s3.create_bucket(S3BUCKET)
    bucket.set_acl("public-read")

def send_to_s3(bucket,key,filename):
    s3key = boto.s3.key.Key(bucket)
    s3key.key = key
    s3key.set_contents_from_filename(filename)
    s3key.set_acl("public-read")

print "*** Uploading files:"
# Ensure scripts are available before templates
for root, dirs, files in os.walk(os.path.join(TARGET, S3SCRIPTS)):
    for file in files:
        filename = os.path.join(root, file)
        relname = os.path.relpath(filename, TARGET)
        print relname
        send_to_s3(bucket, relname, filename)
# Scripts done, send templates
for root, dirs, files in os.walk(os.path.join(TARGET, S3TEMPLATES)):
    for file in files:
        filename = os.path.join(root, file)
        relname = os.path.relpath(filename, TARGET)
        print relname
        send_to_s3(bucket, relname, filename)

# Don't close manually as it throws an error
#s3.close()

