@isTest
private class CRAN_VEC_ADV_ReportResultsController_TST {

	@isTest 
    static void reportResultsWithOpportunities() {
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
        Contact mainContact = dataFactory.createIndividualContactWithTwoBps();
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
        String recordId = finAcc.Id;
        String nKey = 'FinServ__FinancialAccount__c';
        String objectName = 'Opportunity';
        CRAN_VEC_ADV_ReportResultsController_AUC.DataList(recordId, nKey, '',objectName);
	}

   	@isTest 
    static void reportResultsWithQuotes() {
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
        Contact mainContact = dataFactory.createIndividualContactWithTwoBps();
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
        Opportunity opp = dataFactory.createOppForRelatedLists(finAcc.Id, accBP.Id);
        String recordId = opp.Id;
        String nKey = 'OpportunityId';
        String objectName = 'Quote';
        CRAN_VEC_ADV_ReportResultsController_AUC.DataList(recordId, nKey, '',objectName);
	}

	/*    
	@isTest 
    static void reportResultsWithIPLs() {
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
        Contact mainContact = dataFactory.createIndividualContactWithTwoBps();
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
        Opportunity opp = dataFactory.createOppForRelatedLists(finAcc.Id, accBP.Id);
		Quote qte = [SELECT Id, OpportunityId FROM Quote WHERE OpportunityId =: opp.Id];
        String recordId  = qte.Id;
        String nKey      = 'CRAN_VEC_ADV_L_Version__c';
        String objectName='CRAN_VEC_ADV_Investment_Proposition_Line__c';		
        CRAN_VEC_ADV_ReportResultsController_AUC.DataList(recordId, nKey, '',objectName);
	}
    */
    
	@isTest 
    static void reportResultsWithRestrictions() {		
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
        Contact mainContact = dataFactory.createIndividualContactWithTwoBps();
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
        Opportunity opp = dataFactory.createOppForRelatedLists(finAcc.Id, accBP.Id);
		Quote qte = [SELECT Id, OpportunityId FROM Quote WHERE OpportunityId =: opp.Id];
        String recordId  = qte.Id;
        String nKey      = 'CRAN_VEC_ADV_L_Version__c';
        String objectName='CRAN_VEC_ADV_IPL_Restriction__c';		
        CRAN_VEC_ADV_ReportResultsController_AUC.DataList(recordId, nKey, '',objectName);
	}   


    @isTest 
    static void CRAN_VEC_ADV_showHeader_TST() {
        
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
        Account myAccount = dataFactory.createBPAccount();
        FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);
        Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

        Test.startTest();
        String temp = CRAN_VEC_ADV_ReportResultsController_AUC.showHeader(myOpportunity.Id);

        Test.stopTest();
    }

    /*@isTest 
    static void reportResultsWithOrders() {
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
        Contact mainContact = dataFactory.createIndividualContactWithTwoBps();
        Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
        FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
        Opportunity opp = dataFactory.createOppForRelatedLists(finAcc.Id, accBP.Id);
        String recordId = opp.Id;
        String nKey = 'OpportunityId';
        String objectName = 'Order';
        dataFactory.createrOrder();
        CRAN_VEC_ADV_ReportResultsController_AUC.DataList(recordId, nKey, 'FX',objectName);
    } */

}