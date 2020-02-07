*** Settings ***
Resource      ../../../resources/common.robot
Resource      ../../../resources/users.robot
Library       RequestsLibrary 
Library       Collections
Library       JSONLibrary
Library       os
Test Setup  create session  mysession  ${base_url}  

*** Test Cases ***
