# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Use Ubuntu 14.04 as a base image.
  config.vm.box = "ubuntu/trusty64"

  # If trusty is not available - download it from there.
  config.vm.box_url = "https://vagrantcloud.com/ubuntu/boxes/trusty64"

  # Build machine based on provision.sh file.
  config.vm.provision :shell, :path => "provision.sh", :args => ENV['SHELL_ARGS']

  # This IP in private network should be free :)
  config.vm.network :private_network, ip: '10.254.254.254'

  # Main hostname (will be added to /etc/hosts on your host.
  config.vm.hostname = "docker.dev"

  # Prepare 12 more domain slots, although it's probably better to use tools like dynmasq
  config.hostsupdater.aliases = ["drupal1.dev", "drupal2.dev", "drupal3.dev", "drupal4.dev", "drupal5.dev", "drupal6.dev", "drupal7.dev", "drupal8.dev", "drupal9.dev", "drupal10.dev", "drupal11.dev", "drupal12.dev"]

  # Forward ssh-agent
  config.ssh.forward_agent = true

  # Mount parent folder (to this file) to /home/vagrant/projects
  config.vm.synced_folder "./", "/nfs-tmp",
    id: "core",
    :nfs => true,
    :mount_options => ['nolock,vers=3,udp']
  config.bindfs.bind_folder "/nfs-tmp", "/home/vagrant/projects",
    mirror: "root,www-data,vagrant",
    group: "www-data",
    perms: "u=u:g=g:o=o"

  # Mount user .ssh folder to /home/vagrant/identity
  config.vm.synced_folder "~/.ssh", "/ssh-tmp",
    id: "identity",
    :nfs => true,
    :mount_options => ['nolock,vers=3,udp']
  config.bindfs.bind_folder "/ssh-tmp", "/home/vagrant/identity",
    user: "root",
    group: "root",
    perms: "u=u:g=g:o=o"

  # Set Virtual Box parameters
  config.vm.provider :virtualbox do |vb|
    vb.memory = 4096
    vb.cpus = 2
    vb.name = "docker_host"
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

end
