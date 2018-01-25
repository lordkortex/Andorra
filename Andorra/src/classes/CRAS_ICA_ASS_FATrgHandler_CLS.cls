public class CRAS_ICA_ASS_FATrgHandler_CLS extends TriggerHandler  {
    private Map<Id, FinServ__FinancialAccount__c> newMap;
    private Map<Id, FinServ__FinancialAccount__c> oldMap;
    private List<FinServ__FinancialAccount__c> newList;
    private List<FinServ__FinancialAccount__c> oldList;
    
    public CRAS_ICA_ASS_FATrgHandler_CLS(SObjectType objectType) {
        super(objectType);
        this.newMap = (Map<id, FinServ__FinancialAccount__c>) Trigger.newMap;
        this.oldMap = (Map<id, FinServ__FinancialAccount__c>) Trigger.oldMap;
        this.newList  = (List<FinServ__FinancialAccount__c>) Trigger.new;
        this.oldList  = (List<FinServ__FinancialAccount__c>) Trigger.old;    
    }
    
    public override void afterInsert() 
    {
        if(isInsurance())
        {
            Set<Id> idsFA = new Set<Id>();
            
            for(FinServ__FinancialAccount__c fA :this.newList)
            {
                idsFA.add(fA.Id);
            }
            
            List<Id> idsFALst = new List<Id>();
            idsFALst.addAll(idsFA);
            
            CRAS_ICA_ASS_FAFutureHandler_CLS.changeOffice(idsFALst);
        }
    }
    
    public override void beforeInsert() 
    {
        if(isInsurance())
        {
            for(FinServ__FinancialAccount__c fA :this.newList)
            {
                if (fa.CRAN_ICA_KER_P_Identity__c != CRAS_ICA_ASS_Helpers_CLS.IDENTITY_SEGUROS_DIRECCION_RESTRINGIDO){
                  	fa.CRAN_ICA_KER_P_Identity__c = CRAS_ICA_ASS_Helpers_CLS.IDENTITY_SEGUROS_DIRECCION;  
                }                
            }  
        }  
    }
    /*
    public override void beforeUpdate() 
    {
        
         if (!TriggerHandler.isBypassed(super.getHandlerName())) {
            TriggerHandler.bypass(super.getHandlerName());  
            if(isInsurance())
            {
                CRAS_ICA_ASS_FAFutureHandler_CLS.setOwner(Trigger.new);
            }  
         }
    }*/
    
    private Boolean isInsurance(){
        for (FinServ__FinancialAccount__c fA : this.newList){
            if (String.isNotBlank(fA.CRAS_ICA_ASS_T_AxisFAID__c)){
                return true; 
            }
        }
        return false;
    }
    
}