#!/bin/bash

### colouring now matches the same as aus cyber scrape

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
    cleaned_severity=($(grep -P ">[0-9]\.[0-9] [A-ZS]*</a><br/>" "output.txt"| sed "s/.*\">//g" | sed "s/<.*//g" | sed 's/[0-9]\.[0-9] //g'))

    for x in "${!cleaned_severity[@]}"; do
    if [ ${cleaned_severity[$x]} = "CRITICAL" ];then
        cleaned_severity[$x]=$(echo -e "\033[31mCRITICAL\e[0m")
    elif [ ${cleaned_severity[$x]} = "HIGH" ];then
        cleaned_severity[$x]=$(echo -e "\033[35mHIGH\e[0m")
    elif [ ${cleaned_severity[$x]} = "MEDIUM" ];then
        cleaned_severity[$x]=$(echo -e "\033[33mMEDIUM\e[0m")
    elif [ ${cleaned_severity[$x]} = "LOW" ];then
        cleaned_severity[$x]=$(echo -e "\033[32mLOW\e[0m")
    fi
    done

    



    IFS=${IFS_BAK}
    
    for x in ${!cleaned_CVE[@]};do
    echo -e "    ==========================================================
    | $x | ${cleaned_CVE[$x]} | ${cleaned_Published[$x]}
    | ${cleaned_severity[$x]} |
    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    done
    
    read -p "Please enter a number for further information or ENTER to exit: " selection
}


cve_more_information(){
    raw_CVEs
    case "$selection" in
    0 | ${cleaned_CVE[0]} ) more_information=(${cleaned_CVE[0]}) ;;
    1 | ${cleaned_CVE[1]} ) more_information=(${cleaned_CVE[1]}) ;;
    2 | ${cleaned_CVE[2]} ) more_information=(${cleaned_CVE[2]}) ;;
    3 | ${cleaned_CVE[3]} ) more_information=(${cleaned_CVE[3]}) ;;
    4 | ${cleaned_CVE[4]} ) more_information=(${cleaned_CVE[4]}) ;;
    5 | ${cleaned_CVE[5]} ) more_information=(${cleaned_CVE[5]}) ;;
    6 | ${cleaned_CVE[6]} ) more_information=(${cleaned_CVE[6]}) ;;
    7 | ${cleaned_CVE[7]} ) more_information=(${cleaned_CVE[7]}) ;;
    8 | ${cleaned_CVE[8]} ) more_information=(${cleaned_CVE[8]}) ;;
    9 | ${cleaned_CVE[9]} ) more_information=(${cleaned_CVE[9]}) ;;
    10 | ${cleaned_CVE[10]} ) more_information=(${cleaned_CVE[10]}) ;;
    11 | ${cleaned_CVE[11]} ) more_information=(${cleaned_CVE[11]}) ;;
    12 | ${cleaned_CVE[12]} ) more_information=(${cleaned_CVE[12]}) ;;
    13 | ${cleaned_CVE[13]} ) more_information=(${cleaned_CVE[13]}) ;;
    14 | ${cleaned_CVE[14]} ) more_information=(${cleaned_CVE[14]}) ;;
    15 | ${cleaned_CVE[15]} ) more_information=(${cleaned_CVE[15]}) ;;
    16 | ${cleaned_CVE[16]} ) more_information=(${cleaned_CVE[16]}) ;;
    17 | ${cleaned_CVE[17]} ) more_information=(${cleaned_CVE[17]}) ;;
    18 | ${cleaned_CVE[18]} ) more_information=(${cleaned_CVE[18]}) ;;
    19 | ${cleaned_CVE[19]} )  more_information=(${cleaned_CVE[19]}) ;;
    CVE-[0-9]*-[0-9]*)  more_information=($selection) ;;
    * )  more_information="Good bye" ;;

    esac

}

JSON_cve_information_dump(){
    cve_more_information
    if [ "$more_information" = "Good bye" ]; then
        echo
    else
        #more_information=$(curl -s "https://services.nvd.nist.gov/rest/json/cve/1.0/$more_information" | jq .)
        #echo $more_information
        curl -s "https://services.nvd.nist.gov/rest/json/cve/1.0/$more_information" | jq . > test_extrap_more_info.txt

        
    fi

}
#JSON_cve_information_dump


CVE_ID=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].cve.CVE_data_meta.ID | sed 's/"//g')
CVE_Assigner=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].cve.CVE_data_meta.ASSIGNER | sed 's/"//g')
CVE_description=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].cve.description.description_data | jq .[0].value | sed 's/"//g')
CVE_CWE=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].cve.problemtype.problemtype_data | jq .[0].description | jq .[0].value | sed 's/"//g')
CVE_refs=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].cve.references.reference_data | sed 's/"//g')
        


echo $CVE_refs
