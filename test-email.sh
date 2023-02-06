#!/bin/bash
# ver 1.0
# Author: JoeTheTech

clear

email=$1
if [ -z "$email" ] || ! echo "$email" | grep -Eq '^[a-zA-Z0-9._%+-]+@wrga\.gov$'; then
  cowsay "ERROR: Invalid email address. Email must be in the format 'user@wrga.gov'"
  exit 1
fi

subject="Test From IT"
body="Test email message from the IT staff. You can delete this message."

(
echo "ehlo inetsrv.wrga.gov"
sleep 1
echo "mail from: test@inetsrv.wrga.gov"
sleep 1
echo "rcpt to: $email"
sleep 1
echo "data"
sleep 1
echo "subject: $subject"
echo ""
echo "$body"
echo "."
sleep 1
echo "quit"
) | telnet inetsrv.wrga.gov 25

cowsay "Test email sent to $email. Please check your inbox to confirm receipt."
