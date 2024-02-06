#!/bin/bash

# A simple backup script that makes a backup of an existing DB and a series of files
# The compressed backup is uploaded to a remote SFTP, along with a given number of the most recent files
# Finally, an email alert is generated and sent

# Requirements: tar, bzip2, ftp and pre-configured mutt for the email notification


# Author: JA Vieitez

#Local stuff
NOW=$(date +"%m-%d-%Y")
WORKFOLDER='/dailybackup'
SQLUSER='usergoeshere'
SQLPASS='passgoeshere'
DBNAME='dbname'
BACKUPFILEPREFIX='localfilesbackup_'


#FTP Stuff
HOST='name or ip'
USER='usergoeshere'
PASSWD='passgoeshere'
REMOTEFOLDER='/backupfiles'

# email 
DESTINATIONEMAIL='user@domain.com'


#************************* SQL BACKUP ******************************************
#remove previous SQL exports, if any
rm $WORKFOLDER/*.sql
#dump the whole DB to a file and zip it
echo dumping MySQL DB to file
mysqldump -u$SQLUSER -p$SQLPASS  $DBNAME > $WORKFOLDER/$DBNAME-$NOW.sql
echo Backup OK, compressing file
bzip2 $WORKFOLDER/$DBNAME-$NOW.sql --best


#************************* local files BACKUP ******************************************
echo Creating backup file for all relevant local files....
tar cvf $WORKFOLDER/$BACKUPFILEPREFIX$NOW.tar /etc/nagios3/ > /dev/null
tar rvf $WORKFOLDER/$BACKUPFILEPREFIX$NOW.tar /usr/lib/nagios/plugins/ > /dev/null
tar rvf $WORKFOLDER/$BACKUPFILEPREFIX$NOW.tar /etc/exim4/ > /dev/null
tar rvf $WORKFOLDER/$BACKUPFILEPREFIX$NOW.tar /var/tracprojects/ > /dev/null
tar rvf $WORKFOLDER/$BACKUPFILEPREFIX$NOW.tar /var/www/ > /dev/null
tar rvf $WORKFOLDER/$BACKUPFILEPREFIX$NOW.tar /usr/local/scripts/ > /dev/null

echo Backup OK, compressing file
bzip2 $WORKFOLDER/$BACKUPFILEPREFIX$NOW.tar --best  # > /dev/null


#************************* BACKUP SYNC ******************************************
#remove files older than 6 days from local dir
find $WORKFOLDER/* -mtime +5 -exec rm {} \;

#sync with remote FTP folder
echo uploading to and syncing remote FTP
lftp -f "
set ssl:verify-certificate no;
open $HOST
user $USER $PASSWD
mirror --reverse --delete --verbose $WORKFOLDER $REMOTEFOLDER
bye
"


#************************* EMAIL NOTIFICATION ******************************************

echo sending confirmation email

# ls FTP contents and output to txt file. The file will be  used in the message body
ftp -n $HOST <<END_LSSCRIPT
quote USER $USER
quote PASS $PASSWD
cd /backupfiles
mls * /tmp/messagebody.txt
quit
END_LSSCRIPT

# send email confirmation message 
echo --------------------------------------------------------------------------------------------------------------------- >> /tmp/messagebody.txt
echo backup files for Nagios, MantisBT and TRAC wiki have been created on $NOW . Files have been stored on remote FTP $HOST >> /tmp/messagebody.txt
echo --------------------------------------------------------------------------------------------------------------------- >> /tmp/messagebody.txt

mutt -s "A remote Nagios, MantisBT and wiki Backup has been created on $NOW " -- $DESTINATIONEMAIL < /tmp/messagebody.txt

#remove the temp files
rm /tmp/messagebody.txt

exit 0
