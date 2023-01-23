#/!bin/bash

version=$(hatch version)
hatch env prune
hatch build
docker rmi -f scythe-mail-merge:$version
docker build --build-arg version=$version -t scythe-mail-merge:$version .
docker tag scythe-mail-merge:$version scythe-mail-merge:latest