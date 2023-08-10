echo "Adds users listed in user-list.txt as Pantheon team members and to the Drupal site as Admin role"
echo ""

users=`cat team-list.txt`

read -p "Site's machine name:  " sitename
read -p "Site's env:  " env

for user in $users
  do
    echo "__________________________________________________"
    echo ""
    echo "Adding $user as Pantheon team member to $sitename.$env"
    echo "__________________________________________________" 

    terminus site:team:add $sitename $user@email.arizona.edu team_member

    echo ""
    echo "Creating $user account on Drupal site; add CAS user name; add to Admin Role."
    echo ""

    terminus drush $sitename.$env -- user:create $user --mail="$user@email.arizona.edu"
    terminus drush $sitename.$env -- urol administrator $user
    terminus drush $sitename.$env -- cas:set-cas-username $user $user
  done
