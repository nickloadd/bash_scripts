#!/bin/bash
year=$(date +%Y)
previous_month=$(date -d "`date +%Y-%m-01` -1day" +'%m')
while [ ! -z "$(clickhouse-backup list remote | grep "${year}-${previous_month}-[0-3][0-9]-daily")" ]
do
  remove_backup=$(clickhouse-backup list remote | grep "${year}-${previous_month}-[0-3][0-9]-daily" | head -n 1 | cut -d " " -f 1)
  clickhouse-backup delete remote ${remove_backup}
  echo "${remove_backup} was deleted from S3 storage"
done

##Cron tabs:
##Monthly job to make full backup
#0 0 2 * * /opt/delete-unneeded-backups.sh