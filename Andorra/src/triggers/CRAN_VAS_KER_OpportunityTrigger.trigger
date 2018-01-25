/*
 * Name: Francisco J. Díaz
 * Date: 21/06/2017
 * Email: fjdiaz@creditandorra.ad
*/

trigger CRAN_VAS_KER_OpportunityTrigger on Opportunity (after insert, after update, before delete, before insert, before update) {
    new CRAN_VAS_KER_OppTriggerHandler_CLS(Opportunity.getSObjectType()).run();
    new CRAS_ICA_ASS_OppTrgHandler_CLS(Opportunity.getSObjectType()).run(); 
}