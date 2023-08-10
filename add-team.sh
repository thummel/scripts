echo "Adds users listed in user-list.txt as Pantheon team members and to the Drupal site as Admin role"
echo ""

users=`cat team-list.txt`


for user in $users
  do
    echo "__________________________________________________"
    echo ""
    echo "Adding $user as Pantheon team member to $sitename.dev"
    echo "__________________________________________________" 

    terminus site:team:add $sitename $user@email.arizona.edu team_member

    echo ""
    echo "Creating $user account on Drupal site; add CAS user name; add to Admin Role."
    echo ""

    terminus drush $sitename.dev -- user:create $user --mail="$user@email.arizona.edu"
    terminus drush $sitename.dev -- urol administrator $user
    terminus drush $sitename.dev -- cas:set-cas-username $user $user
  done
