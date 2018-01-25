@isTest
private class CRAN_VEC_ADV_PrintContract_TST{
	
	@isTest
	static void CRAN_VEC_ADV_PrintContract(){			    	
    	CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);
		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);
		 
		CRAN_VAS_KER_ESignature__c aux = new CRAN_VAS_KER_ESignature__c();
		aux.CRAN_VAS_KER_Reference_Line__c = '3333';
		insert aux;
		
		Test.startTest();			
		CRAN_VEC_ADV_PrintContract_AUC.retrieveReferenceLine(myOpportunity.Id);
		Test.stopTest();
	}
	
	    @isTest
	static void CRAN_VEC_ADV_PrintContract_test1(){			    	
    	CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);
		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);
		 
		CRAN_VAS_KER_ESignature__c aux = new CRAN_VAS_KER_ESignature__c();
		aux.CRAN_VAS_KER_Reference_Line__c = '3333';
		aux.CRAN_VAS_KER_Opportunity__c = myOpportunity.id;
        aux.CRAN_VAS_KER_Signature_Type__c = 'Proposal';
        insert aux;
        
		Test.startTest();			
		CRAN_VEC_ADV_PrintContract_AUC.retrieveReferenceLine(myOpportunity.Id);
		Test.stopTest();
	}

    @isTest
	static void CRAN_VEC_ADV_PrintContract_test2(){			    	
    	CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);
		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);
        myOpportunity.CRAN_VEC_ADV_T_AvaloqPropId__c = '';
        update myOpportunity;
		 
		CRAN_VAS_KER_ESignature__c aux = new CRAN_VAS_KER_ESignature__c();
		aux.CRAN_VAS_KER_Reference_Line__c = '3333';
		aux.CRAN_VAS_KER_Opportunity__c = myOpportunity.id;
        aux.CRAN_VAS_KER_Signature_Type__c = 'Proposal';
        insert aux;
        
		Test.startTest();			
		CRAN_VEC_ADV_PrintContract_AUC.retrieveReferenceLine(myOpportunity.Id);
		Test.stopTest();
	}

    @isTest
	static void CRAN_VEC_ADV_PrintContract_test1_1(){			    	
    	CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);
		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);
		 
		CRAN_VAS_KER_ESignature__c aux = new CRAN_VAS_KER_ESignature__c();
		aux.CRAN_VAS_KER_Reference_Line__c = '3333';
		aux.CRAN_VAS_KER_Opportunity__c = myOpportunity.id;
        aux.CRAN_VAS_KER_Signature_Type__c = 'Proposal';
        insert aux;
        
		Test.startTest();			
		CRAN_VEC_ADV_PrintContract_AUC.retrieveReferenceLine(myOpportunity.Id);
		Test.stopTest();
	}

    @isTest
	static void CRAN_VEC_ADV_PrintContract_test2_2(){			    	
    	CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);
		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);
        myOpportunity.CRAN_VEC_ADV_T_AvaloqPropId__c = '';
        update myOpportunity;
		 
		CRAN_VAS_KER_ESignature__c aux = new CRAN_VAS_KER_ESignature__c();
		aux.CRAN_VAS_KER_Reference_Line__c = '3333';
		aux.CRAN_VAS_KER_Opportunity__c = myOpportunity.id;
        aux.CRAN_VAS_KER_Signature_Type__c = 'Proposal';
        insert aux;
        
		Test.startTest();			
		CRAN_VEC_ADV_PrintContract_AUC.retrieveReferenceLine(myOpportunity.Id);
		Test.stopTest();
	}

	@isTest
	static void CRAN_VEC_ADV_PrintContract_Error(){			    	
		Test.startTest();			
		CRAN_VEC_ADV_PrintContract_AUC.ErrorResponse temp = new CRAN_VEC_ADV_PrintContract_AUC.ErrorResponse('');
		Test.stopTest();
	}


	@isTest
	static void CRAN_VEC_ADV_SuccesError_TST(){	
		CRAN_VEC_ADV_PrintContract_AUC.SuccessInitResponse success = new CRAN_VEC_ADV_PrintContract_AUC.SuccessInitResponse('1111','2222','');
		CRAN_VEC_ADV_PrintContract_AUC.ErrorResponse error = new CRAN_VEC_ADV_PrintContract_AUC.ErrorResponse((CalloutException)CalloutException.class.newInstance());
	}	


	@isTest
    static void CRAN_VEC_ADV_IP_signQuote_test2() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createSetting_AvaloqOppInvestProposal();

		List<Quote> myQuote = [SELECT Id FROM Quote LIMIT 1];

		CRAN_VAS_KER_ESignature__c aux = new CRAN_VAS_KER_ESignature__c();
		aux.CRAN_VAS_KER_Reference_Line__c = '3333';
		insert aux;
		
		Test.startTest();			
		CRAN_VEC_ADV_PrintContract_AUC.retrieveReferenceLine(myQuote[0].Id);
		Test.stopTest();
    }


    @isTest
    static void CRAN_VEC_ADV_IP_signQuote_test3() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);

		dataFactory.createSetting_AvaloqOppInvestProposal();

		List<Quote> myQuote = [SELECT Id FROM Quote LIMIT 1];

		CRAN_VAS_KER_ESignature__c aux = new CRAN_VAS_KER_ESignature__c();
		aux.CRAN_VAS_KER_Reference_Line__c = '3333';
		insert aux;
		
		Test.startTest();			
		CRAN_VEC_ADV_PrintContract_AUC.retrieveReferenceLine(aux.Id);
		Test.stopTest();
    }


    @isTest
    static void CRAN_VEC_ADV_IP_signQuote_test4() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

		Account myAccount = dataFactory.createBPAccount();
		FinServ__FinancialAccount__c myFaccouunt = dataFactory.createFS_FinancialAccount(myAccount);

		Opportunity myOpportunity = dataFactory.createOppwithVersionwithIPLs(myFaccouunt.Id,myAccount.Id);
		myOpportunity.StageName = CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_DONE;
		update myOpportunity;

		dataFactory.createSetting_AvaloqOppInvestProposal();

		List<Quote> myQuote = [SELECT Id FROM Quote LIMIT 1];

		CRAN_VAS_KER_ESignature__c aux = new CRAN_VAS_KER_ESignature__c();
		aux.CRAN_VAS_KER_Reference_Line__c = '3333';
		insert aux;
		
		Test.startTest();			
		CRAN_VEC_ADV_PrintContract_AUC.retrieveReferenceLine(myOpportunity.Id);
		Test.stopTest();
    }

}