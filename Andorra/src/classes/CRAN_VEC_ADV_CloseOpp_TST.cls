@isTest
private class CRAN_VEC_ADV_CloseOpp_TST {
		
    /**
    * Action para el boton de cerrar opportunity del Componente Lightning.
    * 
    */
        
   	@isTest 
    static void CRAN_VEC_ADV_IP_closeOpportunity_test() {
		
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();

		// Bad Status
		CRAN_VEC_ADV_CloseOpp_AUC.closeOpportunity(myOpportunity.Id);

		// Status To Sign
		myOpportunity.CRAN_VEC_ADV_B_isService__c =true;
		update myOpportunity;
		myOpportunity.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_PEND_SIGN;
		update myOpportunity;
		CRAN_VEC_ADV_CloseOpp_AUC.closeOpportunity(myOpportunity.Id);
    }	

    @isTest 
    static void CRAN_VEC_ADV_IP_closeOpError_test() {
		
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();

		// Bad Status
		CRAN_VEC_ADV_CloseOpp_AUC.closeOpportunity('');

		// Status To Sign
		myOpportunity.CRAN_VEC_ADV_B_isService__c =true;
		update myOpportunity;
		myOpportunity.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_PEND_SIGN;
		update myOpportunity;
		CRAN_VEC_ADV_CloseOpp_AUC.closeOpportunity('');
    }	

    @isTest 
    static void CRAN_VEC_ADV_IP_closeOpErrorStr_test() {
		
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();

		List<Quote> myQuote = [SELECT Id FROM Quote LIMIT 1];

		// Status To Sign
		myOpportunity.CRAN_VEC_ADV_B_isService__c =true;
		update myOpportunity;
		myOpportunity.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_PEND_SIGN;
		update myOpportunity;
		CRAN_VEC_ADV_CloseOpp_AUC.closeOpportunity(myQuote[0].Id);
    }	

    @isTest 
    static void CRAN_VEC_ADV_SuccessResponse_test() {
    	CRAN_VEC_ADV_CloseOpp_AUC.SuccessResponse success = new CRAN_VEC_ADV_CloseOpp_AUC.SuccessResponse(new Quote());
    }

}