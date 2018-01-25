/**
 * CRAN_VEC_ADV_Investment_Proposal_AUC
 *
 * Fecha: 5/5/2016
 * @author  Vector
 * @version 1.0
 *
*/
@isTest
private class CRAN_VEC_ADV_Investment_Proposal_TST {
	
	/*------------------*/
    /*   TEST ACTIONS   */
    /*------------------*/


	@isTest 
    static void CRAN_VEC_ADV_Investment_Proposal_test() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();

		//CRAN_VEC_ADV_Investment_Proposal_AUC.discardOpp(myOpportunity.Id+'');

    }


    @isTest 
    static void CRAN_VEC_ADV_Investment_acceptOpp2_test() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);
		System.debug('myOpportunity '+myOpportunity);
		
		myOpportunity.CRAN_VEC_ADV_B_isService__c = true;
		update myOpportunity;

		myOpportunity.StageName = 'advToSign';

		update myOpportunity;

		myOpportunity.CRAN_VEC_ADV_B_isService__c = false;

		update myOpportunity;		

        dataFactory.createAvaloqSettingMockTrue();
		Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST(CRAN_VEC_ADV_Constants_CLS.SERVICE_FIRMA_OPORTUNIDAD));
		Test.startTest();
		CRAN_VEC_ADV_Investment_Proposal_AUC.acceptOppOnlyServiceSign(myOpportunity.Id+'');
		Test.stopTest();
    }


    @isTest 
    static void CRAN_VEC_ADV_Investment_simulOpp_test() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		myOpportunity.CRAN_VEC_ADV_B_isService__c = true;
		update myOpportunity;

		myOpportunity.StageName = 'advAccepted';
		update myOpportunity;

		myOpportunity.CRAN_VEC_ADV_B_isService__c = false;
		update myOpportunity;

		CRAN_VEC_ADV_Investment_Proposal_AUC.simulOpp(myOpportunity.Id+'');

    }


    @isTest 
    static void CRAN_VEC_ADV_Investment_simulOppBad_test() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		CRAN_VEC_ADV_Investment_Proposal_AUC.simulOpp(myOpportunity.Id+'');

    }


    @isTest 
    static void CRAN_VEC_ADV_Investment_calcProp_test() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		Quote myQuote = [SELECT Id, OpportunityId, CRAN_VEC_ADV_N_LineItems__c FROM Quote];

		List<CRAN_VEC_ADV_Investment_Proposition_Line__c> myLine = [SELECT Id, CRAN_VEC_ADV_P_nodeType__c, CRAN_VEC_ADV_L_Version__c FROM CRAN_VEC_ADV_Investment_Proposition_Line__c];
		System.debug('myLine '+myLine);

		System.debug('myQuote '+myQuote);
		System.debug('myOpportunity '+myOpportunity.StageName);

		CRAN_VEC_ADV_Investment_Proposal_AUC.calcProp(myQuote.Id+'','');

    }


    @isTest 
    static void CRAN_VEC_ADV_Investment_trxOpp_test() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		myOpportunity.CRAN_VEC_ADV_B_isService__c = true;
		update myOpportunity;

		myOpportunity.StageName = 'advErrSim';
		update myOpportunity;

		myOpportunity.CRAN_VEC_ADV_B_isService__c = false;
		update myOpportunity;

		dataFactory.createAvaloqSettingMockTrue();

		CRAN_VEC_ADV_Investment_Proposal_AUC.trxOppOnlyRegen(myOpportunity.Id+'');

    }

        @isTest 
    static void CRAN_VEC_ADV_Investment_trxOpprr_test() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		myOpportunity.CRAN_VEC_ADV_B_isService__c = true;
		update myOpportunity;

		myOpportunity.StageName = 'advErrSim';
		update myOpportunity;

		myOpportunity.CRAN_VEC_ADV_B_isService__c = false;
		update myOpportunity;

		dataFactory.createAvaloqSettingMockTrue();

		CRAN_VEC_ADV_Investment_Proposal_AUC.trxOppOnlyRegen('');

    }

    /*@isTest 
    static void CRAN_VEC_ADV_Investment_close_test() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		myOpportunity.CRAN_VEC_ADV_B_isService__c = true;
		update myOpportunity;

		myOpportunity.StageName = 'advAccepted';
		update myOpportunity;

		myOpportunity.CRAN_VEC_ADV_B_isService__c = false;
		update myOpportunity;

		dataFactory.createAvaloqSettingMockTrue();

		CRAN_VEC_ADV_Investment_Proposal_AUC.closeAcceptOrRegen(myOpportunity.Id+'');

    }*/


   /* @isTest 
    static void CRAN_VEC_ADV_Inv_calcPropPdf_test() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		update myOpportunity;
		dataFactory.createAvaloqSettingMockTrue();

		Quote myQuote = [SELECT Id, OpportunityId, CRAN_VEC_ADV_N_LineItems__c FROM Quote];

		CRAN_VEC_ADV_Investment_Proposal_AUC.calcPropPdf(myOpportunity.Id+'');

    }*/



   /* @isTest 
    static void CRAN_VEC_ADV_Inv_calcPropPdf2_test() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		update myOpportunity;
		dataFactory.createAvaloqSettingMockTrue();

		Quote myQuote = [SELECT Id, OpportunityId, CRAN_VEC_ADV_N_LineItems__c FROM Quote];

		myQuote.Status='Synchronized';
		update myQuote;

		Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST(CRAN_VEC_ADV_Constants_CLS.SERVICE_CALCULAR_OPORTUNIDAD));

		Test.startTest();
		CRAN_VEC_ADV_Investment_Proposal_AUC.calcPropPdf(myOpportunity.Id+'');
		Test.stopTest();

    }*/



    /* @isTest 
    static void CRAN_VEC_ADV_Inv_calcPropPdf3_test() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		update myOpportunity;
		dataFactory.createAvaloqSettingMockTrue();

		Quote myQuote = [SELECT Id, OpportunityId, CRAN_VEC_ADV_N_LineItems__c FROM Quote];

		myQuote.Status='Modified';
		update myQuote;

		Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST(CRAN_VEC_ADV_Constants_CLS.SERVICE_CALCULAR_OPORTUNIDAD));

		Test.startTest();
		CRAN_VEC_ADV_Investment_Proposal_AUC.calcPropPdf(myOpportunity.Id+'');
		Test.stopTest();

    }*/

    @isTest 
    static void CRAN_VEC_ADV_Inv_calcPropPdf4_test() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		update myOpportunity;
		dataFactory.createAvaloqSettingMockTrue();

		Quote myQuote = [SELECT Id, Name,OpportunityId,CRAN_VEC_ADV_P_Currency__c,CRAN_VEC_ADV_P_Currencybk__c,CRAN_VEC_ADV_N_InvAmount__c,CRAN_VEC_ADV_N_InvAmountbk__c,Status,CRAN_VEC_ADV_N_LineItems__c FROM Quote];

		System.debug('myQuote id '+myQuote.Id);
		System.debug('myQuote name '+myQuote.Name);
		System.debug('myQuote currency '+myQuote.CRAN_VEC_ADV_P_Currency__c);
		System.debug('myQuote amount '+myQuote.CRAN_VEC_ADV_N_InvAmount__c);
		System.debug('myQuote Status '+myQuote.Status);
		System.debug('myQuote CRAN_VEC_ADV_P_CurrencyBK__c '+myQuote.CRAN_VEC_ADV_P_CurrencyBK__c);
		System.debug('myQuote CRAN_VEC_ADV_N_InvAmountBK__c '+myQuote.CRAN_VEC_ADV_N_InvAmountBK__c);

		myQuote.CRAN_VEC_ADV_B_isService__c = true;
		myQuote.CRAN_VEC_ADV_P_CurrencyBK__c = myQuote.CRAN_VEC_ADV_P_Currency__c;
		myQuote.CRAN_VEC_ADV_N_InvAmountBK__c = myQuote.CRAN_VEC_ADV_N_InvAmount__c;
		update myQuote;

		myQuote.Status='Synchronized';
		update myQuote;

		myQuote.CRAN_VEC_ADV_B_isService__c = false;
		update myQuote;

		System.debug('myQuote id2 '+myQuote.Id);
		System.debug('myQuote name2 '+myQuote.Name);
		System.debug('myQuote currency2 '+myQuote.CRAN_VEC_ADV_P_Currency__c);
		System.debug('myQuote amount2 '+myQuote.CRAN_VEC_ADV_N_InvAmount__c);
		System.debug('myQuote Status2 '+myQuote.Status);
		System.debug('myQuote CRAN_VEC_ADV_P_CurrencyBK__c '+myQuote.CRAN_VEC_ADV_P_CurrencyBK__c);
		System.debug('myQuote CRAN_VEC_ADV_N_InvAmountBK__c '+myQuote.CRAN_VEC_ADV_N_InvAmountBK__c);

		Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST(CRAN_VEC_ADV_Constants_CLS.SERVICE_CALCULAR_OPORTUNIDAD));


		List<Quote> myQuoteList = [SELECT Id, Name,OpportunityId,CRAN_VEC_ADV_P_Currency__c,CRAN_VEC_ADV_N_InvAmount__c,Status,CRAN_VEC_ADV_N_LineItems__c FROM Quote];
		System.debug('myQuoteList '+myQuoteList);
		System.debug('myQuoteList size '+myQuoteList.size());

		/*Test.startTest();
		CRAN_VEC_ADV_Investment_Proposal_AUC.calcPropPdf(myOpportunity.Id+'');
		Test.stopTest();*/

    }


    @isTest 
    static void CRAN_VEC_ADV_Inv_Model_TST() {
    	CRAN_VEC_ADV_CalcRebalpRestriction rest = new CRAN_VEC_ADV_CalcRebalpRestriction();
    	rest.setId('12345');
    	rest.setJustif('overrride');
    	rest.setOverride(true);
    	rest.getId();
    	rest.getJustif();
    	rest.getOverride();
    	System.assert(rest.getOverride());
    }

    @isTest 
    static void CRAN_VEC_ADV_Rebalp_List() {
    	CRAN_VEC_ADV_RebalpList_RQ rq = new CRAN_VEC_ADV_RebalpList_RQ();
    	CRAN_VEC_ADV_RebalpList_RS rs = (CRAN_VEC_ADV_RebalpList_RS) JSON.deserialize(CRAN_VEC_ADV_Utils.getMockBody(CRAN_VEC_ADV_Constants_CLS.SERVICE_LIST_OPORTUNIDAD), CRAN_VEC_ADV_RebalpList_RS.class);

    	rq.lang = 'ES';
    	rq.dateFrom = '31-12-2017 24:59:59';
    	rq.dateTo = '31-12-2017 24:59:59';
    }


    @isTest 
    static void CRAN_VEC_ADV_haveRestrDifValDoInit_TST() {
    	Test.startTest();
    	CRAN_VEC_ADV_Investment_Proposal_AUC.haveRestrictionsDifValDoInit('53454','none');
		Test.stopTest();
    }

    @isTest 
    static void CRAN_VEC_ADV_ChangeOpp_TST() {
    	
    	CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();

    	Test.startTest();
    	CRAN_VEC_ADV_Investment_Proposal_AUC.ChangedOpportunity temp = new CRAN_VEC_ADV_Investment_Proposal_AUC.ChangedOpportunity(myOpportunity);

		Test.stopTest();
    }

    @isTest 
    static void CRAN_VEC_ADV_FieldChanged_TST() {    	

    	CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();

    	Test.startTest();
    	CRAN_VEC_ADV_Investment_Proposal_AUC.FieldChanged temp = new CRAN_VEC_ADV_Investment_Proposal_AUC.FieldChanged(Opportunity.Fields.StageName,myOpportunity,'');

		Test.stopTest();
    }    

    @isTest 
    static void CRAN_VEC_ADV_ShowHeader_TST() {    	

    	CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createAvaloqSettingMockTrue();
		dataFactory.createSetting_AvaloqOppInvestProposal();

    	Test.startTest();
    	String temp = CRAN_VEC_ADV_Investment_Proposal_AUC.showHeader(myOpportunity.Id);

		Test.stopTest();
    }
    

    @isTest 
    static void CRAN_VEC_ADV_Error_TST() {    	
    	Test.startTest();
    	CRAN_VEC_ADV_Investment_Proposal_AUC.ErrorResponse temp = new CRAN_VEC_ADV_Investment_Proposal_AUC.ErrorResponse('',true);

    	CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);
		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);
		Quote myQuote = [SELECT Id FROM Quote LIMIT 1];
    	CRAN_VEC_ADV_Investment_Proposal_AUC.SuccessResponse temp1 = new CRAN_VEC_ADV_Investment_Proposal_AUC.SuccessResponse(myQuote);
		Test.stopTest();
    }


    @isTest 
    static void CRAN_VEC_ADV_QueryOpp_TST() {    	
    	Test.startTest();
    	CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);
		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);
		Quote myQuote = [SELECT Id FROM Quote LIMIT 1];
			Id recordId = myOpportunity.Id;
			SObjectType objectType = Id.valueOf((String)myOpportunity.Id).getSObjectType();
    	CRAN_VEC_ADV_Investment_Proposal_AUC.queryOpp(objectType,myOpportunity.Id);
    	recordId = myQuote.Id;
			 objectType = Id.valueOf((String)myQuote.Id).getSObjectType();
    	CRAN_VEC_ADV_Investment_Proposal_AUC.queryOpp(objectType,myQuote.Id);
		Test.stopTest();
    }    

}