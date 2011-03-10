# Nuxeo templates for Amazon CloudFormation

Those templates will deploy Nuxeo architectures on CloudFormation.


## Templates list

- NuxeoDM

This will deploy a single EC2 instance containing Nuxeo DM, a PostgreSQL
database and a Apache2 HTTP front-end.
An Elastic IP is associated with the instance.


## Repository structure

- templates: this contain the "template templates" which reference
  user-data scripts.

- userdata: those are the scripts that are run when the instance
  comes up for the first time.
  They basically just download and execute the scripts below.

- scripts: those are the scripts that do the actual setup inside
  "agnostic" AMIs.

- build: this puts everything together and uploads the final template
  and scripts on S3.


## AMIs

We are using AMIs from [Alestic](http://alestic.com/).
The OS is Ubuntu 10.04 LTS (Lucid Lynx).
Those are EBS boot instance (ie not volatile).

