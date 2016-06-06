#
# Cookbook Name:: presto_cassandra
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

presto_catalog_file = '/usr/lib/presto/etc/catalog/' + node.presto_cassandra.connection_name + '.properties'

template presto_catalog_file do
    source 'cassandra.properties.erb'
    owner 'presto'
    group 'presto'
    mode '0755'
    variables ({
        :connection_contact_points => node.presto_cassandra.connection_contact_points
    })
end

include_recipe 'presto_cassandra::restart'
