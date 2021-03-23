#! /bin/sh +x
set -e

HEAP_SIZE=4G
PSQL_Backup=/opt/postgres_data/DB_dump_postgres/data
PSQL_BackupArch=/opt/postgres_data/DB_dump_postgres/arch
PGPASSWORD='My_Pass'
today=`date +'%d-%b-%y_%H-%M-%S'`
day=`date +'%u'`
export HEAP_SIZE today day PSQL_Backup PSQL_BackupArch PGPASSWORD

cd $PSQL_Backup

echo "=================================="
echo "=================================="
echo "Create full postgres dabase backup"
echo "=================================="
echo "=================================="
pg_dumpall --clean -v --if-exists -h localhost -p 5432 -U postgres > $PSQL_Backup/full_db.out

echo "==============================="
echo "==============================="
echo "Create Work dabase backup"
echo "==============================="
echo "==============================="
pg_dump -C --clean -v --if-exists -h localhost -p 5432 -U postgres -d work > $PSQL_Backup/work_db_only.out

echo "Zip db_dump and cleanup tmp files"
zip -r full_db.out_$today.zip full_db.out
zip -r work_db_only.out_$today.zip work_db_only.out
rm -rf full_db.out work_db_only.out

mv $PSQL_Backup/*.zip $PSQL_BackupArch/
find $PSQL_BackupArch/ -type f -name "*.zip" -mtime +60 -exec rm -f {} \;
echo -e "\n"
echo -e "\n"
echo "============================================================================================================================="
echo "Pls find Full postgres backup at $PSQL_BackupArch/full_db.out_$today.zip"
echo "Pls find work db only backup at $PSQL_BackupArch/work_db_only.out_$today.zip"
echo "W A R N I N G: Files older 60 days will be deleted from $PSQL_BackupArch directory automatically"
echo "Backup completed"
echo "============================================================================================================================="

