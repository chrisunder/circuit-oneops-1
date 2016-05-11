# Presto
default["presto"]["port"] = 8080
default["presto"]["data_directory"] = "/mnt/presto/data"
default["presto"]["log_file"] = "/mnt/presto/log/server.log"
default["presto"]["query_max_memory"] = '50G'
default["presto"]["query_max_memory_per_node"] = '1G'
