*** Settings ***
Resource      ../../../../resources/common.robot
Resource      ../../../../resources/routes/auth.robot
Resource      ../../../../resources/routes/profile.robot
Library       RequestsLibrary 
Library       Collections
Library       String
Library       JSONLibrary
Library       os
Test Setup  create session  mysession  ${base_url} 

*** Variables  ***
${request_status}         QA Automation Engineer
${request_skills}         Javascript, Python

*** Test Cases ***
When user creates a profile by filling in all required fields it should return the correct response content
  ${response}=  Get response from logging in a valid user @ /api/auth  email=${email}  password=${password}
    ${bearer_token}=  Get bearer_token  ${response}
    ${headers}=  create dictionary  x-auth-token=${bearer_token}  Content-Type=application/json
    ${response}=  Get response from creating a profile with required fields @ /api/profile  ${headers}  ${request_status}  ${request_skills}

    ${json_object}=  to json  ${response.content}
    ${response_status}=  get value from json  ${json_object}  $.status
    ${response_skills}=  get value from json  ${json_object}  $.skills
    ${response_skills}=  set variable  ${response_skills[0]} 
    ${request_skills}=  Split String  ${request_skills}  ,${SPACE} 
    list should contain value  ${response_skills}  ${request_skills[0]}  ${request_skills[1]}
      
