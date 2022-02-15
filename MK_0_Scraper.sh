#!/bin/bash

###202202141411 --> Website dump completed
###202202151131 --> Point 2 completed

### 1. scrape the relevent website --> tick
### 2. clean the output leaving only the raw CVE numbers
###


website_dump(){
    curl "https://nvd.nist.gov/" > "output.txt" 
}

raw_CVEs(){
    #website_dump
    cleaned=$(grep -P ">CVE-[[:digit:]]{4}-[0-9]*<" "output.txt" | sed "s/.*\" >//g" | sed "s/<.*//g")
}


raw_CVEs

for n in $cleaned;do
    echo $n
    sleep 5s
done