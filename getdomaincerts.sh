#!/bin/bash
# Create cer files for all domain controllers in a supplied domain
# must have dig, nslookup, openssl installed
# change 636 (ldaps) to 3269 for secure global catalog certs (if they are different)
# use like ./getdomaincerts.sh my.addomain.com

if [ $# -eq 0 ]
  then
    echo "No domain supplied. Please supply a domain name in arg position 1."
    exit
fi

dig $1 | awk '{print $5}' | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | while read -r F
do
	NAME=$(nslookup $F | grep $1 | grep -v "domaindnszones"| awk '{print $4}')
        openssl s_client -connect "$F":636 2>/dev/null </dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > "$NAME"cer
done

