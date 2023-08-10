#!/bin/bash
# deploy to Pantheon Quickstart sites to test & live
#

    echo ""
    echo "Grabbing list of Quickstart sites from RII Technical Docs:"
    echo ""
    sites=$(curl https://live-techdocs.pantheonsite.io/export/machine-names/d7/qs)
    echo ""


for sitename in $sites
  do
           echo "DEPLOYING $sitename.test TO TEST ENVIRONMENT"
           echo ""
               terminus env:deploy $sitename.test  --note "deploy to test" 
               terminus drush $sitename.test updatedb - y
               terminus drush $sitename.test cron
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
          echo "Backup $sitename.live"
               terminus backup:create $sitename.live
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
