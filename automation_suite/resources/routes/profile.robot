*** Settings ***
Resource  ../common.robot
Library       RequestsLibrary 
Library       Collections
Library       JSONLibrary
Library       os

*** Variables  ***
${endpoint}         /api/profile

*** Keywords ***
Get response from creating a profile @ /api/profile
  [Arguments]   ${headers}  ${status}  ${skills}  
  ${body}=      create dictionary  status=${status}  skills=${skills}
  ${response}=  post request  mysession  /api/profile  data=${body}  headers=${headers}
  [Return]  ${response}