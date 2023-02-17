#!/bin/bash

docker swarm init

docker stack deploy -c docker-compose.yml pets

curl localhost:3000/pet