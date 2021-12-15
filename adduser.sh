#!/bin/bash

echo ""
echo ""
echo "* adds a user to Pantheon as a Team Member"
echo "* creates a drupal account"
echo "* add a cas username"
echo "* adds user to the Administrator role"
echo ""
echo ""
read -p "Site Name:         " sitename
read -p "Environment:       " env
read -p "UA Netid username: " username


    
echo "________________________________________________"
echo ""
echo "Adding $username to Pantheon account: $sitename"
echo "________________________________________________"
echo "" 
    
terminus site:team:add $sitename $username@email.arizona.edu team_member
    
echo ""
echo "Adding $username to Drupal $sitename."
 
terminus drush $sitename.$env -- user:create $username --mail="$useremail"
terminus drush $sitename.$env -- urol administrator $username    
terminus drush $sitename.$env -- cas:set-cas-username $username $username  
