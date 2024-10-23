
*** Variables ***
# Create Account Locators on UAT Website (uat.aba.com)
${sign_in_link}             xpath=//li[@class='utility-nav__account']/a[contains(@class,'utility-nav__account')]
${register_button}          xpath=//button[@class='btn btn-secondary'][normalize-space()='Register']

${txt_firstName}            xpath=//input[@id='firstName']
${txt_lastName}             xpath=//input[@id='lastName']
${txt_workemail}            xpath=//input[@id='workEmail']
${txt_verifyworkemail}      xpath=//input[@id='verifyWorkEmail']
${txt_password}             xpath=//input[@id='password']
${txt_verifypassword}       xpath=//input[@id='verifyPassword']
${next_button}              xpath=//button[normalize-space()='Next']

${affliation_modal_box}     xpath=//div[@class='modal__content']
${affiliation_modal_txt}    We Found Companies That Match Your Email
${sandy_spring_bank_txt}    xpath=//label[@for='company-0014P00003I954yQAB']
${company_continue_button}  xpath=//button[@class='btn btn-primary close-registration-modal'][contains(normalize-space(),'Continue')]

${work_street_address_txt}  xpath=//input[@id='addressOne']
${city_txt}                 xpath=//input[@id='city']
${company_name_txt}         xpath=//input[@id='companyName']
${workphonefield}           xpath=//input[@id='workPhoneNumber']
${finishregistrationbtn}    xpath=//button[@class='btn btn-secondary'][contains(.,'Finish Registration')]

${welcome_text}     Welcome to ABA.com
${account_continue_button}      xpath=//button[@class='btn btn-primary'][normalize-space()='Continue']
${account_login_icon}       xpath=//div[@class='utility-nav__account-trigger']
${logout_link}              xpath=//li[@class='utility-nav__account-dropdown__sign-out']/a