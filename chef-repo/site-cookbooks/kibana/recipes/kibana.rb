## directory
directory '/var/www/html' do
  owner 'root'
  group 'root'
  mode '0777'
  action :create
  recursive true
end

## kibana install
bash "kibana" do
  not_if "ls /var/www/html/kibana"
  user "root"
  cwd "/usr/local/src"
  code <<-EOH
    wget https://download.elasticsearch.org/kibana/kibana/kibana-3.1.0.tar.gz
    tar xvzf kibana-3.1.0.tar.gz -C /var/www/html
    mv /var/www/html/kibana-3.1.0 /var/www/html/kibana
  EOH
end

## kibana config setting
template "/var/www/html/kibana/config.js" do
  source "config.js.erb"
  owner "root"
  group "root"
  mode 0777
end