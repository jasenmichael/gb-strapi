#!/bin/bash

# CONFIG

localdb=<LOCAL-DB-NAME>
remotedb=<REMOTE-DB-NAME>
remotehost=<REMOTE-HOST.mlab.com>
remoteport=<REMOTE-PORT>
remoteuser=<REMOTE-DB-USER>
remotepass=<REMOTE-DB-PASS>

now=`date +"%m-%d-%Y-%T"`
## export local db
echo "Export local DB - $localdb"
mongodump -d $localdb -o db/local-exports/backup-${now::-3}

## backup...
echo "Backup remote db - $remotedb"
mongodump --host $remotehost:$remoteport -u $remoteuser -p $remotepass -d $remotedb -o db/remote-exports/backup-${now::-3}
## drop all collections from remote db
echo "Remove all collections from remote db - $remotedb"
mongo --host $remotehost:$remoteport -u $remoteuser -p $remotepass $remotedb --eval "db.dropDatabase()"

## import locally exported db to remote
echo "Import local db $localdb to remote db $remotedb"
mongorestore -h $remotehost:$remoteport -d $remotedb -u $remoteuser -p $remotepass db/local-exports/backup-${now::-3}/$localdb
