#!/bin/sh

docker login && \
docker build . -t java-rpi --no-cache && \
docker tag java-rpi jsmsalt/java-rpi:latest && \
docker push jsmsalt/java-rpi:latest