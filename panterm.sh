#!/bin/bash

# panterm
#
# scripts for pantheon sites
#
# usage:
# ./panterm.sh <script> [sitename] [arguments]
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
# function to display the help message
show_help() {
    echo -e "${CYAN}panterm - pantheon + terminus scripts${NC}"
    echo -e "${YELLOW}usage:${NC}"
    echo -e "./panterm.sh <script> [SITENAME] [ARGUMENTS]"
    echo 
    echo -e "${YELLOW}scripts:${NC}"
    echo -e "${GREEN}review${NC}  pulls down a site into ddev and merges PR in for testing"
    echo -e "${GREEN}update${NC}  runs pantheon updates"
    echo
    echo
    echo -e "${CYAN}review script${NC}"
    echo -e "${YELLOW}usage:${NC}"
    echo -e "./panterm.sh review [SITENAME] [PR]"
    echo 
    echo -e "${YELLOW}arguments:${NC}"
    echo -e "${GREEN}SITENAME${NC}  site to test the pr on"
    echo -e "${GREEN}PR${NC}        pull request number [0-9+]"
    echo
    echo
    echo -e "${CYAN}update script${NC}"
    echo -e "${YELLOW}usage:${NC}"
    echo -e "./panterm.sh update [SITENAME] [ARGUMENTS]"
    echo 
    echo -e "${YELLOW}arguments:${NC}"
    echo -e "${GREEN}SITENAME${NC}       site to update"
    echo -e "${GREEN}-nc|--no-check${NC} disable update prompts"
    echo
    echo
    echo -e "${YELLOW}${ITALIC}if no SITENAME, PR, or ARGUMENTS passed will prompt${NC}"
    echo
}



## 
# main
##
#
# checking arguments
#
# make sure have enough args to get started or show help
if [ "$#" -lt 1 ]; then
    show_help
    #echo "usage: $0 <script> <sitename - optional> [additional arguments...]"
    #echo "script: review or update"
    exit 0
fi

# set the gen vars
DIR_LIB="./lib"

# set the vars from args
SCRIPT=$1
SITENAME=$2

# check which script to run
case "$SCRIPT" in
    -h|--help)
        show_help
        exit 0
    ;;
    review)
        if [ -z "$SITENAME" ]; then
            # remove vars and pass others off
            shift 1
            "$DIR_LIB/review.sh" "$@"
        else
            # remove vars and pass others off
            shift 2
            "$DIR_LIB/review.sh" "$SITENAME" "$@"
        fi
    ;;
    update)
        if [ -z "$SITENAME" ]; then
            # remove vars and pass others off
            shift 1
            "$DIR_LIB/update.sh" "$@"
        else
            # remove vars and pass others off
            shift 2
            "$DIR_LIB/update.sh" "$SITENAME" "$@"
        fi
    ;;
    *)
        echo "Unknown script: $SCRIPT. Use 'review' or 'update'."
        exit 1
    ;;
esac







# FROM UPDATE.SH
## 
# main
##
main() {
# parse command line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
        ;;
        review)
            if [ -z "$2" ]; then
                "./lib/review.sh" "$@"
                shift
            else
                "./lib/review.sh" "$2" "$@"
                shift
            fi
        ;;
    esac
done
}

main "$@"; exit 0
