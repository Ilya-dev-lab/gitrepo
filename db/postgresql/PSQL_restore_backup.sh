#! /bin/sh +x
set -e

HEAP_SIZE=4G
PSQL_Backup=/opt/postgres_data/DB_dump_postgres/data
PSQL_BackupArch=/opt/postgres_data/DB_dump_postgres/arch
PGPASSWORD='My_Pass'
today=`date +'%d-%b-%y_%H-%M-%S'`
day=`date +'%u'`
export HEAP_SIZE today day PSQL_Backup PSQL_BackupArch PGPASSWORD

read -p "Please provide absolute or relative path for DB_Dump zip file
e.g.: /opt/postgres_data/DB_dump_postgres/arch/work_db_only.out_23-Sep-20_13-39-50.zip
e.g.: work_db_only.out_23-Sep-20_13-39-50.zip
 " PSQL_Dump_Name
echo -e "\n"

ls -l $PSQL_Dump_Name
rm -rf $PSQL_Backup/*

if [[ $PSQL_Dump_Name == *".zip" ]]; then
  unzip $PSQL_Dump_Name -d $PSQL_Backup/
                elif  [[ $PSQL_Dump_Name == *".tar.gz" ]]; then
                tar -xvf $PSQL_Dump_Name -C $PSQL_Backup/
        else
        cp $PSQL_Dump_Name $PSQL_Backup/
fi
cd $PSQL_Backup
PSQL_Dump_Name=`ls`
echo "PSQL_Dump_Name is $PSQL_Dump_Name"
echo -e "\n"
echo "========================"
echo "Restore $PSQL_Dump_Name "
echo "========================"
echo "account_user_pass"|sudo -S systemctl restart postgresql-12.service
psql -f $PSQL_Dump_Name -U postgres
echo "========================"
echo -e "\n"
echo "Completed"

