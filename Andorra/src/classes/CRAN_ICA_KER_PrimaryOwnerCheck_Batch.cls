public class CRAN_ICA_KER_PrimaryOwnerCheck_Batch implements Database.Batchable<sObject>, Database.Stateful {
    //CRAN_ICA_KER_PrimaryOwnerCheck_Batch batch = new CRAN_ICA_KER_PrimaryOwnerCheck_Batch();
	//Database.executeBatch(batch, 2000);
    
    public CRAN_ICA_KER_PrimaryOwnerCheck_Batch()
    {
        
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT Id, FinServ__PrimaryOwner__c 
                                         FROM FinServ__FinancialAccount__c 
                                         WHERE Id NOT IN (SELECT FinServ__FinancialAccount__c  
                                                          FROM FinServ__FinancialAccountRole__c 
                                                          WHERE FinServ__Role__c = 'Primary Owner')]);
        
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        List<FinServ__FinancialAccountRole__c> lstRel = new List<FinServ__FinancialAccountRole__c>();

        For (FinServ__FinancialAccount__c fa : (List<FinServ__FinancialAccount__c>) scope){
            FinServ__FinancialAccountRole__c rel = new FinServ__FinancialAccountRole__c();
            rel.FinServ__RelatedAccount__c = fa.FinServ__PrimaryOwner__c;
            rel.FinServ__FinancialAccount__c = fa.Id;
            rel.FinServ__Role__c = 'Primary Owner';
            lstRel.add(rel);
        }
        
        insert lstRel;
        
    }
    
    public void finish(Database.BatchableContext BC)
    {
      
    }

}