*** Settings ***
Suite Setup                     Setup Browser
Suite Teardown                  End suite

Resource                        ../../resources/common.robot
Resource                        ../../resources/PageObjectKeywordRecources/CreateAccount_SF_Page.robot
Resource                        ../../resources/TestData/AccountTestData.robot

*** Variables ***
${address_data_filepath}        ${homedirctorypath}/resources/TestData/Billing_Shipping_Address.json

*** Test Cases ***
Create an Organization Account
    [Documentation]             This testcase will create the Organization individual and child affiliation account
    [Tags]                      create_account_sf
    Login
    Navigate to Accounts
    Click New Button
    Select Organization Parent Account and Click Next
    Add Account Name            ${orgaccountnamedata}
    Click Save Button
    Verify Created Account      ${orgaccountnamedata}
    ${accid}                    Get Account Id Value
    Set Global Variable         ${accid}
    #Adding accountname variable, that can be used in tests for global search
    ${accnameval}               Set Variable                ${orgaccountnamedata}
    Set Global Variable         ${accnameval}

Create an Individual Account
    [Tags]                      create_account_sf
    Go Back to Account List view
    Click New Button
    Select Individual Account and Click Next
    Add Account Firstname and LastName                      ${personaccountfname}    ${personaccount_lname}
    ${emailtxt}                 Generate Text for Email
    Set Test Variable           ${emailtxt}
    Add Email and Phone Number                              ${emailtxt}@mailinator.com                             ${ind_phone_num}
    Add Billing and Shipping Address                        ${address_data_filepath}                               Billing_Address             Shipping_Address
    Click Save Button
    Verify Person Account Got Created                       Mr. ${personaccountfname} ${personaccount_lname}

Create Child Affiliation on the Parent Account
    [Tags]                      create_account_sf
    Go Back to Account List view
    Search for Account Record                               ${orgaccountnamedata}
    Navigate to Child Affiliation List view                 ${accid}
    Click New Button on Child affliation
    Add Individual Account on child affiliation             ${personaccountfname} ${personaccount_lname}
    Click Primary Affiliation and Primary contact checkbox
    Select Roles                ${role1data}                ${role2data}
    Click Save Button
    #Validate on the Primary account the Primary Contact field and Dues Contact Value
    Go Back to Account List view
    Search for Account Record                               ${orgaccountnamedata}
    Validate the Primary Contact and Dues Contact Field Values                         ${personaccountfname} ${personaccount_lname}