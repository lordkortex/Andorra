public class CRAN_ICA_KER_ChangeIdentityCntcAcc_Batch implements Database.Batchable<sObject>, Database.Stateful {
	
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator([SELECT Id, CRAN_ICA_KER_P_Identity__c, (SELECT Id, CRAN_ICA_KER_P_Identity__c FROM Contacts) 
                                         FROM Account 
                                         WHERE FinServ__PrimaryContact__c != null]);
    }
     
    public void execute(Database.BatchableContext BC, List<Account> scope)
    {
        List<Account> accUpdate = new List<Account>();
        for(Account acc : scope)
        {
            if(acc.Contacts.Size() > 0)
            {
                if(acc.Contacts[0].CRAN_ICA_KER_P_Identity__c != acc.CRAN_ICA_KER_P_Identity__c)
                {
                    acc.CRAN_ICA_KER_P_Identity__c = acc.Contacts[0].CRAN_ICA_KER_P_Identity__c;
                    accUpdate.add(acc);
                }
            }
        }
        
        update accUpdate;
    }
     
    public void finish(Database.BatchableContext BC)
    {

    }
}