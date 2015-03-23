#!/bin/sh

curl -Lk https://github.com/zaporylie/docker-host/archive/master.tar.gz |  tar -zxf -
cp -Ri docker-host-master/* ./
rm -Rf docker-host-master
vagrant up
vagrant ssh
