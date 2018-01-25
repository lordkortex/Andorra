public with sharing class CRAN_VEC_ADV_FARoleTriggerHandler_CLS extends CRAN_VEC_KER_TriggerHandler_CLS{
  
    private Map<Id, FinServ__FinancialAccountRole__c> newMap;
    private Map<Id, FinServ__FinancialAccountRole__c> oldMap;
    private List<FinServ__FinancialAccountRole__c> newList;
    private List<FinServ__FinancialAccountRole__c> oldList;
    private Boolean doAccion = true;
    
    public CRAN_VEC_ADV_FARoleTriggerHandler_CLS(SObjectType objectType) {
        super(objectType);
        this.newMap = (Map<id, FinServ__FinancialAccountRole__c>) Trigger.newMap;
        this.oldMap = (Map<id, FinServ__FinancialAccountRole__c>) Trigger.oldMap;
        this.newList  = (List<FinServ__FinancialAccountRole__c>) Trigger.new;
        this.oldList  = (List<FinServ__FinancialAccountRole__c>) Trigger.old;
    }
    
    public override void beforeInsert() 
    {
        if (!isInsurance()){
        	bInsert();
        }
    }
    
    public override void beforeUpdate()
    {
        if (doAccion && !isInsurance()) 
        {
            preventAccion();
            CRAN_VEC_ADV_FinancialAccountRoleUtil.updateCloneFinancialAccountRoles((List<FinServ__FinancialAccountRole__c>)Trigger.new,(List<FinServ__FinancialAccountRole__c>)Trigger.old);
            AllowAccion();
        }
    }
    
    public override void afterUpdate()
    {
        if (doAccion && !isInsurance()) 
        {
            preventAccion();
            CRAN_VEC_ADV_FinancialAccountRoleUtil.updateAfterFinancialclone(newList,oldList);
            CRAN_VEC_ADV_FinancialAccountRoleUtil.deleteParent();
            AllowAccion();
        }
        
    }
    
    public override void afterDelete(){
        if (doAccion) 
        { 
            CRAN_VEC_ADV_FinancialAccountRoleUtil.deleteCloneFinancialAccountRoles((List<FinServ__FinancialAccountRole__c>)Trigger.old);
            AllowAccion();
        }
    }
    
    public override void afterUndelete(){
        if (doAccion) 
        { 
        	CRAN_VEC_ADV_FinancialAccountRoleUtil.undeleteCloneFinancialAccountRoles((List<FinServ__FinancialAccountRole__c>)Trigger.new); 
        }
    }
    
    private void bInsert()
    {
        if (doAccion)  
        {
            CRAN_VEC_ADV_FinancialAccountRoleUtil.createFinancialAccountRoles(newList);
        }
    }
    
    private void preventAccion()
    {
        this.doAccion = false;
    }
    
    private void AllowAccion()
    {
        this.doAccion = true;
    }
    
    private Boolean isInsurance(){
        for (FinServ__FinancialAccountRole__c role : this.newList){
            if (String.isNotBlank(role.CRAS_ICA_ASS_T_AxisFARoleID__c)){
                return true; 
            }else{
              	return false;  
            }
        }  
        return false;
    }
}