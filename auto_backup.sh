#!/bin/bash

# Configuration
#which file to backup
SOURCE_DIR="/root/bash_practice/backuptest/backup_dir1"

#where the backup will be stored
BACKUP_DIR="/root/bash_practice/backuptest/backup_dir2"

#remote server address for store data in another server
#REMOTE_SERVER="user@remote.server:/path/to/remote/backup"

#log file for the var dir
LOG_FILE="/var/log/backup.log"

#how long the file will remain
RETENTION_DAYS=7

#public encryption key for gpg
ENCRYPTION_KEY="/root/bash_practice/backuptest/public.key"

# Create a compressed and encrypted backup
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
ARCHIVE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"
tar -czf - "$SOURCE_DIR" | gpg --encrypt --recipient-file "$ENCRYPTION_KEY" -o "$ARCHIVE"

# Transfer the backup to the remote server
#rsync -avz "$ARCHIVE" "$REMOTE_SERVER"

#Transfer the backup to the local server
rsync -avzP "$ARCHIVE" "$BACKUP_DIR"

# Log the backup process
echo "Backup completed at $TIMESTAMP" >> "$LOG_FILE"

# Remove old backups
find "$BACKUP_DIR" -type f -name "backup_*.tar.gz" -mtime +$RETENTION_DAYS -exec rm {} \;

# Log the cleanup process
if [ $? -eq 1 ];then
echo "Old backups deleted at $(date +%Y-%m-%d_%H-%M-%S)" >> "$LOG_FILE"
fi
