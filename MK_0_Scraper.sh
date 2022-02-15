#!/bin/bash

###202202141411 --> Website dump completed
###202202151131 --> Point 2 completed
###202202151154 --> Finished CVE API interaction


### 1. scrape the relevent website --> tick
### 2. clean the output leaving only the raw CVE numbers
### 3. for loop requesting CVE from NVD API


website_dump(){
    curl "https://nvd.nist.gov/" > "output.txt" 
}

raw_CVEs(){
    #website_dump
    cleaned=$(grep -P ">CVE-[[:digit:]]{4}-[0-9]*<" "output.txt" | sed "s/.*\" >//g" | sed "s/<.*//g")
}

request_CVE_NVD_API(){
    raw_CVEs

    for n in $cleaned;do
    curl "https://services.nvd.nist.gov/rest/json/cve/1.0/$n" > "$n.txt"
    sleep 1s
    done

}

request_CVE_NVD_API
