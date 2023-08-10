#!/bin/bash

clear
source update-site-list.sh

sites=`cat all-sites-sorted.txt`
read -p "Environment:  "  env  
echo ""

for sitename in $sites
  do
     echo ""
     echo "$sitename.$env"
     echo ""
     terminus upstream:updates:list $sitename.dev 
     echo ""
     sleep 5
  done
