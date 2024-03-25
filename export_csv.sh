#!/bin/bash

path_temp='/var/lib/mysql-files/mktemp.csv'
pass= #yourpassword

echo $pass | sudo -S systemctl start mysql
mysql -u pysqice -ppassword -e "$1"
echo $pass | sudo -S systemctl stop mysql
echo $pass | sudo -S cat $path_temp > $2
echo $pass | sudo -S rm $path_temp
