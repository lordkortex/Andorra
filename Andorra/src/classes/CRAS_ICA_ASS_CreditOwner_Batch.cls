public class CRAS_ICA_ASS_CreditOwner_Batch implements Database.Batchable<sObject>, Database.Stateful {
    private Integer currentChain;
    private String body;
    private String name;
    private Integer count = 0;
    private Integer fichero = 0;
    
    public CRAS_ICA_ASS_CreditOwner_Batch()
    {
        this.currentChain = 1;
        this.body = '"Account Number";"AxisId";"AvaloqId"\n';
        this.name = CRAS_ICA_ASS_Helpers_CLS.DateNow() + ' -FA';
    }
    
    public CRAS_ICA_ASS_CreditOwner_Batch(Integer chain)
    {
        this.currentChain = chain;
        this.body = '"Account Number";"AxisBPId";"AvaloqBPId"\n';
        this.name = CRAS_ICA_ASS_Helpers_CLS.DateNow() + ' -BP';
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC)
    {
        if(this.currentChain == 1)
        {
            return Database.getQueryLocator([Select Name, CRAS_ICA_ASS_T_AxisFAID__c, 
                                             FinServ__FinancialAccountNumber__c, CRAN_VEC_DEV_T_ContainerID__c
                                             FROM FinServ__FinancialAccount__c 
                                             WHERE OwnerId IN (Select Id FROM User WHERE LastName Like '%Andorrà%')]);
        }
        else
        {
            return Database.getQueryLocator([Select Name, CRAN_VEC_ADV_T_BPId__c, 
                                             AccountNumber, CRAS_ICA_ASS_T_AxisBPID__c
                                             FROM Account 
                                             WHERE OwnerId IN (Select Id FROM User WHERE LastName Like '%Andorrà%') 
                                             AND (CRAS_ICA_ASS_T_AxisBPID__c != '' OR CRAN_VEC_ADV_T_BPId__c != '')]);
        }
        
    }
    
    public void execute(Database.BatchableContext BC, List<sObject> scope)
    {
        if(this.currentChain == 1)
        {
            for(FinServ__FinancialAccount__c fA : (List<FinServ__FinancialAccount__c>) scope)
            {
                this.count++;
                this.body += '"' + fA.FinServ__FinancialAccountNumber__c + '";"' + fA.CRAS_ICA_ASS_T_AxisFAID__c + '";"' + fA.CRAN_VEC_DEV_T_ContainerID__c + '"\n';
            }
        }
        
        else if(this.currentChain == 2)
        {
            for(Account acc : (List<Account>) scope)
            {
                this.count++;
                this.body += '"' + acc.AccountNumber + '";"' + acc.CRAS_ICA_ASS_T_AxisBPID__c + '";"' + acc.CRAN_VEC_ADV_T_BPId__c + '"\n';
            }
        }
        
        if(this.count > 30000)
        {
            Document reportFile= new Document();
            
            reportFile.folderid = UserInfo.getUserId();
            reportFile.Body = Blob.valueOf(this.body);
            reportFile.Name = this.name + this.fichero++ + '.csv';
            
            insert reportFile;
            
            if(this.currentChain == 1)
            {
                this.count = 0;
            	this.body = '"Account Number";"AxisBPId";"AvaloqBPId"\n';
            }
            
            else if(this.currentChain == 2)
            {
                this.count = 0;
            	this.body = '"Account Number";"AxisId";"AvaloqId"\n';
            }
            
        }
        
        
    }
    
    public void finish(Database.BatchableContext BC)
    {
        if(this.count > 0)
        {
            Document reportFile= new Document();
            
            reportFile.folderid = UserInfo.getUserId();
            reportFile.Body = Blob.valueOf(this.body);
            reportFile.Name = this.name + this.fichero++ + '.csv';
            
            insert reportFile;
        }
        
        if(this.currentChain != 2)
        {
            CRAS_ICA_ASS_CreditOwner_Batch reportBatch = new CRAS_ICA_ASS_CreditOwner_Batch(currentChain + 1);
        	Database.executeBatch(reportBatch, 2000);
        }
     
    }
}