# PMX Address Manager for Postfix

The PMX Address Manager for Postfix is a shell script designed to manage email addresses in the relay_recipients file. The script provides the ability to check for an email address in the file, add or remove the email address, and update the hashed version of the file.

## Features
* Check for an email address in the file
* Add an email address to the file with the correct domain name
* Remove an email address from the file
* Update the hashed version of the file
* Restart the postfix service

## Requirements
* The script must be run with ```sudo``` privileges.
* The postfix service must be installed at */opt/pmx6/postfix/*.
* The relay_recipients file must exist at */opt/pmx6/postfix/etc/relay_recipients*.
* The postmap command must be installed and located at ```/opt/pmx6/postfix/sbin/postmap```.
* The postfix service must be able to be restarted with the command ```/opt/pmx6/postfix/etc/init.d/postfix restart```.

## Usage
To use the PMX Address Manager for Postfix, simply run the script with ```sudo``` privileges. The script will prompt for an email address and guide you through the process of checking, adding, or removing the email address from the 'relay_recipients' file.
