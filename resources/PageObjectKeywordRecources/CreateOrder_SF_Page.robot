*** Settings ***
Library                         QWeb
Resource                        ../PageObjectLocators/CreateOrder_SF_Locators.robot
Resource                        ../common.robot


*** Keywords ***

Search for Person Account Record
    [Arguments]                 ${nameofpersonaccount}
    GlobalSearch                ${ABA-SF-STAGING-URL}       ${nameofpersonaccount}      Account
    VerifyText                  ${nameofpersonaccount}
    ClickText                   ${nameofpersonaccount}
    Wait                        5s
    ScrollTo                    Address
    ${getshippingaddress}       GetFieldValue               Shipping Address
    #GetFieldValue is Qforce library keyword which gives the field value on the record
    Set Global Variable         ${getshippingaddress}

Verify the Person Account Record
    [Arguments]                 ${nameofpersonaccount}
    ${personaccname}            GetFieldValue               Account Name
    Should Contain Any          ${nameofpersonaccount}      ${personaccname}

Click New Order Button
    VerifyElement               ${neworder_button}
    ClickElement                ${neworder_button}

Select Order Type
    [Arguments]                 ${ordertypevalue}
    VerifyText                  ${ordertypedropdownlabel}
    DropDown                    ${ordertypedropdownlabel}                               ${ordertypevalue}

Click Continue button
    VerifyText                  Continue
    ClickText                   Continue
    Wait Until Keyword Succeeds                             10x                         1s             VerifyText         Add Merchandise

Search the Merchandise product and Add to Cart and Save the Cart
    [Arguments]                 ${productname}
    VerifyElement               ${cartfilterdropdown}
    Wait                        2s
    DropDown                    ${cartfilterdropdown}       All
    Wait                        5s
    ClickElement                ${searchfieldproduct}
    TypeText                    ${searchfieldproduct}       ${productname}
    Wait                        2s
    VerifyText                  ${productname}
    ClickText                   ${productname}
    ClickElement                ${searchbutton}
    Wait                        5s
    VerifyElement               ${addcarticon}
    ClickElement                ${addcarticon}
    Wait                        2s
    VerifyText                  ${productname}
    ClickText                   Save
    Wait                        5s

Click on Go To Shipping and Calculate Tax
    ClickText                   Go To Tax & Shipping
    VerifyText                  Tax & Shipping Cart Items
    VerifyText                  Calculate Tax
    ClickText                   Calculate Tax
    Wait                        2s
    VerifyText                  Tax Calculated

Click on Go To Shipping and Add Shipping Method
    ClickText                   Go To Tax & Shipping
    VerifyText                  Tax & Shipping Cart Items
    VerifyText                  Edit Shipping
    ClickText                   Edit Shipping
    Wait                        5s
    VerifyText                  How do you want to ship?
    VerifyText                  Ship Method
    TypeText                    Ship Method                 UPS Ground Delivery
    ClickItem                   Ship Method Lookup (New Window)
    SwitchWindow                NEW
    VerifyText                  UPS Ground Delivery
    ClickText                   Go!
    VerifyText                  Ship Methods
    VerifyText                  UPS Ground Delivery
    CloseWindow
    ${savebtn}                  Set Variable                xpath=//input[@value='Save']
    ClickText                   ${savebtn}
    Wait                        5s
    VerifyText                  UPS Ground Delivery
    ClickText                   Save
    Wait                        5s
    ClickText                   Calculate Tax
    Wait                        5s
    VerifyText                  Tax Calculated

Verify and Get SubTotal Shipping and Sales Tax Values
    ${getsalestax}              GetText                     ${salestaxlocator}
    Set Global Variable         ${getsalestax}
    ${getsubtotal_val}          GetText                     ${subtotallocator}
    ${subtotalval}              Remove String               ${getsubtotal_val}          $
    Set Global Variable         ${subtotalval}
    ${get_tax}                  GetText                     ${tax_shippinglocator}
    ${totaltax}                 Remove String               ${get_tax}                  $
    Set Global Variable         ${totaltax}
    ${getTotalamount}           GetText                     ${totallocator}
    ${totalamount}              Remove String               ${getTotalamount}           $
    Set Global Variable         ${totalamount}
    ${getbalance}               GetText                     ${balancelocator}
    ${balanceval}               Remove String               ${getbalance}               $
    Set Global Variable         ${balanceval}

