public class CRAN_ICA_KER_ChangeOwners_Batch implements Database.Batchable<sObject>, Database.Stateful{
	private Integer currentChain;
    
    public CRAN_ICA_KER_ChangeOwners_Batch(){
        currentChain = 3;
    }
    
    public CRAN_ICA_KER_ChangeOwners_Batch(Integer Type){
        currentChain = Type;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        String qry;
        
        if(currentChain == 3)
        {
            qry = 'SELECT Id, CRAN_VEC_ADV_L_MainMngr__c, OwnerId FROM Account WHERE CRAN_VEC_ADV_L_MainMngr__c = null AND CRAS_ICA_ASS_T_AxisBPID__c != \'\'';
        }
        else if(currentChain == 4)
        {
            qry = 'SELECT Id, FinServ__PrimaryOwner__c, FinServ__PrimaryOwner__r.OwnerId, FinServ__PrimaryOwner__r.CRAN_VEC_ADV_L_MainMngr__c, OwnerId FROM FinServ__FinancialAccount__c WHERE CRAS_ICA_ASS_T_AxisFAID__c != \'\'';
        }
        return Database.getQueryLocator(qry);
    }
     
    public void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        if (currentChain == 3){
            List<Account> accLst = new List<Account>();
            for (SObject s: scope){
                Account a = (Account)s;
                a.CRAN_VEC_ADV_L_MainMngr__c = a.OwnerId;
                accLst.add(a);
            }
            update accLst;
        }
        else if (currentChain == 4){
            Id DummyManagerId = CRAS_ICA_ASS_Helpers_CLS.getDummyManagerUserID();
        	Id CreditAndorraId = CRAS_ICA_ASS_Helpers_CLS.getCAUserID();
            
            Map<Id, Id> mapBpOwnerLst = new Map<Id, Id>();
            List<Id> bpIdsLst = new List<Id>();
            for (FinServ__FinancialAccount__c s: (List<FinServ__FinancialAccount__c>)scope){
                Id owner = getOwnerId(s.FinServ__PrimaryOwner__r.OwnerId, 
                                      s.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_L_MainMngr__c,
                                      s.OwnerId,
                                      DummyManagerId,
                                      CreditAndorraId);
                mapBpOwnerLst.put(s.FinServ__PrimaryOwner__c, owner);
                bpIdsLst.add(s.FinServ__PrimaryOwner__c);
                s.OwnerId = owner;
            }
            update scope;
            
            List<Account> bpList = [SELECT Id, OwnerId, CRAN_VEC_ADV_L_MainMngr__c FROM Account WHERE Id IN :bpIdsLst];
            for (Account a: bpList){
                a.OwnerId = mapBpOwnerLst.get(a.Id);
                a.CRAN_VEC_ADV_L_MainMngr__c = mapBpOwnerLst.get(a.Id);
            }
            update bpList;
        }
    }
     
    public void finish(Database.BatchableContext BC)
    {

    }
    
    private static Id getOwnerId(Id BPId, ID MainManagerId, ID FAOwnerId, Id DummyManagerId, Id CreditAndorraId){
        Map<Id, String> dummyIds = new Map<Id, String>{ DummyManagerId => 'Dummy Manager', CreditAndorraId => 'Credit Andorra' };
        
        if ((!dummyIds.containsKey(BPId) && !dummyIds.containsKey(MainManagerId) && !dummyIds.containsKey(FAOwnerId)) ||
           	!dummyIds.containsKey(MainManagerId))
        {
            return MainManagerId;
        }
        else if (!dummyIds.containsKey(FAOwnerId)){
            return FAOwnerId;
        }
        else if (!dummyIds.containsKey(BPId)){
            return BPId;
        }
        else if (BPId == DummyManagerId || MainManagerId == DummyManagerId || FAOwnerId == DummyManagerId){
            return DummyManagerId;
        }
        else {
            return CreditAndorraId;
        }
    }
}