#!/bin/bash
user_search_query(){
    read -p "Please enter a CVE-XXXX-XXXX number for more information: " more_information
    JSON_cve_information_dump

}


JSON_cve_information_dump(){

        more_information=$(curl -s "https://services.nvd.nist.gov/rest/json/cve/1.0/$more_information" | jq . > test_extrap_more_info.txt)

}

user_search_query

bash json_parse_gawk.sh

