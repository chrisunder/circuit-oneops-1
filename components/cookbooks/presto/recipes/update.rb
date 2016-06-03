#
# Cookbook Name:: presto
# Recipe:: update
#
# Copyright 2016, Walmart Labs
#
# Apache License, Version 2.0
#

bash "backup_configs" do
  code <<-EOL
  cp -r /etc/presto /etc/presto.bak
  EOL
end

include_recipe "presto::delete"
include_recipe "presto::install"

bash "restore_configs" do
  code <<-EOL
  rm -rf /etc/presto
  cp -r /etc/presto.bak /etc/presto
  rm -rf /etc/presto.bak
  EOL
end

include_recipe "presto::start"
