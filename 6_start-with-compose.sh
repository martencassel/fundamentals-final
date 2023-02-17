#!/bin/bash

# If needed
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
export PATH=/usr/local/bin:$PATH


docker rm -f $(docker ps -aq)

cat <<EOF > docker-compose.yml
version: "3.1"

services:
  database:
    image: martendocker/mydb
    networks:
    - back-tier
  api:
    image: martendocker/myapi
    networks:
    - front-tier
    - back-tier
  ui:
    image: martendocker/myui
    ports:
    - "3000:3000"
    networks:
    - front-tier
networks:
  front-tier:
  back-tier:
EOF

docker-compose up -d

curl localhost:3000/pet