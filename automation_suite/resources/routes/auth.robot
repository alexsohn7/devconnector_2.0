*** Settings ***
Resource      ../common.robot
Library       RequestsLibrary 
Library       Collections
Library       JSONLibrary
Library       os

*** Variables ***
${endpoint}         /api/auth

*** Keywords ***
Get response from logging in a valid user @ /api/auth
  [Arguments]   ${email}  ${password}
  ${headers}=   create dictionary  Content-Type=application/json
  ${body}=      create dictionary  email=${email}  password=${password} 
  ${response}=  post request  mysession  ${endpoint}  data=${body}  headers=${headers}
  [Return]  ${response}

Get bearer_token
  [Arguments]  ${response}
  ${json_object}=                 to json                        ${response.content}
  ${bearer_token}=            get value from json            ${json_object}          $.token
  [return]  ${bearer_token[0]}