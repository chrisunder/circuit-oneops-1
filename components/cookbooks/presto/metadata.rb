name             'Presto'
maintainer       'Walmart Labs'
maintainer_email 'BFDTeam@email.wal-mart.com'
license          'Apache License, Version 2.0'
description      'Installs/Configures presto'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
depends             'shared'

grouping 'default',
         access: 'global',
         packages: ['base', 'mgmt.catalog', 'mgmt.manifest', 'catalog', 'manifest', 'bom']

# installation attributes

attribute 'version',
          description: 'Version',
          required: 'required',
          default: '0.148.SNAPSHOT-1.x86_64',
          format: {
              important: true,
              help: 'Version of Presto',
              category: '1.Global',
              order: 1
          }

attribute 'data_directory_dir',
          description: 'Data Directory',
          default: '/mnt/presto/data',
          format: {
              help: 'Location for metadata and temporary data',
              category: '1.Global',
              order: 2
          }

attribute 'log_file',
          description: 'Data Directory',
          default: ' Location for logs',
          format: {
              help: 'Location for metadata and temporary data',
              category: '1.Global',
              order: 3
          }

attribute 'query_max_memory',
          description: 'Max Query Memory',
          default: '50GB',
          format: {
              help: 'The maximum amount of distributed memory that a query may use',
              category: '1.Global',
              order: 4
          }

attribute 'query_max_memory_per_node',
          description: 'Max Query Memory Per Node',
          default: '1GB',
          format: {
              help: 'The maximum amount of memory that a query may use on any one machine',
              category: '1.Global',
              order: 5
          }

attribute 'port',
          description: 'HTTP Port',
          required: 'required',
          default: '8080',
          format: {
              help: 'Port Presto cordinator listens on for incoming HTTP requests',
              category: '1.Global',
              order: 6,
              filter: { 'all' => { 'visible' => 'http_connector_enabled:eq:true' } },
              pattern: '[0-9]+'
          }

recipe 'status', 'Presto Status'
recipe 'start', 'Start Presto'
recipe 'stop', 'Stop Presto'
recipe 'restart', 'Restart Presto'
recipe 'repair', 'Repair Presto'
recipe 'debug', 'Debug Presto'
