#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

echo -e "\u2554\u2550\u2550\u2557"
echo -e "\u2551 FoxHole \u2551"
echo -e "\u255A\u2550\u2550\u255D"

# Prompt the user for an IP address or hostname
echo -e "${BLUE}Enter the IP address or hostname to scan:${NC}"
read TARGET

# Validate the input (basic check for non-empty input)
if [[ -z "$TARGET" ]]; then
  echo -e "${RED}Error: You must enter an IP address or hostname.${NC}"
  exit 1
fi

# Ask the user if they want to scan the full range or specify a custom range
echo -e "${BLUE}Do you want to scan the full range (0-65535) or a custom range?${NC}"
echo -e "${YELLOW}1) Scan full range (0-65535)${NC}"
echo -e "${YELLOW}2) Specify a custom port range${NC}"
read -p "Enter your choice (1 or 2): " CHOICE

# Validate the user's choice
if [[ "$CHOICE" -eq 1 ]]; then
  START_PORT=0
  END_PORT=65535
elif [[ "$CHOICE" -eq 2 ]]; then
  # Ask for the custom range
  echo -e "${YELLOW}Enter the starting port:${NC}"
  read START_PORT
  echo -e "${YELLOW}Enter the ending port:${NC}"
  read END_PORT

  # Validate that the starting port is less than the ending port
  if [[ "$START_PORT" -ge "$END_PORT" ]]; then
    echo -e "${RED}Error: The starting port must be less than the ending port.${NC}"
    exit 1
  fi
else
  echo -e "${RED}Invalid choice. Exiting...${NC}"
  exit 1
fi

# Notify the user that scanning is starting
echo -e "${YELLOW}Sniffin' around on $TARGET...${NC}"

# Perform the port scan based on the user-specified range
for PORT in $(seq $START_PORT $END_PORT); do
  timeout 1 bash -c "</dev/tcp/$TARGET/$PORT &>/dev/null" 2>/dev/null && echo -e "{🦊}${GREEN}port $PORT is open${NC}"
done

# Notify the user when the scan is complete
echo -e "${RED}Scan completed on $TARGET.${NC}"

# Exit the script
exit 0
