#!/bin/bash

# ddev reviewer
#
# will create a clone of a website on pantheon
# apply a PR from github for testing
#
# TODO
# check if composer seceret is there for running composer install for unity-profile
#

# set colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
BLACK='\033[0;30m'
DARK_GRAY='\033[1;30m'
LIGHT_GRAY='\033[0;37m'
WHITE='\033[1;37m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'

# set styles for output
BOLD='\033[1m'
DIM='\033[2m'
ITALIC='\033[3m'
UNDERLINE='\033[4m'
BLINK='\033[5m'
REVERSE='\033[7m'
HIDDEN='\033[8m'
STRIKETHROUGH='\033[9m'

# no color to reset
NC='\033[0m' 



## 
# functions
##
#
# function to display the help message
show_help() {
    echo -e "${CYAN}review script - panterm review${NC}"
    echo 
    echo -e "${YELLOW}usage:${NC}"
    echo -e "./panterm.sh review [SITENAME] [PR]"
    echo 
    echo -e "${YELLOW}arguments:${NC}"
    echo -e "${GREEN}SITENAME${NC}  site to test the pr on"
    echo -e "${GREEN}PR${NC}        pull request number [0-9+]"
    echo
    echo -e "${YELLOW}${ITALIC}if no SITENAME or PR passed will prompt${NC}"
    echo
}

# system requirement checks
check_req() {
    # check if ddev is installed
    # check the ddev config flie for if terminus token is there
    if command -v ddev >/dev/null 2>&1; then
        echo -e "${GREEN}ddev installed${NC}"

        # set the ddev config file
        FILE_CONFIG_DDEV="$HOME/.ddev/global_config.yaml"

        # check if the terminus machine token is set or not
        if grep -q "TERMINUS_MACHINE_TOKEN" "$FILE_CONFIG_DDEV" 2>/dev/null; then
            echo -e "${GREEN}TERMINUS_MACHINE_TOKEN found in ${BOLD}$FILE_CONFIG_DDEV${NC}"
        else
            echo -e "${RED}TERMINUS_MACHINE_TOKEN not found in ${BOLD}${UNDERLINE}$FILE_CONFIG_DDEV${NC} ${RED}please add and try again${NC}"
            exit 0
        fi
    else
        echo -e "${RED}ddev not installed, please install and try again${NC}"
        exit 0
    fi

    # check if gh is installed
    if command -v gh >/dev/null 2>&1; then
        echo -e "${GREEN}gh installed${NC}"
    else
        echo -e "${RED}gh not installed, please install and try again${NC}"
        exit 0
    fi

    # check if mkcert is installed
    if command -v mkcert >/dev/null 2>&1; then
        echo -e "${GREEN}mkcert installed${NC}"
    else
        echo -e "${RED}mkcert not installed, please install and try again${NC}"
        exit 0
    fi

    # check if docker is installed
    if command -v docker >/dev/null 2>&1; then
        echo -e "${GREEN}docker installed, checking if running...${NC}"
    else
        echo -e "${RED}docker not installed, please install and try again${NC}"
        exit 0
    fi

    # check if docker is running
    if docker info >/dev/null 2>&1; then
        echo -e "${GREEN}docker is running, moving on${NC}"
    else
        echo -e "${RED}docker is not running, please start docker and try again${NC}"
        exit 0
    fi
}



## 
# main
##
#
# getting or setting arguments
#
# check for a sitename passed
if [ -z "$1" ]; then
    # no arguments so check reqs and get site
    check_req

    # get the site name
    read -p "$(echo -e ${CYAN}enter site name to use: ${NC})" SITENAME
else
    # check for needing help first
    if [[ "$1" == "-h" ]]; then
        show_help
        exit 0
    else
        # check reqs first
        check_req

        # got sitename so set to var
        SITENAME="$1"
    fi
fi

# check for a PR passed
if [ -z "$2" ]; then
    # no arguments so get PR
    # get the PR number
    read -p "$(echo -e ${CYAN}enter PR number to use: ${NC})" PR_NUM
else
    # got PR so set to var
    PR_NUM="$2"
fi

# create the git clone command to pull from pantheon
CMD_CLONE=$(terminus connection:info --field git_command $SITENAME.dev)

echo "SITENAME $SITENAME"

