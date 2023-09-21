#!/bin/bash

key=$1
host=$2
port=$3
database=$4
username=$5
password=$6
symbol=$7

#bash quote_app.sh API_KEY PSQL_HOST PSQL_PORT PSQL_DATABASE PSQL_USERNAME PSQL_PASSWORD SYMBOLS

output=$(curl --request GET \
	--url "https://alpha-vantage.p.rapidapi.com/query?function=GLOBAL_QUOTE&symbol=${symbol}&datatype=json" \
	--header 'X-RapidAPI-Host: alpha-vantage.p.rapidapi.com' \
	--header "X-RapidAPI-Key: ${key}" | jq '."Global Quote"')

echo "$output"
open=$(echo "$output" | head -3 | tail -1 | awk '{print $3}' | sed 's/"//g' | sed 's/,//g')
high=$(echo "$output" | head -4 | tail -1 | awk '{print $3}' | sed 's/"//g' | sed 's/,//g')
low=$(echo "$output" | head -5 | tail -1 | awk '{print $3}' | sed 's/"//g' | sed 's/,//g')
price=$(echo "$output" | head -6 | tail -1 | awk '{print $3}' | sed 's/"//g' | sed 's/,//g')
volume=$(echo "$output" | head -7 | tail -1 | awk '{print $3}' | sed 's/"//g' | sed 's/,//g')

echo "symbol: ${symbol}"
echo "open: ${open}"
echo "high: ${high}"
echo "low: ${low}"
echo "price: ${price}"
echo "volume: ${volume}"

#insert_stmt="INSERT INTO quotes (symbol, open, high, low, price, volume)
#            VALUES('$symbol', '$open', '$high', '$low', '$price', '$volume');"
#
#export PGPASSWORD=$password
#psql -h "$host" -p "$port" -d "$database" -U "$username" -c "$insert_stmt"
