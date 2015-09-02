## java install
package "java-1.7.0-openjdk" do
  action :install
end

package "wget"

## install
bash "elasticsearch" do
  not_if "ls /usr/local/share/elasticsearch-1.2.1"
  user "root"
  cwd "/usr/local/src"
  code <<-EOH
    wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.2.1.tar.gz
    tar xvzf elasticsearch-1.2.1.tar.gz -C /usr/local/share/
  EOH
end

## add service
bash "elasticsearch_as_service" do
  not_if "ls usr/local/share/elasticsearch-1.2.1/bin/service"
  user "root"
  cwd "/usr/local/src"
  code <<-EOH
    wget https://github.com/elasticsearch/elasticsearch-servicewrapper/archive/master.zip
    unzip /usr/local/src/master
    mv /usr/local/src/elasticsearch-servicewrapper-master/service/ /usr/local/share/elasticsearch-1.2.1/bin/
    /usr/local/share/elasticsearch-1.2.1/bin/service/elasticsearch install
  EOH
end

## elasticsearch log dir
directory '/usr/local/share/elasticsearch-1.2.1/logs/' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

## elasticsearch.yml
template "/usr/local/share/elasticsearch-1.2.1/config/elasticsearch.yml" do
  source "elasticsearch.yml.erb"
  owner "root"
  group "root"
  mode 755
end


## service start
service "elasticsearch" do
  action [ :enable, :start ]
  subscribes :restart, resources(:template => "/usr/local/share/elasticsearch-1.2.1/config/elasticsearch.yml")
end

## chkconfig
execute "add_elasticsearch_service" do
  user "root"
  command  "chkconfig elasticsearch on"
  action :run
end