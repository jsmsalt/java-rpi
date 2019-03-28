#!/bin/sh

docker login && \
docker build . -t alpine-java-rpi --no-cache && \
docker tag alpine-java-rpi jsmsalt/alpine-java-rpi:latest && \
docker push jsmsalt/alpine-java-rpi:latest