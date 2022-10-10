#!/bin/bash

clear
echo ""
echo ""
echo "DRUPAL 9 MULTIDEV CONFIG EXPORT: "
echo 
echo "In a Multidev:"
echo "* set multidev to sftp mode"
echo "* export configuration"
echo "* git commit the changes"
echo ""
echo "In Dev:"
echo "* backup dev"
echo "* merge multidev to dev"
echo "* imports configuration from file system to database"
echo "* opens dev in browser for testing"
echo "* prompts for deployment to test"
echo "* prompts for deployment to live"
echo ""
echo ""      

read -p "Pantheon site's machine name:        "  sitename      
read -p "Multidev's machine name:             "  multi
read -p "Describe changes [commit message]:   "  message

echo ""
echo ""      
echo "Exporting configuration from the database to the file system on:"
echo "$sitename.$multi"
echo "________________________________________________________________"      
echo ""
echo ""

terminus connection:set $sitename.$multi sftp --yes
terminus drush   $sitename.$multi config:export --yes
terminus env:commit  --message "$message" $sitename.$multi --yes


read -p "Continue to Dev? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

echo "Backing up Dev/Master:" $sitename.dev
terminus backup:create $sitename.dev

Echo "Merging to Dev (master) and importing configs"

terminus multidev:merge-to-dev $sitename.$multi --yes
terminus remote:drush $sitename.dev config:import --yes
terminus remote:drush $sitename.dev updatedb --yes

terminus env:wake $sitename.dev

mylogin=$(terminus drush $sitename.dev uli $myusername)          

open $mylogin
sleep 4

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
    terminus drush $sitename.text 
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
