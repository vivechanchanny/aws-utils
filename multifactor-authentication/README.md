
# Welcome to build environment in AWS
This page contains instructionsto implement multifactor on your bastion host.

## Installing Google Authenticator on EC2 Instance

SSH into your EC2 instance the way you normally would and then switch into your root account or use sudo and run:

sudo yum install google-authenticator -y




:

# Install & configure
Either use the fully automated approach or manually execute the commands
## Automated Approach
- Login to bastion host and set the following env variables.
  - export ANSIBLE_HOST_KEY_CHECKING=false
  - export INSTNAME=build-host
- wget https://raw.githubusercontent.com/vivechanchanny/aws-utils/main/build-host/ansible-setup.yml -O ansible-setup.yml
- ansible-playbook  -u ubuntu  -e  "INSTNAME=$INSTNAME"  ansible-setup.yml
- export INST_IP=$(bash get-private-ip.sh $INSTNAME)
