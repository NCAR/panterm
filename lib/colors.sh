#!/bin/bash

# colors.sh
#
# file to hold the output colors#
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

# printing in color examples
# echo -e "${RED}This text is red${NC}"
# echo -e "${GREEN}This text is green${NC}"
# echo -e "${YELLOW}This text is yellow${NC}"
# echo -e "${BLUE}This text is blue${NC}"