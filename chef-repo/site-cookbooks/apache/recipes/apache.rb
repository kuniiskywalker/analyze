package "httpd" do
  # version "2.2.15-30.el6.centos"
  action :install
end

service "httpd" do
  supports :status =>true, :restart=>true, :reload=>true
  action [:enable, :start]
end

execute "add_httpd_service" do
  user "root"
  command  "chkconfig httpd on"
  action :run
end