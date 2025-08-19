#!/bin/bash

# AutoScriptX Enhanced Menu
# Version: 2.0
# Enhanced with better UI and improved functionality

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Function to display error messages
display_error() {
  echo -e "${RED}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${RED}║                                    ERROR                                     ║${NC}"
  echo -e "${RED}║                                                                              ║${NC}"
  echo -e "${RED}║  🚫 $1${NC}"
  echo -e "${RED}║                                                                              ║${NC}"
  echo -e "${RED}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
}

# Function to display success messages
display_success() {
  echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${GREEN}║                                   SUCCESS                                    ║${NC}"
  echo -e "${GREEN}║                                                                              ║${NC}"
  echo -e "${GREEN}║  ✅ $1${NC}"
  echo -e "${GREEN}║                                                                              ║${NC}"
  echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
}

# Check for root privileges
check_root() {
  if [ "$(id -u)" -ne 0 ]; then
    display_error "PLEASE RUN THIS SCRIPT AS ROOT USER!"
    exit 1
  fi
}

# Function to get system information
get_system_info() {
  os_name=$(hostnamectl | grep 'Operating System' | cut -d ':' -f2- | xargs)
  uptime=$(uptime -p | cut -d " " -f 2-10)
  public_ip=$(curl -s ifconfig.me 2>/dev/null || echo "UNAVAILABLE")
  vps_domain=$(cat /etc/AutoScriptX/domain 2>/dev/null || echo "NOT SET")
  used_ram=$(free -m | awk 'NR==2 {print $3}')
  total_ram=$(free -m | awk 'NR==2 {print $2}')
  cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
  disk_usage=$(df -h / | awk 'NR==2 {print $5}')
}

# Function to display animated header
display_animated_header() {
  clear
  echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${CYAN}║                                                                              ║${NC}"
  echo -e "${CYAN}║${WHITE}    ██████╗ ██╗   ██╗████████╗ ██████╗ ███████╗ ██████╗██████╗ ██╗██████╗ ████████╗${CYAN}║${NC}"
  echo -e "${CYAN}║${WHITE}   ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝██╔════╝██╔══██╗██║██╔══██╗╚══██╔══╝${CYAN}║${NC}"
  echo -e "${CYAN}║${WHITE}   ███████║██║   ██║   ██║   ██║   ██║███████╗██║     ██████╔╝██║██████╔╝   ██║   ${CYAN}║${NC}"
  echo -e "${CYAN}║${WHITE}   ██╔══██║██║   ██║   ██║   ██║   ██║╚════██║██║     ██╔══██╗██║██╔═══╝    ██║   ${CYAN}║${NC}"
  echo -e "${CYAN}║${WHITE}   ██║  ██║╚██████╔╝   ██║   ╚██████╔╝███████║╚██████╗██║  ██║██║██║        ██║   ${CYAN}║${NC}"
  echo -e "${CYAN}║${WHITE}   ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝ ╚══════╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝        ╚═╝   ${CYAN}║${NC}"
  echo -e "${CYAN}║                                                                              ║${NC}"
  echo -e "${CYAN}║${YELLOW}                           🚀 VPS MANAGEMENT SYSTEM 🚀                        ${CYAN}║${NC}"
  echo -e "${CYAN}║                                                                              ║${NC}"
  echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
  echo ""
}

# Function to display system information
display_system_info() {
  echo -e "${BLUE}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BLUE}║${WHITE}                              SYSTEM INFORMATION                             ${BLUE}║${NC}"
  echo -e "${BLUE}╠══════════════════════════════════════════════════════════════════════════════╣${NC}"
  echo -e "${BLUE}║                                                                              ║${NC}"
  echo -e "${BLUE}║${WHITE}  🖥️  OPERATING SYSTEM    : ${GREEN}$os_name${BLUE}║${NC}"
  echo -e "${BLUE}║${WHITE}  ⏰  SYSTEM UPTIME       : ${GREEN}$uptime${BLUE}║${NC}"
  echo -e "${BLUE}║${WHITE}  🌐  PUBLIC IP ADDRESS   : ${GREEN}$public_ip${BLUE}║${NC}"
  echo -e "${BLUE}║${WHITE}  🔗  DOMAIN NAME         : ${GREEN}$vps_domain${BLUE}║${NC}"
  echo -e "${BLUE}║${WHITE}  💾  RAM USAGE           : ${GREEN}${used_ram}MB / ${total_ram}MB${BLUE}║${NC}"
  echo -e "${BLUE}║${WHITE}  🔥  CPU USAGE           : ${GREEN}$cpu_usage${BLUE}║${NC}"
  echo -e "${BLUE}║${WHITE}  💿  DISK USAGE          : ${GREEN}$disk_usage${BLUE}║${NC}"
  echo -e "${BLUE}║                                                                              ║${NC}"
  echo -e "${BLUE}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
  echo ""
}

