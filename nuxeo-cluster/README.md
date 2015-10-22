** Work in progress **

Those templates are used to setup a Nuxeo cluster.

Notes:  
You should not use them as is except for tests.  
The whole setup is Single AZ.  
The RDS and ElastiCache instances are configured without MultiAZ and without backups.

This requires your AWS account to already be set up with a VPC, with:
- a public subnet (for the load balancer),
- a private subnet with internet access (for the Nuxeo and Elasticsearch nodes),
- a "SSH from here" security group (bastion hosts) that will be allowed to connect to the nodes,
- an associated DB subnet group in RDS,
- an associated cache subnet group in ElastiCache

