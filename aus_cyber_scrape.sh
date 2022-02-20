#!/bin/bash

### can I save this to a variable then call grep on it, to save the unessasary use of files, or maybe use a tempoary file.
raw_html=$(curl "https://www.cyber.gov.au/acsc/view-all-content/alerts")

scrape_HTML(){
alert_date=($(echo "$raw_html" | grep  "<p class=\"acsc-date\">" | sed 's/.*e\">//' | sed 's/ -.*//' | sed 's/ /-/g' )) ### date of the alert.
alert_severity=($(echo "$raw_html" | grep  "<p class=\"acsc-date\">" | sed 's/.*alert-//' | sed 's/">.*//')) ### severity of the alert.
IFS_BAK=${IFS} 
### change the defualt field separator to a newline
IFS="
"
alert_summary=($(echo "$raw_html" | grep   "<p class=\"acsc-summary\">" | sed 's/.*y">//g' | sed 's/<\/p>//g')) ### Summary of the alert.
alert_elaboration=($(echo "$raw_html" | grep   "<p class=\"acsc-title\">" | sed 's/.*e">//g' | sed 's/<\/p>//g'))
alert_elaboration_url=($(echo "$raw_html" | grep   "<p class=\"acsc-title\">" | sed 's/.*e">//g' | sed 's/<\/p>//g' | sed 's/ /-/g'))

for x in "${!alert_date[@]}"; do
if [ ${alert_severity[$x]} = "CRITICAL" ];then
    alert_severity[$x]=$(echo -e "\033[31mCRITICAL\e[0m")
elif [ ${alert_severity[$x]} = "HIGH" ];then
    alert_severity[$x]=$(echo -e "\033[35mHIGH\e[0m")
elif [ ${alert_severity[$x]} = "MEDIUM" ];then
    alert_severity[$x]=$(echo -e "\033[33mMEDIUM\e[0m")
elif [ ${alert_severity[$x]} = "LOW" ];then
    alert_severity[$x]=$(echo -e "\033[32mLOW\e[0m")
fi
alert_summary[$x]=$(echo -e "\033[34m${alert_summary[$x]}\e[0m")
echo -e "
___________________________________________________________________\n       
${alert_date[$x]} | ${alert_severity[$x]} | ${alert_elaboration[$x]} 
___________________________________________________________________\n
${alert_summary[$x]}\n
https://www.cyber.gov.au/acsc/view-all-content/alerts/${alert_elaboration_url[$x]}
===================================================================\n"

done
### change the default field separator back to a space
IFS=${IFS_BAK}

}
 
scrape_HTML