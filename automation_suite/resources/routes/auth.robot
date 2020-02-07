*** Settings ***
Resource      ../common.robot
Library       RequestsLibrary 
Library       Collections
Library       JSONLibrary
Library       os


*** Keywords ***
Get response from logging in a valid user @ /api/auth
  [Arguments]   ${email}  ${password}
  ${headers}=   create dictionary  Content-Type=application/json
  ${body}=      create dictionary  email=${email}  password=${password} 
  ${response}=  post request  mysession  /api/auth  data=${body}  headers=${headers}
  [Return]  ${response}