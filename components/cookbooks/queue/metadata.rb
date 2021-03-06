name             "Queue"
description      "Queue"
version          "0.1"
maintainer       "OneOps"
maintainer_email "support@oneops.com"
license          "Apache License, Version 2.0"

grouping 'default',
  :access => "global",
  :packages => [ 'base', 'mgmt.catalog', 'mgmt.manifest', 'catalog', 'manifest', 'bom' ]


attribute 'queuename',
          :description => 'Queue Name',
          :required => 'required',
          :format => {
              :help => 'Queue Name',
              :category => '1.Destination',
             :order => 1,
          }

attribute 'destinationtype',
          :description => 'Destination Type',
          :default => 'Q',
          :format => {
              :help => 'Destination type - Queue',
              :category => '1.Destination',
              :order => 2,
              :form => {'field' => 'select', 'options_for_select' => [['Queue', 'Q'], ['Composite Queue', 'compositeQueue']]}
          }

attribute 'maxmemorysize',
          :description => 'Maximum Memory',
          :default => '0',
          :format => {
              :help => 'Max message memory for Queue. 0 means no limit.',
              :category => '1.Destination',
              :order => 3,
              :filter => {'all' => {'visible' => 'false'}}
          }

attribute 'permission',
          :description => "User Permission",
          :data_type => "hash",
          :default => '{"readonly":"R"}',
          :format => {
            :help => 'User permissions. eg (username:permission). Valid values for permissions are R for READ, W for WRITE and RW ReadWrite',
            :category => '2.Permissions',
            :pattern  => ['R', 'W', 'RW'],
            :order => 1
          }

attribute 'destinationpolicy',
         :description => "Destination Policy",
         :data_type => "text",
         :default => "",
         :format => {
           :help => 'Define destination policy specifically for this queue',
           :category => '3.DestinationPolicy',
           :order => 1
         }

attribute 'virtualdestination',
         :description => "Composite Queue Definition",
         :data_type => "text",
         :default => "",
         :format => {
            :help => 'Composite Queue definition',
            :category => '4.CompositeQueue',
            :filter => {'all' => {'visible' => 'destinationtype:eq:compositeQueue'}},
            :order => 1
         }

recipe 'purge',  'Purge ActiveMQ queue'
recipe 'repair', 'Repairs ActiveMQ resource'
