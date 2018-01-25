public class CRAS_ICA_ASS_InvoicesTrgHandler_CLS extends TriggerHandler {
    
    private Map<Id, CRAS_ICA_ASS_Invoice__c> newMap;
    private Map<Id, CRAS_ICA_ASS_Invoice__c> oldMap;
    private List<CRAS_ICA_ASS_Invoice__c> newList;
    private List<CRAS_ICA_ASS_Invoice__c> oldList;
    
    public CRAS_ICA_ASS_InvoicesTrgHandler_CLS(SObjectType objectType) {
        super(objectType);
        this.newMap = (Map<id, CRAS_ICA_ASS_Invoice__c>) Trigger.newMap;
        this.oldMap = (Map<id, CRAS_ICA_ASS_Invoice__c>) Trigger.oldMap;
        this.newList  = (List<CRAS_ICA_ASS_Invoice__c>) Trigger.new;
        this.oldList  = (List<CRAS_ICA_ASS_Invoice__c>) Trigger.old;
    }
    
    public override void afterInsert() {
        Set<Id> idsList = new Set<Id>();
        Set<Id> idsInvList = new Set<Id>();
        for(CRAS_ICA_ASS_Invoice__c invoice : this.newList){
            idsList.add(invoice.CRAS_ICA_ASS_F_FAID__c);
            idsInvList.add(invoice.id);
        }
        List<Id> FAIdsList = new List<Id>();
        List<Id> INVIdsList = new List<Id>();
        FAIdsList.addAll(idsList);
        INVIdsList.addAll(idsInvList);
        CRAS_ICA_ASS_InvoicesFutureHandler_CLS.calculateInvoicesStatus(FAIdsList);
    }
}