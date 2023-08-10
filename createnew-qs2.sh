!/bin/bash

clear
echo ""
echo "* Create new QS2 D9 website"
echo ""
echo ""

read -p "Machine Name:  " sitename
read -p "Site Label:    " label

echo ""
terminus site:create --org ua-campus-web-services -- $sitename "$label" 3162cc4c-2f75-40cb-8487-0c69bda99f39

echo ""
echo ""
echo "Install Drupal QS2"
    terminus -y -n drush $sitename.dev -- site:install az_quickstart   --account-name="rii-user" --account-mail="thummel@arizona.edu"  --site-mail="research-web@list.arizona.edu"  --site-name="$label"  --yes --verbose 

    terminus drush $sitename.dev -- user:create rii-admin --mail="research-web@list.arizona.edu"
    terminus drush $sitename.dev -- urol administrator rii-admin

echo ""
echo ""
read -p "Add Team to Pantheon and Drupal? [y/n] " answer3
   if [[ $answer3 = y ]] ; then
     source add-team.sh  
   fi


    terminus env:wake $sitename.dev
    mylogin=$(terminus drush $sitename.dev uli 2)
    open $mylogin
    

echo "__________________________________________________________________"
echo ""
echo "Manual Changes:"
echo ""
echo "   1. Set sitewide settings:"
echo "        Go to: Admininistration > Reports > Available Updates > Settings"
echo "        Add to Update Notification Email:" 
echo "          web-notifications-aaaabckgz22xagw3rpzhgyewne@uaresearch.slack.com"
echo "        Set email notification to: Only Security Updates"
echo ""
echo ""
echo "    2. Update rii-comms website: https://rii-comms.arizona.edu"
echo "         Add an entry for the new website."
echo ""
echo ""
echo "    3. Create a services.yml file"
echo "       Copy the file web/sites/default/default-services.yml to services.yml"
echo "       Use SFTP or git"


