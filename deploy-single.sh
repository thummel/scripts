#!/bin/bash
# deploy to Pantheon test & live
#
echo ""


read -p "Site Machine Name:  " sitename  

           echo "DEPLOY TO TEST ENVIRONMENT"
           echo ""
           read -p "Deploy to $sitename.test? [y/n] " answer
            if [[ $answer = y ]] ; then
               echo "Deploying to: $sitename.test"
               terminus env:deploy $sitename.test  --note "deploy to test" 
               terminus drush $sitename.test updatedb - y
               terminus drush $sitename.test cron
               mytest=$(terminus drush $sitename.test uli $myusername)
               open $mytest
          sleep 15
          open https://test-$sitename.pantheonsite.io/admin/reports/status
          open https://test-$sitename.pantheonsite.io/admin/reports/updates
          open https://test-$sitename.pantheonsite.io/admin/reports/dblog
            else
               echo "Done deploying $sitename.test"
               echo ""
            fi
    	   
           echo "DEPLOY TO LIVE ENVIRONMENT"
           echo ""
           echo ""
           read -p "Deploy to $sitename.live? [y/n] " answer3
             if [[ $answer3 = y ]] ; then
               echo ""
          echo ""
          echo "Backup $sitename.live"
               terminus backup:create $sitename.live
               terminus env:deploy $sitename.live --note "deploy to live"
               terminus drush $sitename.live updatedb -y
               terminus drush $sitename.live cron
               mylive=$(terminus drush $sitename.live uli $myusername)
               open $mylive
          sleep 15
          open https://live-$sitename.pantheonsite.io/admin/reports/status
          open https://live-$sitename.pantheonsite.io/admin/reports/updates
          open https://live-$sitename.pantheonsite.io/admin/reports/dblog
          else
             echo "Done deploying: $sitename.live"
          fi
