/**
* Company         : VASS
* Version         : 1.0 
* Project         : Credit Andorra
* Description     : 
*                       - Create a class generic that have methods for manipulate objects.       
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0     22/01/2018		Nacho Hita				Test methods for ManageIndividualUtil	
*
******/

@IsTest
private class CRAN_VAS_ON_ManageIndividualUtil_TST {

    public static TestParams testParams = new TestParams();
    public static Contact ContactCreated = new Contact();
    
    @isTest static void constructor_OK(){
        CRAN_VAS_ON_ManageIndividualUtil_CLS a = new CRAN_VAS_ON_ManageIndividualUtil_CLS();
    }
    @isTest static void createIndividual_OK(){
    	ContactCreated = CRAN_VAS_ON_ManageIndividualUtil_CLS.createIndividual(testParams.firstName, 
                                                                               testParams.lastName, 
                                                                               testParams.email, 
                                                                               testParams.phone, 
                                                                               testParams.prefix);
        test.startTest();
        	System.assertEquals(ContactCreated.email, 'mail@gmail.com');
        test.stopTest();
    }
    
    @isTest static void createIndividual_KO(){
    	ContactCreated = CRAN_VAS_ON_ManageIndividualUtil_CLS.createIndividual(testParams.firstName, 
                                                                               testParams.lastName, 
                                                                               testParams.email, 
                                                                               '69696859686969685968696968596869696859686969685968', 
                                                                               testParams.prefix);
        test.startTest();
        	System.assertEquals(ContactCreated, null);
        test.stopTest();
    } 
    
    private class TestParams{
		public String email;
		public String firstName;
		public String lastName;
		public String phone;
		public String prefix;

        public TestParams(){
            email		=	'mail@gmail.com';
            firstName 	=	'NOELIA';
            lastName	=	'RUIZ';
            prefix 		=	'+34';
            phone 		=	'699636352';
    	}
    }
    
    public static Contact getContact(TestParams testParams){
		Contact objContact = new Contact();
		objContact = CRAN_VAS_ON_ManageAccountUtil_CLS.createAccount(true, testParams.email, testParams.firstName, testParams.lastName, testParams.prefix, testParams.phone);
		return objContact;
	}
    
	public static ID getContactId(TestParams testParams){
		Contact objContact = new Contact();
		objContact = CRAN_VAS_ON_ManageAccountUtil_CLS.createAccount(true, testParams.email, testParams.firstName, testParams.lastName, testParams.prefix, testParams.phone);
	
		ID idContact = objContact.Id; 
		return idContact;
	}  
    
}