#
# Cookbook Name:: presto_coordinator
# Recipe:: add
#
# Copyright 2016, Walmart Labs
#
# Apache License, Version 2.0
#

# sleeping to prevent coordinator from running at the same time as the
# main install
#secondsToSleep=Random.new.rand(120)
secondsToSleep=120
Chef::Log.info("Sleeping #{secondsToSleep}")
sleep (secondsToSleep)

include_recipe "presto_coordinator::select_new_coordinator"
