#!/bin/bash
clear

echo ""
echo "For all Pantheon sites:"
echo "  * Removes a user from Pantheon as a team member"
echo "  * Cancels drupal account but keeps any content"
echo ""

read -p "NetID of user to remove: " username

echo ""
echo "Getting a list of all Pantheon sites.."
sites=`cat all-sites-sorted.txt`
echo ""

for sitename in $sites
  do
  echo "___________________________________________"
  echo ""
  echo "$sitename: Removing Pantheon Team Member: $username"
  echo ""
  
  siteid=$(terminus site:info $sitename --fields=ID --format=list)
  terminus site:team:remove $siteid $username@email.arizona.edu
  
  echo ""
  echo "Removed from Pantheon"
  echo ""
  echo "Canceling Drupal Account in Dev, Test, Live environments:"

  terminus drush $sitename.dev  -- user:cancel $username -y
  terminus drush $sitename.test -- user:cancel $username -y
  terminus drush $sitename.live -- user:cancel $username -y
done
