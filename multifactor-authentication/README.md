
# Welcome to build environment in AWS
This page contains instructionsto implement multifactor on your bastion host.

## Install EPEL Repo on the EC2 instance

Google Authenticator is part of the EPEL repo and you should install the EPEL repo in your EC2 instance.
In my case, I am using Amazon EC2 Instance (OS) and I can download my EPEL 7 and install like this
```
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
```

## Installing Google Authenticator on EC2 Instance
SSH into your EC2 instance the way you normally would and then switch into your root account or use sudo and run:
```
sudo yum install google-authenticator -y
```
##  Update the sshd PAM and install Google authenticator module
```
sudo vi /etc/pam.d/sshd
```
Add the following to the bottom of the file to use Google Authenticator. If there are service accounts or users who should be able to log in without MFA, add nullok at the end of the following statement. This will mean that users who don’t run Google Authenticator initialization won’t be asked for a second authentication.
```
auth required pam_google_authenticator.so or
                 OR
auth required pam_google_authenticator.so nullok
```
Comment out the password requirement as we want to use only the key-based authentication.
```
#auth       substack     password-auth 
```
Don’t forget to Save the file

## Update the sshd configuration 

In this step we are going to tell sshd that we have one more level of multifactor authentication for the user to login along with the Keybased auth.
This step is to make sshd daemon to prompt the user for the Verification Code.
Edit the file as root
```
sudo vi /etc/ssh/sshd_config
```
Comment out the line which says ChallengeResponseAuthentication ‘no’ and uncomment the line which says ‘yes’.
```
ChallengeResponseAuthentication yes
#ChallengeResponseAuthentication no
```
Finally, we need to let sshd daemon know that it should ask the user for an SSH key and a verification code
```
AuthenticationMethods publickey,keyboard-interactive
```
Save the file.

## run Google Authenticator on EC2 and Get QR code

Once you have the Google Authenticator installed in your mobile you are ready to perform the second phase of this configuration.
the second phase should be performed at the ec2 server.
```
 google-authenticator
```

Here are my answers. (Refer the following snippet)
```
Do you want authentication tokens to be time-based (y/n) y

******* THERE WOULD BE A QR CODE DISPLAYED HERE ****
 

Your new secret key is: 2IAROUZWA6ZRSRRR89ZLYNZUC2A
Your verification code is 601376
Your emergency scratch codes are:
  85535499
  25397636
  98473698
  70322035
  60012461

Do you want me to update your "/root/.google_authenticator" file? (y/n) y

Do you want to disallow multiple uses of the same authentication
token? This restricts you to one login about every 30s, but it increases
your chances to notice or even prevent man-in-the-middle attacks (y/n) y

By default, a new token is generated every 30 seconds by the mobile app.
In order to compensate for possible time-skew between the client and the server,
we allow an extra token before and after the current time. This allows for a
time skew of up to 30 seconds between authentication server and client. If you
experience problems with poor time synchronization, you can increase the window
from its default size of 3 permitted codes (one previous code, the current
code, the next code) to 17 permitted codes (the 8 previous codes, the current
code, and the 8 next codes). This will permit for a time skew of up to 4 minutes
between client and server.
Do you want to do so? (y/n) n

If the computer that you are logging into isn't hardened against brute-force
login attempts, you can enable rate-limiting for the authentication module.
By default, this limits attackers to no more than 3 login attempts every 30s.
Do you want to enable rate-limiting? (y/n) y
```
That’s it. You have successfully set up Google Authenticator with AWS EC2 instance
