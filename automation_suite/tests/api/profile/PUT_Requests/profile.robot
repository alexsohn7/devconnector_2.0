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
${title}                  SDET
${company}                Freelance
${location}               Santa Monica, CA
${from}                   8-10-2018
${description}            Freelance automated testing skills

*** Test Cases ***
# When user creates a profile by filling in all required fields it should return the correct response content
#   ${response}=  Get response from logging in a valid user @ /api/auth  email=${email}  password=${password}
#   ${bearer_token}=  Get bearer_token  ${response}
#   ${headers}=  create dictionary  x-auth-token=${bearer_token}  Content-Type=application/json
#   ${body}=     create dictionary  title=${title}  company=${company}  location=${location}  from=${from}  current=true  description=${description}
#   ${response}=  put request  mysession  /api/profile/experience  data=${body}  headers=${headers}
#   ${json_object}=  to json  ${response.content}
#   ${response_experience}=  get value from json  ${json_object}  $.experience[0]
#   ${response_experience}=  set to dictionary  ${response_experience[0]}
#   dictionary should contain value  ${response_experience.values()}  ${title}  ${company}
#   dictionary should contain value  ${response_experience}  ${location}  ${from}
#   dictionary should contain value  ${response_experience}  ${description}    