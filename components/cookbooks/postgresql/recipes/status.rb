postgresql_service_name = "postgresql-#{node["postgresql"]["version"]}"
cmd = Mixlib::ShellOut.new("/etc/init.d/#{postgresql_service_name} status")
cmd.run_command
#cmd.error!
#Chef::Log.info(cmd.inspect)
Chef::Log.info("Execution completed\n#{cmd.format_for_exception}")
