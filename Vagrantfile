# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'open-uri'
require 'json'

CARELINK_DOWNLOAD_LINKS_URL = "https://carelink.minimed.eu/patient/dataUpload/client/links"
SYMLINK_NAME = "CareLinkUploader-windows-installer.exe"

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
ENV['VAGRANT_DEFAULT_PROVIDER'] = "virtualbox"
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "gusztavvargadr/windows-11-21h2-enterprise"

  config.vm.guest = :windows
  config.vm.communicator = "winrm"
  config.vm.network "forwarded_port", guest: 3389, host: 53389

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    vb.linked_clone = true

    # Display the VirtualBox GUI when booting the machine
    vb.gui = true
  
    # Customize the amount of memory on the VM:
    vb.memory = "4096"
    vb.cpus = 2
    vb.customize ["modifyvm", :id, "--vram", 128]
    vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
    vb.customize ["modifyvm", :id, "--usb", "on"]
    vb.customize ["modifyvm", :id, "--usbehci", "on"]
    vb.customize [
      "usbfilter", "add", "0",
      "--target", :id,
      "--name", "Contour Plus Link 2.4",
      "--action", "hold",
      "--vendorid", "1A79",
      "--productid", "6210"
    ]
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  config.trigger.before [:reload, :up, :provision] do |trigger|
    trigger.info = "Downloading CareLinkUploader on the host..."
    trigger.ruby do |env, machine|
      data = JSON.load(URI.parse(CARELINK_DOWNLOAD_LINKS_URL).open)
      uri = URI.parse(data["urlWin"])
      carelink_exe_name = File.basename(uri.path)
      if (!File.exist?(carelink_exe_name))
        IO.copy_stream(uri.open, carelink_exe_name)
        if (File.exist?(SYMLINK_NAME))
          File.symlink(carelink_exe_name, "#{SYMLINK_NAME}.new")
          begin
            File.rename("#{SYMLINK_NAME}.new", SYMLINK_NAME)
          rescue
            File.unlink("#{SYMLINK_NAME}.new")
            raise
          end
        else
          File.symlink(carelink_exe_name, SYMLINK_NAME)
        end
      end
    end
  end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", path: "./provision.ps1", args: [SYMLINK_NAME]
end
