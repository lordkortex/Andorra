public with sharing class CRAN_VEC_ADV_CFTriggerHandler_CLS extends CRAN_VEC_KER_TriggerHandler_CLS{


  public CRAN_VEC_ADV_CFTriggerHandler_CLS(SObjectType objectType) {
    super(objectType);
    //this.setMaxLoopCount(1);
  }

   public override void beforeInsert() {
   		CRAN_VEC_ADV_CustomFormTriggerUtil.cargarRelaciones((Map<Id,CRAN_VEC_ADV_CustomForm__c>)Trigger.oldMap, (List<CRAN_VEC_ADV_CustomForm__c>)Trigger.new, 'Insert');
  }

   public override void beforeUpdate() {
    	CRAN_VEC_ADV_CustomFormTriggerUtil.cargarRelaciones((Map<Id,CRAN_VEC_ADV_CustomForm__c>)Trigger.oldMap, (List<CRAN_VEC_ADV_CustomForm__c>)Trigger.new, 'Update');
  }

   public override void beforeDelete() {
		CRAN_VEC_ADV_CustomFormTriggerUtil.checkDelete((Map<Id,CRAN_VEC_ADV_CustomForm__c>)Trigger.oldMap, (List<CRAN_VEC_ADV_CustomForm__c>)Trigger.new, 'delete');
		CRAN_VEC_ADV_CustomFormTriggerUtil.deleteFormResponses((Map<Id,CRAN_VEC_ADV_CustomForm__c>)Trigger.oldMap, (List<CRAN_VEC_ADV_CustomForm__c>)Trigger.new);
	}
}