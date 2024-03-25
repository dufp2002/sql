"""
File: cluster-db.py
Author: Pierre-Alexandre Dufrene
Date: February 9th 2024
Description: Fetches data from the cluster and stores it in a database.
"""

import subprocess

local_file = "/home/super/document/doctorat/pysqice/pysqice/quspin_fermions/data/to_insert_in_database"
cluster_link = "paduf@ip09.ccs.usherbrooke.ca"
remote_directory = "/net/nfs-iq/data/paduf/pysqice/pysqice/quspin_fermions/data/to_insert_in_database"

# Synchronize the local and cluster data
sync_array = f"scp -r {cluster_link}:{remote_directory}/* {local_file}"

# Database checker
db_check = "/home/super/document/doctorat/pysqice/pysqice/database/db_checking.sh"

# Retrieves data from the cluster
#connect_process = subprocess.run(f'{sync_array}', shell=True)
#connect_process.wait()

# Transfers the data to the database
database = subprocess.run(f"{db_check}", shell=True)
#database.wait()

exit(0)
