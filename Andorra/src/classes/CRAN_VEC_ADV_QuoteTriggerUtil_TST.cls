@isTest
private class CRAN_VEC_ADV_QuoteTriggerUtil_TST {

	@testSetup
	static void loadTestData() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();
		Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
	}
	
	@isTest static void quoteWithFinalCheck() {
		RecordType advQuoteRecTyp = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Quote' AND DeveloperName='CRAN_VEC_ADV_Invt_Prop'];
		Opportunity opp = [SELECT Id, StageName,CRAN_VEC_ADV_F_isNotEdit__c FROM Opportunity LIMIT 1];
		Quote myQuote = new Quote(CRAN_VEC_ADV_P_Quote_ID__c = '2223', Name = 'nameOpportunity', CRAN_VEC_ADV_N_Version__c = 1, OpportunityId = opp.Id, CRAN_VEC_ADV_P_Currency__c = 'AFN', CRAN_VEC_ADV_N_InvAmount__c = 20, CRAN_VEC_ADV_D_StartDate__c = Date.today(), CRAN_VEC_ADV_B_OverrideAll__c = false, CRAN_VEC_ADV_B_Final__c = true, CRAN_VEC_ADV_B_FinalBK__c = true, CRAN_VEC_ADV_P_CurrencyBK__c = 'ALL', CRAN_VEC_ADV_N_InvAmountBK__c = 20, RecordTypeId = advQuoteRecTyp.Id);
        insert myQuote;
        Quote quote = [SELECT CRAN_VEC_ADV_B_Final__c FROM Quote WHERE CRAN_VEC_ADV_B_Final__c = false LIMIT 1];
        quote.CRAN_VEC_ADV_B_Final__c = true;
        update quote;
	}
	
	@isTest static void quoteOverrideRestr() {
		Quote quote = [SELECT Id, CRAN_VEC_ADV_B_OverrideAll__c FROM Quote LIMIT 1];
		quote.CRAN_VEC_ADV_B_OverrideAll__c = true;
		update quote;
	}
	
}