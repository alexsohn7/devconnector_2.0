*** Settings ***
Resource      ../../../../resources/common.robot
Resource      ../../../../resources/routes/profile.robot
Library       RequestsLibrary 
Library       Collections
Library       JSONLibrary
Library       os
Test Setup  create session  mysession  ${base_url} 