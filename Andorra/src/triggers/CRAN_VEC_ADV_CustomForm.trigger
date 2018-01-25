/**
 * CRAN_VEC_ADV_CustomForm Trigger Class
 *
 * Fecha: 29/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/


trigger CRAN_VEC_ADV_CustomForm on CRAN_VEC_ADV_CustomForm__c (	before insert, before update, before delete, after insert, 
																after update, after delete, after undelete) {

		new CRAN_VEC_ADV_CFTriggerHandler_CLS(CRAN_VEC_ADV_CustomForm__c.getSObjectType()).run();
}