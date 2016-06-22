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
          :default  => '0.149.SNAPSHOT-1.x86_64',
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

attribute 'presto_rpm_install_url',
        :description  => 'Presto Install URL',
        :default  => 'URL to rpm.  Use $version to for version identifer',
        :format  => {
            :help  => 'Presto Install URL. $version will be replaceed with the version of presto',
            :category  => '1.Global',
            :order  => 3
        }

recipe 'status', 'Presto Status'
recipe 'start', 'Start Presto'
recipe 'stop', 'Stop Presto'
recipe 'restart', 'Restart Presto'
recipe 'repair', 'Repair Presto'
