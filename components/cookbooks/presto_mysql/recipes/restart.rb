#
# Cookbook Name:: presto_mysql
# Recipe:: restart
#
ruby_block 'Restart presto service' do
    block do
        Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
        shell_out!('service presto restart',
                   live_stream: Chef::Log.logger)
    end
end
