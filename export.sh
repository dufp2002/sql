#!/bin/bash

script=$(realpath "$0")
script_path="$(dirname "$script")"

sql_statement='select sector, energy from pysqice.simulation;'
#FIELDS ENCLOSED BY '"' TERMINATED BY ';' ESCAPED BY '"' LINES TERMINATED BY "\r\n"
echo $sql_statement

sudo systemctl start mysql
mysql -u pysqice -ppassword -e "$sql_statement" > mktemp.csv
sudo systemctl stop mysql

tail -n +2 mktemp.csv > mktemp
sed 's/[[:space:]]\+/;/g' mktemp > mktemp.csv
rm mktemp

path="$script_path/../quspin_fermions/post-processing/plotting.py"

conda run -p /home/super/miniconda3/envs/spinice python $path mktemp.csv $1 $2

rm mktemp.csv
