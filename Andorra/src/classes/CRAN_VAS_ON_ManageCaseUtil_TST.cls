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
* @version  1.0     22/01/2018		Nacho Hita				Test methods for ManageCaseUtil	
*
******/

@IsTest
private class CRAN_VAS_ON_ManageCaseUtil_TST{
	public static TestParams testParams = new TestParams();
    public static Case CaseGenerated = new Case();
    public static ID idContact = getContactId(testParams);
	public static Case caseCreated = new Case();            
    
    @isTest static void createCase_OK(){
        CaseGenerated = CRAN_VAS_ON_ManageCaseUtil_CLS.createCase(idContact);
        
        test.startTest();
        	system.assertEquals( CaseGenerated.ContactId, idContact );
        test.stopTest();
    }
    
    @isTest static void getMapStages_OK(){
        CaseGenerated = CRAN_VAS_ON_ManageCaseUtil_CLS.createCase(idContact);
        Stage_Flow__mdt mapStages = CRAN_VAS_ON_ManageCaseUtil_CLS.getMapStages(CaseGenerated.Id);
        
        test.startTest();
        	System.assertEquals(mapStages.Current_Stage__c, CaseGenerated.Stage__c);
        test.stopTest();
    }
    
    @isTest static void updateCaseStage_OK(){
        CaseGenerated = CRAN_VAS_ON_ManageCaseUtil_CLS.createCase(idContact);
        
        CRAN_VAS_ON_ManageCaseUtil_CLS.updateCaseStage(CaseGenerated.Id);
        Set<String> stFields = new Set<String>{'Stage__c', 'Subject'};	 
        Case aux = (Case)CRAN_VAS_ON_ManageObjectUtil_CLS.queryObject(CaseGenerated.Id, 'Case', stFields);
                                                       
        test.startTest();
        	System.assertEquals(aux.Stage__c, 'PreVideo Declarations');
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
    	
	public static ID getContactId(TestParams testParams){
		Contact objContact = new Contact();
		//objContact = CRAN_VAS_ON_ManageAccountUtil_CLS.createAccount(true, testParams.email, testParams.firstName, testParams.lastName, testParams.prefix, testParams.phone);
	
		ID idContact = objContact.Id; 
		return idContact;
	}
}