echo "Remove a user as a Pantheon team member and drupal user"
echo ""
echo ""
read -p "Username to remove:  " username

source update-site-list.sh
sites=`cat all-sites-sorted.txt`



for sitename in $sites.dev
  do
    echo "__________________________________________________________"
    echo ""
    echo "Removing Pantheon Team Member: $username"
    echo $sitename
    echo "___________________________________________________________" 

    terminus site:team:remove $sitename.env $username

    echo ""
    echo "Blocking $user account on Drupal site"
    echo ""

    terminus drush $sitename.dev -- user:block $username
done
