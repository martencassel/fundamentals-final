#!/bin/bash

docker tag mydb martendocker/mydb
docker tag myapi martendocker/myapi
docker tag myui martendocker/myui

docker login

docker push martendocker/mydb
docker push martendocker/myapi
docker push martendocker/myui