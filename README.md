# Some useful scripts
Most of them are quick and dirty solutions to everyday problems

 * __check_url_pcre.sh__: Finds a Perl Compatible RegExp in a remote url (web, webservice, etc...)
 * __check_url_pcre_xml.sh__: Same as check_url_pcre, but returns an integer from an XML field, which is compared with a provided value. This can trigger a Nagios alert when a value is exceeded.   
 * __comparediff.sh__: compares the content of fileA, line by line, with the content of fileB, and writes the output to outputfile
 * __fetchremotelogs.sh__: retrieves a series of log files from each server on a cluster, and counts the repetitions of a given string in them
 * __simpleSQLbackup.sh__: A simple backup script that can be scheduled to make a backup of an existing DB and a series of files, and then upload them to a remote place
