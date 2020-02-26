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
When the user attempts to gets a user profile by user id it should return a status code 200 and the user profile
  ${response}=  Get response from logging in a valid user @ /api/auth  email=${email}  password=${password}
  ${bearer_token}=  Get bearer_token  ${response}
  ${headers}=  create dictionary  x-auth-token=${bearer_token}  Content-Type=application/json
  ${response}=  Get response from creating a profile with required fields @ /api/profile  ${headers}  status=${request_status}  skills=${request_skills}

  ${json_object}=  to json  ${response.content}
  ${response_user_id}=  get value from json  ${json_object}  $.user
  ${user_id}=  set variable  ${response_user_id[0]}  
  ${response}=  Get user profile by user id  user_id=${user_id}
  ${json_object}=  to json  ${response.content}
  ${user_profile_status}=  get value from json  ${json_object}  $.status
  should be equal  ${user_profile_status[0]}  ${request_status}
  ${user_profile_skills}=  get value from json  ${json_object}  $.skills
  ${user_profile_skills}=  set variable  ${user_profile_skills[0]}
  ${request_skills}=  Split String  ${request_skills}  ,${SPACE}
  list should contain value  ${user_profile_skills}  ${request_skills[0]}  ${request_skills[1]}

When the user attempts to get a user profile by an incorrect user id it should return a status code 400 and Profile not found error message 
  ${response}=  Get response from logging in a valid user @ /api/auth  email=${email}  password=${password}
  ${bearer_token}=  Get bearer_token  ${response}
  ${headers}=  create dictionary  x-auth-token=${bearer_token}  Content-Type=application/json
  ${response}=  Get response from creating a profile with required fields @ /api/profile  ${headers}  status=${request_status}  skills=${request_skills}

  ${json_object}=  to json  ${response.content}
  ${response_user_id}=  get value from json  ${json_object}  $.user
  ${user_id}=  set variable  ${response_user_id[0]}  
  ${response}=  Get user profile by user id  user_id=5e3a8b38f3d2c74306d5eaae
  ${status_code}=             convert to string               ${response.status_code}
  should be equal             ${status_code}                  400
  ${json_object}=                 to json                     ${response.content}
  ${response_message}=        get value from json             ${json_object}      $.msg
  should be equal              ${response_message[0]}         Profile not found

When the user attempts to get a user profile by an invalid user id it should return a status code 400 and Profile not found error message 
  ${response}=  Get response from logging in a valid user @ /api/auth  email=${email}  password=${password}
  ${bearer_token}=  Get bearer_token  ${response}
  ${headers}=  create dictionary  x-auth-token=${bearer_token}  Content-Type=application/json
  ${response}=  Get response from creating a profile with required fields @ /api/profile  ${headers}  status=${request_status}  skills=${request_skills}

  ${json_object}=  to json  ${response.content}
  ${response_user_id}=  get value from json  ${json_object}  $.user
  ${user_id}=  set variable  ${response_user_id[0]}  
  ${response}=  Get user profile by user id  user_id=invalid user id
  ${status_code}=             convert to string               ${response.status_code}
  should be equal             ${status_code}                  400
  ${json_object}=                 to json                     ${response.content}
  ${response_message}=        get value from json             ${json_object}      $.msg
  should be equal              ${response_message[0]}         Profile not found