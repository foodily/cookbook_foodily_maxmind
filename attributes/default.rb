# Attributes for managing mindmax geo-ip data

default['foodily_maxmind']['update_install_version']='2.0.0'

#calculate checksum with > shasum -a 256 geoipupdate-2.0.0.tar.gz after manually downloading once.
default['foodily_maxmind']['update_install_checksum']='b80e20aa9046bd63653d9a28c3bd9591261d59a6437a17673d5700c5924ef832'

#generate the filename based on the install version.
default['foodily_maxmind']['update_install_filename']='geoipupdate-'+node['foodily_maxmind']['update_install_version']+'.tar.gz'

#dynamicallly build the download url from version
default['foodily_maxmind']['update_install_url']='https://github.com/maxmind/geoipupdate/releases/download/v'+ node['foodily_maxmind']['update_install_version'] + '/'+ node['foodily_maxmind']['update_install_filename']

#name for the downloaded source package
default['foodily_maxmind']['source_install_location']='/tmp/'+node['foodily_maxmind']['update_install_filename']

default['foodily_maxmind']['install_location']='/usr/local/geoipupdater'
default['foodily_maxmind']['data_file_location']='/data/geoip'
default['foodily_maxmind']['conf_file']='/etc/geoip.conf'