# Function to display main menu
display_main_menu() {
  echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${PURPLE}║${WHITE}                                 MAIN MENU                                   ${PURPLE}║${NC}"
  echo -e "${PURPLE}╠══════════════════════════════════════════════════════════════════════════════╣${NC}"
  echo -e "${PURPLE}║                                                                              ║${NC}"
  echo -e "${PURPLE}║${WHITE}  [1] 👤  CREATE NEW ACCOUNT                                              ${PURPLE}║${NC}"
  echo -e "${PURPLE}║${WHITE}  [2] 🗑️   DELETE ACCOUNT                                                  ${PURPLE}║${NC}"
  echo -e "${PURPLE}║${WHITE}  [3] 🔄  RENEW ACCOUNT                                                   ${PURPLE}║${NC}"
  echo -e "${PURPLE}║${WHITE}  [4] 🔒  LOCK/UNLOCK ACCOUNT                                             ${PURPLE}║${NC}"
  echo -e "${PURPLE}║${WHITE}  [5] 📝  EDIT BANNER MESSAGE                                             ${PURPLE}║${NC}"
  echo -e "${PURPLE}║${WHITE}  [6] ⚙️   EDIT 101 RESPONSE                                               ${PURPLE}║${NC}"
  echo -e "${PURPLE}║${WHITE}  [7] 🌐  CHANGE DOMAIN                                                   ${PURPLE}║${NC}"
  echo -e "${PURPLE}║${WHITE}  [8] 🔧  MANAGE SERVICES                                                 ${PURPLE}║${NC}"
  echo -e "${PURPLE}║${WHITE}  [9] 📊  SYSTEM INFORMATION                                              ${PURPLE}║${NC}"
  echo -e "${PURPLE}║${WHITE}  [0] ❌  EXIT PROGRAM                                                     ${PURPLE}║${NC}"
  echo -e "${PURPLE}║                                                                              ║${NC}"
  echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
  echo ""
}

# Function to get user choice
get_user_choice() {
  echo -e "${YELLOW}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${YELLOW}║${WHITE}                            PLEASE SELECT AN OPTION                          ${YELLOW}║${NC}"
  echo -e "${YELLOW}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
  echo -n -e "${WHITE}ENTER YOUR CHOICE [0-9]: ${NC}"
  read choice
  echo ""
}

# Function to handle menu selection
handle_menu_selection() {
  case $choice in
    1)
      display_success "LAUNCHING CREATE ACCOUNT MODULE..."
      sleep 1
      create-account
      ;;
    2)
      display_success "LAUNCHING DELETE ACCOUNT MODULE..."
      sleep 1
      delete-account
      ;;
    3)
      display_success "LAUNCHING RENEW ACCOUNT MODULE..."
      sleep 1
      renew-account
      ;;
    4)
      display_success "LAUNCHING LOCK/UNLOCK MODULE..."
      sleep 1
      lock-unlock
      ;;
    5)
      display_success "LAUNCHING BANNER EDITOR..."
      sleep 1
      edit-banner
      ;;
    6)
      display_success "LAUNCHING RESPONSE EDITOR..."
      sleep 1
      edit-response
      ;;
    7)
      display_success "LAUNCHING DOMAIN CHANGER..."
      sleep 1
      change-domain
      ;;
    8)
      display_success "LAUNCHING SERVICE MANAGER..."
      sleep 1
      manage-services
      ;;
    9)
      display_success "LAUNCHING SYSTEM INFO..."
      sleep 1
      system-info
      ;;
    0)
      echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
      echo -e "${GREEN}║${WHITE}                              GOODBYE!                                       ${GREEN}║${NC}"
      echo -e "${GREEN}║${WHITE}                    THANK YOU FOR USING AUTOSCRIPTX                         ${GREEN}║${NC}"
      echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
      exit 0
      ;;
    *)
      display_error "INVALID OPTION! PLEASE SELECT A NUMBER BETWEEN 0-9"
      sleep 2
      main_menu
      ;;
  esac
}

# Main menu function
main_menu() {
  check_root
  get_system_info
  display_animated_header
  display_system_info
  display_main_menu
  get_user_choice
  handle_menu_selection
}

# Start the program
main_menu

