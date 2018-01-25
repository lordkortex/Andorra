/**
 * CRAN_VEC_ADV_ESignature Trigger Handler Class
 *
 * Fecha: 13/06/2017
 * @author  Javier Touchard Vicente (Vector ITC)
 * @version 1.0
 *
*/


public with sharing class CRAN_VEC_ADV_ESTriggerHandler_CLS extends CRAN_VEC_KER_TriggerHandler_CLS{


	public CRAN_VEC_ADV_ESTriggerHandler_CLS(SObjectType objectType) {
		super(objectType);		
	}

	public override void afterUpdate() {
    	CRAN_VEC_ADV_ESignatureTriggerUtil.gestionObjetosRelacionados((List<CRAN_VAS_KER_ESignature__c>)Trigger.new, (List<CRAN_VAS_KER_ESignature__c>)Trigger.old);
  }
}