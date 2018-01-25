/**
 * The Class CRAN_VAS_ON_CustomRecoverWSHandler_TST.
 */
@isTest(SeeAllData=true)
private class CRAN_VAS_ON_CustomRecoverWSHandler_TST {

	/** The String. */
	public static FINAL String actionId = 'RecoverCaseStatus';
	 	
   
	/**
	 * It tests get execute action OK.
	 */
	@isTest static void itTestsGetExecuteActionOK() { 
		
		Test.startTest();
		
		 Case caseItem = new Case(Subject='Test Controller Acct Case',Stage__c='Case Created');
		 insert caseItem;
	 
		
		 CRAN_VAS_ON_CustomRecoverWSHandler_CLS cons = new CRAN_VAS_ON_CustomRecoverWSHandler_CLS();
		 String jsonRequest = '{"idCase": "' + caseItem.Id + '" }';
		 String responseJSON = cons.getExecuteAction(jsonRequest,actionId);
		 
		 System.debug('jsonRequest: ' + jsonRequest);

		Test.stopTest();
	
	}

	
	/**
	 * It tests get execute action KO.
	 */
	@isTest static void itTestsGetExecuteActionKO() {
		Test.startTest();
		
		  Case caseItem = new Case(Subject='Test Controller Acct Case',Stage__c='Case Created');
		 insert caseItem;
	 
		 CRAN_VAS_ON_CustomRecoverWSHandler_CLS cons = new CRAN_VAS_ON_CustomRecoverWSHandler_CLS();
		 String jsonRequest = '{"idCaseX": "' + caseItem.Id + '" }';
		 String responseJSON = cons.getExecuteAction(jsonRequest,actionId);
		 System.debug('jsonRequest: ' + jsonRequest);

		Test.stopTest();
	}




}