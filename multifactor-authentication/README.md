
# Welcome to build environment in AWS
This page contains instructionsto implement multifactor on your bastion host.

## Install EPEL Repo on the EC2 instance

Google Authenticator is part of the EPEL repo and you should install the EPEL repo in your EC2 instance.
In my case, I am using Amazon EC2 Instance (OS) and I can download my EPEL 7 and install like this
**
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
**
 

## Installing Google Authenticator on EC2 Instance

SSH into your EC2 instance the way you normally would and then switch into your root account or use sudo and run:

sudo yum install google-authenticator -y
##  Update the sshd PAM and install Google authenticator module

sudo vi /etc/pam.d/sshd

Add the following to the bottom of the file to use Google Authenticator. If there are service accounts or users who should be able to log in without MFA, add nullok at the end of the following statement. This will mean that users who don’t run Google Authenticator initialization won’t be asked for a second authentication.

auth required pam_google_authenticator.so or

auth required pam_google_authenticator.so nullok

Comment out the password requirement as we want to use only the key-based authentication.

#auth       substack     password-auth 

Don’t forget to Save the file






## Update the sshd configuration 

In this step we are going to tell sshd that we have one more level of multifactor authentication for the user to login along with the Keybased auth.

This step is to make sshd daemon to prompt the user for the Verification Code.

Edit the file as root

sudo vi /etc/ssh/sshd_config
 

Comment out the line which says ChallengeResponseAuthentication ‘no’ and uncomment the line which says ‘yes’.

ChallengeResponseAuthentication yes
#ChallengeResponseAuthentication no
Finally, we need to let sshd daemon know that it should ask the user for an SSH key and a verification code

AuthenticationMethods publickey,keyboard-interactive
Save the file.
## 
## rn Google Authenticator on EC2 and Get QR code

Once you have the Google Authenticator installed in your mobile you are ready to perform the second phase of this configuration.

the second phase should be performed at the ec2 server.
## Automated Approach
- Login to bastion host and set the following env variables.
  - export ANSIBLE_HOST_KEY_CHECKING=false
  - export INSTNAME=build-host
- wget https://raw.githubusercontent.com/vivechanchanny/aws-utils/main/build-host/ansible-setup.yml -O ansible-setup.yml
- ansible-playbook  -u ubuntu  -e  "INSTNAME=$INSTNAME"  ansible-setup.yml
- export INST_IP=$(bash get-private-ip.sh $INSTNAME)
## 
