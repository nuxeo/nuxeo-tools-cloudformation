The VPC template assumes you have the following in place in your infrastructure:
- a VPC with:
- a public subnet,
- a private subnet,
- a security group for bastion hosts (for the incoming SSH traffic to the private subnet).

It will create:
- a Nuxeo instance in the private subnet,
- a load balancer in the public subnet (which acts as a reverse proxy, and is intended to be augemented as a HTTPS endpoint),
- a security group for the load balancer that allows HTTP and HTTPS traffic,
- a security group for the Nuxeo instance that allows HTTP traffic from the load balancer and SSH traffic from the bastion host(s).

