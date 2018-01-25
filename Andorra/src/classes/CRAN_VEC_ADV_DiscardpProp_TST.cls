@isTest
private class CRAN_VEC_ADV_DiscardpProp_TST {
		
    /**
    * Action para el boton de descartar opportunity del Componente Lightning.
    * 
    */
   	@isTest 
    static void CRAN_VEC_ADV_IP_discardOpportunity_test() {
		
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();

		// Bad Status
		CRAN_VEC_ADV_DiscardpProp_AUC.discardOpportunity(myOpportunity.Id);

		// Status Simulated
		myOpportunity.CRAN_VEC_ADV_B_isService__c =true;
		update myOpportunity;
		myOpportunity.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_SIMULATED;
		update myOpportunity;
		CRAN_VEC_ADV_DiscardpProp_AUC.discardOpportunity(myOpportunity.Id);
    }	


    @isTest 
    static void CRAN_VEC_ADV_IP_discardQuote_test() {
		
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();

		List<Quote> myQuote = [SELECT Id FROM Quote LIMIT 1];
		// Bad Status
		CRAN_VEC_ADV_DiscardpProp_AUC.discardOpportunity(myQuote[0].Id);

		// Status Simulated
		myOpportunity.CRAN_VEC_ADV_B_isService__c =true;
		update myOpportunity;
		myOpportunity.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_SIMULATED;
		update myOpportunity;
		CRAN_VEC_ADV_DiscardpProp_AUC.discardOpportunity(myQuote[0].Id);
    }

    @isTest 
    static void CRAN_VEC_ADV_IP_discardOpError_test() {
		
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();

		// Bad Status
		CRAN_VEC_ADV_DiscardpProp_AUC.discardOpportunity('');

		// Status Simulated
		myOpportunity.CRAN_VEC_ADV_B_isService__c =true;
		update myOpportunity;
		myOpportunity.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_SIMULATED;
		update myOpportunity;
		CRAN_VEC_ADV_DiscardpProp_AUC.discardOpportunity('');
    }	

    @isTest 
    static void CRAN_VEC_ADV_IP_discOpErrorStr_test() {
		
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();

		List<Quote> myQuote = [SELECT Id FROM Quote LIMIT 1];

		// Status Simulated
		myOpportunity.CRAN_VEC_ADV_B_isService__c =true;
		update myOpportunity;
		myOpportunity.StageName = 'advToSign';
		update myOpportunity;
		CRAN_VEC_ADV_DiscardpProp_AUC.discardOpportunity(myQuote[0].Id);
    }	

    @isTest 
    static void CRAN_VEC_ADV_IP_discOpSuccessErrorResponse_test() {
		
		CRAN_VEC_ADV_DiscardpProp_AUC.SuccessResponse success = new CRAN_VEC_ADV_DiscardpProp_AUC.SuccessResponse(new Quote());
		CRAN_VEC_ADV_DiscardpProp_AUC.ErrorResponse error = new CRAN_VEC_ADV_DiscardpProp_AUC.ErrorResponse((CalloutException)CalloutException.class.newInstance());
		
    }	

    @isTest 
    static void CRAN_VEC_ADV_correctOppStatusDiscard_test1() {
		
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);


		// Bad Status
		CRAN_VEC_ADV_DiscardpProp_AUC.correctOppStatusDiscard(myOpportunity.Id);

    }

    @isTest 
    static void CRAN_VEC_ADV_correctOppStatusDiscard_test2() {
		
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);
		myOpportunity.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_SIMULATED;
		update myOpportunity;

		CRAN_VEC_ADV_DiscardpProp_AUC.correctOppStatusDiscard(myOpportunity.Id);

    }	

    @isTest 
    static void CRAN_VEC_ADV_correctOppStatusDiscard_test3() {
		
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);
		myOpportunity.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_ERRSIM;
		update myOpportunity;

		CRAN_VEC_ADV_DiscardpProp_AUC.correctOppStatusDiscard(myOpportunity.Id);

    }		

}