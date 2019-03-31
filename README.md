# CassandraTools
Tools for Cassandra

Usage: cassandra_tests.sh [-h | cassandra host] [--ssl]</br>
for ssl support one has to add the host</br>
example:</br>
  without ssl - run cassandra_tests.sh , or cassandra_tests.sh `hostname`</br>
  with    ssl - run cassandra_tests.sh `hostname` --ssl</br>

The script creates a keyspace, creates a table, inserts into the table and select from it, then drops the table and the keyspace</br>

