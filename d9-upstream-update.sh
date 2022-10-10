#!/bin/bash

clear
echo ""
echo "QS2 Upstream update"
echo ""
echo ""
read -p "Site's machine name:  "  sitename      
echo ""

echo ""
echo "Backing up Live"
echo ""

# terminus backup:create $sitename.live

echo ""

echo "Cloning the database and files from Live to Dev"
echo ""

terminus env:clone-content --cc --updatedb -- $sitename.live dev

echo ""
echo ""
echo "Update the database on Dev"
echo ""
terminus drush $sitename.dev updb

echo ""
echo ""
echo "Switch to SFTP mode and export the configuration"
echo ""

terminus connection:set $sitename.dev sftp --yes
terminus drush $sitename.dev cex

echo ""
echo ""
echo "Commit any changes"
terminus env:commit  --message "config export" $sitename.dev --yes

echo ""
echo ""

read -n 1 -r -s -p $'When sync is done, press enter to continue...\n'

echo ""
echo ""
echo "Switch to GIT mode and apply upstream updates"
echo ""

terminus connection:set $sitename.dev git --yes
terminus upstream:updates:apply --updatedb --accept-upstream -- $sitename.dev

echo ""
echo ""
echo "Import configuration "
echo ""
terminus drush $sitename.dev config:import --yes

echo ""
echo "Run Distro Update"

terminus drush $sitename.dev config-distro-update --yes

echo ""
echo "Bring DEV up site in a browser for testing"
echo ""

terminus env:wake $sitename.dev

mylogin=$(terminus drush $sitename.dev uli $myusername)          

open $mylogin


echo ""
echo "TEST"
echo "Deploy to TEST environment and Import Configuration"
echo ""
read -p "Deploy to $sitename.test?  [y/n] " answer
  if [[ $answer = y ]] ; then
    echo ""
    echo "Deploying to: $sitename.test"
    terminus env:deploy $sitename.test  --note "deploy to test: $message" 
    echo ""
    echo "Clone database from Live to Test"
    terminus env:clone-content --cc --updatedb -- $sitename.live test
    echo ""
    echo "Run Config Import"
    terminus drush $sitename.test config:import
    echo ""
    echo "Run Distro Update"
    terminus drush $sitename.dev config-distro-update --yes
    echo ""
    echo "Update the database and run cron"
    terminus drush $sitename.test updatedb
    terminus drush $sitename.test cron
    terminus env:wake $sitename.test 
    ecgo ""
    echo "Bring up site in browser for testing"
    mytest=$(terminus drush $sitename.test uli $myusername)
    open $mytest
    sleep 5
    open https://test-$sitename.pantheonsite.io/
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
    echo "Backing up and Deploying to: $sitename.live"
    terminus backup:create $sitename.live
   
    echo ""
    echo "Deploy code from test to live" 
    terminus env:deploy $sitename.live --note "deploy to live: $message"

    echo "Import configuration on Live"
    terminus drush $sitename.live config:import

    echo "Run Distro Update on Live"
    terminus drush $sitename.dev config-distro-update --yes

    echo ""
    echo "Update the database and bring up site"
    terminus drush $sitename.live updatedb
    terminus drush $sitename.live cron
    mylive=$(terminus drush $sitename.live uli $myusername)
    open $mylive
  else
    exit
  fi
