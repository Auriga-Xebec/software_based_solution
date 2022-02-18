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
        echo "you have selected option 1"
    ;;
    2 )
        echo "you have selected option 2"
    ;;
    3 )
        echo "you have selected option 3"
    ;;
    4 )
        echo "you have selected option 4"
        break 
    ;;
    * )
        echo "Failed to select 1-4"
    ;;
esac


done