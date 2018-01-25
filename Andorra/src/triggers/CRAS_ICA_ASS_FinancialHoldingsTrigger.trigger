trigger CRAS_ICA_ASS_FinancialHoldingsTrigger on FinServ__FinancialHolding__c ( before insert, 
    before update, 
    before delete, 
    after insert, 
    after update, 
    after delete, 
    after undelete) 
{
	new CRAS_ICA_ASS_FinHoldingsTrgHandler_CLS(FinServ__FinancialHolding__c.getSObjectType()).run(); 
}