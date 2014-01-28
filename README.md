# foodily_maxmind cookbook

# Requirements
	libcurl4-gnutls-dev - curl development libraries
        foodily_users::foodily - create foodily user
# Usage

# Attributes
	default['foodily_maxmind']['update_install_version']='2.0.0'
	default['foodily_maxmind']['update_install_checksum']='b80e20aa9046bd63653d9a28c3bd9591261d59a6437a17673d5700c5924ef832'
	default['foodily_maxmind']['install_location']

* generated attributes:
	default['foodily_maxmind']['update_install_filename']='geoipupdate-'+node['foodily_maxmind']['update_install_version']+'.tar.gz'
	default['foodily_maxmind']['update_install_url']='https://github.com/maxmind/geoipupdate/releases/download/v'+ node['foodily_maxmind']['update_install_version'] + '/'+ node['foodily_maxmind']['update_install_filename']
	default['foodily_maxmind']['binary_file']=node['foodily_maxmind']['install_location']+'/bin/geoipupdate'


# Recipes
  	foodily_maxmind::default.rb : 
		install updater
		install geoip.conf - file
		create data directory
		schedule cron

# Author

Author:: Foodily, Inc (<sysadmin@foodily.com>)
