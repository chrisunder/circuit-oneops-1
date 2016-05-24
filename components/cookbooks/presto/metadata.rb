name             'Presto'
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

attribute 'version',
          :description => 'Version',
          :required => 'required',
          :default  => '0.148.SNAPSHOT-1.x86_64',
          :format  => {
              :important  => true,
              :help  => 'Version of Presto',
              :category  => '1.Global',
              :order  => 1
          }

attribute 'data_directory_dir',
          :description  => 'Data Directory',
          :default  => '/mnt/presto/data',
          :format  => {
              :help  => 'Location for metadata and temporary data',
              :category  => '1.Global',
              :order  => 2
          }

recipe 'status', 'Presto Status'
recipe 'start', 'Start Presto'
recipe 'stop', 'Stop Presto'
recipe 'restart', 'Restart Presto'
recipe 'repair', 'Repair Presto'
recipe 'debug', 'Debug Presto'
