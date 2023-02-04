#!/bin/bash
#
# Version: 1.0
# Author: JoeTheTech
#

# Get the email address as input
read -p "Enter the email address: " email

# Extract the first part of the email address (before the "@" symbol)
email_first_part="${email%@*}"

# Check if the file "/opt/pmx6/postfix/etc/relay_recipients" exists
if [ ! -f "/opt/pmx6/postfix/etc/relay_recipients" ]; then
  # If the file is missing, ask for the path to it
  read -p "The file relay_recipients does not exist. Where is it located? " file_path
else
  # If the file exists, set the file_path variable to the expected path
  file_path="/opt/pmx6/postfix/etc/relay_recipients"
fi

# Check if the first part of the email address is in the file
if grep -wq "$email_first_part" "$file_path"; then
  echo "The email address is in the list."
else
  # If the first part of the email address is not in the file, prompt to add it
  read -p "The email address is not in the list. Do you want to add it? (yes/no) " add_to_list
  if [ "$add_to_list" == "yes" ]; then
    sudo sh -c "echo '$email OK' >> $file_path"
    sudo sh -c "sort $file_path -o $file_path"
    
    # Check if the email was added to the file
    if grep -wq "$email OK" "$file_path"; then
      read -p "The email address has been added to the list. Do you want to hash the new version? (yes/no) " hash_recipients
      if [ "$hash_recipients" == "yes" ]; then
        sudo /opt/pmx6/postfix/sbin/postmap hash:/opt/pmx6/postfix/etc/relay_recipients
        if [ -f "/opt/pmx6/postfix/etc/relay_recipients.db" ]; then
          echo "The file relay_recipients.db has been updated."
          sudo /opt/pmx6/postfix/etc/init.d/postfix restart
          echo "Postfix has been restarted."
        else
          echo "The file relay_recipients.db was not updated."
        fi
      else
        echo "The new version of relay_recipients has not been hashed."
      fi
    else
      echo "The email address was not added to the list."
    fi
  else
    echo "The email address has not been added to the list."
  fi
fi
