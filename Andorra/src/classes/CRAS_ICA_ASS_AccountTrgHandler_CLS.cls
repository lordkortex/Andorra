public class CRAS_ICA_ASS_AccountTrgHandler_CLS extends TriggerHandler 
{
    private Map<Id, Account> newMap;
    private Map<Id, Account> oldMap;
    private List<Account> newList;
    private List<Account> oldList;
    
    public CRAS_ICA_ASS_AccountTrgHandler_CLS(SObjectType objectType) 
    {
        super(objectType);
        this.newMap = (Map<id, Account>) Trigger.newMap;
        this.oldMap = (Map<id, Account>) Trigger.oldMap;
        this.newList  = (List<Account>) Trigger.new;
        this.oldList  = (List<Account>) Trigger.old;
    }
    
    public override void beforeInsert() 
    {
        if(isInsuranceBP())
        {
            for(Account acc :this.newList)
            {
                if (acc.CRAN_ICA_KER_P_Identity__c != CRAS_ICA_ASS_Helpers_CLS.IDENTITY_SEGUROS_DIRECCION_RESTRINGIDO){
                    acc.CRAN_ICA_KER_P_Identity__c = CRAS_ICA_ASS_Helpers_CLS.IDENTITY_SEGUROS_DIRECCION;
                }                
            }  
        }  
    }
    
    public override void afterUpdate() 
    {
        Set<Id> idsAccount = new Set<Id>();
        
        for(Integer i = 0; i < this.newList.size(); i++)
        {
            if(String.isNotBlank(this.newList[i].CRAN_VEC_ADV_T_BPId__c) && this.newList[i].CRAN_ICA_KER_P_Oficina__c != this.oldList[i].CRAN_ICA_KER_P_Oficina__c && String.isBlank(this.newList[i].CRAS_ICA_ASS_T_AxisBPID__c))
            {
                idsAccount.add(this.newList[i].Id);
            }
        }
        
        List<Id> idsAccountList = new List<Id>();
        idsAccountList.addAll(idsAccount);
        
        if(idsAccountList.size() != 0)
        {
            CRAS_ICA_ASS_AccountFutureHandler_CLS.changeOffice(idsAccountList);
        }
    }
    
    private Boolean isInsuranceBP(){
        for (Account acc : this.newList){
            if (String.isNotBlank(acc.CRAS_ICA_ASS_T_AxisBPID__c)){
                return true; 
            }
        }
        return false;
    }
}