include_pack 'genericlb'

name 'presto'
description 'Presto'
type 'Platform'
category 'Other'

# security group aka firewall
resource "secgroup",
    :cookbook => "secgroup",
    :design => true,
    :attributes => {
        "inbound" => '[
            "22 22 tcp 0.0.0.0/0",
            "1024 65535 tcp 0.0.0.0/0",
            "60000 60010 udp 0.0.0.0/0",
            "8080 8080 tcp 0.0.0.0/0"
        ]'
    },
    :requires => {
        :constraint => "1..1",
        :services => "compute"
    }

resource 'compute',
         :cookbook => 'oneops.1.compute',
         :design => true,
         :attributes => {:size => 'XXL'}

resource 'presto',
         :cookbook => 'oneops.1.presto',
         :design => true,
         :requires => {
             :constraint => '1..1',
             :services => 'mirror'
         },
         :attributes => {
         },
         :monitors => {
             'HttpValue' => { :description => 'HttpValue',
                              :source => '',
                              :chart => { 'min' => 0, 'unit' => '' },
                              :cmd => 'check_http_value!#{cmd_options[:url]}!#{cmd_options[:format]}',
                              :cmd_line => '/opt/nagios/libexec/check_http_value.rb $ARG1$ $ARG2$',
                              :cmd_options => {
                                  'url' => '',
                                  'format' => ''
                              },
                              :metrics => {
                                  'value' => metric(:unit => '', :description => 'value', :dstype => 'DERIVE')

                              } },
             'JvmInfo' => { :description => 'JvmInfo',
                            :source => '',
                            :chart => { 'min' => 0, 'unit' => '' },
                            :cmd => 'check_presto_jvm',
                            :cmd_line => '/opt/nagios/libexec/check_presto.rb JvmInfo',
                            :metrics => {
                                'max' => metric(:unit => 'B', :description => 'Max Allowed', :dstype => 'GAUGE'),
                                'free' => metric(:unit => 'B', :description => 'Free', :dstype => 'GAUGE'),
                                'total' => metric(:unit => 'B', :description => 'Allocated', :dstype => 'GAUGE'),
                                'percentUsed' => metric(:unit => 'Percent', :description => 'Percent Memory Used', :dstype => 'GAUGE')
                            },
                            :thresholds => {
                                'HighMemUse' => threshold('5m', 'avg', 'percentUsed', trigger('>', 98, 15, 1), reset('<', 98, 5, 1))
                            } }
         }

resource 'presto_coordinator',
      :cookbook => 'oneops.1.presto_coordinator',
      :design => true,
      :requires => { 'constraint' => '1..1' }

resource 'presto_mysql',
       :cookbook => 'oneops.1.presto_mysql',
       :design => true,
       :requires => { 'constraint' => '0..*' }

resource 'artifact',
         :cookbook => 'oneops.1.artifact',
         :design => true,
         :requires => { 'constraint' => '0..*' },
         :attributes => {

         },
         :monitors => {
             'URL' => { :description => 'URL',
                        :source => '',
                        :chart => { 'min' => 0, 'unit' => '' },
                        :cmd => 'check_http_status!#{cmd_options[:host]}!#{cmd_options[:port]}!#{cmd_options[:url]}!#{cmd_options[:wait]}!#{cmd_options[:expect]}!#{cmd_options[:regex]}',
                        :cmd_line => '/opt/nagios/libexec/check_http_status.sh $ARG1$ $ARG2$ "$ARG3$" $ARG4$ "$ARG5$" "$ARG6$"',
                        :cmd_options => {
                            'host' => 'localhost',
                            'port' => '8080',
                            'url' => '/',
                            'wait' => '15',
                            'expect' => '200 OK',
                            'regex' => ''
                        },
                        :metrics => {
                            'time' => metric(:unit => 's', :description => 'Response Time', :dstype => 'GAUGE'),
                            'up' => metric(:unit => '', :description => 'Status', :dstype => 'GAUGE'),
                            'size' => metric(:unit => 'B', :description => 'Content Size', :dstype => 'GAUGE', :display => false)
                        },
                        :thresholds => {

                        } }
         }

resource 'build',
         :cookbook => 'oneops.1.build',
         :design => true,
         :requires => { 'constraint' => '0..*' },
         :attributes => {
             'install_dir' => '/usr/local/build',
             'repository'    => '',
             'remote'        => 'origin',
             'revision'      => 'HEAD',
             'depth'         => 1,
             'submodules'    => 'false',
             'environment'   => '{}',
             'persist'       => '[]',
             'migration_command' => '',
             'restart_command'   => ''
         }

resource "lb",
         :except => [ 'single' ],
         :design => false,
         :cookbook => "oneops.1.lb",
         :requires => { "constraint" => "1..1", "services" => "lb,dns,*mirror" },
         :attributes => {
             'ecv_map' => '{"8080":"GET /v1/info/coordinator"}',
             'listeners' => '[ "http 8080 http 8080" ]'
         }

resource 'java',
         :cookbook => 'oneops.1.java',
         :design => true,
         :requires => {
             :constraint => '1..1',
             :services => '*mirror',
             :help => 'Java Programming Language Environment'
         },
         :attributes => {
             'flavor' => 'oracle'
         }

# depends_on
[{ :from => 'presto',     :to => 'java' },
 { :from => 'presto',     :to => 'user' },
 { :from => 'artifact',   :to => 'library' },
 { :from => 'artifact',   :to => 'presto'  },
 { :from => 'artifact',   :to => 'download' },
 { :from => 'artifact',   :to => 'build' },
 { :from => 'artifact',   :to => 'volume' },
 { :from => 'build',      :to => 'library' },
 { :from => 'build',      :to => 'presto'  },
 { :from => 'build',      :to => 'download' },
 { :from => 'java',       :to => 'compute' },
 { :from => 'presto_coordinator', :to => 'fqdn' },
 { :from => 'presto_coordinator', :to => 'presto' },
 { :from => 'presto_mysql', :to => 'presto' },
 { :from => 'java',       :to => 'os' },
 { :from => 'java',       :to => 'download' }].each do |link|
    relation "#{link[:from]}::depends_on::#{link[:to]}",
             :relation_name => 'DependsOn',
             :from_resource => link[:from],
             :to_resource => link[:to],
             :attributes => { 'flex' => false, 'min' => 1, 'max' => 1 }
end

[{ :from => 'presto_coordinator', :to => 'fqdn' }].each do |link|
    relation "#{link[:from]}::depends_on_converge::#{link[:to]}",
             :except => ['_default', 'single'],
             :relation_name => 'DependsOn',
             :from_resource => link[:from],
             :to_resource => link[:to],
             :attributes => { 'flex' => false, "converge" => true, 'min' => 1, 'max' => 1 }
end

# managed_via
['presto', 'build', 'artifact', 'java', 'presto_coordinator', 'presto_mysql' ].each do |from|
    relation "#{from}::managed_via::compute",
             :except => ['_default'],
             :relation_name => 'ManagedVia',
             :from_resource => from,
             :to_resource => 'compute',
             :attributes => {}
end
