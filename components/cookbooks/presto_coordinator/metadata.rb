name             'Presto_coordinator'
maintainer       'Walmart Labs'
maintainer_email 'BFDTeam@email.wal-mart.com'
license          'Apache License, Version 2.0'
description      'Installs/Configures presto'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
depends          'shared'

grouping 'default',
         :access => 'global',
         :packages => ['base', 'mgmt.catalog', 'mgmt.manifest', 'catalog', 'manifest', 'bom']

# installation attributes

attribute 'query_max_memory',
          :description => 'Max Query Memory',
          :default => '50GB',
          :format => {
              :help => 'The maximum amount of distributed memory that a query may use',
              :category => '1.Global',
              :order => 1
          }

attribute 'query_max_memory_per_node',
          :description => 'Max Query Memory Per Node',
          :default => '2GB',
          :format => {
              :help => 'The maximum amount of memory that a query may use on any one machine',
              :category => '1.Global',
              :order => 2
          }

recipe 'status', 'Presto Coordinator Status'
recipe 'select_new_coordinator', 'Select New Presto Coordinator'
