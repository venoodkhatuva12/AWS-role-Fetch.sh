#! /bin/bash
#
# Dependencies:
yum install jq -y

#
# Description:
#   Makes assuming an AWS IAM role (+ exporting new temp keys) easier
set +x
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset  AWS_SESSION_TOKEN
export AWS_ACCESS_KEY_ID=ABCDEFGHIJKLMNOPQRSTUVWXYZ
export AWS_SECRET_ACCESS_KEY=ABCDEFGHabvIJKLMN/OPQRS/TUVWXYZ
export AWS_REGION=us-west-1

temp_role=$(aws sts assume-role \
                    --role-arn "arn:aws:iam::1234567890:role/Role-Name" \
                    --role-session-name "Role-Session")

export AWS_ACCESS_KEY_ID=$(echo $temp_role | jq .Credentials.AccessKeyId | xargs)
export AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq .Credentials.SecretAccessKey | xargs)
export AWS_SESSION_TOKEN=$(echo $temp_role | jq .Credentials.SessionToken | xargs)

env | grep -i AWS_
