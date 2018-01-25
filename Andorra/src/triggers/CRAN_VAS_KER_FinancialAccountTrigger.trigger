trigger CRAN_VAS_KER_FinancialAccountTrigger on FinServ__FinancialAccount__c (before insert, before update, after update, after insert, before delete, after delete) {
    new CRAS_ICA_ASS_FATrgHandler_CLS(FinServ__FinancialAccount__c.getSObjectType()).run(); 
}