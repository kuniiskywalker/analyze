## directory
directory '/var/www/html' do
  owner 'root'
  group 'root'
  mode '0777'
  action :create
  recursive true
end

package "wget"

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

# cookbook_file '/etc/init.d/kibana' do
#   source "kibana"
#   mode "0755"
# end

# ## kibana config setting
# template "/var/www/html/kibana/config.js" do
#   source "config.js.erb"
#   owner "root"
#   group "root"
#   mode 0777
# end