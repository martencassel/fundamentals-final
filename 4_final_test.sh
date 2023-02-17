#!/bin/bash

docker network rm demo_net||true
docker container rm -f ui||true
docker container rm -f api||true
docker container rm -f database||true


docker network create demo_net
docker container run -d --network demo_net --name database mydb
docker container run -d --network demo_net --name api myapi
docker container run -d --network demo_net --name ui -p 3000:3000 myui

docker ps

curl localhost:3000/pet

docker container rm -f ui
docker container rm -f api
docker container rm -f database
docker network rm demo_net