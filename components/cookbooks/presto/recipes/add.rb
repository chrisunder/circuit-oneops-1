#
# Cookbook Name:: presto
# Recipe:: add
#
# Copyright 2016, Walmart Labs
#
# Apache License, Version 2.0
#

include_recipe "presto::delete"

package 'mosh'
package 'screen'

include_recipe "presto::install"

include_recipe "presto::start"
