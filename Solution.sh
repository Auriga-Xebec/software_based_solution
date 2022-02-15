#!/bin/bash

#wget   https://services.nvd.nist.gov/rest/json/cves/1.0?cvssV3Metrics=S:U/AV:N/AC:L/PR:H/UI:N/C:L/I:R/A:R/E:F/RL:X/CR:H/IR:H/AR:H/cvssV3Severity=CRITICAL 


#cpeMatchString 
get_critical_API_NVD(){
    curl https://services.nvd.nist.gov/rest/json/cves/1.0/\?cvssV3Severity=CRITICAL | jq . > critical.txt
}

parse_cwe_JSON(){
    for n in {0..19};do
        latest_cwe=$(jq .result.CVE_Items critical.txt | jq .[$n].cve.problemtype.problemtype_data | jq .[0].description | jq '.[0].value')
        echo $latest_cwe
    done
}

parse_cve_JSON(){
    for n in {0..19};do
        latest_cve=$(jq .result.CVE_Items critical.txt | jq .[$n].cve.CVE_data_meta.ID)
        echo $latest_cve
    done
}

parse_description_JSON(){
    for n in {0..19};do
        description_JSON=$(jq .result.CVE_Items critical.txt |  jq .[$n].cve.description.description_data | jq .[0].value)

        echo -e  $description_JSON "\n"
    done
}

get_latest_CVEs(){
    now=$(date +'%d/%m/%Y')
    year=$(date +'%Y')
    month=$(date +'%m')
    day=$(date +'%d')
    last_week=$(expr $day - 1)
    if [[ $last_week -le 0 ]];then 
        last_week=1
    fi
    if [[ $last_week -lt 10 ]];then
    last_week=0$last_week
    fi




    #echo "$year is the year"
    #echo "$month is the month"
    #echo "$day is the day"
    #echo "$last_week is the day last week"
    #url="https://services.nvd.nist.gov/rest/json/cves/1.0/?PubStartDate=$year-$month-$day\T00:00:00:000+UTC%2B01:00\&PubEndDate=$year-$month-$day\T23:59:00:000+UTC-05:00&resultsPerPage=200"
    #echo $url
    #curl https://services.nvd.nist.gov/rest/json/cves/1.0/?PubStartDate=$year-$month-$day\T00:00:00:000+UTC%2B08:00\&PubEndDate=$year-$month-$day\T23:59:00:000+UTC%2B08:00\&resultsPerPage=1 | jq . > tester.txt
    #curl https://services.nvd.nist.gov/rest/json/cves/1.0/?PubStartDate=2021-02-13\&PubEndDate=2022-02-13\&resultsPerPage=1 | jq . > tester1.txt

}



#wget https://nvd.nist.gov/ tester1.txt

#curl https://services.nvd.nist.gov/rest/json/cves/1.0/?modStartDate=2021-08-04T13:00:00:000+UTC%2B01:00\&modEndDate=2021-10-22T13:36:00:000+UTC%2B01:00 | jq . > tester.txt
#for n in {0..19};do

    #latest_cve=
    
    # latest_cwe_sed=$(jq .result.CVE_Items critical.txt |  jq .[$n]  | sed -ne '/\"value\": \"CWE-.*\"/ { 
    #    s/"value":// 
    #    P 
    #    }')
    #latest_description_sed=$(jq .result.CVE_Items critical.txt |  jq .[$n]  | sed -ne '/\"value\":
    #cwe_values=(grep $latest_description '\"value\" \: \"CWE-.*\"') #.description.description_data | jq .[0].value )
    #echo $latest_cve
    #echo $latest_description_sed
    #echo "$cwe_values"

#done

this=$(<this.txt)
array=()

for n in $this ;do
    array[${#array[@]}]="$n"
done
for index in $array ;do
    echo $index
done