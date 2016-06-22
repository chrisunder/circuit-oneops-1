#
# Cookbook Name:: presto
# Recipe:: install
#
# Copyright 2016, Walmart Labs
#
# Apache License, Version 2.0
#


# Replace any $version placeholder variables present in the URL
# e.x: http://<mirror>/some/path/$version.rpm
install_url = node.presto.presto_rpm_install_url.gsub('$version', node.presto.version)

Chef::Log.info("Installing Presto with #{install_url}")

node_id = SecureRandom.uuid

node_prop_file = '/etc/presto/node.properties'

if File.file?(node_prop_file)
    File.open(node_prop_file, "r") do |file_handle|
      file_handle.each_line do |line|
        if line =~ /node.id/ then
            node_id = line.split("=")[1].gsub(/\n/, "")
            Chef::Log.info("Reusing node id of #{node_id}")
        end
      end
    end
end

include_recipe "presto::delete"

ruby_block 'Install Presto RPM' do
    block do
        Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
        system("yum install -y '#{install_url}'")
    end
end

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
        :node_id => node_id,
        :data_directory_dir => node.presto.data_directory_dir,
        :query_max_memory => node.presto.query_max_memory,
        :query_max_memory_per_node => node.presto.query_max_memory_per_node,
    })
end
    })
end
