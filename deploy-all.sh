#!/bin/bash
# deploy all Pantheon test & live sites
#

source update-site-list.sh

for sitename in $sites
  do
           
echo ""
echo "copy database and files from Live to Test"
echo "terminus env:clone-content --cc --updatedb -- $sitename.live test"

terminus env:clone-content --cc --updatedb -- $sitename.live test           
               
echo "Deploy code to Test from Devel"

terminus env:deploy $sitename.test  --note "deploy to test"
               
echo "Update database on Test:" 
              
terminus drush $sitename.test updatedb - y
echo "cron"
               
terminus drush $sitename.test cron
            
echo "wake"
               
terminus env:wake $sitename.test
             
echo "login"
mytest=$(terminus drush $sitename.test uli $myusername)
               
open $mytest          
sleep 15
open https://test-$sitename.pantheonsite.io/admin/reports/status
open https://test-$sitename.pantheonsite.io/admin/reports/updates
open https://test-$sitename.pantheonsite.io/admin/reports/dblog

           
echo ""    	              
echo ""           
echo "LIVE ENVIRONMENT"           
echo ""           
read -p "Backup & Deploy to $sitename.live? [y/n] " answer3
             
if [[ $answer3 = y ]] ; then               
echo ""          
echo ""
               terminus env:deploy $sitename.live --note "deploy to live"
               terminus drush $sitename.live updatedb -y
               terminus drush $sitename.live cron
               mylive=$(terminus drush $sitename.live uli $myusername)
          echo ""
          echo "Login:"
          echo "$mylive"
               open $mylive
          sleep 15
          open https://live-$sitename.pantheonsite.io/admin/reports/status
          open https://live-$sitename.pantheonsite.io/admin/reports/updates
          open https://live-$sitename.pantheonsite.io/admin/reports/dblog
          else
             exit
          fi

done
