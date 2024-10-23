*** Settings ***
Library                        QForce
Library                        String
Resource                       ../PageObjectLocators/CreateAccount_SF_Locators.robot
Resource                       ../common.robot

*** Keywords ***
Navigate to Accounts
    GoTo                       ${accountslistviewurl}

Click New Button
    VerifyElement              ${newbutton}
    ClickElement               ${newbutton}
    VerifyText                 New Account

Select Organization Parent Account and Click Next 
    ClickText                  Organization (Parent)
    ClickElement               ${nextbutton}

Add Account Name 
    [Arguments]                ${accountnamevalue}
    VerifyText                 *Account Name
    ClickText                  *Account Name
    TypeText                   *Account Name               ${accountnamevalue}

Click Save Button
    VerifyElement              ${savebutton}
    ClickElement               ${savebutton}

Verify Created Account
    [Arguments]                ${accountnamevalue}
    VerifyField                Account Name                ${accountnamevalue}

Get Created Account URL
    ${created_account_URL}     GetUrl
    RETURN                     ${created_account_URL}

Get Account Id Value
    ScrollTo                   Tax
    ${accountid}               GetFieldValue               Long Account ID
    RETURN                     ${accountid}

Go Back to Account List view
    GoTo                       ${accountslistviewurl}

Select Individual Account and Click Next
    ClickText                  Individual Person
    ClickElement               ${nextbutton}

Add Account Firstname and LastName
    [Arguments]                ${fnameval}                 ${lnameval}
    PickList                   Salutation                  Mr.
    VerifyText                 First Name
    ClickText                  First Name
    TypeText                   First Name                  ${fnameval}
    ClickText                  *Last Name
    TypeText                   *Last Name                  ${lnameval}

Add Email and Phone Number
    [Arguments]                ${emailval}                 ${phoneval}
    ScrollTo                   Communication
    VerifyElement              ${emaillocator}
    TypeText                   ${emaillocator}             ${emailval}
    VerifyElement              ${phonelocator}
    TypeText                   ${phonelocator}             ${phoneval}

Add Billing and Shipping Address
    [Arguments]                ${addressjsondatafilepath}                              ${billingaddressjsondatakey}                     ${shippingaddressdatakey}
    ${jsondata}=               Read JSON From File         ${addressjsondatafilepath}
    ${billingaddressdata}=     Get From Dictionary         ${jsondata}                 ${billingaddressjsondatakey}
    ${shippingaddressdata}=    Get From Dictionary         ${jsondata}                 ${shippingaddressdatakey}
    ScrollTo                   Address
    VerifyText                 Billing Address
    #This loop will add the data for Billing Address
    FOR                        ${data}                     IN                          @{billingaddressdata}
        VerifyText             Billing Street
        ClickText              Billing Street
        TypeText               Billing Street              ${data['billing_street']}
        VerifyText             Billing City
        ClickText              Billing City
        TypeText               Billing City                ${data['billing_city']}
        VerifyText             Billing Zip/Postal Code
        ClickText              Billing Zip/Postal Code
        TypeText               Billing Zip/Postal Code     ${data['billing_zip']}
        PickList               Billing State/Province      ${data['billing_state']}
        PickList               Billing Country             ${data['billing_country']}
    END
    #This loop will add the data for shipping Address
    FOR                        ${data}                     IN                          @{shippingaddressdata}
        VerifyText             Shipping Address
        ClickText              Shipping Street
        TypeText               Shipping Street             ${data['shipping_street']}
        VerifyText             Shipping City
        ClickText              Shipping City
        TypeText               Shipping City               ${data['shipping_city']}
        VerifyText             Shipping Zip/Postal Code
        ClickText              Shipping Zip/Postal Code
        TypeText               Shipping Zip/Postal Code    ${data['shipping_zip']}
        PickList               Shipping State/Province     ${data['shipping_state']}
        PickList               Shipping Country            ${data['shipping_country']}
    END


Verify Person Account Got Created
    [Arguments]                ${nameofpersonaccount}
    VerifyField                Account Name                ${nameofpersonaccount}

    #Create a Child Affiliation
Search for Account Record
    [Arguments]                ${nameofpersonaccount}
    GlobalSearch               ${ABA-SF-STAGING-URL}       ${nameofpersonaccount}      Account
    VerifyText                 ${nameofpersonaccount}
    ClickText                  ${nameofpersonaccount}

Navigate to Child Affiliation List view
    [Arguments]                ${accountidval}
    ${childaffiliationurl}     Set Variable                ${ABA-SF-STAGING-URL}/lightning/r/Account/${accountidval}/related/NU__Affiliates__r/view
    GoTo                       ${childaffiliationurl}
    VerifyText                 Child Affiliations

Click New Button on Child affliation
    ClickText                  New

Add Individual Account on child affiliation
    [Arguments]                ${individualaccount}
    ComboBox                   *Account                    ${individualaccount}

Click Primary Affiliation and Primary contact checkbox
    VerifyCheckbox             Primary Affiliation
    ClickCheckbox              Primary Affiliation         on
    VerifyCheckbox             Primary Contact
    ClickCheckbox              Primary Contact             on

Select Roles
    [Arguments]                ${role1}                    ${role2}
    MultiPicklist              ${role1}                    ${role2}

Generate Text for Email
    ${randomstring}            Generate Random String      4                           [LETTERS]
    RETURN                     ${randomstring}

Validate the Primary Contact and Dues Contact Field Values
    [Arguments]                ${individualpersonname}
    ${primarycontact}          GetFieldValue               Primary Contact
    ${status}                  Run Keyword and Return Status                           Should Not Be Equal         ${None}              ${primarycontact}
    Run Keyword If             '${individualpersonname}' in '${primarycontact}'        Should Be True              ${status}            ELSE                  Should Not Be True    ${status}
    ${duescontact}             GetFieldValue               Dues Contact
    ${status}                  Run Keyword and Return Status                           Should Not Be Equal         ${None}              ${duescontact}
    Run Keyword If             '${individualpersonname}' in '${duescontact}'           Should Be True              ${status}            ELSE                  Should Not Be True    ${status}