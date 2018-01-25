/**
 * CRAN_VEC_ADV_ESignature Trigger Class
 *
 * Fecha: 13/06/2017
 * @author  Javier Touchard Vicente (Vector ITC)
 * @version 1.0
 *
*/


trigger CRAN_VEC_ADV_ESignature on CRAN_VAS_KER_ESignature__c (before insert, before update, before delete, after insert, 
	                                                           after update, after delete, after undelete) {

	new CRAN_VEC_ADV_ESTriggerHandler_CLS(CRAN_VAS_KER_ESignature__c.getSObjectType()).run();

}