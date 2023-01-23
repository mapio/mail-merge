#!/bin/bash

name="$1"
email="$2"

if [ -z "$name" ]; then
  echo 'scythe-mail-merge: please provide your name as first command line argument'
  exit 1
fi

if [ -z "$email" ]; then
  echo 'scythe-mail-merge: please provide your email as second command line argument'
  exit 1
fi

secret_key=$(python -c 'import os; print(os.urandom(32).hex())')
token_generation_auth=$(python -c 'import os; print(os.urandom(16).hex())')

did=$(docker run -d --rm -it -v $(pwd)/config.py:/config.py -p 8080:8080 -e SECRET_KEY=$secret_key -e TOKEN_GENERATION_AUTH=$token_generation_auth scythe-mail-merge:latest)

sleep 3 

curl -sH "X-TOKEN-GENERATION-AUTH: $token_generation_auth" -d "name=$name" -d "mail=$email" http://localhost:8080/token

echo -e "\nReturn to stop..."
read line
docker rm -f $did