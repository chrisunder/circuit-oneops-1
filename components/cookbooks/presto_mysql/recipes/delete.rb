#
# Cookbook Name:: Presto_mysql
# Recipe:: delete
#
# Copyright 2016, Walmart Labs
#
# Apache License, Version 2.0
#

presto_catalog_file = '/etc/presto/catalog/' + node.presto_mysql.connection_name + '.properties'

file presto_catalog_file do
    action :delete
end

include_recipe 'presto_mysql::restart'