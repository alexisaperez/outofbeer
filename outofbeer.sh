#!/bin/bash
set -e

echo "This script is somewhat useless but if you are out of beer and need to know how many branches are in any given git repository continue on"

# Setup project
LOCAL=$(pwd)
echo 'Please enter the URL of the repo'
read REPO
PROJ=$(echo "${REPO}" | sed 's#.*/##')
PROJDIR="${LOCAL}/${PROJ}/"

# Discover the branches and display them with some verbage
function discover_branches {
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
  CURRENT=$(echo "${BRANCHES}" | grep -o "\*.*")
  echo  "${CURRENT}"
  printf "\nOther notable branches are:\n"
  printf "%s\n" "${BR[@]:1}"
}
# Allow the user to save the repo or discard it.
function save {
  read -p "Do you want to keep "${PROJ}" saved on your machine? (y/n)" CHOICE
  case "${CHOICE}" in
    y|Y ) echo "${PROJ} has been saved to "${PROJDIR}" let's go get a 🍺"; exit;;
    n|N ) echo ""${PROJ}" has been deleted from "${LOCAL}", let's go get a 🍺"; rm -rf "${PROJ}";;
    * ) echo "Thats invalid I think you had to many 🍺 🍺 's, try again"; save;;
  esac
}
# Show the user the 2 last commits on the current branch that is checked out.
function last_diffs {
  LASTD=$(cd "${PROJDIR}" && script -q /dev/null git log -n 2 | cat)
  printf "Would you like to see the last 2 commits on the current branch? (y/n)"
  read RCOM
  case "${RCOM}" in
    y|Y ) printf "\n$LASTD\n"; save;;
    n|N ) echo "Getting close to beer time"; save;;
    * ) echo "Thats invalid I think you had to many 🍺 🍺 's, try again"; save;;
  esac
}

discover_branches
last_diffs
