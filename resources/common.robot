*** Settings ***
Documentation                   Example resource file with custom keywords. NOTE: Some keywords below may need
...                             minor changes to work in different instances.
Library                         QForce
Library                         QWeb
Library                         String
Library                         QVision
Library                         FakerLibrary
Library                         Collections
Library                         OperatingSystem
Library                         JSONLibrary


*** Variables ***
# IMPORTANT: Please read the readme.txt to understand needed variables and how to handle them!!
${BROWSER}                      ${BROWSER}
${EMULATION}                    ${EMULATION}
${username}                     ${username}
${login_url}                    ${URL_Stage}
${password}                     ${password}
${home_url}                     ${login_url}/lightning/page/home
${homedirctorypath}             ${Source_Directory_Path}
${consumer_secret}              ${consumer_secret}
${consumer_Id}                  ${consumer_Id}

# UAT Website URL Variable
${uat_website_url}              ${ABA-UAT-WEBSITE-URL}
# Salesforce Staging URL Variable
${sf_login_stage_url}           ${ABA-SF-STAGING-URL}
${sf_staging_username}          ${ABA-SF-STAGING-USERNAME}
${sf_staging_password}          ${ABA-SF-STAGING-PASSWORD}
${sf_staging_mfa_token}         ${secret}

#Account Name variable
${orgaccountnamedata}           ${ABA-Org-Account-User}
${personaccountfname}           ${ABA-Person-Account-Firstname}
${personaccount_lname}          ${ABA-Person-Account-lastname}

#Random accountname variable
${Account_Name_Prefix}          TestAutomation
#created a empty dictionary to strore the generated random name
&{ACCOUNT_GENERATED_STRINGS}    name=
#Variable to store the generated random name
${generatedaccountname}

#Random Indvidual accountname variable
${Ind_FirstName_Prefix}         TestAuto
&{INDVIDUAL_ACCOUNT_GENERATED_STRINGS}                      fname=${Ind_FirstName_Prefix}                           lname=${generatedlastname}
#When the name is generated, storing in a variable can be used in other test suites
${personaccountname}            ${Ind_FirstName_Prefix} ${generatedlastname}


*** Keywords ***
Setup Browser
    # Setting search order is not really needed here, but given as an example
    # if you need to use multiple libraries containing keywords with duplicate names
    Set Library Search Order    QForce                      QWeb                        QVision
    OpenBrowser                 about:blank                 ${BROWSER}                  emulation=${EMULATION}
    SetConfig                   LineBreak                   ${EMPTY}                    #\ue000
    Evaluate                    random.seed()               random                      # initialize random generator
    SetConfig                   DefaultTimeout              60s                         #sometimes salesforce is slow
    # adds a delay of 0.3 between keywords. This is helpful in cloud with limited resources.
    #SetConfig                   Delay                       0.3
    #Authenticate                ${consumer_id}              ${consumer_secret}          ${username}                 ${password}        sandbox=True

Authenticate Salesforce
    Authenticate                ${consumer_id}              ${consumer_secret}          ${sf_staging_username}                 ${sf_staging_password}                 custom_url=${sf_login_stage_url}           timeout=60s

End suite
    Close All Browsers


Login
    [Documentation]             Login to Salesforce instance. Takes instance_url, username and password as
    ...                         arguments. Uses values given in Copado Robotic Testing's variables section by default.
    [Arguments]                 ${sf_instance_url}=${sf_login_stage_url}                ${sf_username}=${sf_staging_username}                   ${sf_password}=${sf_staging_password}
    GoTo                        ${sf_instance_url}
    TypeText                    Username                    ${sf_username}              delay=1
    TypeSecret                  Password                    ${sf_password}
    ClickText                   Log In
    # We'll check if variable ${secret} is given. If yes, fill the MFA dialog.
    # If not, MFA is not expected.
    # ${secret} is ${None} unless specifically given.
    ${verifyidentitytxt}        IsText                      Verify Your Identity
    IF                          '${verifyidentitytxt}' == 'True'
        ${MFA_needed}=          Run Keyword And Return Status                           Should Not Be Equal         ${None}                     ${secret}
        Run Keyword If          ${MFA_needed}               Fill MFA                    ${sf_username}              ${secret}                   ${sf_instance_url}
    ELSE
        Should Be Equal         ${FALSE}                    ${verifyidentitytxt}
    END


Login As
    [Documentation]             Login As different persona. User needs to be logged into Salesforce with Admin rights
    ...                         before calling this keyword to change persona.
    ...                         Example:
    ...                         LoginAs                     Chatter Expert
    [Arguments]                 ${persona}
    ClickText                   Setup
    ClickItem                   Setup                       delay=1
    SwitchWindow                NEW
    TypeText                    Search Setup                ${persona}                  delay=2
    ClickElement                //*[@title\="${persona}"]                               delay=2                     # wait for list to populate, then click
    VerifyText                  Freeze                      timeout=45                  # this is slow, needs longer timeout
    ClickText                   Login                       anchor=Freeze               partial_match=False         delay=1


Fill MFA
    [Documentation]             Gets the MFA OTP code and fills the verification dialog (if needed)
    [Arguments]                 ${sf_username}=${sf_staging_username}                   ${mfa_secret}=${secret}     ${sf_instance_url}=${sf_login_stage_url}
    ${mfa_code}=                GetOTP                      ${sf_username}              ${mfa_secret}               ${sf_login_stage_url}
    TypeSecret                  Verification Code           ${mfa_code}
    ClickText                   Verify


