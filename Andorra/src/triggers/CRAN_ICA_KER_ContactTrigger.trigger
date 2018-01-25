trigger CRAN_ICA_KER_ContactTrigger on Contact (
	before insert, 
    before update, 
    before delete, 
    after insert, 
    after update, 
    after delete, 
    after undelete) 
{
    new CRAN_ICA_KER_ContactTrgHandler_CLS(Contact.getSObjectType()).run(); 
}