# Packer AMI build for Bamboo 6 on Win 2012 R2 & .Net 4.5.2
This script creates an AMI with Bamboo 6 and tools required to build .net 4.5.2 applications on a local Agent.  This will enable you to satisfy the requirements for the requirements for the [Starter Licence](https://www.atlassian.com/licensing/bamboo) and so should only be used for demo/experimentation purposes.  
For a full licence I'd suggest only using Packer to build the remote agent AMIs for use as Elastic Cloud agents.  The server itself can then be whichever operating system you like and can be managed with config tools such as Ansible.

## Requirements
* An AWS account with permissions to create EC2 instances and AMIs
* [Packer](https://www.packer.io/)

## Usage Instructions

1. Ensure your aws credentials have been configured.  These scripts expect to use [Automatic Lookup](https://www.packer.io/docs/builders/amazon.html#specifying-amazon-credentials).  To use a profile other than default, set the env variable `AWS_PROFILE` to the profile name.
1. Clone or download this repo
1. In the repo folder run 
    ```
    packer build bamboo-server.json
    ```
1. Go make a cup of coffee
1. Once finished, check the output for successful test results.
1. Your AMI is now ready to launch
1. Amend your instance's [Security Group rules](http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_SecurityGroups.html#AddRemoveRules) to allow TCP inbound over port 8085.
1. Once launched navigate to `http://<instanceip>:8085` to complete the [Bamboo setup wizard](https://confluence.atlassian.com/bamboo/running-the-setup-wizard-289276851.html).

**Note:** The Bamboo Server is set up as a service but does not have logon credentials.  These will need to be set once the Administrator password is known after you've launched your instance.  Follow these [instructions for running Bamboo as a Service](https://confluence.atlassian.com/bamkb/running-bamboo-as-a-windows-service-troubleshooting-guide-420973231.html).
