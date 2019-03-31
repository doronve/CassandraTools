#!/bin/bash
#
# Name:
# Description: check cassandra cluster
#

function Usage() {
  echo "Usage: $0 [cassandra host] [--ssl]"
  echo "for ssl support one has to add the host"
  echo "example:"
  echo "  without ssl - run $0 , or $0 \`hostname\`"
  echo "  with    ssl - run $0 \`hostname\` --ssl"
  exit
}

CHOST=$1
[[ -z "$CHOST" ]]          && CHOST=`hostname`
[[ "$CHOST" == "-h" ]]     && Usage
[[ "$CHOST" == "--help" ]] && Usage
SSL=$2
[[ ! -z "$SSL" ]] && SSL="--ssl"

echo CHOST=$CHOST
echo SSL=$SSL

CMD="show version"
echo "$CMD;"
echo "$CMD;"                      | cqlsh -u cassandra -p cassandra $CHOST $SSL

CMD="show host"
echo "$CMD;"
echo "$CMD;"                      | cqlsh -u cassandra -p cassandra $CHOST $SSL

CMD="describe keyspaces"
echo "$CMD;"
echo "$CMD;"                      | cqlsh -u cassandra -p cassandra $CHOST $SSL

KSNAME=test_`date +%Y%m%d`
CMD="CREATE KEYSPACE $KSNAME WITH REPLICATION = { 'class' : 'SimpleStrategy', 'replication_factor' : 1 }"
echo "$CMD;"
echo "$CMD;"                      | cqlsh -u cassandra -p cassandra $CHOST $SSL

CMD="describe keyspaces"
echo "$CMD;"
echo "$CMD;"                      | cqlsh -u cassandra -p cassandra $CHOST $SSL

TNAME=tsttbl_`date +%Y%m%d`
CMD="create table ${KSNAME}.${TNAME} ( category text, points int, id UUID, lastname text, PRIMARY KEY (category, points)) WITH CLUSTERING ORDER BY (points DESC)"
echo "$CMD;"
echo "$CMD;"                      | cqlsh -u cassandra -p cassandra $CHOST $SSL

CMD="describe table ${KSNAME}.${TNAME}"
echo "$CMD;"
echo "$CMD;"                      | cqlsh -u cassandra -p cassandra $CHOST $SSL

for i in `seq 1 10`
do
  UU=`uuidgen`
  CMD="INSERT INTO ${KSNAME}.${TNAME} (category,points,id,lastname) VALUES ('cat${i}',${i}0,${UU},'vader${i}') USING TTL ${i}0"
  echo "$CMD;"
  echo "$CMD;"                      | cqlsh -u cassandra -p cassandra $CHOST $SSL
done

CMD="select * from ${KSNAME}.${TNAME}"
echo "$CMD;"
echo "$CMD;"                      | cqlsh -u cassandra -p cassandra $CHOST $SSL

echo sleep 15;
sleep 15;

CMD="select * from ${KSNAME}.${TNAME}"
echo "$CMD;"
echo "$CMD;"                      | cqlsh -u cassandra -p cassandra $CHOST $SSL

CMD="truncate table ${KSNAME}.${TNAME}"
echo "$CMD;"
echo "$CMD;"                      | cqlsh -u cassandra -p cassandra $CHOST $SSL

CMD="select * from ${KSNAME}.${TNAME}"
echo "$CMD;"
echo "$CMD;"                      | cqlsh -u cassandra -p cassandra $CHOST $SSL

CMD="drop table ${KSNAME}.${TNAME}"
echo "$CMD;"
echo "$CMD;"                      | cqlsh -u cassandra -p cassandra $CHOST $SSL

CMD="select * from ${KSNAME}.${TNAME}"
echo "$CMD;" "note - should fail"
echo "$CMD;"                      | cqlsh -u cassandra -p cassandra $CHOST $SSL

CMD="drop keyspace ${KSNAME}"
echo "$CMD;"
echo "$CMD;"                      | cqlsh -u cassandra -p cassandra $CHOST $SSL

CMD="describe keyspaces"
echo "$CMD;"
echo "$CMD;"                      | cqlsh -u cassandra -p cassandra $CHOST $SSL

