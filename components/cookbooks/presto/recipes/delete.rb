tomcat_pkgs = value_for_platform(
  "default" => ["presto"]
)


service "presto" do
  only_if { ::File.exists?('/etc/init.d/presto') }
  service_name "presto"
  action [:stop, :disable]
end

tomcat_pkgs.each do |pkg|
  package pkg do
    action :purge
  end
end



directory "/etc/presto" do
  recursive true
  action :delete
end
