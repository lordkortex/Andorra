trigger CRAN_VEC_ADV_IPL on CRAN_VEC_ADV_Investment_Proposition_Line__c (before insert, before update, 
	before delete, after insert, after update, after delete, after undelete) {

	new CRAN_VEC_ADV_IPLTriggerHandler_CLS(CRAN_VEC_ADV_Investment_Proposition_Line__c.getSObjectType()).run();
}