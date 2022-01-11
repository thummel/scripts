#!/bin/bash

clear
echo ""
echo ""
echo "Configuration Management Demo"
echo ""

read -p "Pantheon site's machine name:        "  sitename      
read -p "Multidev's machine name:             "  multi
read -p "Describe changes [commit message]:   "  message

echo ""      
echo "Switch to SFTP Mode:"
echo "terminus connection:set $sitename.$multi sftp --yes"

terminus connection:set $sitename.$multi sftp --yes

read -r -s -p $

echo ""
echo "Export Configuration:"
echo "terminus drush $sitename.$multi config:export --yes"
echo ""

terminus drush $sitename.$multi config:export --yes

read -r -s -p $

echo ""
echo ""
echo "Terminus Commit:"
echo ""
read -p "Describe changes [git commit message]:   "  message
echo ""
echo "terminus env:commit  --message "$message" --force $sitename.$multi --yes"

terminus env:commit  --message "$message" --force $sitename.$multi --yes
echo ""
read -r -s -p $

echo ""
echo ""

read -p "Backup and Merge to Dev? y/n" -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

echo "Backing up Dev/Master:"
echo ""
echo "terminus backup:create $sitename.dev"
echo ""

# terminus backup:create $sitename.dev

echo ""
read -r -s -p $
echo ""
echo ""
echo "Merge Code to Dev/Master from Multidev:"
echo ""
echo  terminus multidev:merge-to-dev $sitename.$multi 
echo ""
terminus multidev:merge-to-dev $sitename.$multi 
echo ""

echo ""
read -r -s -p $
echo ""
echo ""
echo "DEV: Import database and files from Live"
echo "terminus env:clone-content $sitename dev"
echo ""
terminus env:clone-content $sitename dev
echo ""
echo ""
read -r -s -p $
echo ""
echo "DEV: Import configuration from Code to Database:"
echo ""
echo "terminus drush $sitename.dev config:import --yes"
echo ""
terminus drush $sitename.dev config:import --yes

echo ""
read -r -s -p $
echo ""
echo "Clear the cache:"
echo "terminus env:clear-cache $sitename.dev --yes"
echo ""
terminus env:clear-cache $sitename.dev --yes

echo ""
read -r -s -p $
echo ""
echo "Bring DEV up site in a browser and login"
echo ""

terminus env:wake $sitename.dev

mylogin=$(terminus drush $sitename.dev uli $myusername)          

open $mylogin
sleep 4

open https://dev-$sitename.pantheonsite.io/admin/reports/dblog
open https://dev-$sitename.pantheonsite.io/admin/reports/updates
open https://dev-$sitename.pantheonsite.io/admin/reports/status


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
