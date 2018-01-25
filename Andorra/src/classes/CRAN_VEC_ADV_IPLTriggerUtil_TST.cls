@isTest
private class CRAN_VEC_ADV_IPLTriggerUtil_TST {

	@testSetup
	static void loadTestData() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact mainContact = dataFactory.createIndividualContactWithTwoBps();
        Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
		FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c WHERE
		                                       Name = 'Test Finacial Account' LIMIT 1];
		Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
	}

	@isTest static void testInsertNoFieldSelected() {
		Quote quot = [SELECT Id FROM QUOTE LIMIT 1];
		FinServ__Securities__c asset = new FinServ__Securities__c(Name = 'Security',
		        FinServ__SecuritiesName__c = 'Security ', FinServ__SourceSystemId__c = '9_');
		insert asset;
		Test.startTest();
		CRAN_VEC_ADV_Investment_Proposition_Line__c ipl =
		    new CRAN_VEC_ADV_Investment_Proposition_Line__c();
		ipl.CRAN_VEC_ADV_N_PercentQtty__c = 100;
		ipl.CRAN_VEC_ADV_N_PropQtty__c = 100;
		CRAN_VEC_ADV_NewIPL_AUC.saveIPL(ipl, quot.Id, asset.Id, null,null,null );
		Test.stopTest();
	}

    @isTest static void testInsertNoFieldChangedByUserSelected() {
		Quote quot = [SELECT Id FROM QUOTE LIMIT 1];
		FinServ__Securities__c asset = new FinServ__Securities__c(Name = 'Security',
		        FinServ__SecuritiesName__c = 'Security ', FinServ__SourceSystemId__c = '9_');
		insert asset;
		CRAN_VEC_ADV_Investment_Proposition_Line__c ipl =
		    new CRAN_VEC_ADV_Investment_Proposition_Line__c();
		ipl.CRAN_VEC_ADV_N_PercentQtty__c = 100;
		ipl.CRAN_VEC_ADV_N_PropQtty__c = 100;
		CRAN_VEC_ADV_NewIPL_AUC.saveIPL(ipl, quot.Id, asset.Id, 57,null,null );
		CRAN_VEC_ADV_Investment_Proposition_Line__c ipl2 = 
		[SELECT Id, CRAN_VEC_ADV_N_PercentQtty__c,CRAN_VEC_ADV_N_PropQtty__c,CRAN_VEC_ADV_B_isEdit__c  FROM CRAN_VEC_ADV_Investment_Proposition_Line__c 
		 LIMIT 1 ];
		Test.startTest();
		ipl2.CRAN_VEC_ADV_N_PercentQtty__c = 99;
        ipl2.CRAN_VEC_ADV_N_PropQtty__c = 99;
		ipl2.CRAN_VEC_ADV_B_isEdit__c = true;
		ipl2.CRAN_VEC_ADV_B_IsService__c = true;
        ipl2.CRAN_VEC_ADV_FieldChangedbyUser__c = null;
		update ipl2;
		Test.stopTest();
	}


	@isTest static void testUpdateOK() {
		Quote quot = [SELECT Id FROM QUOTE LIMIT 1];
		FinServ__Securities__c asset = new FinServ__Securities__c(Name = 'Security',
		        FinServ__SecuritiesName__c = 'Security ', FinServ__SourceSystemId__c = '9_');
		insert asset;
		CRAN_VEC_ADV_Investment_Proposition_Line__c ipl =
		    new CRAN_VEC_ADV_Investment_Proposition_Line__c();
		ipl.CRAN_VEC_ADV_N_PercentQtty__c = 100;
		ipl.CRAN_VEC_ADV_N_PropQtty__c = 100;
		CRAN_VEC_ADV_NewIPL_AUC.saveIPL(ipl, quot.Id, asset.Id, 57,null,null );
		CRAN_VEC_ADV_Investment_Proposition_Line__c ipl2 = 
		[SELECT Id, CRAN_VEC_ADV_N_PercentQtty__c,CRAN_VEC_ADV_B_isEdit__c  FROM CRAN_VEC_ADV_Investment_Proposition_Line__c 
		 LIMIT 1 ];
		Test.startTest();
		ipl2.CRAN_VEC_ADV_N_PercentQtty__c = 99;
		ipl2.CRAN_VEC_ADV_B_isEdit__c = true;
		ipl2.CRAN_VEC_ADV_B_IsService__c = true;
		update ipl2;
		Test.stopTest();
	}
}