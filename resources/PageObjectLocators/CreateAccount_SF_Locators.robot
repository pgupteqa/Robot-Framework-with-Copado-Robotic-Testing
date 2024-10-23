*** Variables ***

#Account page list view URL
${accountslistviewurl}    ${sf_login_stage_url}/lightning/o/Account/list
${newbutton}    xpath=//li/a[@title='New']
${nextbutton}   xpath=//button[contains(.,'Next')]
${savebutton}   xpath=//button[@name='SaveEdit']

#Individual Account form fields locators
${firstnamelocator}    xpath=//input[@name='firstName']
${lastnamelocator}     xpath=//input[@name='lastName']
${emaillocator}        xpath=//input[@name='PersonEmail']
${phonelocator}        xpath=//input[@name='Phone']