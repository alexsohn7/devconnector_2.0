*** Settings ***
Resource      ../../../../resources/common.robot
Resource      ../../../../resources/routes/users.robot
Library       RequestsLibrary 
Library       Collections
Library       JSONLibrary
Library       os
Test Setup  create session  mysession  ${base_url}

*** Test Cases ***
Registering a unique email address should return a status code 200  
  ${response}=  Get response from registering a new user @ /api/users  name=${name}  email=${email}  password=${password}

  # Validations 
  ${status_code}=             convert to string              ${response.status_code}
  should be equal             ${status_code}                 200  

Registering a user with an email that already exists should return a status code 400 and user already exists error message 
  ${response}=  Get response from registering a new user @ /api/users  name=${name}  email=${email}  password=${password}

  # Validations 
  ${status_code}=             convert to string              ${response.status_code}
  should be equal             ${status_code}                 400
  ${json_object}=                 to json                        ${response.content}
  ${response_message}=        get value from json                ${json_object}             $.errors[0].msg   
  should contain  ${response_message}  User already exists

Registering a user without filling in email field should return a status code 400 and Please include a valid email error message
  ${response}=  Get response from registering a new user @ /api/users  name=${name}  email=  password=${password}

  # Validations 
  ${status_code}=             convert to string              ${response.status_code}
  should be equal             ${status_code}                 400
  ${json_object}=                 to json                        ${response.content}
  ${response_message}=        get value from json                ${json_object}             $.errors[0].msg   
  should contain  ${response_message}  Please include a valid email

Registering a user without filling in password field should return a status code 400 and Please enter a password with 6 or more characters error message
  ${response}=  Get response from registering a new user @ /api/users  name=${name}  email=${email}  password=

  # Validations 
  ${status_code}=             convert to string              ${response.status_code}
  should be equal             ${status_code}                 400
  ${json_object}=                 to json                        ${response.content}
  ${response_message}=        get value from json                ${json_object}             $.errors[0].msg   
  should contain  ${response_message}  Please enter a password with 6 or more characters                

Registering a user without filling in name field should return a status code 400 and Name is required error message
  ${response}=  Get response from registering a new user @ /api/users  name=  email=${email}  password=${password}

  # Validations 
  ${status_code}=             convert to string              ${response.status_code}
  should be equal             ${status_code}                 400
  ${json_object}=                 to json                        ${response.content}
  ${response_message}=        get value from json                ${json_object}             $.errors[0].msg   
  should contain  ${response_message}  Name is required

