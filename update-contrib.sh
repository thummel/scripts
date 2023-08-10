#!/bin/bash
# Drupal 7 check contributed modules and themes
#

clear
      echo ""
      echo ""
      echo ""
      echo "QS WARNING: "
      echo "Do not use this script to update modules controlled by UA Quickstart"
      echo ""
      echo "Grabbing list of D7 Quickstart sites from RII Technical Docs:"
      echo ""
      sites=$(curl https://live-techdocs.pantheonsite.io/export/machine-names/d7-3)

    echo ""
    echo ""

for sitename in $sites
  do
      echo ""
      echo "________________________________"
      echo ""
      echo "STARTING: $sitename.dev"
      
            terminus drush $sitename.dev pm-updatestatus
            
      echo ""
      echo "WARNING: "
      echo "Do not use this script to update modules controlled by UA Quickstart"
      echo ""
      echo ""        
         read -p "Do you want to update a module(s) on $sitename.dev? [y/n]   "  answer1
          if [[ $answer1 == y ]]; then
             echo ""
             read -p "Enter module machine name(s): " modules
                echo ""
                terminus connection:set $sitename.dev sftp -q
                terminus drush $sitename.dev up $modules
                terminus env:commit $sitename.dev --message "updated $modules"
                terminus drush $sitename.dev updatedb
                terminus drush $sitename.dev cron
         echo ""
         echo "Module $modules have been updated"
         echo ""
         echo "TEST MODULE BEFORE MOVING TO TEST ENVIRONMENT"
          mylogin=$(terminus drush $sitename.dev uli $myusername)
          open $mylogin

      echo ""
          source deploy.sh
    else
      echo ""
      echo "COMPLETED: $sitename"
    fi
done
