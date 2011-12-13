# Nuxeo templates for Amazon CloudFormation

Those templates will deploy Nuxeo architectures on CloudFormation.


## Templates list

- **Nuxeo**

This will deploy a single EC2 instance containing Nuxeo, a PostgreSQL
database and a Apache2 HTTP front-end.  
An Elastic IP is associated with the instance.


## Repository structure

- **templates**: this contain the "template templates" which reference
  user-data scripts.

- **userdata**: those are the scripts that are run when the instance
  comes up for the first time.
  They basically just download and execute the scripts below.

- **scripts**: those are the scripts that do the actual setup inside
  "agnostic" AMIs.

- **build**: this puts everything together and uploads the final template
  and scripts on S3.


## AMIs

We are using AMIs from [Alestic](http://alestic.com/).  
The OS is Ubuntu 10.04 LTS (Lucid Lynx).  
Those are EBS boot instance (ie not volatile).


## About Nuxeo

Nuxeo provides a modular, extensible Java-based [open source software platform for enterprise content management] [1] and packaged applications for [document management] [2], [digital asset management] [3] and [case management] [4]. Designed by developers for developers, the Nuxeo platform offers a modern architecture, a powerful plug-in model and extensive packaging capabilities for building content applications.

[1]: http://www.nuxeo.com/en/products/ep
[2]: http://www.nuxeo.com/en/products/document-management
[3]: http://www.nuxeo.com/en/products/dam
[4]: http://www.nuxeo.com/en/products/case-management

More information on: <http://www.nuxeo.com/>

