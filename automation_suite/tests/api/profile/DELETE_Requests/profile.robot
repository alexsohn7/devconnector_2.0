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
${to_be_deleted_skills}         Developer
${to_be_deleted_status}         PHP, SQL 

*** Test Cases ***
When user registers, creates a profile, deletes the profile, and looks up all profiles, it should ensure that the user and the profile no longer exists
  ${headers}=   create dictionary  Content-Type=application/json
  ${body}=      create dictionary  name=${to_be_deleted_name}  email=${to_be_deleted_email}  password=${to_be_deleted_password} 
  ${response}=  post request  mysession  /api/users  data=${body}  headers=${headers}
  ${bearer_token}=  Get bearer_token  ${response}
  ${headers}=  create dictionary  x-auth-token=${bearer_token}  Content-Type=application/json
  ${response}=  Get response from creating a profile with required fields @ /api/profile  ${headers}  status=${to_be_deleted_status}  skills=${to_be_deleted_skills}
  ${json_object}=  to json  ${response.content}
  ${response}=  delete request  mysession  /api/profile  headers=${headers}
  ${status_code}=             convert to string                  ${response.status_code}
  should be equal             ${status_code}                     200
  ${json_object}=             to json                            ${response.content}
  ${response_message}=        get value from json                ${json_object}             $.msg
  should be equal             ${response_message[0]}             User deleted
  ${response}=  get request  mysession  /api/profile
  ${all_user_profiles}=  set variable  ${response.content}
  should not contain  ${all_user_profiles}  ${to_be_deleted_name}  ${to_be_deleted_skills}  ${to_be_deleted_status}