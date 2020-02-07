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

Registering a user with an email that already exists should return a status code 400 
  ${response}=  Get response from registering a new user @ /api/users  name=${name}  email=${email}  password=${password}

  # Validations 
  ${status_code}=             convert to string              ${response.status_code}
  should be equal             ${status_code}                 400



