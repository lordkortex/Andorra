@isTest
private class CRAN_VEC_ADV_QuoteSync_TST {
	@testSetup
	static void loadTestData() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
	}

	@isTest static void testGetQuote() {
		Quote quot = [SELECT Id FROM QUOTE LIMIT 1];
		CRAN_VEC_ADV_QuoteSync_AUC.QuoteMessage(quot.Id);
	}
}