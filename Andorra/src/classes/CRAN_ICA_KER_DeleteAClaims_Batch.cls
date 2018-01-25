public class CRAN_ICA_KER_DeleteAClaims_Batch implements Database.Batchable<sObject>, Database.Stateful {
    private Integer currentChain;
 
    public CRAN_ICA_KER_DeleteAClaims_Batch()
    {
        currentChain = 1;
    }
    
    public CRAN_ICA_KER_DeleteAClaims_Batch(Integer chain)
    {
        currentChain = chain;
    }
     
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        Database.QueryLocator query;
        
        if(currentChain == 1)
        {
            query = Database.getQueryLocator([Select Id From CRAS_ICA_ASS_Invoice__c]);
        }
        else if(currentChain == 2)
        {
            query = Database.getQueryLocator([Select Id From CRAS_ICA_ASS_ClaimsPctHistory__c]);
        }
        else if(currentChain == 3)
        {
            query = Database.getQueryLocator([Select Id, FinServ__PrimaryOwner__c 
                                              From FinServ__FinancialAccount__c 
                                              WHERE CRAS_ICA_ASS_T_SolicitudAxisID__c != null]);
        }
        else if(currentChain == 4)
        {
            query = Database.getQueryLocator([Select Id, CRAS_ICA_ASS_N_NumUnpaidInvoices__c 
                                              From FinServ__FinancialAccount__c 
                                              WHERE CRAS_ICA_ASS_N_NumUnpaidInvoices__c > 0]);
        }
     
        return query;
    }
     
    public void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        if(currentChain == 3)
        {
            List<Account> accLst = new List<Account>();
            
            for(FinServ__FinancialAccount__c fA : (List<FinServ__FinancialAccount__c>) scope)
            {
                accLst.add(new Account(Id = fA.FinServ__PrimaryOwner__c));
            }
            
            delete scope;
            delete accLst;
        }
        else if(currentChain == 4)
        {
            for (FinServ__FinancialAccount__c fA : (List<FinServ__FinancialAccount__c>)scope)
            {
                fa.CRAS_ICA_ASS_N_NumUnpaidInvoices__c = 0;
            }
            
            update scope;
        }
        
        else
        {
            
            delete scope;
        }
    }
     
    public void finish(Database.BatchableContext BC)
    {
        if(currentChain < 4)
        {
            CRAN_ICA_KER_DeleteAClaims_Batch cleanBatch = new CRAN_ICA_KER_DeleteAClaims_Batch(currentChain + 1);
            Database.executeBatch(cleanBatch, 2000);
        }
        else 
        {
            System.debug('FIN');
        }
    }
}