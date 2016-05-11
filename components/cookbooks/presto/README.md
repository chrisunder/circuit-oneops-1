presto Cookbook
===============
This cookbook creates Presto clusters.  See https://prestodb.io/ for more details about Presto

Requirements
------------
Platform:

* CentOS, Red Hat, Fedora (OpenJDK)

Dependencies:

* java


Attributes
----------
* `port` - The network port used by Prestos's HTTP connector, default `8080`.
* `data_directory_dir` - Location for metadata and temporary data, default `/mnt/presto/data`.
* `log_file` - Location for logs, default `/mnt/presto/log/server.log`.
* `query_max_memory` - The maximum amount of distributed memory that a query may use, default `50GB`.
* `query_max_memory_per_node` - The maximum amount of memory that a query may use on any one machine., default `1GB`.

License and Authors
-------------------
Authors:
Chris Undernehr
