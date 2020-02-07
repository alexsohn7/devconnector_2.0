*** Settings ***
Library       RequestsLibrary 
Library       Collections
Library       JSONLibrary
Library       os

*** Variables ***
${base_url}                   http://localhost:5000
${name}                       james
${email}                      jameshyun67@gmail.com
${password}                   littleman
${bearer_token}  None  

*** Keywords ***
Get bearer_token
  [Arguments]  ${response}
  ${json_object}=                 to json                        ${response.content}
  ${bearer_token}=            get value from json            ${json_object}          $.token
  ${bearer_token}=            Set global variable            ${bearer_token[0]}