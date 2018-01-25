public class CRAS_ICA_ASS_CleanFullData_Batch implements Database.Batchable<sObject>, Database.Stateful {
	private Integer currentChain;
 
    public CRAS_ICA_ASS_CleanFullData_Batch()
    {
    	currentChain = 1;
    }
     
    public CRAS_ICA_ASS_CleanFullData_Batch(Integer chain)
    {
    	currentChain = chain;
    }
     
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
    	String qry;
        
        if(currentChain == 1)
        {
        	qry = 'Select Id From CRAS_ICA_ASS_Invoice__c'; 
        }

		else if(currentChain == 2)
        {
        	qry = 'Select Id From CRAS_ICA_ASS_FA_PremiumHistory__c';
        }
        
        else if(currentChain == 3)
        {
        	qry = 'Select Id From CRAS_ICA_ASS_ClaimAmountHistory__c';
        }
        
        else if(currentChain == 4)
        {
        	qry = 'Select Id From CRAS_ICA_ASS_ClaimsPctHistory__c';
        }

        else if(currentChain == 5)
        {
        	qry = 'Select Id From CRAN_VEC_ADV_CustomForm_Response__c';
        }
        else if(currentChain == 6)
        {
            qry = 'Select Id From CampaignInfluence';
        }
        else if(currentChain == 7)
        {
            qry = 'Select Id From Opportunity';
        }
        else if(currentChain == 8)
        {
        	qry = 'Select Id From FinServ__FinancialHolding__c';
        }
        else if(currentChain == 9)
        {
            qry = 'Select Id From FinServ__FinancialAccountRole__c';
        }
        else if(currentChain == 10)
        {
            qry = 'Select Id From CRAN_ICA_KER_FinancialMovement__c';
        }
        else if(currentChain == 11)
        {
            qry = 'Select Id From FinServ__FinancialAccount__c';
        }
        else if(currentChain == 12)
        {
            qry = 'Select Id From Account';
        }
        else if(currentChain == 13)
        {
            qry = 'Select Id From Contact';
        }
        else if(currentChain == 14)
        {
            qry = 'Select Id From FinServ__Securities__c';
        }
        else if(currentChain == 15)
        {
            qry = 'Select Id From FinServ__AssetsAndLiabilities__c';
        }        
        else if(currentChain == 16)
        {
            qry = 'Select Id From CampaignMember';
        }
        else if(currentChain == 17)
        {
            qry = 'Select Id From Campaign';
        }
        
     
    	return Database.getQueryLocator(qry);
    }
     
    public void execute(Database.BatchableContext BC, List<sObject> scope)
    {
    	delete scope;
    }
     
    public void finish(Database.BatchableContext BC)
    {
    	if(currentChain < 17)
        {
            CRAS_ICA_ASS_CleanFullData_Batch cleanBatch = new CRAS_ICA_ASS_CleanFullData_Batch(currentChain + 1);
            Database.executeBatch(cleanBatch, 2000);
        }
    	else 
        {
            System.debug('FIN');
        }
    }
}