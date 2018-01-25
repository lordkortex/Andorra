public class CRAS_ICA_ASS_FinHoldingsTrgHandler_CLS extends TriggerHandler {
    
    private Map<Id, FinServ__FinancialHolding__c> newMap;
    private Map<Id, FinServ__FinancialHolding__c> oldMap;
    private List<FinServ__FinancialHolding__c> newList;
    private List<FinServ__FinancialHolding__c> oldList;
    
    public CRAS_ICA_ASS_FinHoldingsTrgHandler_CLS(SObjectType objectType) 
    {
        super(objectType);
        this.newMap = (Map<id, FinServ__FinancialHolding__c>) Trigger.newMap;
        this.oldMap = (Map<id, FinServ__FinancialHolding__c>) Trigger.oldMap;
        this.newList  = (List<FinServ__FinancialHolding__c>) Trigger.new;
        this.oldList  = (List<FinServ__FinancialHolding__c>) Trigger.old;
    }
    
    public override void afterInsert() 
    {
        upsertFH();
    }
    
    public override void afterUpdate()
    {
        upsertFH();
    }
    
    private void upsertFH()
    {
        Set<Id> idsList = new Set<Id>();
        for(FinServ__FinancialHolding__c holding : this.newList){
            if (String.isNotBlank(holding.CRAS_ICA_ASS_T_AxisProductID__c)){
                idsList.add(holding.Id);
            }
        }
        if (idsList.size() > 0){
            List<Id> FHIdsList = new List<Id>();
            FHIdsList.addAll(idsList);
            CRAS_ICA_ASS_FHFutureHandler_CLS.updateInsurancePolicyProduct(FHIdsList);
        }
    }
}