#
# Cookbook Name:: presto_mysql
# Recipe:: add
#
# Copyright 2016, Walmart Labs
#
# Apache License, Version 2.0
#

directory '/usr/lib/presto/etc/catalog/' do
  owner 'presto'
  group 'presto'
  mode  '0755'
  recursive true
end

presto_catalog_file = '/usr/lib/presto/etc/catalog/' + node.presto_mysql.connection_name + '.properties'

template presto_catalog_file do
    source 'mysql.properties.erb'
    owner 'presto'
    group 'presto'
    mode '0755'
    variables ({
        :connection_url => node.presto_mysql.connection_url,
        :connection_user_id => node.presto_mysql.connection_user_id,
        :connection_password => node.presto_mysql.connection_password
    })
end

include_recipe 'presto_mysql::restart'
