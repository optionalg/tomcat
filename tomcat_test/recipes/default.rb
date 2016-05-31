#
# Cookbook Name:: tomcat_test
# Recipe:: default
#
#
# All rights reserved - Do Not Redistribute
#

# Create tomcat user group
group node['tomcat']['group'] do
  gid node['tomcat']['group_id']
  action :create
end

# Create tomcat user
user node['tomcat']['user'] do
  gid node['tomcat']['group_id']
  uid node['tomcat']['user_id']
  action :create
end

# Create base directory
directory node['tomcat']['base_directory'] do
  owner node['tomcat']['user']
  group node['tomcat']['group']
  mode "00755"
  recursive true
end

# Download tomcat
remote_file "#{Chef::Config[:file_cache_path]}/#{node['tomcat']['tomcat_file']}" do
  source node['tomcat']['source_url']
  owner node['tomcat']['user']
  group node['tomcat']['group']
  mode "00755"
  backup false
end

# Install tomcat
install_dir="#{node['tomcat']['base_directory']}/#{node['tomcat']['instance']}"

bash "Install tomcat" do
  cwd node['tomcat']['base_directory']
  user node['tomcat']['user']
  group node['tomcat']['group']
  code <<-EOH
    tar zxf #{Chef::Config[:file_cache_path]}/#{node['tomcat']['tomcat_file']}
    mv #{node['tomcat']['default_instance']} #{node['tomcat']['instance']}
    rm -rf #{node['tomcat']['instance']}/webapps/*
  EOH
  not_if do
    ::File.exists?(install_dir)
  end
end

# Create tomcat init script
template "/etc/init.d/tomcat_#{node['tomcat']['instance']}" do
  source 'tomcat_init.sh.erb'
  mode "00755"
  backup false
  variables(
    :base_dir => node['tomcat']['base_directory'], 
    :instance_name => node['tomcat']['instance']
  )
end

# Start the service
execute "tomcat_#{node['tomcat']['instance']}" do
  command "service tomcat_#{node['tomcat']['instance']} start"
end

# Create a sample web page
directory "#{install_dir}/webapps/MyApp" do
  action :create
  user node['tomcat']['user']
  group node['tomcat']['group']
  mode "00755"
end

template "#{install_dir}/webapps/MyApp/index.html" do
  source 'sample.html.erb'
  mode "00755"
  backup false
end
