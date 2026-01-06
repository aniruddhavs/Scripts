#!/bin/bash

# Configuration
MOUNT1="/home/rajapi/ext_storage/primary"
MOUNT2="/home/rajapi/ext_storage/backup"
SOURCE="/home/rajapi/gitea"
EXCLUDE_FILE="/home/rajapi/scripts/exclude_list.txt"
LOGFILE="/home/rajapi/custom_logs/daily_backup.log"
BACKUP_SUBFOLDER1="PiBackup/gitea"
BACKUP_SUBFOLDER2="PiBackup/gitea"

echo "=== Backup started: $(date) ===" >> "$LOGFILE"

# Check and backup to HDD1
if grep -qs "$MOUNT1" /proc/mounts; then
    echo "$(date): $MOUNT1 mounted. Starting backup..." >> "$LOGFILE"
    rsync -av --delete --exclude-from="$EXCLUDE_FILE"\
	--prune-empty-dirs \
	--quiet \
	--itemize-changes\
	"$SOURCE/" "$MOUNT1/$BACKUP_SUBFOLDER1/" >> "$LOGFILE" 2>&1
    if [ $? -eq 0 ]; then
        echo "$(date): Backup to $MOUNT1 completed successfully" >> "$LOGFILE"
    else
        echo "$(date): Backup to $MOUNT1 failed" >> "$LOGFILE"
    fi
else
    echo "$(date): ERROR: $MOUNT1 not mounted" >> "$LOGFILE"
fi

# Check and backup to HDD2  
if grep -qs "$MOUNT2" /proc/mounts; then
    echo "$(date): $MOUNT2 mounted. Starting backup..." >> "$LOGFILE"
    rsync -av --delete --exclude-from="$EXCLUDE_FILE"\
	--prune-empty-dirs \
	--quiet \
	--itemize-changes \
	 "$SOURCE/" "$MOUNT2/$BACKUP_SUBFOLDER2/" >> "$LOGFILE" 2>&1
    if [ $? -eq 0 ]; then
        echo "$(date): Backup to $MOUNT2 completed successfully" >> "$LOGFILE"
    else
        echo "$(date): Backup to $MOUNT2 failed" >> "$LOGFILE"
    fi
else
    echo "$(date): ERROR: $MOUNT2 not mounted" >> "$LOGFILE"
fi

echo "=== Backup ended: $(date) ===" >> "$LOGFILE"
