*** Settings ***
Resource      ../../../../resources/common.robot
Resource      ../../../../resources/routes/auth.robot
Library       RequestsLibrary 
Library       Collections
Library       JSONLibrary
Library       os
Test Setup  create session  mysession  ${base_url} 

*** Test Cases ***
Get correct name and email of logged in user
  ${response}=  Get response from logging in a valid user @ /api/auth  email=${email}  password=${password}
  ${bearer_token}=  Get bearer_token  ${response}
  ${headers}=  create dictionary  x-auth-token=${bearer_token}  Content-Type=application/json
  ${response}=  get request  mysession  /api/auth  headers=${headers}
  ${json_object}=                 to json                        ${response.content}

  # Validation
  ${login_page_name}=            get value from json            ${json_object}          $.name
  ${name}=  convert to string  ${name}
  should be equal  ${login_page_name[0]}   ${name}
  ${login_page_email}=            get value from json            ${json_object}          $.email
  ${email}=  convert to string  ${email}
  should be equal  ${login_page_email[0]}   ${email}

Return token is not valid and status code 401 when logging in with incorrect password
  ${response}=  Get response from logging in a valid user @ /api/auth  email=${email}  password=${password}
  ${bearer_token}=  Get bearer_token  ${response}
  ${headers}=  create dictionary  x-auth-token=${bearer_token}asdf  Content-Type=application/json
  ${response}=  get request  mysession  /api/auth  headers=${headers}

# Validations 
  ${status_code}=             convert to string                  ${response.status_code}
  should be equal             ${status_code}                     401
  ${json_object}=             to json                            ${response.content}
  ${response_message}=        get value from json                ${json_object}             $.msg
  should be equal             ${response_message[0]}             Token is not valid

Return No token, authorization denied when logging in with non-registered user
  ${response}=  Get response from logging in a valid user @ /api/auth  email=${email}  password=${password}
  ${headers}=  create dictionary  Content-Type=application/json
  ${response}=  get request  mysession  /api/auth  headers=${headers}
  ${json_object}=                 to json                        ${response.content}

  # Validation
  ${status_code}=             convert to string                  ${response.status_code}
  should be equal             ${status_code}                     401
  ${json_object}=             to json                            ${response.content}
  ${response_message}=        get value from json                ${json_object}             $.msg
  should be equal             ${response_message[0]}             No token, authorization denied