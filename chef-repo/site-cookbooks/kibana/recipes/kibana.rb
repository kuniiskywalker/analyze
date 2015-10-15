package "wget"

## directory
directory '/var/log/kibana/' do
  owner 'root'
  group 'root'
  mode '0777'
  action :create
  recursive true
end

## kibana install
bash "kibana" do
  not_if "ls /usr/local/kibana"
  user "root"
  cwd "/usr/local/src"
  code <<-EOH
    wget https://download.elastic.co/kibana/kibana/kibana-4.1.1-linux-x64.tar.gz
    tar -zxvf kibana-4.1.1-linux-x64.tar.gz
    mv kibana-4.1.1-linux-x64 ../kibana
  EOH
end

cookbook_file '/etc/init.d/kibana' do
  source "kibana"
  mode "0755"
end

bash 'replace kibana new line' do
  action :run
  cwd '/etc/init.d'
  code <<-EOH
sudo sed -i 's/\r//' kibana
  EOH
end

execute "add_kibana_service" do
  user "root"
  command  "chkconfig kibana on"
  action :run
end
