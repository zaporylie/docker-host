Docker Host for OSX
==============================

So you want to use Docker containers on Mac? Yeah... that's possible but 
requires one more level for your development environment.
 
But don't worry! It's not that bad :)

You can use some fancy tools, like boot2docker (so you'll get access to docker
directly from your host). I tried that - it takes a lot of time to configure it
and it doesn't work that well. So I decided to write this small Ubuntu based
vagrant box. **Finally - simplest solutions are the best!**


## Requirements

* Vagrant (with VirtualBox as a provider)
* [Vagrant-hostupdater](https://github.com/cogitatio/vagrant-hostsupdater)
* [Vagrant-bindfs](https://github.com/gael-ian/vagrant-bindfs)

## Instalation

Use shortcut:
````bash
curl -s https://raw.githubusercontent.com/zaporylie/docker-host/master/install.sh | sudo sh

# sudo is used to type password only once, and skip it when vagrant will mount 
# folders with nfs
````

or follow this steps:

1. Download and extract repository.
1. To make it easy keep projects you are currently working on in this directory. You can move it to another place but set correct path to sync folder in Vagrantfile
1. `vagrant up` then `vagrant ssh` from anywhere inside this directory.
1. `docker ps` you can start right away!

I still recommend to use git, vim or other tools on your host - it 
is probably more convenient. I believe you will use vagrant only to run 
`docker-compose up`, eventually manage your images/containers.

## Features

This box comes with two useful container:

1. [nginx-proxy](https://github.com/jwilder/nginx-proxy) by jwilder (user VIRTUAL_HOST env flag)
1. [dockerui](https://github.com/crosbymichael/dockerui) by crosbymichael (visit docker.dev:81)

## Known issues

* To deal with file permissions we use bindfs (so first mount nfs to tmp 
location, then bindfs locally with ownership change). It can cause small 
performance issues.
* You can't change file ownership but, in the same time, bindfs takes care to
mirror ownership, so vagrant, root and www-data "think" that they are file 
owners. It can cause security issues (drupal core will be writable for www-data).
* Virtualbox takes 4 GB of RAM. That's a lot.
