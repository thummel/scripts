#!/bin/bash
# Backup all sites dev (git master)
#
clear
cd ~/bin

source update-site-list.sh

sites=`cat all-sites-sorted.txt`

for sitename in $sites
  do
   echo ""
   echo "WEBSITE: $sitename:"
   echo ""
   echo "Backing up dev / git master"
   echo ""
   terminus backup:create $sitename.dev

   echo ""
   echo "Backing up live:"
   echo ""
   terminus backup:create  $sitename.live
   echo ""
   
done

 
echo ""
echo "Done"
echo ""         
read -p "Run Upstream Updates on all sites? [y/n]   "  answer1
  if [[ $answer1 == y ]]; then
     echo ""
     source upstream-all.sh
  else
     exit
  fi
 
