*** Settings ***
Library    QForce
Resource                        ../PageObjectLocators/CreateAccountPageLocators.robot


*** Keywords ***
Navigate to Website URL
    [Arguments]                 ${websiteurl}
    GoTo                        ${websiteurl}

Click Sign In
    VerifyElement               ${sign_in_link}
    ClickElement                ${sign_in_link}

Click Register Button
    VerifyElement               ${register_button}
    ScrollTo                    ${register_button}
    ClickElement                ${register_button}

Enter FirstName and LastName data
    [Arguments]                 ${fname}                    ${lname}
    VerifyText                  Create an ABA Account
    VerifyElement               ${txt_firstName}
    ClickElement                ${txt_firstName}
    TypeText                    ${txt_firstName}            ${fname}
    VerifyElement               ${txt_lastName}
    ClickElement                ${txt_lastName}
    TypeText                    ${txt_lastName}             ${lname}

Enter Email Address and Verify Email Address data
    [Arguments]                 ${emailid}
    VerifyElement               ${txt_workemail}
    ClickElement                ${txt_workemail}
    TypeText                    ${txt_workemail}            ${emailid}
    VerifyElement               ${txt_verifyworkemail}
    ClickElement                ${txt_verifyworkemail}
    TypeText                    ${txt_verifyworkemail}      ${emailid}

Enter Password and Confirm Password data
    [Arguments]                 ${passworddata}
    VerifyElement               ${txt_password}
    ClickElement                ${txt_password}
    TypeText                    ${txt_password}             ${passworddata}
    VerifyElement               ${txt_verifypassword}
    ClickElement                ${txt_verifypassword}
    TypeText                    ${txt_verifypassword}       ${passworddata}

Click on Next Button
    VerifyElement               ${next_button}
    ClickElement                ${next_button}

Add Associated Company
    [Arguments]                 ${companyname}
    VerifyText                  We Found Companies That Match Your Email
    VerifyText                  ${companyname}
    VerifyElement               ${sandy_spring_bank_txt}             
    ClickElement                ${sandy_spring_bank_txt}

Click Continue Button    
    ScrollTo                    ${company_continue_button}
    VerifyElement               ${company_continue_button}
    ClickElement                ${company_continue_button}

Verify Company Name Field Value
    [Arguments]                 ${companyname}
    ${getcompanynamefieldvalue}    GetInputValue              ${company_name_txt}
    Should Be Equal As Strings     ${getcompanynamefieldvalue}    ${companyname}

Verify Work Address Value
    [Arguments]                 ${workaddress}
    ${workaddressfieldvalue}    GetInputValue               Work Street Address
    Should Be Equal As Strings  ${workaddressfieldvalue}    ${workaddress}

Verify ZipCode Value
    [Arguments]                 ${zipcode}
    ${zipcodefieldvalue}        GetInputValue               Zip Code
    Should Be Equal As Strings                              ${zipcodefieldvalue}       ${zipcode}

Add Work Phone Number
    [Arguments]                 ${phonenumber}
    VerifyElement               ${workphonefield}
    ClickElement                ${workphonefield}
    TypeText                    ${workphonefield}           ${phonenumber}

Select Primary Function and Your Job Levels Values
    [Arguments]                 ${primaryfunctionvalue}     ${joblevelvalue}
    DropDown                    Your Primary Function       ${primaryfunctionvalue}
    DropDown                    Your Job Level (Optional)    ${joblevelvalue}

Click Finish Registration Button
    VerifyElement               ${finishregistrationbtn}
    ClickElement                ${finishregistrationbtn}

Validate New Created Account
    [Arguments]                 ${firstnameval}             ${lastnameval}
    VerifyText                  ${welcome_text}
    VerifyElement               ${account_continue_button}
    ClickElement                ${account_continue_button}
    VerifyElement               ${account_login_icon}
    ClickElement                ${account_login_icon}
    VerifyText                  Hello, ${firstnameval} ${lastnameval}

Logout from the Website
    VerifyElement               ${logout_link}
    ClickElement                ${logout_link}
    VerifyElement               ${sign_in_link}







