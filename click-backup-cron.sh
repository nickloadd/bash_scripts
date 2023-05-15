##Preparation:
##Create click DB user with access to target database or tables and select on system.*
##Install clickhouse-backup tool : https://github.com/AlexAkulov/clickhouse-backup
##Create clickhouse-backup config with "backups_to_keep_local: 0" settings. For example, /etc/clickhouse-backup/config-monthly.yml

##Body of script:
#!/bin/bash
set +x
period=$1

year=$(date +%Y)
previous_month=$(date -d "`date +%Y-%m-01` -1day" +'%m')
backup_name=$(date +%Y-%m-%d)
#List of tables to backup
tables=""

if [[ "full" == "${period}" ]]; then
  echo "Removing old unneeded backups"
  clickhouse-backup list local | cut -d " " -f 1 | xargs -I {} clickhouse-backup delete local {}
  while [ ! -z "$(clickhouse-backup list remote | grep "${year}-${previous_month}-[0-3][0-9]-diff")" ]
  do
    remove_backup=$(clickhouse-backup list remote | grep "${year}-${previous_month}-[0-3][0-9]-diff" | head -n 1 | cut -d " " -f 1)
    clickhouse-backup delete remote ${remove_backup}
    echo "${remove_backup} was deleted from S3 storage"
  done
fi

echo "Creating local backup '${backup_name}-${period}'"
clickhouse-backup create --tables "${tables}" "${backup_name}-${period}"

if [[ "full" == "${period}" ]]; then
  while [ ! -z "$(clickhouse-backup list remote | grep "${year}-${previous_month}-[0-3][0-9]-diff")" ]
  do
    remove_backup=$(clickhouse-backup list remote | grep "${year}-${previous_month}-[0-3][0-9]-diff" | head -n 1 | cut -d " " -f 1)
    clickhouse-backup delete remote ${remove_backup}
    echo "${remove_backup} was deleted from S3 storage"
  done
fi

if [[ "diff" == "${period}" && "2" -le "$(clickhouse-backup list local | wc -l)" ]]; then
  prev_backup_name="$(clickhouse-backup list local | tail -n 2 | head -n 1 | cut -d " " -f 1)"
  echo "Uploading the backup '${backup_name}-${period}' as diff from the previous backup ('${prev_backup_name}')"
  clickhouse-backup upload --diff-from "${prev_backup_name}" "${backup_name}-${period}"
elif [[ "full" == "${period}" ]]; then
  echo "Uploading the backup ${backup_name}-${period}"
  clickhouse-backup upload "${backup_name}-${period}"
fi

##Cron tabs:
##Monthly job to make full backup
#0 0 1 * * /opt/click-backup.sh monthly
##Daily job to make diff backup
#0 0 2-31 * * /opt/click-backup.sh daily