presto_pkgs = value_for_platform(
  "default" => ["presto-server-rpm"]
)


service "presto" do
  only_if { ::File.exists?('/etc/presto/node.properties') }
  service_name "presto"
  action [:stop, :disable]
end

presto_pkgs.each do |pkg|
  package pkg do
    action :purge
  end
end



directory "/etc/presto" do
  recursive true
  action :delete
end

directory node.presto.data_directory_dir do
  recursive true
  action :delete
end
