*** Settings ***
Resource  ../common.robot
Library       RequestsLibrary 
Library       Collections
Library       JSONLibrary
Library       os

*** Variables  ***
${endpoint}         /api/profile

*** Keywords ***
Get response from creating a profile with required fields @ /api/profile
  [Arguments]   ${headers}  ${status}  ${skills}  
  ${body}=      create dictionary  status=${status}  skills=${skills}
  ${response}=  post request  mysession  /api/profile  data=${body}  headers=${headers}
  [Return]  ${response}

Get user profile by user id 
  [Arguments]  ${user_id}
  ${response}=  get request  mysession  api/profile/user/${user_id}  
  [Return]  ${response}  
