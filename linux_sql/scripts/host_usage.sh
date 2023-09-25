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

# Save machine statistics in MB and current machine hostname to variables
vmstat_mb=$(vmstat --unit M)
hostname=$(hostname -f)

# Retrieve hardware specification variables
memory_free=$(echo "$vmstat_mb" | awk '{print $4}'| tail -n1 | xargs)
cpu_idle=$(echo "$vmstat_mb" | tail -1 | awk -v col="15" '{print $col}' | xargs)
cpu_kernel=$(echo "$vmstat_mb" | tail -1 | awk -v col="14" '{print $col}' | xargs)
disk_io=$(vmstat --unit M -d | tail -1 | awk -v col="10" '{print $col}' | xargs)
disk_available=$(df -m / | tail -1 | awk '{print $4}' | xargs)
timestamp=$(date +'%Y-%m-%d %H:%M:%S')

#Set up env var for psql cmd
export PGPASSWORD=$psql_password

# Subquery to find matching id in host_info table
find_stmt="(SELECT id FROM host_info WHERE hostname='${hostname}')";
host_id=$(psql -h "$psql_host" -p "$psql_port" -d "$db_name" -U "$psql_user" -t -c "$find_stmt" | xargs)

# PSQL command: Inserts server usage data into host_usage table
insert_stmt="
  INSERT INTO host_usage (
    timestamp,
    host_id,
    memory_free,
    cpu_idle,
    cpu_kernel,
    disk_io,
    disk_available
  )
  VALUES(
    '${timestamp}',
    ${host_id},
    ${memory_free},
    ${cpu_idle},
    ${cpu_kernel},
    ${disk_io},
    ${disk_available}
  );"

#Insert date into a database
psql -h "$psql_host" -p "$psql_port" -d "$db_name" -U "$psql_user" -c "$insert_stmt"
echo "New host usage record of ${hostname} is inserted successfully"
exit $?