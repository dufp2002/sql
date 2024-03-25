#!/bin/bash

path=/home/super/document/doctorat/pysqice/pysqice/quspin_fermions/data/to_insert_in_database/
count=$(find $path -type f | wc -l)

# Check if folder is empty
if [ $count -eq 0 ]; then
  exit 0
fi

in_database=/home/super/document/doctorat/pysqice/pysqice/quspin_fermions/data/in_database/
problem_data=/home/super/document/doctorat/pysqice/pysqice/quspin_fermions/data/problem_data/

# Iterate over all files in the chosen folder
for file in $path*;
do
  json_file=$file

  keys=$(jq -r 'keys_unsorted | @csv' "$json_file")
  values=$(jq -r 'to_entries | .[].value' $json_file)

  values=$(jq -r 'to_entries | map(.value | if type == "string" then "\"\(. | gsub("\""; "\\\""))\"" else . end) | .[]' $json_file)



  sql_statement="insert into pysqice.simulation"
  sql_statement="$sql_statement ($keys)"
  sql_statement=$(echo "$sql_statement" | sed 's/\["\(.*\)"]/(\1)/; s/"/ /g')
  sql_statement="$sql_statement value("

  # Iterate over lines and echo each value
  IFS=$'\n'  # Set Internal Field Separator to newline
  for value in $values; do
    #if [[ $value == *'('* ]] || [[ $value == *'['* ]]; then
    #  sql_statement="$sql_statement \"$value\","
    #else
      sql_statement="$sql_statement $value,"
    #fi
  done

  sql_statement="${sql_statement%,}"
  sql_statement="$sql_statement );"
  mysql -u pysqice -ppassword -e "$sql_statement"

  if [ $? -eq 0 ]; then
    mv $json_file $in_database
  else
    mv $json_file $problem_data
  fi
done
