#!/bin/bash

cat <<EOF > ./api/Dockerfile
FROM maven:3.6.3-jdk-8 AS appserver 
COPY . .
RUN mvn -B -f pom.xml -s /usr/share/maven/ref/settings-docker.xml dependency:resolve
RUN mvn -B -s /usr/share/maven/ref/settings-docker.xml package -DskipTests

FROM openjdk:8-jdk-alpine
RUN adduser --gecos "" --disabled-password --home /home/gordon gordon
COPY --from=appserver /target/ddev-0.0.1-SNAPSHOT.jar .
ENTRYPOINT ["java", "-jar", "/ddev-0.0.1-SNAPSHOT.jar"]
CMD ["--spring.profiles.active=postgres"]
EOF

docker build -t myapi ./api/ -f ./api/Dockerfile

docker network create demo_net
docker container run -d --network demo_net --name database mydb
docker container run -d --network demo_net -p 8080:8080 --name api myapi

curl localhost:8080/api/pet

docker container rm -f api 
docker container rm -f database
docker network rm docker_net

# API will attempt to load the postgres password from /run/secrets/postgres_password if it exists.
# Otherwise, it will load the password from src/main/resources/application.yml

docker network create demo_net
docker container run -d --network demo_net --name database mydb
docker container run -d \
     -v $(pwd)/docker_postgres_password:/run/secrets/postgres_password \
     --network demo_net -p 8080:8080 --name api myapi \
   
curl localhost:8080/api/pet

docker container rm -f api 
docker container rm -f database
docker network rm docker_net
