#!/bin/bash

website_dump(){
    curl "https://nvd.nist.gov/" > "output.txt"
}

raw_CVEs(){
    IFS_BAK=${IFS} 
    IFS="
"
    #website_dump
    cleaned_CVE=($(grep -P ">CVE-[[:digit:]]{4}-[0-9]*<" "output.txt" | sed "s/.*\" >//g" | sed "s/<.*//g"))
    cleaned_Published=($(grep -P "\d*:\d*:\d*" "output.txt" | awk '{$1=$1};NF'))
    for x in ${!cleaned_CVE[@]};do
    echo -e "    ==========================================================
    | $x | ${cleaned_CVE[$x]} | ${cleaned_Published[$x]}
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    done
    IFS=${IFS_BAK}
    read -p "Please enter a number for further information: " selection
}


cve_more_information(){
    raw_CVEs
    case "$selection" in
    0) echo ${cleaned_CVE[0]} ;;
    1) echo ${cleaned_CVE[1]} ;;
    2) echo ${cleaned_CVE[2]} ;;
    3) echo ${cleaned_CVE[3]} ;;
    4) echo ${cleaned_CVE[4]} ;;
    5) echo ${cleaned_CVE[5]} ;;
    6) echo ${cleaned_CVE[6]} ;;
    7) echo ${cleaned_CVE[7]} ;;
    8) echo ${cleaned_CVE[8]} ;;
    9) echo ${cleaned_CVE[9]} ;;
    10) echo ${cleaned_CVE[10]} ;;
    11) echo ${cleaned_CVE[11]} ;;
    12) echo ${cleaned_CVE[12]} ;;
    13) echo ${cleaned_CVE[13]} ;;
    14) echo ${cleaned_CVE[14]} ;;
    15) echo ${cleaned_CVE[15]} ;;
    16) echo ${cleaned_CVE[16]} ;;
    17) echo ${cleaned_CVE[17]} ;;
    18) echo ${cleaned_CVE[18]} ;;
    19) echo ${cleaned_CVE[19]} ;;
    *) echo "Pick a number 1-19" ;;
    

    esac

}
cve_more_information