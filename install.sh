#!/bin/sh

curl -Lk https://github.com/zaporylie/drupal-host/archive/master.tar.gz |  tar -zxf -
cp -Ri drupal-host-master/* ./
rm -Rf drupal-host-master
vagrant up
vagrant ssh
