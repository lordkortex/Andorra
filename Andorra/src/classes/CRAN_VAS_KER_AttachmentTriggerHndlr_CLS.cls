public with sharing class CRAN_VAS_KER_AttachmentTriggerHndlr_CLS extends TriggerHandler {

	private Map<Id, Attachment> newMap;
  private Map<Id, Attachment> oldMap;
	private List<Attachment> newList;
	private List<Attachment> oldList;

	public CRAN_VAS_KER_AttachmentTriggerHndlr_CLS(SObjectType objectType) {
  	super(objectType);
  	this.newMap = (Map<Id, Attachment>) Trigger.newMap;
    this.oldMap = (Map<Id, Attachment>) Trigger.oldMap;
  	this.newList = (List<Attachment>) Trigger.new;
  	this.oldList = (List<Attachment>) Trigger.old;
	}

	//public override void beforeUpdate() {}

	//public override void beforeInsert() {}

	//public override void beforeDelete() {}

	public override void afterInsert() {
      if (!TriggerHandler.isBypassed(super.getHandlerName())) {
          
          TriggerHandler.bypass(super.getHandlerName());

          for (Attachment attach : newList) {
          	if (Contract.sObjectType == attach.parentId.getSObjectType()
              || Account.sObjectType == attach.parentId.getSObjectType()
              || Opportunity.sObjectType == attach.parentId.getSObjectType()) {
          		CRAN_VAS_KER_AttachmentTriggerHelper_CLS.getInstance().addToMap(attach);
          	}
          }  

          CRAN_VAS_KER_AttachmentTriggerHelper_CLS.getInstance().run(); 
      } 	
	}

	//public override void afterUpdate() {}

	//public override void afterDelete() {}
}