Click PayNow button
    ClickText                   Go To Payment
    VerifyText                  Pay Now
    ClickText                   Pay Now

Add Card Details and Submit the Order
    [Arguments]                 ${paymentmethods}           ${cardnum}                  ${expmonth}    ${expyear}         ${cvvno}
    DropDown                    Payment Method              ${paymentmethods}
    TypeText                    Number                      ${cardnum}
    TypeText                    CSC                         ${cvvno}
    DropDown                    ${expmonthdropdown}         ${expmonth}
    DropDown                    ${expyeardropdown}          ${expyear}
    ClickText                   Save
    ClickText                   Submit Order

Verify the Bill To Field Value Should Contain Person Account Name
    [Arguments]                 ${personaccountnameval}
    ${billtoval}                GetFieldValue               Bill To
    Should Contain              ${billtoval}                ${personaccountnameval}

Validate the Financial Details Values
    ScrollTo                    Invoice Description
    ${gtotal}                   GetFieldValue               Grand Total
    Should Contain              ${gtotal}                   ${totalamount}
    ${totalpayamt}              GetFieldValue               Total Payment
    Should Contain              ${totalpayamt}              ${totalamount}
    ${subtotval}                GetFieldValue               Sub Total
    Should Contain              ${subtotval}                ${subtotalval}
    ${totaltaxval}              GetFieldValue               Total Shipping And Tax
    Should Contain              ${totaltaxval}              ${totaltax}

Navigate to Order Item Record
    ClickText                   Order Items
    ${ele}                      Set Variable                xpath=//th[@data-label='Order Item Id']//a
    ${orderitemurl}             GetAttribute                ${ele}                      href
    Set Global Variable         ${orderitemurl}
    GoTo                        ${orderitemurl}
    Wait                        2s
    VerifyField                 Sales Tax Name              MD

Navigate to Product Item
    ClickText                   Order Item Lines
    ${elel}                     Set Variable                xpath=//td[@data-label='Product']//a
    ${orderitelinemurl}         GetAttribute                ${elel}                     href
    GoTo                        ${orderitelinemurl}
    VerifyField                 Record Type Name            Merchandise

Validate Shipping Checkbox is Not Checked For NonShippable Product
    ScrollTo                    Shipping
    VerifyCheckbox              Shippable
    ${shippingcheckboxstatus}                               Run Keyword and Return Status              VerifyCheckboxValue            Shippable    off
    Set Global Variable         ${shippingcheckboxstatus}

Validate the Shipping Details On Order Item Record Should be Empty When Shipping Checkbox is Not Checked On the Product Record    
    IF                          '${shippingcheckboxstatus}' == 'True'
        GoTo                    ${orderitemurl}
        ScrollTo                Shipping Detail
        VerifyField             Shipping Address            ${EMPTY}
    END

Validate Shipping Checkbox is Checked For Shippable Product
    ScrollTo                    Shipping
    VerifyCheckbox              Shippable
    ${shippingcheckboxstatus}                               Run Keyword and Return Status              VerifyCheckboxValue            Shippable    on
    Set Global Variable         ${shippingcheckboxstatus}

Validate the Shipping Details On Order Item Record Should be Equal the Shipping Address on Person Account   
    IF                          '${shippingcheckboxstatus}' == 'True'
        GoTo                    ${orderitemurl}
        ScrollTo                Shipping Detail
        ${shippingadd}          GetFieldValue               Shipping Address
        ${getstr}               Get Substring               ${shippingadd}              0              20    #First 20 characters will match the string as the address have spaces and state code on the shipping address field on item
        Should Contain          ${getshippingaddress}       ${getstr}
    END

LogOut from Saleforce Application
    ${profileicon}              Set Variable                xpath=//div[@data-aura-class='forceEntityIcon']
    VerifyElement               ${profileicon}
    ClickElement                ${profileicon}
    VerifyText                  Log Out
    ClickText                   Log Out
    Wait                        5s
    VerifyText                  Log in with Stage Login