Home
    [Documentation]             Example appstarte: Navigate to homepage, login if needed
    GoTo                        ${home_url}
    ${login_status} =           IsText                      To access this page, you have to log in to Salesforce.                              2
    Run Keyword If              ${login_status}             Login
    # ClickText                 Home
    # VerifyTitle               Home | Salesforce


    # Example of custom keyword with robot fw syntax. NOTE: These keywords may need to be adjusted
    # to work in your environment
VerifyStage
    [Documentation]             Verifies that stage given in ${text} is at ${selected} state; either selected (true) or not selected (false)
    [Arguments]                 ${text}                     ${selected}=true
    VerifyElement               //a[@title\="${text}" and (@aria-checked\="${selected}" or @aria-selected\="${selected}")]


VerifyStageColor
    [Documentation]             Example keyword on how to verify background color of element.
    ...                         Note that this keyword might need adjusting in your instance (colors and locators can be different)
    [Arguments]                 ${stage_text}               ${color}=navy
    &{COLORS}=                  Create Dictionary           navy=rgba(1, 68, 134, 1)    green=rgba(59, 167, 85, 1)

    ${elem}=                    GetWebElement               ${stage_text}               element_type=item
    ${background_color}=        Evaluate                    $elem.value_of_css_property("background-color")
    Should Be Equal             ${COLORS.${color}}          ${background_color}         msg=Error: Background color ( ${background_color}) differs from ${color} (${COLORS.${color}})


NoData
    VerifyNoText                ${data}                     timeout=3                   delay=2


DeleteAccounts
    [Documentation]             RunBlock to remove all data until it doesn't exist anymore
    ClickText                   ${data}
    ClickText                   Delete
    VerifyText                  Are you sure you want to delete this account?
    ClickText                   Delete                      2
    VerifyText                  Undo
    VerifyNoText                Undo
    ClickText                   Accounts                    partial_match=False


DeleteLeads
    [Documentation]             RunBlock to remove all data until it doesn't exist anymore
    ClickText                   ${data}
    ClickText                   Delete
    VerifyText                  Are you sure you want to delete this lead?
    ClickText                   Delete                      2
    VerifyText                  Undo
    VerifyNoText                Undo
    ClickText                   Leads                       partial_match=False


#User defined Keywords can be used throughout the testcases

Generate Email Address
    [Documentation]             Generate the random email address to avoid the duplicate emails during the create account process
    ${randomstring}             Generate Random String      4                           [LETTERS]
    # 4 is length of string and [LETTERS] represents the uppercase and lowercase ASCII characters
    ${emailstring}              Set Variable                ${randomstring}fstest@yopmail.com
    RETURN                      ${emailstring}


Generate Unique String
    ${unique_string}            Wait Until Keyword Succeeds                             10x                         1s                          Generate And Check String
    RETURN                      ${unique_string}

Generate and Check String
    ${random_number}            Generate Random String      2                           [NUMBERS]
    ${random_string_acclname}                               Generate Random String      5                           [LETTERS]
    ${random_string}            Set Variable                ${Account_Name_Prefix} ${random_string_acclname}${random_number}
    ${exists}                   Dictionary Should Not Contain Value                     ${ACCOUNT_GENERATED_STRINGS}                            ${random_string}
    Set To Dictionary           ${ACCOUNT_GENERATED_STRINGS}                            name                        ${random_string}
    RETURN                      ${random_string}

Generate Dynamic Account Name
    ${unique_string}            Wait Until Keyword Succeeds                             10x                         1s                          Generate And Check String
    Dictionary Should Contain Value                         ${ACCOUNT_GENERATED_STRINGS}                            ${unique_string}
    ${generated_acc_name}       Get From Dictionary         ${ACCOUNT_GENERATED_STRINGS}                            name    default="Test"
    Set Global Variable         ${generatedaccountname}     ${generated_acc_name}

Generate Unique lname String
    ${unique_lnamestring}       Wait Until Keyword Succeeds                             10x                         1s                          Generate Individual Account LastName
    RETURN                      ${unique_lnamestring}

Generate Individual Account LastName
    [Documentation]             This keyword will generate the random individual account name dynamically
    ${random_string_lname}      Generate Random String      5                           [LETTERS]
    ${random_number_val}        Generate Random String      1                           [NUMBERS]
    ${random_ind_lname}         Set Variable                ${random_string_lname} ${random_number_val}
    ${exists}                   Dictionary Should Not Contain Value                     ${INDVIDUAL_ACCOUNT_GENERATED_STRINGS}                  ${random_ind_lname}
    Set To Dictionary           ${INDVIDUAL_ACCOUNT_GENERATED_STRINGS}                  lname                       ${random_ind_lname}
    RETURN                      ${random_ind_lname}

Generate Dynamic Indvidual lname
    ${unique_lnamestring}       Wait Until Keyword Succeeds                             10x                         1s                          Generate Individual Account LastName
    Dictionary Should Contain Value                         ${INDVIDUAL_ACCOUNT_GENERATED_STRINGS}                  ${unique_lnamestring}
    ${generated_lname}          Get From Dictionary         ${INDVIDUAL_ACCOUNT_GENERATED_STRINGS}                  lname   default="Test"
    Set Global Variable         ${generatedlastname}        ${generated_lname}


    # Get JsonTest Data from a file
Read JSON From File
    [Arguments]                 ${file_path}
    ${json_string}=             Get File                    ${file_path}
    ${json_dict} =              Evaluate                    json.loads("""${json_string}""")                        json
    RETURN                      ${json_dict}
