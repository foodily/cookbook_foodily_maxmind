#
# Cookbook Name:: foodily_maxmind
# Recipe:: default
#
# Copyright (C) 2014 Foodily, Inc
# 
# All rights reserved - Do Not Redistribute
#

#apt-get update
#apt-get upgrade ilibcurl4-gnutls-dev

package 'libcurl4-gnutls-dev' do
 action :install
end

include_recipe 'foodily_users::foodily'

#install geoip.conf
cookbook_file "geoip-conf" do
  path   node['foodily_maxmind']['conf_file']
  owner  'foodily'
  group  'foodily'
  mode   '0755'
  action :create_if_missing
end


source_filename=node['foodily_maxmind']['update_install_filename']
source_filepath="#{Chef::Config['file_cache_path']}/#{source_filename}"
extract_path=node['foodily_maxmind']['install_location']
binary_file="#{extract_path}/bin/geoipupdate"

#download updater
remote_file source_filepath  do
  source   node['foodily_maxmind']['update_install_url']
  action :create_if_missing
  checksum node['foodily_maxmind']['update_install_checksum']
  owner 'foodily' 
  group 'foodily'
  mode '0755'
end

#unpack updater
bash 'extract_geoipupdater' do
  cwd ::File.dirname(source_filepath)
  code <<-EOH
    mkdir -p #{extract_path}
    tar xzf #{source_filename} -C #{extract_path}
    mv #{extract_path}/*/* #{extract_path}/
    EOH
  not_if { ::File.exists?(extract_path) }
end

#build
 Chef::Log.info ( "#{binary_file} doesn't exist.  Building from source" )  unless ::File.exists?(binary_file) 
bash 'build_geoipupdater' do
  cwd ::File.dirname(extract_path)
  code <<-EOH
    cd #{extract_path} && ./configure
    cd #{extract_path} && make && make install 
    EOH
  not_if { ::File.exists?(binary_file) }
end

#run first time if file is not present


directory node['foodily_maxmind']['data_file_location'] do
  owner 'foodily'
  group 'foodily'
  mode 00755
  recursive true
  action :create
end

data_file = node['foodily_maxmind']['data_file_location']+"/GeoIP2-City.mmdb"
data_file_path = node['foodily_maxmind']['data_file_location']
geoip_command = "#{binary_file} -f #{node['foodily_maxmind']['conf_file']} -d #{node['foodily_maxmind']['data_file_location']}"



Chef::Log.info ( "#{data_file} not found.  Populating data file with #{geoip_command}") unless ::File.exists?(data_file) 
bash 'populate_geoipupdater' do
  cwd ::File.dirname(data_file_path)
  code <<-EOH
      #{geoip_command} 
      EOH
    not_if { ::File.exists?(data_file) }
end


#schedule cron for updater.
cron 'geoipupdater' do
    action :create
    weekday '5'
    user 'foodily'
    command geoip_command

end







