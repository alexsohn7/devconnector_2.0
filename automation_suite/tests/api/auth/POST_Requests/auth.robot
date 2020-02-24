*** Settings ***
Resource      ../../../../resources/common.robot
Resource      ../../../../resources/routes/auth.robot
Library       RequestsLibrary 
Library       Collections
Library       JSONLibrary
Library       os
Test Setup  create session  mysession  ${base_url}  

*** Test Cases ***
When users log in with correct credentials it should return status code 200 and token
  ${response}=  Get response from logging in a valid user @ /api/auth  email=${email}  password=${password}
  
  # Validations
  ${status_code}=             convert to string              ${response.status_code}
  should be equal             ${status_code}                 200           
  should contain              ${response.content}            token

When user attempts to log in without filling in required email field it should return status code 400 and Please include a valid email error message
  ${response}=  Get response from logging in a valid user @ /api/auth  email=  password=${password}

  ${status_code}=             convert to string               ${response.status_code}
  should be equal             ${status_code}                  400
  ${json_object}=                 to json                     ${response.content}
  ${response_message}=        get value from json             ${json_object}             $.errors[0].msg   
  should be equal              ${response_message[0]}         Please include a valid email

When user attempts to log in without filling in required password field it should return status code 400 and Invalid Credentials error message
  ${response}=  Get response from logging in a valid user @ /api/auth  email=${email}  password=

  ${status_code}=             convert to string               ${response.status_code}
  should be equal             ${status_code}                  400
  ${json_object}=                 to json                     ${response.content}
  ${response_message}=        get value from json             ${json_object}             $.errors[0].msg   
  should be equal              ${response_message[0]}         Invalid Credentials

When user logs in with an email that does not exist it should return status code 400 and Invalid Credentials error message
  ${response}=  Get response from logging in a valid user @ /api/auth  email=${non_existing_email}  password=${password}

  ${status_code}=             convert to string               ${response.status_code}
  should be equal             ${status_code}                  400
  ${json_object}=                 to json                     ${response.content}
  ${response_message}=        get value from json             ${json_object}             $.errors[0].msg   
  should be equal              ${response_message[0]}         Invalid Credentials

When user logs in with an incorrect password it should return status code 400 and Invalid Credentials error message
  ${response}=  Get response from logging in a valid user @ /api/auth  email=${email}  password=${incorrect_password}

  ${status_code}=             convert to string               ${response.status_code}
  should be equal             ${status_code}                  400
  ${json_object}=                 to json                     ${response.content}
  ${response_message}=        get value from json             ${json_object}             $.errors[0].msg   
  should be equal              ${response_message[0]}         Invalid Credentials  