public virtual class CRAN_VAS_ON_TestBase_TST {

	public static FINAL String requestUri = 'https://creditandorra--DEVBOARD.cs89.my.salesforce.com/services/apexrest/action/';

    public static TestParams testParams = new TestParams();
    
    public static TestParams setUp() {
		testParams.email 		=	'mail@gmail.com';
		testParams.firstName 	=	'NOELIA';
		testParams.lastName		=	'RUIZ';
		testParams.prefix 		=	'+34';
		testParams.phone 		=	'699636352';
		return testParams;
    }
    
    public static Contact createContact(){
		testParams = setUp();
        
		Contact objContact = new Contact();
        objContact = CRAN_VAS_ON_ManageAccountUtil_CLS.createContact(true, testParams.email, testParams.firstName, testParams.lastName, testParams.prefix, testParams.phone);

        return objContact;
    }

    /*
    * @Method:      Create Test Account
    * @param:        
    * @author       Griselda Diaz
    * @Description	Create Aaccount for testing
    */

	public static Account createAccount() {
		Account objAcc = new Account(
			Name =	'Test Acc'
		);	

		insert objAcc;
		return objAcc;
	}

	/*
    * @Method:      Create Test Case
    * @param:       accountID
    * @author       Griselda Diaz
    * @Description	Create Case for testing
    */

	public static Case createCase(Id accountID) {
		Case objCase = new Case( 
    		AccountId = accountID, 	
    		Stage__c = 'New',
    		Origin = 'Test Class',
    		Subject = 'Test'
    	);

		insert objCase;
		return objCase;
	}


	public static RestResponse postJsonRaw(String actionId, String paramsJSON) {
		// Set up a test request
		RestRequest request = new RestRequest();
		RestResponse response = new RestResponse();
		RestContext.request = request;
		RestContext.response = response;
		request.requestUri = requestUri + actionId;
		request.httpMethod = 'POST';
		request.requestBody = Blob.valueOf(paramsJSON);
		// Call the method to test
		CRAN_VAS_ON_GenericSalesforceWS_CLS.executeAction();
		 
		return response;
	}	
	 
       
    private class TestParams{
		public String email;
		public String firstName;
		public String lastName;
		public String phone;
		public String prefix;
	}
}