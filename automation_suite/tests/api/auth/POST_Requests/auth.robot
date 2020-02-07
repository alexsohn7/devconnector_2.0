*** Settings ***
Resource      ../../../../resources/common.robot
Resource      ../../../../resources/routes/auth.robot
Library       RequestsLibrary 
Library       Collections
Library       JSONLibrary
Library       os
Test Setup  create session  mysession  ${base_url}  

*** Test Cases ***
When users log in with correct credentials should return token
  ${response}=  Get response from logging in a valid user @ /api/auth  email=${email}  password=${password}
  

  # Validations           
  should contain              ${response.content}            token