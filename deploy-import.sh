#!/bin/bash
# deploy to Pantheon test & live
#

echo ""
echo "Deploy to TEST and Import Configuration"
echo ""
read -p "Deploy to $sitename.test?  [y/n] " answer
  if [[ $answer = y ]] ; then
    echo "Deploying to:" $sitename.test
    terminus env:deploy $sitename.test  --note "deploy to test: $message" 
    terminus drush $sitename.test config:import
    terminus drush $sitename.test updatedb
    terminus drush $sitename.test cron
    terminus env:wake $sitename.test 
    mytest=$(terminus drush $sitename.test uli $myusername)
    open $mytest
    sleep 5
    open https://dev-$sitename.pantheonsite.io/admin/reports/dblog
    open https://dev-$sitename.pantheonsite.io/admin/reports/updates
    open https://dev-$sitename.pantheonsite.io/admin/reports/status
  else
    exit
  fi

echo ""
echo ""    	   
echo "DEPLOY TO LIVE ENVIRONMENT"
echo ""
echo ""
read -p "Deploy to $sitename.live? [y/n] " answer3
  if [[ $answer3 = y ]] ; then
    echo ""
    echo "Backing up and Deploying to:" $sitename.live
    terminus backup:create $sitename.live
    terminus drush $sitename.live config:import
    terminus env:deploy $sitename.live --note "deploy to live: $message"
    terminus drush $sitename.live updatedb
    terminus drush $sitename.live cron
    mylive=$(terminus drush $sitename.live uli $myusername)
    open $mylive
    sleep 5
    open https://live-$sitename.pantheonsite.io/admin
  else
    exit
  fi
