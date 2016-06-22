name             'Presto_swift'
maintainer       'Walmart Labs'
maintainer_email 'BFDTeam@email.wal-mart.com'
license          'Apache License, Version 2.0'
description      'Presto Swift Connector'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
depends          'shared'

grouping 'default',
         :access => 'global',
         :packages => ['base', 'mgmt.catalog', 'mgmt.manifest', 'catalog', 'manifest', 'bom']

# installation attributes

attribute 'connection_name',
          :description => 'Swift Conenction Name',
          :required => 'required',
          :default => 'myconnectionname',
          :format => {
              :category => '1.Global',
              :help => 'Name of connection for Swift',
              :order => 1
          }

attribute 'connection_metastore_url',
          :description => 'Swift Conenction URL',
          :required => 'required',
          :default => 'thrift://HOST_NAME:9083',
          :format => {
            :category => '1.Global',
            :help => 'The metastore thrift url for Swift',
            :order => 2
        }

attribute 'nexus_hadoop_openstack_repo',
          :description => 'Nexus Hadoop Stack Repository',
          :required => 'required',
          :default => '',
          :format => {
            :category => '1.Global',
            :help => 'The Nexus repository to use for the Hadoop Openstack resources',
            :order => 3
        }

attribute 'hadoop_openstack_version',
          :description => 'Hadoop Openstack Version',
          :required => 'required',
          :default => '3.0.0-SNAPSHOT',
          :format => {
            :category => '1.Global',
            :help => 'The version of the Hadoop Openstack Jar',
            :order => 4
        }

attribute 'nexus_central_repo',
          :description => 'Nexus Central Repository',
          :required => 'required',
          :default => 'central',
          :format => {
            :category => '1.Global',
            :help => 'The Nexus repository to use for most resources',
            :order => 5
        }

attribute 'commons_httpclient_version',
          :description => 'HTTP Client Commons Version',
          :required => 'required',
          :default => '3.1',
          :format => {
            :category => '1.Global',
            :help => 'The version of the commons HTTP client Jar',
            :order => 6
        }

attribute 'commons_jackson_version',
          :description => 'Jackson Version',
          :required => 'required',
          :default => '1.9.13',
          :format => {
            :category => '1.Global',
            :help => 'The version of the Jackson Jar',
            :order => 7
        }

# attribute to be removed once the hadoop client component is ready
attribute 'swift_url',
          :description => "Keystone authenticaiton hostname",
          :required => "required",
          :default => "https://cdc-prd001-api-endpoint.ost.cloud.wal-mart.com:5443/v2.0/tokens",
          :format => {
              :category => '1.Global',
              :help => 'Full url used to access swift',
              :order => 8
          }

attribute 'swift_username',
          :description => "Keystone username",
          :required => "required",
          :default => "sw_bfd",
          :format => {
              :category => '1.Global',
              :help => 'Username to connect to swift service',
              :order => 9
          }

attribute 'swift_password',
          :description => "Keystone password",
          :required => "required",
          :encrypted => true,
          :default => "somepassword",
          :format => {
              :category => '1.Global',
              :help => 'Password to connect to swift service',
              :order => 10
         }

attribute 'swift_tenant',
          :description => "Swift Tenant",
          :required => "required",
          :default => "sw_bfd",
          :format => {
              :category => '1.Global',
              :help => 'Tenant to use for swift',
              :order => 11
         }

attribute 'swift_tmp_dir',
          :description => "hadoop.tmp.dir",
          :required => "required",
          :default => "/tmp",
          :format => {
              :category => '1.Global',
              :order => 12
          }

attribute 'swift_block_size',
          :description => "fs.swift.blocksize",
          :required => "required",
          :default => "131072",
          :format => {
              :category => '1.Global',
              :order => 13
        }

attribute 'swift_min_split_size',
          :description => "mapred.min.split.size",
          :required => "required",
          :default => "131072",
          :format => {
              :category => '1.Global',
              :order => 14
        }

attribute 'swift_max_split_size',
          :description => "mapred.max.split.size",
          :required => "required",
          :default => "1048576",
          :format => {
              :category => '1.Global',
              :order => 15
        }

attribute 'swift_request_size',
          :description => "fs.swift.requestsize",
          :required => "required",
          :default => "1024",
          :format => {
              :category => '1.Global',
              :order => 16
        }

attribute 'swift_connect_timeout',
          :description => "fs.swift.connect.timeout",
          :required => "required",
          :default => "30000",
          :format => {
              :category => '1.Global',
              :order => 17
        }

attribute 'swift_socket_timeout',
          :description => "fs.swift.socket.timeout",
          :required => "required",
          :default => "120000",
          :format => {
              :category => '1.Global',
              :order => 18
        }

attribute 'swift_connect_retry_count',
          :description => "fs.swift.connect.retry.count",
          :required => "required",
          :default => "3",
          :format => {
              :category => '1.Global',
              :order => 19
        }

attribute 'swift_throttle_delay',
          :description => "fs.swift.connect.throttle.delay",
          :required => "required",
          :default => "0",
          :format => {
              :category => '1.Global',
              :order => 20
        }
