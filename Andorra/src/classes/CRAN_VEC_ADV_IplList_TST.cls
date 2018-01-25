@isTest
public class CRAN_VEC_ADV_IplList_TST {

	@isTest 
    static void iplList() {
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
        CRAN_VEC_ADV_IplList_AUC.DataList(recordId, nKey, '',objectName);
	}

    @isTest 
    static void CRAN_VEC_ADV_showHeader_TST() {        
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
        Account myAccount = dataFactory.createBPAccount();
        FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);
        Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);
        Test.startTest();
        String temp =  CRAN_VEC_ADV_IplList_AUC.showHeader(myOpportunity.Id);
        Test.stopTest();
    }

}