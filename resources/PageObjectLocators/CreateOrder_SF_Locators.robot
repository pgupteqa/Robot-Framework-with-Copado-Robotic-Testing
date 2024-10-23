*** Variables ***

#New order button
${neworder_button}          xpath=//button[contains(.,'New Order')]
${ordertypedropdownlabel}                               xpath=//select[@name='nu-orderType']

${cartfilterdropdown}       xpath=//select[@name='j_id0:j_id1:form:j_id12:j_id13:Inputs:MerchandiseBlock:j_id64']
${searchbutton}             xpath=//input[@value='Search']
${searchfieldproduct}       xpath=//input[@name='j_id0:j_id1:form:j_id12:j_id13:Inputs:MerchandiseBlock:SearchField']

${addcarticon}              xpath=//a[contains(@name,'Inputs:MerchandiseBlock:ItemLines')]
${expmonthdropdown}         xpath=//select[contains(@name,'ccexpmonth')]
${expyeardropdown}          xpath=//select[contains(@class,'ccexpyear')]

#Cart details for Total, Subtotal, Sales Tax, Tax ans shipping locators
${subtotallocator}                 xpath=//span[@id='j_id0:j_id1:form:nusidebar:nusidebar:OrderProperties:j_id263:orderSBTotalSpan:j_id277']
${totallocator}                    xpath=//span[@id='j_id0:j_id1:form:nusidebar:nusidebar:OrderProperties:j_id263:j_id291:j_id293']
${salestaxlocator}                 xpath=//td[@id='j_id0:j_id1:form:j_id11:j_id12:CartItems:j_id44:0:j_id72']
${tax_shippinglocator}             xpath=//span[@id='j_id0:j_id1:form:nusidebar:nusidebar:OrderProperties:j_id263:j_id288:j_id290']
${balancelocator}                  xpath=//span[@id='j_id0:j_id1:form:nusidebar:nusidebar:OrderProperties:j_id263:j_id307:j_id309:displayCurrency:j_id310']