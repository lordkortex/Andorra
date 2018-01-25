public with sharing class CRAN_VEC_ADV_IPLTriggerHandler_CLS extends CRAN_VEC_KER_TriggerHandler_CLS {
	public CRAN_VEC_ADV_IPLTriggerHandler_CLS(SObjectType objectType) {
		super(objectType);
	}

	public override void beforeInsert() {
		CRAN_VEC_ADV_IPLTriggerUtil.assignFieldtoEvaluate((Map<Id, CRAN_VEC_ADV_Investment_Proposition_Line__c>)Trigger.oldMap, (List<CRAN_VEC_ADV_Investment_Proposition_Line__c>)Trigger.new, 'insert');
	}

	public override void beforeUpdate() {
		CRAN_VEC_ADV_IPLTriggerUtil.assignFieldtoEvaluate((Map<Id, CRAN_VEC_ADV_Investment_Proposition_Line__c>)Trigger.oldMap, (List<CRAN_VEC_ADV_Investment_Proposition_Line__c>)Trigger.new, 'update');
	}
}