#!/bin/bash

echo "This script will create log files"
echo ""
echo ""


read -p "Site Machine Name:  " sitename
echo ""
echo ""
echo "Get site ID:"
echo ""  
  terminus site:info $sitename    
echo ""

read -p "Enter Site's ID:  "  SITE_UUID

ENV=dev

for app_server in `dig +short -4 appserver.$ENV.$SITE_UUID.drush.in`;
do
  mkdir $sitename-logs
  cd $sitename-logs
  rsync -rlvz --size-only --ipv4 --progress -e 'ssh -p 2222' $ENV.$SITE_UUID@$app_server:logs/* app_server_$app_server

  echo $ENV.$SITE_UUID@$app_server
  ls $ENV.$SITE_UUID@$app_server/logs
done

# Include MySQL logs
for db_server in `dig +short -4 dbserver.$ENV.$SITE_UUID.drush.in`;
do
  rsync -rlvz --size-only --ipv4 --progress -e 'ssh -p 2222' $ENV.$SITE_UUID@$db_server:logs/* db_server_$db_server
done
