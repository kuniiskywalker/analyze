Vagrant.configure(2) do |config|

  config.vm.box = "centos64"
  config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.4.2/centos64-x86_64-20140116.box"

  config.vbguest.auto_update = false

  config.omnibus.chef_version = :latest

  config.vm.network :forwarded_port, guest: 80, host: 8000
  config.vm.network :forwarded_port, guest: 9200, host: 9200
  config.vm.synced_folder ".", "/vagrant", owner: 'vagrant', group: 'vagrant', mount_options: ['dmode=777', 'fmode=666']
  
  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = ["chef-repo/cookbooks", "chef-repo/site-cookbooks"]

    chef.add_recipe "elasticsearch::elasticsearch"
    chef.add_recipe "kibana::kibana"
    chef.add_recipe "apache::apache"
    chef.add_recipe "fluentd"

  end

end
