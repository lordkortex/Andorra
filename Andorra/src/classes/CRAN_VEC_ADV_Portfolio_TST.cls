@isTest
private class CRAN_VEC_ADV_Portfolio_TST {


	@testSetup 
	static void loadTestData() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFactory.createAvaloqSetting();
		Contact c = dataFactory.createIndividualContactWithTwoBps();

		dataFactory.createSecurities();
	}
	
	@isTest 
	static void CRAN_VEC_ADV_PortFolio_Account_BP() {
		Account testAccountBP = [SELECT Id FROM Account WHERE RecordType.DeveloperName=:CRAN_VEC_ADV_TestDataFactory_TST.Account_BusinessPartner_Name AND CRAN_VEC_ADV_T_BPId__c ='9_9000001' LIMIT 1];
		ApexPages.StandardController sc = new ApexPages.StandardController(testAccountBP);

		PageReference pageRef = Page.CRAN_VEC_ADV_Portfolio;
        pageRef.getParameters().put('id', String.valueOf(sc.getId()));
        
        Test.setCurrentPage(pageRef);
        CRAN_VEC_ADV_Portfolio_CTR newPFController = new CRAN_VEC_ADV_Portfolio_CTR(sc);

        Test.startTest();
        Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST(CRAN_VEC_ADV_Constants_CLS.SERVICE_PORTFOLIO));
        newPFController.refreshPortfolio();
        Test.stopTest();
	}

	@isTest 
	static void CRAN_VEC_ADV_PortFolio_Account_Person() {
		Account testAccountPerson = [SELECT Id,
											CRAN_VEC_ADV_T_BPId__c,
											CRAN_VEC_ADV_P_Bunit__c
									 FROM Account WHERE RecordType.DeveloperName=:CRAN_VEC_ADV_TestDataFactory_TST.Account_IndividualCA_Name LIMIT 1];
		ApexPages.StandardController sc = new ApexPages.StandardController(testAccountPerson);

		PageReference pageRef = Page.CRAN_VEC_ADV_Portfolio;
        pageRef.getParameters().put('id', String.valueOf(sc.getId()));
        
        Test.setCurrentPage(pageRef);
        CRAN_VEC_ADV_Portfolio_CTR newPFController = new CRAN_VEC_ADV_Portfolio_CTR(sc);

        Test.startTest();
        Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST('portfolio'));
        newPFController.refreshPortfolio();
        Test.stopTest();	
	}

	@isTest 
	static void CRAN_VEC_ADV_PortFolio_FinancialAccount() {
		FinServ__FinancialAccount__c testFA = [SELECT 	Id,
														CRAN_VEC_DEV_T_ContainerID__c,
                                                 		CRAN_VEC_ADV_P_Bunit__c,
                                                 		FinServ__PrimaryOwner__c
                                                FROM FinServ__FinancialAccount__c WHERE RecordType.DeveloperName=:CRAN_VEC_ADV_TestDataFactory_TST.FA_Container_Name LIMIT 1];
		ApexPages.StandardController sc = new ApexPages.StandardController(testFA);

		PageReference pageRef = Page.CRAN_VEC_ADV_Portfolio;
        pageRef.getParameters().put('id', String.valueOf(sc.getId()));
        
        Test.setCurrentPage(pageRef);
        CRAN_VEC_ADV_Portfolio_CTR newPFController = new CRAN_VEC_ADV_Portfolio_CTR(sc);
		
        Test.startTest();
        Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST('portfolio'));
        newPFController.refreshPortfolio();
        Test.stopTest();
	}

	
}