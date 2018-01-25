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
* @version  1.0     25/01/2018		Jhon Cortes				Test methods for ManageLeadUtil	
*
******/

@IsTest(SeeAllData=false)
private class CRAN_VAS_ON_ManageLeadUtil_TST{
	
	 @isTest 
    static void createLead_Constructor(){
    	
    	CRAN_VAS_ON_ManageLeadUtil_CLS constructor = new CRAN_VAS_ON_ManageLeadUtil_CLS();
    }
    
	
    @isTest 
    static void createLead_OK(){
    	
    	string strEmail = 'testEmail@test.com';
    	string strFirstName = 'TesFirstName'; 
    	string strLastName = 'TestLastName'; 
    	string strPrefix = 'prf'; 
    	string strPhone  = '111111';
    	
        Lead leadGenerated = CRAN_VAS_ON_ManageLeadUtil_CLS.createLead(strEmail,strFirstName,strLastName,strPrefix,strPhone);
        
        test.startTest();
        	system.assertNotEquals(null, leadGenerated.Id);
        test.stopTest();
    }
    
    @isTest 
    static void createLead_Error(){
    	
    	string strEmail = 'BadEmail';
    	string strFirstName = 'TesFirstName'; 
    	string strLastName = 'TestLastName'; 
    	string strPrefix = 'TestPrefix'; 
    	string strPhone  = 'TestPrhone';
    	
    	Lead leadGenerated;
    	
    	try{
    		 leadGenerated = CRAN_VAS_ON_ManageLeadUtil_CLS.createLead(strEmail,strFirstName,strLastName,strPrefix,strPhone);
        } catch (Exception e){
        	System.debug('Exception: ' + e.getMessage());
        }
        
        test.startTest();
        	system.assertEquals(null, leadGenerated);
        test.stopTest();
    }
    
    
    
    
    
   
}