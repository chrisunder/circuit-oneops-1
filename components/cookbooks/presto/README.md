presto Cookbook
===============
This cookbook creates Presto clusters.  See https://prestodb.io/ for more details about Presto

Requirements
------------
Platform:

* CentOS and Red Hat

Dependencies:

* Oracle JDK 1.8


Attributes
----------
* `version` - Version number of Presto to install.  For example: 0.148.SNAPSHOT-1.x86_64
* `data_directory_dir` - Location for metadata and temporary data, default `/mnt/presto/data`. This value can not be changed after a deploy.
* `query_max_memory` - The maximum amount of distributed memory that a query may use, default `50GB`.
* `query_max_memory_per_node` - The maximum amount of memory that a query may use on any one machine., default `1GB`.

License and Authors
-------------------
Authors:
Chris Undernehr
