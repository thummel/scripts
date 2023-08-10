#!/bin/bash
# Get list of Pantheon sites and sort and output
#
echo ""
echo "Updating list of Pantheon sites"


 cat /dev/null > all-sites.txt
 terminus site:list --format=list --field=Name > all-sites.txt
 sort all-sites.txt > all-sites-sorted.txt


