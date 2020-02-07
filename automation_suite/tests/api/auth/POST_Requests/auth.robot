*** Settings ***
Resource      ../../../../resources/common.robot
Resource      ../../../../resources/routes/auth.robot
Library       RequestsLibrary 
Library       Collections
Library       JSONLibrary
Library       os

*** Test Cases ***
When users log in with correct credentials should return token
  create session  mysession  ${base_url}
  ${response}=  Get response from logging in a valid user @ /api/auth  email=${email}  password=${password}
  Get bearer_token  ${response}

  # Validations           
  should contain              ${response.content}            token