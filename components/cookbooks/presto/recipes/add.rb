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

include_recipe "presto::start"
