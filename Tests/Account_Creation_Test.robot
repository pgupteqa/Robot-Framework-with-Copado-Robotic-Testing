*** Settings ***
Resource                        ../resources/common.robot
Resource                        ../resources/PageObjectKeywordRecources/CreateAccountPage.robot
Resource                        ../resources/TestData/AccountTestData.robot

Suite Setup                     Setup Browser
Suite Teardown                  End suite

*** Test Cases ***
Create an ABA Account on UAT Website
    [Documentation]             This test will create a account by registering the user on uat.aba.com
    [Tags]                      create_account_website
    Navigate to Website URL     ${uat_website_url}
    Click Sign In
    Click Register Button
    Enter FirstName and LastName data                       ${acc_firstname}              ${acc_lastname}
    ${emailaddress}=           Generate Email Address
    Set Global Variable        ${emailaddress}
    Enter Email Address and Verify Email Address data       ${emailaddress}
    Enter Password and Confirm Password data                ${acc_password}
    Click on Next Button
    Add Associated Company     ${acc_companyname}
    Click Continue Button
    Verify Company Name Field Value                         ${acc_companyname}
    Verify Work Address Value                               ${acc_workaddress}
    Add Work Phone Number       ${acc_phonenumber}
    Select Primary Function and Your Job Levels Values      ${acc_primary_function}       ${acc_joblevels}
    Click Finish Registration Button
    Validate New Created Account                            ${acc_firstname}              ${acc_lastname}
    Logout from the Website
    