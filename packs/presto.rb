include_pack 'genericlb'

name 'presto'
description 'presto'
type 'Platform'
category 'Other'

environment 'redundant', {}
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
             'install_type' => 'binary'
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
             'Log' => { :description => 'Log',
                        :source => '',
                        :chart => { 'min' => 0, 'unit' => '' },
                        :cmd => 'check_logfiles!logpresto!#{cmd_options[:logfile]}!#{cmd_options[:warningpattern]}!#{cmd_options[:criticalpattern]}',
                        :cmd_line => '/opt/nagios/libexec/check_logfiles   --noprotocol --tag=$ARG1$ --logfile=$ARG2$ --warningpattern="$ARG3$" --criticalpattern="$ARG4$"',
                        :cmd_options => {
                            'logfile' => '!#{cmd_options[:logfile]}',
                            'warningpattern' => 'WARNING',
                            'criticalpattern' => 'CRITICAL'
                        },
                        :metrics => {
                            'logpresto_lines' => metric(:unit => 'lines', :description => 'Scanned Lines', :dstype => 'GAUGE'),
                            'logpresto_warnings' => metric(:unit => 'warnings', :description => 'Warnings', :dstype => 'GAUGE'),
                            'logpresto_criticals' => metric(:unit => 'criticals', :description => 'Criticals', :dstype => 'GAUGE'),
                            'logpresto_unknowns' => metric(:unit => 'unknowns', :description => 'Unknowns', :dstype => 'GAUGE')
                        },
                        :thresholds => {
                            'CriticalLogException' => threshold('15m', 'avg', 'logpresto_criticals', trigger('>=', 1, 15, 1), reset('<', 1, 15, 1))
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

resource 'presto-daemon',
         :cookbook => 'oneops.1.daemon',
         :design => true,
         :requires => {
             :constraint => '0..1',
             :help => 'Restarts Presto'
         },
         :attributes => {
             :service_name => 'presto',
             :use_script_status => 'true',
             :pattern => ''
         },
         :monitors => {
             'prestoprocess' => { :description => 'PrestoProcess',
                                  :source => '',
                                  :chart => { 'min' => '0', 'max' => '100', 'unit' => 'Percent' },
                                  :cmd => 'check_process!:::node.workorder.rfcCi.ciAttributes.service_name:::!:::node.workorder.rfcCi.ciAttributes.use_script_status:::!:::node.workorder.rfcCi.ciAttributes.pattern:::!:::node.workorder.rfcCi.ciAttributes.secondary_down:::',
                                  :cmd_line => '/opt/nagios/libexec/check_process.sh "$ARG1$" "$ARG2$" "$ARG3$" "$ARG4$"',
                                  :metrics => {
                                      'up' => metric(:unit => '%', :description => 'Percent Up')
                                  },
                                  :thresholds => {
                                      'PrestoDaemonProcessDown' => threshold('1m', 'avg', 'up', trigger('<=', 98, 1, 1), reset('>', 95, 1, 1))
                                  } }
         }

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

                        } },
             'exceptions' => { :description => 'Exceptions',
                               :source => '',
                               :chart => { 'min' => 0, 'unit' => '' },
                               :cmd => 'check_logfiles!logexc!#{cmd_options[:logfile]}!#{cmd_options[:warningpattern]}!#{cmd_options[:criticalpattern]}',
                               :cmd_line => '/opt/nagios/libexec/check_logfiles   --noprotocol  --tag=$ARG1$ --logfile=$ARG2$ --warningpattern="$ARG3$" --criticalpattern="$ARG4$"',
                               :cmd_options => {
                                   'logfile' => '/log/logmon/logmon.log',
                                   'warningpattern' => 'Exception',
                                   'criticalpattern' => 'Exception'
                               },
                               :metrics => {
                                   'logexc_lines' => metric(:unit => 'lines', :description => 'Scanned Lines', :dstype => 'GAUGE'),
                                   'logexc_warnings' => metric(:unit => 'warnings', :description => 'Warnings', :dstype => 'GAUGE'),
                                   'logexc_criticals' => metric(:unit => 'criticals', :description => 'Criticals', :dstype => 'GAUGE'),
                                   'logexc_unknowns' => metric(:unit => 'unknowns', :description => 'Unknowns', :dstype => 'GAUGE')
                               },
                               :thresholds => {
                                   'CriticalExceptions' => threshold('15m', 'avg', 'logexc_criticals', trigger('>=', 1, 15, 1), reset('<', 1, 15, 1))
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

resource 'secgroup',
         :cookbook => 'oneops.1.secgroup',
         :design => true,
         :attributes => {
             'inbound' => '[ "22 22 tcp 0.0.0.0/0",
                            "8080 8080 tcp 0.0.0.0/0",
                            "-1 -1 icmp 0.0.0.0/0",
                            "60000 61000 udp 0.0.0.0/0" ]'
         },
         :requires => {
             :constraint => '1..1',
             :services => 'compute'
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
[{ :from => 'presto', :to => 'os' },
 { :from => 'presto', :to => 'user' },
 { :from => 'presto-daemon', :to => 'compute' },
 { :from => 'presto',     :to => 'java' },
 { :from => 'artifact',   :to => 'library' },
 { :from => 'artifact',   :to => 'presto'  },
 { :from => 'artifact',   :to => 'download' },
 { :from => 'artifact',   :to => 'build' },
 { :from => 'artifact',   :to => 'volume' },
 { :from => 'build',      :to => 'library' },
 { :from => 'build',      :to => 'presto'  },
 { :from => 'build',      :to => 'download' },
 { :from => 'daemon',     :to => 'artifact' },
 { :from => 'daemon',     :to => 'build' },
 { :from => 'java',       :to => 'compute' },
 { :from => 'java',       :to => 'os' },
 { :from => 'java',       :to => 'download' }].each do |link|
    relation "#{link[:from]}::depends_on::#{link[:to]}",
             :relation_name => 'DependsOn',
             :from_resource => link[:from],
             :to_resource => link[:to],
             :attributes => { 'flex' => false, 'min' => 1, 'max' => 1 }
end

relation 'presto-daemon::depends_on::artifact',
         :relation_name => 'DependsOn',
         :from_resource => 'presto-daemon',
         :to_resource => 'artifact',
         :attributes => { 'propagate_to' => 'from', 'flex' => false, 'min' => 1, 'max' => 1 }

# managed_via
['presto', 'artifact', 'build', 'java', 'presto-daemon'].each do |from|
    relation "#{from}::managed_via::compute",
             :except => ['_default'],
             :relation_name => 'ManagedVia',
             :from_resource => from,
             :to_resource => 'compute',
             :attributes => {}
end
