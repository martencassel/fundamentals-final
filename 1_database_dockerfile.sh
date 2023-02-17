#!/bin/bash

cat > ./database/Dockerfile <<EOF
FROM postgres:9.6
ENV POSTGRES_USER gordonuser
ENV POSTGRES_DB ddev
ENV POSTGRES_PASSWORD gordonpass
COPY pg_hba.conf /usr/share/postgresql/9.6/
COPY postgresql.conf /usr/share/postgresql/9.6/
COPY init-db.sql /docker-entrypoint-initdb.d/
EOF

docker rm -f database||true
docker build -t mydb ./database/
docker run --name=database -d database 
docker container exec -it database bash
$ psql -d ddev -U gordonuser -c 'select * from images;'
