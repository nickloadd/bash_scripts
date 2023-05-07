#!/bin/bash
set +x
period=$1

backup_name=$(date +%Y-%m-%d)
day=$(date +%d)

echo "Creating local backup '${backup_name}'"
clickhouse-backup create "${backup_name}"

if [[ "daily" == "${period}" && "2" -le "$(clickhouse-backup list local | wc -l)" ]]; then
  prev_backup_name="$(clickhouse-backup list local | tail -n 2 | head -n 1 | cut -d " " -f 1)"
  echo "Uploading the backup '${backup_name}' as diff from the previous backup ('${prev_backup_name}')"
  clickhouse-backup upload --diff-from "${prev_backup_name}" "${backup_name}-diff"
elif [[ "monthly" == "${period}" ]]; then
  echo "Uploading the backup '${backup_name}, and removing old unneeded backups"
  KEEP_BACKUPS_LOCAL=1 KEEP_BACKUPS_REMOTE=1 clickhouse-backup upload "${backup_name}-full"
fi