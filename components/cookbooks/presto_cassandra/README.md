presto_cassandra Cookbook
===============
This cookbook creates a Presto Cassandra Connector.

See https://prestodb.io/docs/current/connector/cassandra.html for more details about the Presto Cassandra Connector

Requirements
------------
Platform:

* CentOS and Red Hat

Dependencies:

* Oracle JDK 1.8
* Presto


Attributes
----------
* `connection_name` - The name of the connection, default cassandra
* `connection_contact_points` - Comma-separated list of hosts in a Cassandra cluster. The Cassandra driver will use these contact points to discover cluster topology. At least one Cassandra host is required, default host1,host2.

License and Authors
-------------------
Authors:
Chris Undernehr
