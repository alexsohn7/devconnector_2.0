*** Settings ***
Library       RequestsLibrary 
Library       Collections
Library       JSONLibrary
Library       os

*** Variables ***
${base_url}                   http://localhost:5000
${bearer_token}               set global variable 
${name}                       james
${email}                      jameshyun55@gmail.com
${password}                   littleman                    

*** Test Cases ***
Registering a user should return a status code 200
  create session  mysession  ${base_url}
  ${headers}=  create dictionary  Content-Type=application/json
  ${body}=     create dictionary  name=${name}  email=${email}  password=${password}
  ${response}=  post request  mysession  /api/users  data=${body}  headers=${headers}

  # Validations 
  ${status_code}=             convert to string              ${response.status_code}
  should be equal             ${status_code}                 200                     


When users log in with correct credentials should return token
  create session  mysession  ${base_url}
  ${headers}=  create dictionary   Content-Type=application/json
  ${body}=     create dictionary  email=${email}  password=${password}
  ${response}=  post request  mysession  /api/auth  data=${body}  headers=${headers}
  ${json_object}=                 to json                        ${response.content}
  ${bearer_token}=            get value from json            ${json_object}          $.token
  ${bearer_token}=            Set global variable            ${bearer_token[0]}

  # Validations           
  should contain              ${response.content}            token

Get user information based on authentication token
  create session  mysession  ${base_url}
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

