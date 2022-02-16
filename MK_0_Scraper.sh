#!/bin/bash

###202202141411 --> Website dump completed
###202202151131 --> Point 2 completed
###202202151154 --> Finished CVE API interaction
###202202151639 --> Parsing more data fields from the JSON CVE files
###202202160735 --> Fixed bug in file loop function
###202202160735 --> Finished the variable scraping from JSON and formatting for awk
###202202160735 --> Modified the awk format file to remove newlines

### 1. scrape the relevent website --> tick
### 2. clean the output leaving only the raw CVE numbers
### 3. for loop requesting CVE from NVD API
### 4. Scrape a summary of information for each CVE
### 5. awk for each of the above summarys -|-> which will be incorpreated with (tester_looping_files) and find_CVE_Data
### 6. Add date function to make new directory per CVE dump......maybe

### current process flow 
### tester_looping_files -calls $1-> find_CVE_Data -calls $1-> pretty_awk_fix --> request_CVE_NVD_API --> raw_CVEs --> website_dump

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
    ### uses the ls function to find the contents of the file just created for housing the CVEs
    ### the output array is used as the iteration for the for loop
    new_file=$(ls NewCve)
    echo "" > "this.txt" ### if the destination file exists clear its contents

    for i in ${new_file[*]}; do
    find_CVE_Data $i
    done
}

find_CVE_Data(){

    #this code will need to loop 20 times, creating an awk formated document for each variable

   refrences=$(grep "\"url\": \"" "NewCve/$1" | awk '{$1=$1};1' | sed 's/.*:/:/g' | sed 's/\",//g')
   CVE_ID=$(cat "NewCve/$1" | jq .result.CVE_Items | jq .[0].cve.CVE_data_meta.ID)
   CWE_ID=$(cat "NewCve/$1" | jq .result.CVE_Items | jq .[0].cve.problemtype.problemtype_data | jq .[0].description | jq .[0].value)
   severity=$(cat "NewCve/$1" | jq .result.CVE_Items | jq .[0].impact.baseMetricV3.cvssV3.baseSeverity)
   

   echo -e "$CVE_ID:$CWE_ID:$severity$refrences" | tr -d '\n' > "format/$CVE_ID-$severity"
   file_format_awk=$CVE_ID-$severity
   pretty_awk_fix "$file_format_awk"
}

pretty_awk_fix(){
awk 'BEGIN { 
      
    FS=":"; 
      
    print "_____________________________________________"; 
      
    print "|\033[34mCVE ID\033[0m               |\033[34mCWE ID\033[0m            | \033[34mSeverity\033[0m                                                    |"; 
      
} 
      
{ 
      
    printf("| %-19s | %-16s | %-60s|\n", $1, $2, $3); 
    printf("| %-100s |\n", $4);
    printf("| %-100s |\n", $5);
    printf("| %-100s |\n", $6);
    printf("| %-100s |\n", $7);
      
} 
      
END { 
      
    print("_____________________________________"); 
      
}' "format/$1"

}

tester_looping_files
              