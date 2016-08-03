#!/bin/bash
set -e
echo "This script is somewhat useless but if you are out of beer and need to know how many branches are in any given git repository continue on"
echo 'Please enter the URL of the repo'
read REPO
PROJ=$(echo "${REPO}" | sed 's#.*/##')
if [ ! -d "${PROJ}" ]; then
  BRANCHES=$(git clone "${REPO}" &>/dev/null && cd "${PROJ}" && script -q /dev/null git branch -a | cat)
else
  BRANCHES=$(cd "${PROJ}" && script -q /dev/null git branch -a | cat)
fi
BR=()
while read -r line; do
   BR+=("$line")
done <<< "${BRANCHES}"
printf "\n"${PROJ}" has "$(tput setaf 1)${#BR[@]}"$(tput sgr0)"" total branches\n\nYou are currently on\n"
echo  "${BR[0]}"
printf "\nOther notable branches are:\n"
printf "%s\n" "${BR[@]:1}"
function save {
  LOCAL=$(pwd)
  read -p "Do you want to keep "${PROJ}" saved on your machine? (y/n)" CHOICE
  case "${CHOICE}" in
    y|Y ) echo "${PROJ} has been saved to "${LOCAL}"/"${PROJ}" let's go get a 🍺"; exit;;
    n|N ) echo ""${PROJ}" has been deleted from "${LOCAL}", let's go get a 🍺"; rm -rf "${PROJ}";;
    * ) echo "Thats invalid I think you had to many 🍺 🍺 's, try again"; save;;
  esac
}
save
