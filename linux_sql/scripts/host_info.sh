#!/bin/bash

# Setup and validate arguments
psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

# Check # of args
if [ "$#" -ne 5 ]; then
  echo "Illegal number of parameters"
  exit 1
fi

# Retrieve hardware info
lscpu_out=$(lscpu)
hostname=$(hostname -f)
cpu_number=$(echo "$lscpu_out"  | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out"  | egrep "Architecture:" | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out"  | egrep "Model name:" | awk '{$1 = $2 = ""; print $0}' | xargs)
cpu_mhz=$(echo "$lscpu_out"  | egrep "CPU MHz:" | awk '{print $3}' | xargs)
l2_cache=$(echo "$lscpu_out"  | egrep "L2 cache:" | awk '{ gsub("K", "", $3); print $3}' | xargs)
total_mem=$(vmstat --unit M | tail -1 | awk '{print $4}')
timestamp=$(date +'%Y-%m-%d %H:%M:%S')

#Set up env var for psql cmd
export PGPASSWORD=$psql_password

# PSQL command: Insert server hardware info data into host_info table
insert_stmt="
  INSERT INTO host_info (
    hostname,
    cpu_number,
    cpu_architecture,
    cpu_model,
    cpu_mhz,
    l2_cache,
    timestamp,
    total_mem
  )
  VALUES(
    '${hostname}',
    ${cpu_number},
    '${cpu_architecture}',
    '${cpu_model}',
    ${cpu_mhz},
    ${l2_cache},
    '${timestamp}',
    ${total_mem}
  );"

#Insert date into a database
psql -h "$psql_host" -p "$psql_port" -d "$db_name" -U "$psql_user" -c "$insert_stmt"
echo "New host info record of ${hostname} is inserted successfully"
exit $?