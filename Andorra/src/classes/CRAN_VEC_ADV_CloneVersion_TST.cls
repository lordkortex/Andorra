@isTest
private class CRAN_VEC_ADV_CloneVersion_TST {

	@testSetup
	static void loadTestData() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c LIMIT 1];
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
	}

	@isTest static void cloneVersionNotHavingGoodStage() {
		Quote quote = [SELECT Id, Name,CRAN_VEC_ADV_F_StageName__c,OpportunityId FROM Quote LIMIT 1];
		Opportunity opp = [SELECT Id, StageName,CRAN_VEC_ADV_F_isNotEdit__c FROM Opportunity WHERE Id =: quote.OpportunityId];
		opp.StageName = 'advClosed';
		//update opp;
		ApexPages.StandardController sc = new ApexPages.StandardController(quote);
		ApexPages.currentPage().getParameters().put('noShow',quote.CRAN_VEC_ADV_F_StageName__c);
		CRAN_VEC_ADV_CloneVersion_CTR newCloneController = new CRAN_VEC_ADV_CloneVersion_CTR(sc);
		Test.startTest();
		PageReference pageRef = Page.CRAN_VEC_ADV_CloneVersion;
        Test.setCurrentPage(pageRef);
        newCloneController.cloneQuote();
        Test.stopTest();
	}

	@isTest static void cloneVersionHavingGoodStage() {
		Quote quote = [SELECT Id, Name,CRAN_VEC_ADV_F_StageName__c,OpportunityId FROM Quote LIMIT 1];
		Opportunity opp = [SELECT Id, StageName FROM Opportunity WHERE Id =: quote.OpportunityId];
		opp.StageName = 'advOpen';
		update opp;
		quote = [SELECT Id, Name,CRAN_VEC_ADV_F_StageName__c,OpportunityId FROM Quote LIMIT 1];
		ApexPages.StandardController sc = new ApexPages.StandardController(quote);
		ApexPages.currentPage().getParameters().put('noShow',quote.CRAN_VEC_ADV_F_StageName__c);
		CRAN_VEC_ADV_CloneVersion_CTR newCloneController = new CRAN_VEC_ADV_CloneVersion_CTR(sc);

		PageReference pageRef = Page.CRAN_VEC_ADV_CloneVersion;
        Test.setCurrentPage(pageRef);
        newCloneController.cloneQuote();
	}

}