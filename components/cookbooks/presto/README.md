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

License and Authors
-------------------
Authors:
Chris Undernehr
