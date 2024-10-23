*** Settings ***
Library                         QWeb
Suite Setup                     Setup Browser
Suite Teardown                  End suite

Resource                        ../../resources/common.robot
Resource                        ../../resources/PageObjectKeywordRecources/CreateOrder_SF_Page.robot
Resource                        ../../resources/TestData/AccountTestData.robot

*** Test Cases ***
Create a New Order using Non Shippable Product Ebook
    [Documentation]            This testcase will purchase the product as Non Shippable Ebook
    [Tags]                     Ebook_test
    Login
    Search for Person Account Record                       ${personaccountfname} ${personaccount_lname}
    #Search for Person Account Record                        TestAuto MvWVZ 1
    Click New Order Button
    Select Order Type           Merchandise
    Click Continue button
    Search the Merchandise product and Add to Cart and Save the Cart         ${ebookname}
    Click on Go To Shipping and Calculate Tax
    Verify and Get SubTotal Shipping and Sales Tax Values
    Click PayNow button
    Add Card Details and Submit the Order                   ${paymentmethod}    ${cardnumber}    ${expirymonth}    ${expiryyear}    ${cvv}
    Verify the Bill To Field Value Should Contain Person Account Name            TestAuto MvWVZ 1
    Validate the Financial Details Values
    Navigate to Order Item Record
    Navigate to Product Item
    Validate Shipping Checkbox is Not Checked For NonShippable Product
    Validate the Shipping Details On Order Item Record Should be Empty When Shipping Checkbox is Not Checked On the Product Record
    LogOut from Saleforce Application

Create a New Order using a Shippable Procut for Printable Book
    [Documentation]            This testcase will purchase the product as Shippable Printable Book
    [Tags]                     Printablebook_test
    Login
    Search for Person Account Record                       ${personaccountfname} ${personaccount_lname}
    #Search for Person Account Record                        TestAuto MvWVZ 1
    Click New Order Button
    Select Order Type           Merchandise
    Click Continue button
    Search the Merchandise product and Add to Cart and Save the Cart         ${printbook}
    Click on Go To Shipping and Add Shipping Method
    Verify and Get SubTotal Shipping and Sales Tax Values
    Click PayNow button
    Add Card Details and Submit the Order                   ${paymentmethod}    ${cardnumber}    ${expirymonth}    ${expiryyear}    ${cvv}
    Verify the Bill To Field Value Should Contain Person Account Name            TestAuto MvWVZ 1
    Validate the Financial Details Values
    Navigate to Order Item Record
    Navigate to Product Item
    Validate Shipping Checkbox is Checked For Shippable Product
    Validate the Shipping Details On Order Item Record Should be Equal the Shipping Address on Person Account
    LogOut from Saleforce Application