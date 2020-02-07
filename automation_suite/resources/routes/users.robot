*** Settings ***
Resource  ../common.robot
Library       RequestsLibrary 
Library       Collections
Library       JSONLibrary
Library       os

*** Variables  ***
${endpoint}         /api/users

*** Keywords ***
Get response from registering a new user @ /api/users
  [Arguments]   ${name}  ${email}  ${password}
  ${headers}=   create dictionary  Content-Type=application/json
  ${body}=      create dictionary  name=${name}  email=${email}  password=${password} 
  ${response}=  post request  mysession  /api/users  data=${body}  headers=${headers}
  [Return]  ${response}