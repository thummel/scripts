#!/bin/bash
#  Updates all DEV environments
#
# Requires terminus plugin:
# https://github.com/pantheon-systems/terminus-mass-update

clear
echo ""
echo "Mass Pantheon upstream updates on DEV environment of ALL sites"
echo "Requires terminus plugin: https://github.com/pantheon-systems/terminus-mass-update"
echo ""

echo "Running command:"
echo "terminus site:list --format=list | terminus site:mass-update:apply"
echo ""

terminus site:list --format=list | terminus site:mass-update:apply

echo ""
echo ""
echo "Done mass upsteam updates"
echo ""
echo "Run deploy"
echo ""
     source deploy-all.sh






