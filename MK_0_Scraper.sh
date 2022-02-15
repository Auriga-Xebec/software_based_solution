#!/bin/bash

###202202141411 --> Website dump completed
###202202151131 --> Point 2 completed
###202202151154 --> Finished CVE API interaction
###202202151639 --> Parsing more data fields from the JSON CVE files

### 1. scrape the relevent website --> tick
### 2. clean the output leaving only the raw CVE numbers
### 3. for loop requesting CVE from NVD API
### 4. Scrape a summary of information for each CVE
### 5. awk for each of the above summarys

### current process flow 
### request_CVE_NVD_API --> raw_CVEs --> website_dump

website_dump(){
    curl "https://nvd.nist.gov/" > "output.txt" 
}

raw_CVEs(){
    #website_dump
    cleaned=$(grep -P ">CVE-[[:digit:]]{4}-[0-9]*<" "output.txt" | sed "s/.*\" >//g" | sed "s/<.*//g")
}

request_CVE_NVD_API(){
    raw_CVEs
    mkdir "NewCve"
    for n in $cleaned;do
    curl "https://services.nvd.nist.gov/rest/json/cve/1.0/$n" | jq . >> "NewCve/$n.txt"
    sleep 0.2s
    done
}

tester_looping_files(){
    new_file=$(ls NewCve)

    for i in ${new_file[*]}; do
    cat "NewCve/$i" | jq . >> output2.txt
    done
}

find_CVE_Data(){

   CVE_ID=$(cat "NewCve/CVE-2021-20877.txt" | jq .result.CVE_Items | jq .[0].cve.CVE_data_meta.ID)
   CWE_ID=$(cat "NewCve/CVE-2021-20877.txt" | jq .result.CVE_Items | jq .[0].cve.problemtype.problemtype_data | jq .[0].description | jq .[0].value)
   severity=$(cat "NewCve/CVE-2021-20877.txt" | jq .result.CVE_Items | jq .[0].impact.baseMetricV3.cvssV3.baseSeverity)
   
   for x in {1..100};do
        refrences=$(cat "NewCve/CVE-2021-20877.txt" | jq .result.CVE_Items | jq .[0].cve.references.reference_data | jq .[$x].url)
        if [ "$refrences" = "null" ];then
        break
        fi
        echo "$refrences"
    done

}
find_CVE_Data