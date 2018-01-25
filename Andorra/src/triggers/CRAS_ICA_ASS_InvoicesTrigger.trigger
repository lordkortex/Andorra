trigger CRAS_ICA_ASS_InvoicesTrigger on CRAS_ICA_ASS_Invoice__c ( before insert, 
    before update, 
    before delete, 
    after insert, 
    after update, 
    after delete, 
    after undelete) 
{
	new CRAS_ICA_ASS_InvoicesTrgHandler_CLS(CRAS_ICA_ASS_Invoice__c.getSObjectType()).run(); 
}