*** Settings ***
Resource      ../../../resources/common.robot
Resource      ../../../resources/users.robot
Library       RequestsLibrary 
Library       Collections
Library       JSONLibrary
Library       os 

*** Test Cases ***
Get correct name and email of logged in user
  create session  mysession  ${base_url}
  ${headers}=  create dictionary   Content-Type=application/json
  ${body}=     create dictionary  email=${email}  password=${password}
  ${response}=  post request  mysession  /api/auth  data=${body}  headers=${headers}
  Get bearer_token  ${response}
  ${headers}=  create dictionary  x-auth-token=${bearer_token[0]}  Content-Type=application/json
  ${response}=  get request  mysession  /api/auth  headers=${headers}
  ${json_object}=                 to json                        ${response.content}

  # Validation
  ${login_page_name}=            get value from json            ${json_object}          $.name
  ${name}=  convert to string  ${name}
  should be equal  ${login_page_name[0]}   ${name}
  ${login_page_email}=            get value from json            ${json_object}          $.email
  ${email}=  convert to string  ${email}
  should be equal  ${login_page_email[0]}   ${email}