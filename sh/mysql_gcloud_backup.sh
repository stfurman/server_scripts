#!/bin/bash

# This script allows you to backup a MySQL database and upload it to Google Cloud Storage using gsutil.
# It will require you to have gsutil installed and configured on your system.
# Make sure to replace the placeholders with your actual database credentials and database name.
# You can schedule this script to run periodically using a cron job.

# Define variables
DATE=`date +%Y-%m-%d_%H%M`
LOCAL_BACKUP_DIR="/tmp"

# Database credentials
DB_HOST=""
DB_NAME=""
DB_USER=""
DB_PASSWORD=""

BUCKET_NAME=""

echo "$(date): Starting backup process"

mysqldump -h $DB_HOST -u $DB_USER -p$DB_PASSWORD --skip-lock-tables $DB_NAME | gzip  > $LOCAL_BACKUP_DIR/$DATE-$DB_NAME.sql.gz

echo "$(date): Database backup file successfully created"

echo "$(date): Uploading to the cloud"

# Upload the backup file to Google Cloud Storage
gsutil cp $LOCAL_BACKUP_DIR/$DATE-$DB_NAME.sql.gz gs://$BUCKET_NAME

echo "Backup file uploaded to Google cloud"

rm $LOCAL_BACKUP_DIR/$DATE-$DB_NAME.sql.gz

echo "Deleted temproary backup file"
