@isTest
private class CRAN_VEC_ADV_PrintPrevProp_TST {

	/**
    * Action para el boton de print preview del Componente Lightning.
    * 
    */
   	@isTest 
    static void CRAN_VEC_ADV_IP_printPreview_test() {
		
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();

		// Bad Status
		CRAN_VEC_ADV_PrintPrevProp_AUC.printPreview(myOpportunity.Id);

		// Status Simulated
		myOpportunity.CRAN_VEC_ADV_B_isService__c =true;
		update myOpportunity;
		myOpportunity.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_SIMULATED;
		update myOpportunity;
		CRAN_VEC_ADV_PrintPrevProp_AUC.printPreview(myOpportunity.Id);
    }

    @isTest 
    static void CRAN_VEC_ADV_IP_printPrevErr_test() {
		
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();

		// Bad Status
		CRAN_VEC_ADV_PrintPrevProp_AUC.printPreview('');

    }

    @isTest 
    static void CRAN_VEC_ADV_IP_printPrevQuot_test() {
		
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();

		Quote MyQuote = [SELECT Id FROM Quote LIMIT 1];
		// Bad Status
		CRAN_VEC_ADV_PrintPrevProp_AUC.printPreview(MyQuote.Id);

		// Status Simulated
		myOpportunity.CRAN_VEC_ADV_B_isService__c =true;
		update myOpportunity;
		myOpportunity.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_SIMULATED;
		update myOpportunity;
		CRAN_VEC_ADV_PrintPrevProp_AUC.printPreview(MyQuote.Id);

    }    
}