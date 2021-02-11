if [[ "$1" == "" || "$2" == "" ]]; then
        echo "Usage $0 key-name key-description [keyfile(default=id_rsa)]"
        exit 1
fi

keyname=$1
keydescription=$2
keyfile=id_rsa

if [[ "$3" != "" ]]; then
    keyfile=$3
fi
if [[ -e /home/ec2-user/.ssh/$keyfile ]]
then
    echo "ssh key file $keyfile already exists. Exiting"
    exit 0
fi

# TBD RUn describe keys and check if the key is in aws.
ssh-keygen -t rsa -b 4096 -C $keydescription  -f /home/ec2-user/.ssh/$keyfile -P ""
aws ec2 delete-key-pair --key-name $keyname

aws ec2 import-key-pair --key-name $keyname --public-key-material fileb://~/.ssh/$keyfile.pub
