public class CRAS_ICA_ASS_FARoleTrgHandler_CLS extends TriggerHandler {
    
    private static CRAS_ICA_ASS_InsuranceGlobal_CS__c relCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
    private Map<Id, FinServ__FinancialAccountRole__c> newMap;
    private Map<Id, FinServ__FinancialAccountRole__c> oldMap;
    private List<FinServ__FinancialAccountRole__c> newList;
    private List<FinServ__FinancialAccountRole__c> oldList;
    private Boolean doAccion = true;
    
    public CRAS_ICA_ASS_FARoleTrgHandler_CLS(SObjectType objectType) 
    {
        super(objectType);
        this.newMap = (Map<id, FinServ__FinancialAccountRole__c>) Trigger.newMap;
        this.oldMap = (Map<id, FinServ__FinancialAccountRole__c>) Trigger.oldMap;
        this.newList  = (List<FinServ__FinancialAccountRole__c>) Trigger.new;
        this.oldList  = (List<FinServ__FinancialAccountRole__c>) Trigger.old;
    }
    
    public override void beforeInsert() 
    {
        upsertFARAssegurances();
    }

    public override void beforeUpdate()
    {
        if (doAccion) 
        {
            preventAccion();

            if(isInsurance())
            {
                CRAS_ICA_ASS_FARoleFutureHandler_CLS.cloneBeforeUpdateFinancialAccountRole(this.newList, this.oldList);
            }

            AllowAccion();
        }
        
        upsertFARAssegurances();
    }
    
    public override void afterUpdate() 
    {
        CRAS_ICA_ASS_FARoleFutureHandler_CLS.disableAfterUpdateFinancialAccountRole(this.newList);
    }
    
    private void upsertFARAssegurances(){
        if (isInsurance()){
            List<FinServ__FinancialAccountRole__c> roles = new List<FinServ__FinancialAccountRole__c>();
            for(FinServ__FinancialAccountRole__c rol : this.newList){
                if (rol.FinServ__Role__c == CRAS_ICA_ASS_Helpers_CLS.SEGUROS_ROL_TOMADOR){
                    roles.add(rol);
                }
            }
            CRAS_ICA_ASS_FALogicHandler_CLS.setOwners(roles);
        }
    } 
    
    private Boolean isInsurance(){
        for (FinServ__FinancialAccountRole__c role : this.newList){
            if (String.isNotBlank(role.CRAS_ICA_ASS_T_AxisFARoleID__c)){
                return true; 
            }
        }  
        return false;
    }

    private void preventAccion()
    {
        this.doAccion = false;
    }

    private void AllowAccion()
    {
        this.doAccion = true;
    }
}