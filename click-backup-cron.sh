##Preparation:
##Create click DB user with access to target database or tables and select on system.*
##Install clickhouse-backup tool : https://github.com/AlexAkulov/clickhouse-backup
##Create clickhouse-backup config with "backups_to_keep_local: 0" settings. For example, /etc/clickhouse-backup/config-monthly.yml

##Body of script:
#!/bin/bash
set +x
period=$1

backup_name=$(date +%Y-%m-%d)

if [[ "monthly" == "${period}" ]]; then
  echo "Removing old unneeded backups"
  clickhouse-backup list local | cut -d " " -f 1 | xargs -I {} clickhouse-backup delete local {}
fi

echo "Creating local backup '${backup_name}-${period}'"
clickhouse-backup create "${backup_name}-${period}"

if [[ "daily" == "${period}" && "2" -le "$(clickhouse-backup list local | wc -l)" ]]; then
  prev_backup_name="$(clickhouse-backup list local | tail -n 2 | head -n 1 | cut -d " " -f 1)"
  echo "Uploading the backup '${backup_name}-${period}' as diff from the previous backup ('${prev_backup_name}')"
  clickhouse-backup upload --diff-from "${prev_backup_name}" "${backup_name}-${period}"
elif [[ "monthly" == "${period}" ]]; then
  echo "Uploading the backup '${backup_name}-${period}"
  clickhouse-backup upload "${backup_name}-${period}"
fi

##Cron tabs:
##Monthly job to make full backup
#0 0 1 * * /opt/click-backup.sh monthly
##Daily job to make diff backup
#0 0 2-31 * * /opt/click-backup.sh daily