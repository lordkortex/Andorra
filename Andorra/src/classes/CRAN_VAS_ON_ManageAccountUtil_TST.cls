@IsTest
private class CRAN_VAS_ON_ManageAccountUtil_TST {

	@isTest static void createContact_OK(){  
		TestParams testParams = setUp();
		Contact objContact = new Contact();
		objContact = CRAN_VAS_ON_ManageAccountUtil_CLS.createContact(true, testParams.email, testParams.firstName, testParams.lastName, testParams.prefix, testParams.phone);
	
		test.startTest();
			system.assertEquals( objContact.email, 'mail@gmail.com' );
			system.assertEquals( objContact.phone, '699636352' );
		test.stopTest();
	}
	
	@isTest static void createContact_KO(){  
		TestParams testParams = setUp();
		Contact objContact = new Contact();
		objContact = CRAN_VAS_ON_ManageAccountUtil_CLS.createContact(true, testParams.email, 'MARIAMARIAMARIAMARIAMARIAMARIAMARIAMARIAMARIAMARIA', testParams.lastName, testParams.prefix, testParams.phone);
	
		test.startTest();
			system.assertEquals( objContact, null );
		test.stopTest();
	}
 
	
	private class TestParams{
		public String email;
		public String firstName;
		public String lastName;
		public String phone;
		public String prefix;
	}

	private static TestParams setUp(){
		TestParams testParams = new TestParams();
		testParams.email 		=	'mail@gmail.com';
		testParams.firstName 	=	'NOELIA';
		testParams.lastName		=	'RUIZ';
		testParams.prefix 		=	'+34';
		testParams.phone 		=	'699636352';
		return testParams;
	}
	
	private static ID getContactId(){
		TestParams testParams = new TestParams();
		testParams.email 		=	'mail@gmail.com';
		testParams.firstName 	=	'NOELIA';
		testParams.lastName		=	'RUIZ';
		testParams.prefix 		=	'+34';
		testParams.phone 		=	'699636352';
		
		Contact objContact = new Contact();
		objContact = CRAN_VAS_ON_ManageAccountUtil_CLS.createContact(true, testParams.email, testParams.firstName, testParams.lastName, testParams.prefix, testParams.phone);
	
		ID idContact = objContact.Id; 
		return idContact;
	}
	
}