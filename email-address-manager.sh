#!/bin/bash

read -p "Enter email address: " email
email_part1="${email%@*}"
domain="${email#*@}"

file_path="/opt/pmx6/postfix/etc/relay_recipients"
if [ ! -f "$file_path" ]; then
  read -p "File not found. Enter path: " file_path
fi

if grep -wq "$email_part1" "$file_path"; then
  read -p "Email already in file. Remove? (y/n) " remove
  if [ "$remove" == "y" ]; then
    sudo sed -i "/$email_part1/d" "$file_path"
    read -p "File updated. Hash? (y/n) " hash
    if [ "$hash" == "y" ]; then
      sudo /opt/pmx6/postfix/sbin/postmap hash:"$file_path"
      sudo /opt/pmx6/postfix/etc/init.d/postfix restart
    fi
  fi
else
  if [ "$domain" != "wrga.gov" ]; then
    email="$email_part1@wrga.gov"
  fi
  read -p "Email not in file. Add? (y/n) " add
  if [ "$add" == "y" ]; then
    sudo sh -c "echo '$email OK' >> $file_path"
    read -p "File updated. Hash? (y/n) " hash
    if [ "$hash" == "y" ]; then
      sudo /opt/pmx6/postfix/sbin/postmap hash:"$file_path"
      sudo /opt/pmx6/postfix/etc/init.d/postfix restart
    fi
  fi
fi
