#
# Cookbook Name:: presto_swift
# Recipe:: add
#
# Copyright 2016, Walmart Labs
#
# Apache License, Version 2.0
#

require File.expand_path("../swift_helper.rb", __FILE__)

# Find the Nexus URL
nexus_url = ""
cloud_vars = node.workorder.payLoad.OO_CLOUD_VARS
cloud_vars.each do |var|
  if var[:ciName] == "nexus"
    nexus_url = "#{var[:ciAttributes][:value]}"
  end
end

if nexus_url == ""
  cloud_name = node[:workorder][:cloud][:ciName]

  # Look in the defined services
  if (!node[:workorder][:services]["maven"].nil?)
    nexus_url = node[:workorder][:services]['maven'][cloud_name][:ciAttributes][:url]
  end
end

if nexus_url == ""
  puts "***FAULT:FATAL=The Nexus URL has not been specified. It needs to be set either through the 'nexus' cloud variable or by adding a Maven service to your cloud."
  e = Exception.new("no backtrace")
  e.set_backtrace("")
  raise e
end

# Normalize the nexus URL to ensure it is in the proper format
nexus_url = fix_nexus_url(nexus_url)

hadoop_openstack_url = nexus_url + "/service/local/artifact/maven/redirect?g=org.apache.hadoop&a=hadoop-openstack&v=#{node.presto_swift.hadoop_openstack_version}&r=#{node.presto_swift.nexus_hadoop_openstack_repo}"
httpclient_commons_url = nexus_url + "/service/local/artifact/maven/redirect?g=commons-httpclient&a=commons-httpclient&v=#{node.presto_swift.commons_httpclient_version}&r=#{node.presto_swift.nexus_central_repo}"
jackson_core_asl_url = nexus_url + "/service/local/artifact/maven/redirect?g=org.codehaus.jackson&a=jackson-core-asl&v=#{node.presto_swift.commons_jackson_version}&r=#{node.presto_swift.nexus_central_repo}"
jackson_jaxrs_url = nexus_url + "/service/local/artifact/maven/redirect?g=org.codehaus.jackson&a=jackson-jaxrs&v=#{node.presto_swift.commons_jackson_version}&r=#{node.presto_swift.nexus_central_repo}"
jackson_xc_url = nexus_url + "/service/local/artifact/maven/redirect?g=org.codehaus.jackson&a=jackson-xc&v=#{node.presto_swift.commons_jackson_version}&r=#{node.presto_swift.nexus_central_repo}"
jackson_mapper_asl_url = nexus_url + "/service/local/artifact/maven/redirect?g=org.codehaus.jackson&a=jackson-mapper-asl&v=#{node.presto_swift.commons_jackson_version}&r=#{node.presto_swift.nexus_central_repo}"

Chef::Log.info("Hadoop Openstack URL #{hadoop_openstack_url}")

directory '/usr/lib/presto/etc/catalog/' do
    owner 'presto'
    group 'presto'
    mode  '0755'
    recursive true
end

directory '/etc/hadoop/conf/' do
    owner 'root'
    group 'root'
    mode  '0755'
    recursive true
end

directory '/usr/lib/presto/lib/plugin/hive-hadoop2/' do
    owner 'root'
    group 'root'
    mode  '0755'
    recursive true
end

remote_file "/usr/lib/presto/lib/plugin/hive-hadoop2/hadoop-openstack-#{node.presto_swift.hadoop_openstack_version}.jar" do
    source hadoop_openstack_url
    mode '0644'
    owner 'root'
    group 'root'
    action :create
end

remote_file "/usr/lib/presto/lib/plugin/hive-hadoop2/commons-httpclient-#{node.presto_swift.commons_httpclient_version}.jar" do
    source httpclient_commons_url
    mode '0644'
    owner 'root'
    group 'root'
    action :create
end

remote_file "/usr/lib/presto/lib/plugin/hive-hadoop2/jackson-core-asl-#{node.presto_swift.commons_jackson_version}.jar" do
    source jackson_core_asl_url
    mode '0644'
    owner 'root'
    group 'root'
    action :create
end

remote_file "/usr/lib/presto/lib/plugin/hive-hadoop2/jackson-jaxrs-#{node.presto_swift.commons_jackson_version}.jar" do
    source jackson_jaxrs_url
    mode '0644'
    owner 'root'
    group 'root'
    action :create
end

remote_file "/usr/lib/presto/lib/plugin/hive-hadoop2/jackson-xc-#{node.presto_swift.commons_jackson_version}.jar" do
    source jackson_xc_url
    mode '0644'
    owner 'root'
    group 'root'
    action :create
end

remote_file "/usr/lib/presto/lib/plugin/hive-hadoop2/jackson-mapper-asl-#{node.presto_swift.commons_jackson_version}.jar" do
    source jackson_mapper_asl_url
    mode '0644'
    owner 'root'
    group 'root'
    action :create
end

presto_catalog_file = '/usr/lib/presto/etc/catalog/' + node.presto_swift.connection_name + '.properties'

template presto_catalog_file do
    source 'swift.properties.erb'
    owner 'presto'
    group 'presto'
    mode '0755'
    variables ({ })
end

template '/etc/hadoop/conf/core-site.xml' do
    source 'core-site.xml.erb'
    owner 'root'
    group 'root'
    mode '0755'
    variables ({ })
end

include_recipe 'presto_swift::restart'
