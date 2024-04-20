# Server Scripts

This repository contains a collection of simple yet effective server scripts aimed at enhancing security and monitoring capabilities.

## Disclaimer

These scripts are provided as-is, without any warranty or guarantee of fitness for any particular purpose. While efforts have been made to ensure their reliability and security, the author cannot be held responsible for any damages or liabilities arising from the use of these scripts. It is recommended to thoroughly review and test each script in a controlled environment before deploying them in a production environment. Use them at your own risk.

## Script: Whitelist Cloudflare IP Ranges in UFW

`sh/whitelist_cloudflare.sh`

### Description
This script automates the process of whitelisting Cloudflare IP ranges in UFW (Uncomplicated Firewall) on your server. It also allows you to whitelist your own IP address for SSH access.

### Usage
1. Before running the script, make sure to replace `MY_IP` with your own IP address.
2. Uncomment the line that allows SSH traffic if you want to allow SSH access.
3. Run the script using the following command:
```bash
bash sh/whitelist_cloudflare.sh
```
4. The script will download Cloudflare's IPv4 and IPv6 ranges, flush existing UFW rules, deny all incoming traffic by default, allow outgoing traffic, whitelist your IP address, allow SSH if uncommented, and then allow traffic from Cloudflare IP ranges.
5. Finally, it enables UFW and displays the status.

### Cron Job Example
You can schedule the script to run automatically at regular intervals using cron. Here's an example of how to set up a cron job to run the script daily at midnight:

```bash
# Edit your crontab file
crontab -e
```

Then add the following line to schedule the script to run daily at midnight:

```bash
0 0 * * * /path/to/whitelist_cloudflare.sh >> /var/log/cloudflare_whitelist.log 2>&1
```

## Script: MySQL Database Backup to Google Cloud Storage

`sh/mysql_gcloud_backup.sh`

### Description
This script automates the process of backing up a MySQL database and uploading it to Google Cloud Storage using `gsutil`. It is particularly useful for ensuring data redundancy and disaster recovery in a cloud environment.

### Prerequisites
- Ensure `gsutil` is installed and configured on your system.
- Replace the placeholders (`DB_NAME`, `DB_USER`, `DB_PASSWORD`) with your actual database credentials and database name.
- You may need to adjust the `LOCAL_BACKUP_DIR` variable to specify the directory where temporary backup files will be stored.

### Usage
1. Edit the script and replace the placeholders with your MySQL database credentials and database name.
2. Ensure `gsutil` is properly configured and authenticated to access your Google Cloud Storage bucket.
3. Schedule the script to run periodically using a cron job for regular backups.

### Cron Job Example
You can schedule the script to run automatically at regular intervals using cron. Here's an example of how to set up a cron job to run the script daily at midnight:

```bash
# Edit your crontab file
crontab -e
```

Then add the following line to schedule the script to run daily at midnight:

```bash
0 0 * * * /path/to/mysql_gcloud_backup.sh >> /var/log/mysql_backup.log 2>&1
```

This line will execute the script located at /path/to/mysql_backup.sh every day at midnight. The output of the script will be appended to the log file /var/log/mysql_backup.log, including both standard output and standard error.

Make sure to replace `/path/to/mysql_gcloud_backup.sh` with the actual path to your script. You can adjust the timing by modifying the cron schedule according to your preferences.

After saving the crontab file, cron will automatically execute the script at the specified intervals.