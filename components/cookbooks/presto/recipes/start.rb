#
# Cookbook Name:: tomcat
# Recipe:: start
#

ruby_block 'Start presto service' do
    block do
        Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
        shell_out!('service presto start',
                   live_stream: Chef::Log.logger)
    end
end
