@isTest
private class CRAN_VEC_ADV_SignProp_TST {
    /**
    * Action para el boton de sign del Componente Lightning.
    * 
    */
   	@isTest
    static void CRAN_VEC_ADV_IP_sign_test() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();

		// Bad Status
		CRAN_VEC_ADV_SignProp_AUC.sign(myOpportunity.Id);

		// Status Simulated
		myOpportunity.CRAN_VEC_ADV_B_isService__c =true;
		update myOpportunity;
		myOpportunity.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_SIMULATED;
		update myOpportunity;
		CRAN_VEC_ADV_SignProp_AUC.sign(myOpportunity.Id);
    }

    @isTest 
    static void CRAN_VEC_ADV_Investment_signOpp_test() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		CRAN_VEC_ADV_SignProp_AUC.sign(myOpportunity.Id+'');

    }


    @isTest
    static void CRAN_VEC_ADV_IP_signQuote_test() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();

		List<Quote> myQuote = [SELECT Id FROM Quote LIMIT 1];
		// Bad Status
		CRAN_VEC_ADV_SignProp_AUC.sign(myQuote[0].Id);

		// Status Simulated
		myOpportunity.CRAN_VEC_ADV_B_isService__c =true;
		update myOpportunity;
		myOpportunity.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_SIMULATED;
		update myOpportunity;
		CRAN_VEC_ADV_SignProp_AUC.sign(myQuote[0].Id);
    }


    @isTest
    static void CRAN_VEC_ADV_IP_signErr_test() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();

		// Bad Status
		CRAN_VEC_ADV_SignProp_AUC.sign('');

    }

    @isTest
    static void CRAN_VEC_ADV_IP_callOmsPrint_test() {

    	CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFactory.createAvaloqSettingMockTrue();

        Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST(CRAN_VEC_ADV_Constants_CLS.SERVICE_OMS_PRINT));
  		Test.startTest();
		CRAN_VEC_ADV_SignProp_AUC.callOmsPrint('1112','9');
		Test.stopTest();
	}

	@isTest
    static void CRAN_VEC_ADV_IP_successError_test() {

  		Test.startTest();
		CRAN_VEC_ADV_SignProp_AUC.SuccessResponse success1 = new CRAN_VEC_ADV_SignProp_AUC.SuccessResponse();
		CRAN_VEC_ADV_SignProp_AUC.ErrorResponse error1 = new CRAN_VEC_ADV_SignProp_AUC.ErrorResponse('Error');
		Test.stopTest();
	}
}