#!/bin/bash
# ver 1.3
clear

if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root or with sudo."
  exit
fi

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
      if ! sudo /opt/pmx6/postfix/sbin/postmap hash:"$file_path"; then
        echo "Error: postmap command failed."
        exit 1
      fi
      if ! sudo /opt/pmx6/postfix/etc/init.d/postfix restart; then
        echo "Error: postfix restart command failed."
        exit 1
      fi
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
      if ! sudo /opt/pmx6/postfix/sbin/postmap hash:"$file_path"; then
        echo "Error: postmap command failed."
        exit 1
      fi
      if ! sudo /opt/pmx6/postfix/etc/init.d/postfix restart; then
        echo "Error: postfix restart command failed."
        exit 1
       fi
      fi
    fi
  fi

# Ask to test email.
/usr/games/cowsay -f dragon-and-cow "Run test-email.sh to make sure it works"
