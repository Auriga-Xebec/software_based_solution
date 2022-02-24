#!/bin/bash

### this will be the menu for the software based soluton

while true; do
echo -e "1) Scrape Aus Cyber for latest threats
2) Scrape NVD for the 20 latest scored CVEs
3) Search for a CVE summary
4) Exit"

read selection

case "$selection" in

    1 )
        bash aus_cyber_scrape.sh
    ;;
    2 )
        bash ame_nvd_scraper.sh
    ;;
    3 )
        echo "Pleas"
    ;;
    4 )
        echo "Exit"
        break 
    ;;
    * )
        echo "Failed to select 1-4"
    ;;
esac


done