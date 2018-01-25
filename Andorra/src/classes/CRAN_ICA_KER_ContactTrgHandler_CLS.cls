public class CRAN_ICA_KER_ContactTrgHandler_CLS extends TriggerHandler 
{
    private Map<Id, Contact> newMap;
    private Map<Id, Contact> oldMap;
    private List<Contact> newList;
    private List<Contact> oldList;
    
    public CRAN_ICA_KER_ContactTrgHandler_CLS(SObjectType objectType) 
    {
        super(objectType);
        this.newMap = (Map<id, Contact>) Trigger.newMap;
        this.oldMap = (Map<id, Contact>) Trigger.oldMap;
        this.newList  = (List<Contact>) Trigger.new;
        this.oldList  = (List<Contact>) Trigger.old;
    }
    
    public override void afterInsert() 
    {
        upsertContact();
    }
    
    public override void afterUpdate() 
    {
        upsertContact();
        
        List<Id> conctListId = new List<Id> ();
        for(Id keyMap : this.newMap.keySet())
        {
            if(String.isNotBlank(this.newMap.get(keyMap).CRAS_ICA_ASS_T_AxisPersonID__c) && 
                String.isBlank(this.oldMap.get(keyMap).CRAS_ICA_ASS_T_AxisPersonID__c) && 
                String.isNotBlank(this.newMap.get(keyMap).CRAN_VEC_ADV_N_NumericSort__c))
            {
                conctListId.add(this.newMap.get(keyMap).Id);
            }
        }
        
        if(conctListId.size() > 0)
        {
            CRAN_ICA_KER_ContactFutureHandler_CLS.squashContact(conctListId);
        } 
    }

    
    private void upsertContact(){
        if(isInsurance())
        {
            List<Id> idsList = new List<Id>();
            
            for(Contact conct : this.newList){
                idsList.add(conct.Id);
            }
            
            CRAN_ICA_KER_ContactFutureHandler_CLS.setIdentity(idsList);
        }
        
    }
    
    private Boolean isInsurance(){
        for (Contact cont : this.newList){
            if (String.isNotBlank(cont.CRAS_ICA_ASS_T_AxisPersonID__c)){
                return true; 
            }
        }  
        return false;
    }
}