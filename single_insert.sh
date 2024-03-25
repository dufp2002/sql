#!/bin/bash

keys=('orientation' 'sector' 'num_it' 'pert' 'num_eig' 'a_th' 'e_th' 'energy' 'vector' 'size_x' 'size_y')

in_database=/home/super/document/doctorat/pysqice/pysqice/quspin_fermions/data/in_database/
problem_data=/home/super/document/doctorat/pysqice/pysqice/quspin_fermions/data/problem_data/

json_file=/home/super/document/doctorat/pysqice/pysqice/quspin_fermions/data/problem_data/square44\(0\,3\,1\,1\,2\)60.1100.050.1.json

# Extract values
values=()

# Use keys and values as Bash arguments
for ((i=0; i<${#keys[@]}; i++)); do
  #key=${keys[i]}
  #key_list+=($key)
  values+=("$(jq --arg key "${keys[i]}" 'values[$key]' $json_file)")
done

# Check if the number of columns matches the number of values
if [ "${#keys[@]}" -ne "${#values[@]}" ]; then
  echo "Number of columns does not match the number of values."
  exit 1
fi

value_str=$(IFS=,; echo "${values[*]}")

# Create mysql statement, if I try to directly put
# the statement in the mysql line it doesn't work
# Don't know why

sql_statement="insert into pysqice.simulation values($value_str);"

echo $sql_statement

mysql -u pysqice -ppassword -e "$sql_statement"

echo $?
