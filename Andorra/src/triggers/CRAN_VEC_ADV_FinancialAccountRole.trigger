/**
 * FinancialAccountRole Trigger Class
 *
 * Fecha: 28/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
 * Fecha: 26/05/2017
 * @author  Boris Herrera (ICA)
 * @version 1.1
*/

trigger CRAN_VEC_ADV_FinancialAccountRole on FinServ__FinancialAccountRole__c (
    before insert, 
    before update, 
    before delete, 
    after insert, 
    after update, 
    after delete, 
    after undelete) {
    
        new CRAN_VEC_ADV_FARoleTriggerHandler_CLS(FinServ__FinancialAccountRole__c.getSObjectType()).run();
        new CRAS_ICA_ASS_FARoleTrgHandler_CLS(FinServ__FinancialAccountRole__c.getSObjectType()).run();
}