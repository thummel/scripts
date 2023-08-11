#!/bin/bash

#prompt here to add users to Pantheon & Drupal

echo "Adds users to the site and gives them Administrator Role"

read -p "Site Name: "   sitename
read -p "Environment:"  env
read -p "To add user to Pantheon type username: " username


    echo "______________________________"
    echo "Adding $username to $sitename"
    echo "______________________________" 
    terminus site:team:add $sitename $username@email.arizona.edu team_member
    echo "Now adding to Drupal."
    terminus drush $sitename.$env -- user:create $username --mail="$useremail"
    terminus drush $sitename.$env -- urol administrator $username
    terminus drush $sitename.$env -- cas:set-cas-username $username $username  
