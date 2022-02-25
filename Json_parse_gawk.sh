#!/bin/bash

JSON_Parse(){
CVE_ID=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].cve.CVE_data_meta.ID | sed 's/"//g')
CVE_Assigner=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].cve.CVE_data_meta.ASSIGNER | sed 's/"//g')
CVE_description=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].cve.description.description_data | jq .[0].value | sed 's/"//g')
CVE_CWE=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].cve.problemtype.problemtype_data | jq .[0].description | jq .[0].value | sed 's/"//g')
CVE_refs=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].cve.references.reference_data | sed 's/"//g')

impact_vectorString=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].impact.baseMetricV3.cvssV3.vectorString | sed 's/"//g')
impact_attackVector=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].impact.baseMetricV3.cvssV3.attackVector | sed 's/"//g' ) 
impact_attackComplexity=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].impact.baseMetricV3.cvssV3.attackComplexity | sed 's/"//g') 
impact_privilegesRequired=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].impact.baseMetricV3.cvssV3.privilegesRequired | sed 's/"//g') 
impact_userInteraction=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].impact.baseMetricV3.cvssV3.userInteraction | sed 's/"//g') 

impact_confidentialityImpact=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].impact.baseMetricV3.cvssV3.confidentialityImpact | sed 's/"//g') 
impact_integrityImpact=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].impact.baseMetricV3.cvssV3.integrityImpact | sed 's/"//g') 
impact_availabilityImpact=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].impact.baseMetricV3.cvssV3.availabilityImpact | sed 's/"//g') 

baseSeverity=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].impact.baseMetricV3.cvssV3.baseSeverity | sed 's/"//g') 

publishedDate=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].publishedDate | sed 's/[A-Z]/ /g' | sed 's/"//g')
lastModifiedDate=$(cat "test_extrap_more_info.txt" | jq .result.CVE_Items | jq .[0].lastModifiedDate | sed 's/[A-Z]/ /g' | sed 's/"//g') 

echo "$CVE_ID
$CVE_Assigner
$CVE_CWE
$impact_vectorString
$impact_attackVector
$impact_attackComplexity
$impact_privilegesRequired
$impact_userInteraction
$impact_confidentialityImpact
$impact_integrityImpact
$impact_availabilityImpact
$baseSeverity
$publishedDate
$lastModifiedDate
$CVE_description" > JSON_parsed.txt

gawked

}



gawked(){

gawk 'BEGIN {RS = "" ; FS = "\n" ; OFS = "\t"} {print $1,$2,$3,$12,$4"\n"}
{print "Description:\n"$15"\n"}
{print "Attack vector = " $5}
{print "Attack complexity = " $6}
{print "Privledges required = " $7}
{print "User interaction = " $8 "\n"}
{print "Confidentiality Impact = " $9}
{print "Integrity Impact = " $10}
{print "Availability Impact = " $11 "\n"}
{print "Published = " $13} 
{print "Last Modified = " $14}' JSON_parsed.txt

clean_up

}

clean_up(){
    
    if [ -f "JSON_parsed.txt" ];then
        rm 'JSON_parsed.txt'
    fi    

    if [ -f "test_extrap_more_info.txt" ];then
        rm 'test_extrap_more_info.txt'
    fi

    if [ -f "output.txt" ];then
        rm 'output.txt'
    fi

}

JSON_Parse