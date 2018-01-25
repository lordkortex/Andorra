@isTest
private class CRAN_VAS_ON_CustomNewUserWSHandler_TST {

	public static FINAL String actionId = 'NewUser';
	public static String postRequest = '{"strFirstName": "NOELIA",  "strLastName": "RUÍZ",  "strPrefix": "+34",  "strPhone": "696568956", "strEmail":"email@gmail.com"}';
     	
   	/*
	**  Valid Response
	**
		  {
		    "validated": true,
		    "status": "200",
		    "nextStage": "Create Case",
		    "message": "",
		    "error": false,
		    "currentStage": null,
		    "caseId": "5000E000005mReEQAU"
		}
	**
	**
   	*/
   	
	@isTest static void itTestsGetExecuteActionOK() { 
		
		Test.startTest();
		CRAN_VAS_ON_CustomNewUserWSHandler_CLS.ResponseWSWrapper results = postJSON(actionId, postRequest);
		Test.stopTest();
		
		System.assertEquals(200, results.status);
		System.assertEquals(false,results.error);
		System.assertEquals('Case Created', results.currentStage);
		System.assertEquals('PreVideo Declarations', results.nextStage);
		System.assertEquals(true,results.validated);
		System.assert(results.caseId.length() > 4);
	}


	/*
	**
	**
		{
		    "validated": false,
		    "status": "Error 500",
		    "nextStage": null,
		    "message": "Insert failed. First exception on row 0; first error: INVALID_EMAIL_ADDRESS, Email: invalid email address: 12569999: [Email]",
		    "error": true,
		    "currentStage": null,
		    "caseId": null
		}
	**
	**
	*/

	
	@isTest static void itTestsGetExecuteActionKO() {
		String badPostRequest = '{"strFirstName": "NOELIA",  "strLastName": "RUÍZ",  "strPrefix": "+34",  "strPhone": "696568956", "strEmail":"12569999"}';
		Test.startTest();
		CRAN_VAS_ON_CustomNewUserWSHandler_CLS.ResponseWSWrapper results = postJSON(actionId, badPostRequest);
		Test.stopTest();

		System.assert(results.validated == false);
		System.assert(results.status == 500);
		System.assert(results.error == true);
		System.assert(results.message.contains('Insert failed'));
		System.assert(results.currentStage == null);
		System.assert(results.nextStage == null);  
		System.assert(results.caseId == null);
	}


	@isTest static void itTestsNoDataCreatedIfErrorOccurred() {
		String badPostRequest = '{"strFirstName": "NOELIA",  "strLastName": "RUÍZ",  "strPrefix": "+34",  "strPhone": "696568956", "strEmail":"12569999"}';
		Test.startTest();
		CRAN_VAS_ON_CustomNewUserWSHandler_CLS.ResponseWSWrapper results = postJSON(actionId, badPostRequest);
		Test.stopTest();

		List<Lead> listLeads = [
			SELECT Id
			FROM Lead
		];

		List<Case> listCases = [
			SELECT Id
			FROM Case
		];

		System.assertEquals(0,listCases.size());
		System.assertEquals(0,listLeads.size());
		
	}

	@isTest static void itTestsFailCreateNewUserIfLeadEmailAlreadyExists() {
		
		Lead newLead = new Lead (
			Email = 'email@gmail.com',
			LastName = 'Grant',
			FirstName = 'Adam', 
			Company = 'Adam Grant');
		insert newLead;

		Test.startTest();
		CRAN_VAS_ON_CustomNewUserWSHandler_CLS.ResponseWSWrapper results = postJSON(actionId, postRequest);
		Test.stopTest();

		System.assertEquals(false, results.validated);
		System.assertEquals(true, results.message.contains('Duplicated Lead'));
		System.assertEquals(409, results.status);
		System.assert(results.error == true);
		System.assert(results.currentStage == null);
		System.assert(results.nextStage == null);  
		System.assert(results.caseId == null);
		
	}


	@isTest static void itTestsFailCreateNewUserWhenEmailContactAlreadyExists() {
		
		Contact newContact = new Contact (
			Email = 'email@gmail.com',
			LastName = 'Grant',
			FirstName = 'Adam');
		insert newContact;

		Test.startTest();
		CRAN_VAS_ON_CustomNewUserWSHandler_CLS.ResponseWSWrapper results = postJSON(actionId, postRequest);
		Test.stopTest();

		System.assertEquals(false, results.validated);
		System.assertEquals(true, results.message.contains('Duplicated Contact'));
		System.assertEquals(409, results.status);
		System.assert(results.error == true);
		System.assert(results.currentStage == null);
		System.assert(results.nextStage == null);  
		System.assert(results.caseId == null);
		System.assertEquals(0, queryCase().size());
		
	}

	@isTest static void itTestsFailCreateNewUserWhenPhoneContactAlreadyExists() {
		
		Contact newContact = new Contact (
			Phone = '696568956',
			LastName = 'Diaz',
			FirstName = 'Anna');
		insert newContact;

		Test.startTest();
		CRAN_VAS_ON_CustomNewUserWSHandler_CLS.ResponseWSWrapper results = postJSON(actionId, postRequest);
		Test.stopTest();

		System.assertEquals(false, results.validated);
		System.assertEquals(true, results.message.contains('Duplicated Contact'));
		System.assertEquals(409, results.status);
		System.assert(results.error == true);
		System.assert(results.currentStage == null);
		System.assert(results.nextStage == null);  
		System.assert(results.caseId == null);
		System.assertEquals(0, queryCase().size());
		
	}

	public static CRAN_VAS_ON_CustomNewUserWSHandler_CLS.ResponseWSWrapper postJSON(String actionId, String paramsJSON) {
		RestResponse response =  CRAN_VAS_ON_TestBase_TST.postJsonRaw(actionId, paramsJSON);
		String strResponse = response.responseBody.toString();
		CRAN_VAS_ON_CustomNewUserWSHandler_CLS.ResponseWSWrapper ret =
			 (CRAN_VAS_ON_CustomNewUserWSHandler_CLS.ResponseWSWrapper) JSON.deserialize(strResponse, CRAN_VAS_ON_CustomNewUserWSHandler_CLS.ResponseWSWrapper.class);
		if (RestContext.response != null) {
			RestContext.response.statusCode = ret.status;
		}
		return ret;
	}


	private static List<Case> queryCase(){
		List<Case> lstCases = [
			SELECT Id
			FROM Case
		];

		return lstCases;
	}

}