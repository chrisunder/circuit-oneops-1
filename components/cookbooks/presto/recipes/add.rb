ruby_block 'Install Presto RPM' do
    block do
        Chef::Resource::RubyBlock.send(:include, Chef::Mixin::ShellOut)
        system("yum install -y 'http://cdc-rgw.ost.cloud.wal-mart.com/swift/v1/com-walmart-bfd-public-installs/presto/presto-server-rpm-#{node.presto.version}.rpm'")
    end
end

template '/opt/nagios/libexec/check_presto.rb' do
    source 'check_presto.rb.erb'
    owner 'oneops'
    group 'oneops'
    mode '0755'
end

include_recipe "presto::start"
