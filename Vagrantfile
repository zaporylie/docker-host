# -*- mode: ruby -*-
# # vi: set ft=ruby :

require 'fileutils'

Vagrant.require_version ">= 1.6.0"

CLOUD_CONFIG_PATH = File.join(File.dirname(__FILE__), "user-data")
CONFIG = File.join(File.dirname(__FILE__), "config.rb")

if File.exist?(CONFIG)
  require CONFIG
end

Vagrant.configure("2") do |config|

  # always use Vagrants insecure key
  config.ssh.insert_key = false

  config.vm.box = "coreos-%s" % $update_channel
  config.vm.box_version = ">= 308.0.1"
  config.vm.box_url = "http://%s.release.core-os.net/amd64-usr/current/coreos_production_vagrant.json" % $update_channel

  config.vm.provider :virtualbox do |v|
    # On VirtualBox, we don't have guest additions or a functional vboxsf
    # in CoreOS, so tell Vagrant that so it can be smarter.
    v.check_guest_additions = false
    v.functional_vboxsf     = false
  end

  # plugin conflict
  if Vagrant.has_plugin?("vagrant-vbguest") then
    config.vbguest.auto_update = false
  end

  (1..$num_instances).each do |i|
    config.vm.define vm_name = "%s-%02d" % [$instance_name_prefix, i] do |config|

      config.vm.hostname = "%s.%s" % [vm_name, $instance_name_host_domain]

      # Forward ssh-agent
      config.ssh.forward_agent = true

      if $expose_docker_tcp
        config.vm.network "forwarded_port", guest: 2375, host: ($expose_docker_tcp + i - 1), auto_correct: true
      end

      config.vm.provider :virtualbox do |vb|
        vb.gui = $vm_gui
        vb.memory = $vm_memory
        vb.cpus = $vm_cpus
        vb.name = vm_name
      end

      ip = "172.17.9.#{i+100}"
      config.vm.network :private_network, ip: ip

      $shared_folders.each_with_index do |(host_folder, guest_folder), index|
        config.vm.synced_folder host_folder.to_s, guest_folder.to_s, id: "core-share%02d" % index, :map_uid => 0, :map_gid => 0, :nfs => true, :mount_options => ['nolock,vers=3,udp']
      end

      if $share_home
        config.vm.synced_folder ENV['HOME'], ENV['HOME'], id: "home", :map_uid => 0, :map_gid => 0, :nfs => true, :mount_options => ['nolock,vers=3,udp']
      end

      if $share_current
        config.vm.synced_folder File.dirname(__FILE__), File.dirname(__FILE__), id: "current", :map_uid => 0, :map_gid => 0, :nfs => true, :mount_options => ['nolock,vers=3,udp']
      end

      if File.exist?(CLOUD_CONFIG_PATH)
        config.vm.provision :file, :source => "#{CLOUD_CONFIG_PATH}", :destination => "/tmp/vagrantfile-user-data"
        config.vm.provision :shell, :inline => "mv /tmp/vagrantfile-user-data /var/lib/coreos-vagrant/", :privileged => true
      end

    end
  end
end
