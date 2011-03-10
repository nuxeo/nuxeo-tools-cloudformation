#!/usr/bin/env python

import os, sys, time, string, re, shutil, simplejson

# Local dirs
TEMPLATES = "templates"
USERDATA = "userdata"
SCRIPTS = "scripts"
TARGET = "target"

# S3 dirs
S3TEMPLATES = "templates"
S3SCRIPTS = "scripts"

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
                outsfile = os.path.join(TARGET, S3SCRIPTS, s)+"-"+TS
                shutil.copyfile(sfile, outsfile)
                # Replace filename in UserData
                uddata = string.replace(uddata, "@@"+s+"@@", s+"-"+TS)
            # Encode UserData and replace in template
            tpldata = string.replace(tpldata, "@@"+ud+"@@", simplejson.dumps(uddata))
        # Write resulting template
        file = open(outfile, "w")
        file.write(tpldata)
        file.close()
        shutil.copyfile(outfile, outfile_with_ts)

# TODO
# Copy to S3

