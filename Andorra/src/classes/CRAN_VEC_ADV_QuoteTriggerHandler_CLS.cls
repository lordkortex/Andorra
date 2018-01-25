public with sharing class CRAN_VEC_ADV_QuoteTriggerHandler_CLS extends CRAN_VEC_KER_TriggerHandler_CLS {
    public CRAN_VEC_ADV_QuoteTriggerHandler_CLS(SObjectType objectType) {
        super(objectType);
    }

    public override void beforeInsert() {
        CRAN_VEC_ADV_QuoteTriggerUtil.finalVersionUpdate((Map<Id, Quote>)Trigger.oldMap, (List<Quote>)Trigger.new, 'insert');
    }

    public override void beforeUpdate() {
        CRAN_VEC_ADV_QuoteTriggerUtil.finalVersionUpdate((Map<Id, Quote>)Trigger.oldMap, (List<Quote>)Trigger.new, 'update');
        CRAN_VEC_ADV_QuoteTriggerUtil.overrideAllRestrictions((Map<Id, Quote>)Trigger.oldMap, (List<Quote>)Trigger.new);
    }
}