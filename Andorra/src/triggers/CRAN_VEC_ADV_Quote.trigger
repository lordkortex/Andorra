trigger CRAN_VEC_ADV_Quote on Quote (before insert, before update, before delete, after insert, 
																after update, after delete, after undelete) {
	new CRAN_VEC_ADV_QuoteTriggerHandler_CLS(Quote.getSObjectType()).run();
}