#! /bin/sh
set -e
HEAP_SIZE=4G
NEO4J_HOME=/opt/neo4j
NEO4J_RESTORE_HOME=/opt/neo4j/backup/restore
export HEAP_SIZE NEO4J_HOME NEO4J_RESTORE_HOME
rm -rf $NEO4J_RESTORE_HOME/tmp_dir/*

read -p "Please provide absolute or relative path for DB_Dump file
e.g.: /opt/neo4j/backup/11-Sep-20_19-35-46/graph.db.zip
e.g.: ../graph.db.zip
e.g.: ../graph.db.tar.gz
e.g.: ../graph.db.tar
e.g.: ../graph.db
 " Neo4j_Dump_Name
echo -e "\n"

if [[ $Neo4j_Dump_Name == *".zip" ]]; then
  unzip $Neo4j_Dump_Name -d $NEO4J_RESTORE_HOME/tmp_dir/
                elif  [[ $Neo4j_Dump_Name == *".tar.gz" ]]; then
                tar -xvf $Neo4j_Dump_Name -C $NEO4J_RESTORE_HOME/tmp_dir/
                elif  [[ $Neo4j_Dump_Name == *".tar" ]]; then
                tar -xvf $Neo4j_Dump_Name -C $NEO4J_RESTORE_HOME/tmp_dir/
        else
        cp -rfp $Neo4j_Dump_Name $NEO4J_RESTORE_HOME/tmp_dir/
fi

cd $NEO4J_RESTORE_HOME/tmp_dir
DB_Dump_name=`ls`
echo "==================="
echo "Restore NEO4J backup"
echo -e "\n"
echo "1. Stop NEO4J Database"
$NEO4J_HOME/bin/neo4j stop
$NEO4J_HOME/bin/neo4j-admin unbind #if you are using cluster 
echo -e "\n"
echo "==================="
echo "2. Deploy NEO4J dump"
echo -e "\n"
$NEO4J_HOME/bin/neo4j-admin restore --from=$NEO4J_RESTORE_HOME/tmp_dir/$DB_Dump_name --database=graph.db --force
echo -e "\n"
echo ". Start NEO4J Database"
echo -e "\n"
$NEO4J_HOME/bin/neo4j start
rm -rf $NEO4J_RESTORE_HOME/tmp_dir/*
echo -e "\n"
echo "=================================="
echo "Redeploy completed pls check Neo4j"
echo "=================================="
echo -e "\n"