# check if the command starts with "git clone"
if ! echo "$CMD_CLONE" | grep -q '^git clone'; then
    # terminus failed or problem with sitename
    echo -e "${RED}terminus command ${BOLD}${UNDERLINE}$CMD_CLONE${NC} ${RED}error${NC}"
    exit 0  
fi

# check if PR_NUM is a valid number
# TODO chck if valid pr to pull from
if [[ ! "$PR_NUM" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
    echo -e "${RED}pr ${BOLD}${UNDERLINE}$PR_NUM${NC} ${RED}is not a number${NC}"
    exit 0
else
    # add a unique dir to clone into
    CMD_CLONE="${CMD_CLONE}-pr-$PR_NUM"

    # set the pr dir
    DIR_SITE="$SITENAME-pr-$PR_NUM"
fi



#
# pulling site from pantheon
# creating ddev container
# merge pr into container
#
# all good so print out the command
echo -e "${ITALIC}$CMD_CLONE${NC}"

exit 0


# run the clone command
eval $CMD_CLONE

# cd into the new dir
cd $DIR_SITE

# set the ddev configs
# TODO
# see if project-name can be unique or temp so dont have to stop and unlist when done
# or see if can delete the project then continue
ddev config --docroot=web  --project-type=drupal10 --project-name $DIR_SITE

# start ddev
ddev start

# copy the pantheon example to live
cp .ddev/providers/pantheon.yaml.example .ddev/providers/pantheon.yaml

# set the YAML file and the new value
YAML_PANTHEON=".ddev/providers/pantheon.yaml"

# use sed to update the project value
sed -i.bak "s/yourproject.dev/$SITENAME.live/g" $YAML_PANTHEON

# remove the backup file created by sed 
rm "$YAML_PANTHEON.bak"

# make a local cert
mkdir .ddev/custom_certs
cd .ddev/custom_certs/

# generate the self-signed cert, making sure to change the names to match your ddev site's project name
mkcert --cert-file=$DIR_SITE.crt --key-file=$DIR_SITE.key $DIR_SITE.ddev.site 127.0.0.1

# install composer stuff
# TODO make sure in right dir before running composer install
cd ../..
composer install

# pull from pantheon
# TODO maybe pull first for right composer? got "Do you trust" notice
ddev pull pantheon -y

# get the new pr
# get the profile and checkout the pr
git clone https://github.com/NCAR/unity-profile unity-profile-pr
cd unity-profile-pr/
#gh pr checkout "$PR_NUM"
CMD_PR=$(gh pr checkout $PR_NUM)

# example for not valid pr
# GraphQL: Could not resolve to a PullRequest with the number of 10000. (repository.pullRequest)
# check if the PR starts with "GraphQL:" to check for valid PR
if echo "$CMD_PR" | grep -q '^GraphQL'; then
    # not a valid pr so ask to continue first
    read -p "$(echo -e ${YELLOW}PR not found, continue with site setup? [y/n]${NC})" yn

    case $yn in
        [Yy]* )
            echo -e "${CYAN}continuing with no PR...${NC}"
        ;;
        [Nn]* )
            echo -e "${RED}stopping script...${NC}"
            cd ..
            ddev stop --unlist $DIR_SITE
            cd ..
            rm -rf unity-profile-pr/
            exit 0;
        ;
    esac
else
    # run the checkout command
    eval $CMD_PR
fi

# remove the current profile and replace with PR
cd ..
rm -rf web/profiles/composer/unity-profile
mv unity-profile-pr web/profiles/composer/unity-profile

# add status message bout new pr
echo -e "${GREEN}PR merged into site: restarting, clearing cache, and updating database...${NC}"

# restart ddev
ddev restart

# clear cache and update db
ddev drush updb
ddev drush cr

# remove saml
# TODO check for errors before going on
ddev drush pm:uninstall simplesamlphp_auth

# get the username for login link
echo 
read -p "$(echo -e ${CYAN}enter username for login link: ${NC})" USERNAME
echo

# make login link
url_login=$(ddev drush user:login --name=$USERNAME --uri=https://$DIR_SITE.ddev.site)

# output the stop link
echo 
echo "when done testing, stop the ddev container and unlist your project with:"
echo -e "${YELLOW}ddev stop --unlist $DIR_SITE${NC}"

# output the link
echo 
echo -e "use the link below to login:"
echo -e "${YELLOW}${BOLD}${UNDERLINE}$url_login${NC}"







