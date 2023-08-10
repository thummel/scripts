echo "Adds users listed in user-list.txt as Pantheon team members and to the Drupal site as Admin role"
echo ""

users=`cat spreadsheet.txt`
sitename="workshop-demo.dev"

for user in $users
  do
 terminus site:team:add workshop-demo $user@email.arizona.edu team_member
#    terminus drush $sitename -- user:create $user --mail="$user@email.arizona.edu"
#    terminus drush $sitename -- urol administrator $user
#    terminus drush $sitename -- cas:set-cas-username $user $user
  done
