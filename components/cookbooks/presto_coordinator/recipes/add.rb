#
# Cookbook Name:: presto_coordinator
# Recipe:: add
#
# Copyright 2016, Walmart Labs
#
# Apache License, Version 2.0
#

# more than one coordinator instance may run at a time sleep for a time to
# prevent collisions
secondsToSleep=Random.new.rand(120)
Chef::Log.info("Sleeping #{secondsToSleep}")
sleep (secondsToSleep)

include_recipe "presto_coordinator::select_new_coordinator"
