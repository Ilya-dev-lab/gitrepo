#! /bin/sh

HEAP_SIZE=4G
NEO4J_HOME=/opt/neo4j
sysdate=`date +'%d-%b-%y_%H-%M-%S'`
export HEAP_SIZE sysdate NEO4J_HOME
echo -e "\n"
read -p "Would you like to enter custom Backup name??
Please leave this field blank and backup name = sysdate:
Or enter custom name e.g.: My_backup data: " Backup_name
if [ -z "$Backup_name" ]; then
        Backup_name=$sysdate
        echo "Backup name is " $Backup_name;
else
        echo "Backup name is " $Backup_name;
fi

echo "==================="
echo "Create NEO4J backup"
echo "==================="
$NEO4J_HOME/bin/neo4j-admin backup --backup-dir=$NEO4J_HOME/backup/db_dump/ --name=graph.db_$Backup_name --pagecache=4G --check-consistency=false
echo "==================="
echo "zip NEO4J backup"
echo "==================="
cd $NEO4J_HOME/backup/db_dump/
zip -r graph.db_$Backup_name.zip graph.db_$Backup_name
rm -rf graph.db_$Backup_name
echo -e "\n"
echo -e "\n"
echo "========================================================================================"
echo "Pls find neo4j backup at $NEO4J_HOME/backup/db_dump/graph.db_$Backup_name.zip"
echo "W A R N I N G: Files older 30 days will be deleted from db_dump directory automatically"
echo "========================================================================================"
find $NEO4J_HOME/backup/db_dump/ -type f -name "*.zip" -mtime +30 -exec rm -f {} \;

