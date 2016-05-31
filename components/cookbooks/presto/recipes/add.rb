#
# Cookbook Name:: presto
# Recipe:: add
#
# Copyright 2016, Walmart Labs
#
# Apache License, Version 2.0
#

include_recipe "presto::delete"

package 'mosh'
package 'screen'

include_recipe "presto::install_binary"

template '/opt/nagios/libexec/check_presto.rb' do
    source 'check_presto.rb.erb'
    owner 'oneops'
    group 'oneops'
    mode '0755'
end

directory node.presto.data_directory_dir do
  owner 'presto'
  group 'presto'
  mode  '0755'
  recursive true
end

directory '/usr/lib/presto/var' do
  owner 'presto'
  group 'presto'
  mode  '0755'
  recursive true
end

directory '/etc/presto' do
  owner 'presto'
  group 'presto'
  mode  '0755'
  recursive true
end

template '/etc/presto/node.properties' do
    source 'node.properties.erb'
    owner 'presto'
    group 'presto'
    mode '0755'
    variables ({
        :environment => node.workorder.payLoad.Environment[0].ciName,
        :node_id => SecureRandom.uuid,
        :data_directory_dir => node.presto.data_directory_dir
    })
end

include_recipe "presto::start"
