#!/bin/bash

path=/home/super/document/doctorat/pysqice/pysqice/quspin_fermions/data/to_insert_in_database/
log=/home/super/document/doctorat/pysqice/pysqice/log/to_insert_in_database.log

tail -n 10 $log > temp
cat temp > $log
rm temp
now=`date`
echo '///////////////////' >> $log
echo Time: $now >> $log
echo "Path:" $path >> $log 2>&1
# Condition
count=$(find $path -type f | wc -l)
echo "File count:" $count $ >> $log 2>&1

# Check if the folder is not empty
if [ $count -ne 0 ]; then
    echo -n "Database start" >> $log 2>&1
    #sudo systemctl start mysql >> $log 2>&1
    echo -n $'\n' "SQL statement" >> $log 2>&1
    /home/super/document/doctorat/pysqice/pysqice/database/insert.sh >> $log 2>&1 &
    echo -n $'\n' "Database stop" >> $log 2>&1
    #sudo systemctl stop mysql >> $log 2>&1
fi

echo '///////////////////' >> $log
# Sleep for a short interval before checking again
# sleep 600  # Adjust the interval as needed. Don't need if systemd timer

