#
# Cookbook Name:: fluentd
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
cookbook_file "/etc/yum.repos.d/td.repo" do
  source "td.repo"
  mode 00644
end

package "td-agent" do
  action :install
  options "--enablerepo=treasuredata"
end

directory "/var/log/fluent" do
  mode "00775"
  action :create
end

directory "/var/log/httpd/" do
  mode "00777"
end

bash 'install fluent-plugin-elasticsearch' do
  action :run
  cwd '/usr/lib64/fluent/ruby/bin/'
  code <<-EOH
sudo ./fluent-gem install fluent-plugin-elasticsearch
  EOH
end

service "td-agent" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

cookbook_file "/etc/td-agent/td-agent.conf" do
  mode "00644"
  source "td-agent.conf"
  action :create
  notifies :restart, "service[td-agent]"
end