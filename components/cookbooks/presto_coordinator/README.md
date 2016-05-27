presto_coordinator Cookbook
===============
This cookbook creates a Presto Coordinator.  The coordinator cookbook selects a new coordinator and updates the whole cluster.
See https://prestodb.io/ for more details about Presto

Requirements
------------
Platform:

* CentOS and Red Hat

Dependencies:

* Oracle JDK 1.8
* Presto


Attributes
----------
* `query_max_memory` - The maximum amount of distributed memory that a query may use, default `50GB`.
* `query_max_memory_per_node` - The maximum amount of memory that a query may use on any one machine., default `1GB`.

License and Authors
-------------------
Authors:
Chris Undernehr
