#
# Cookbook Name:: presto
# Recipe:: stop

ruby_block 'Stop presto service' do
    block do
        Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
        shell_out!('service presto stop',
                   live_stream: Chef::Log.logger)
    end
end
