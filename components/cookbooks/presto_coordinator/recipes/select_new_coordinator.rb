#
# Cookbook Name:: presto_coordinator
# Recipe:: select_new_coordinator
#

require 'rubygems'
require 'json'

nodes = node.workorder.payLoad.RequiresComputes
computeNodes = Array.new
nodes.each do |n|
    computeNodes.push(n)
end

# build presto_peers array with the ips of the computeNodes
presto_peers = Array.new
computeNodes.each do |n|
    peer_ip = [n[:ciAttributes][:dns_record]]
    presto_peers.push(peer_ip)
end

# sort the Array since we need the list to be in consistnet order for next step
presto_peers.sort!

coordinator_ip = ''
coordinator_fqdn = ''

Chef::Log.info("IP list of #{presto_peers}")

coordinator_ip = presto_peers[0][0]

Chef::Log.info("Coordinator IP will be #{coordinator_ip} with node ip of #{node.ipaddress}")

coordinator_fqdn_payload = node.workorder.payLoad["prestofqdn"]

if (!coordinator_fqdn_payload.nil? )
    coordinator_fqdns = JSON.parse(coordinator_fqdn_payload[0][:ciAttributes][:entries])
    Chef::Log.info("coordinator_fqdns: #{coordinator_fqdns}")
    if (!coordinator_fqdns.nil? && !coordinator_fqdns.empty? )
        coordinator_fqdn = coordinator_fqdns.keys[1]
        Chef::Log.info("Found FQDN of #{coordinator_fqdn}")
    else
        Chef::Log.error("Unable to find a valid FQDN from the list of FQDNs of the load balancer")
        exit 1
    end
else
    Chef::Log.error("Unable to find a valid FQDN payload")
    exit 1
end

coordinator = node.ipaddress == coordinator_ip

template '/etc/presto/config.properties' do
    source 'config.properties.erb'
    owner 'presto'
    group 'presto'
    mode '0755'
    variables ({
        :coordinator => coordinator,
        :port => '8080',
        :coordinator_fqdn => coordinator_fqdn
    })
end

ruby_block 'Restart presto service' do
    block do
        Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
        shell_out!('service presto restart',
                   live_stream: Chef::Log.logger)
    end
end
