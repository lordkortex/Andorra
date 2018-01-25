/**
* Company         : VASS
* Version         : 1.0 
* Project         : Credit Andorra
* Description     :     
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0     22/01/2018		Nacho Hita				Created the test file
*
******/

@IsTest
private class CRAN_VAS_ON_AnswerUtils_TST {
	
    public static String strCode, strError, strCodeFail;
    public static CRAN_VAS_ON_JSONAnswer_CLS objError1, objError2, objError3;
    
    @isTest static void constructor_OK(){
        CRAN_VAS_ON_AnswerUtils_CLS a = new CRAN_VAS_ON_AnswerUtils_CLS();
    }

    @isTest static void answerUtilTest_OK(){
		// Send the code
        strCode		=	'OK';
		objError1	=	CRAN_VAS_ON_AnswerUtils_CLS.createErrorObject(strCode);
        System.assertEquals(strCode, objError1.code);
        
    } 
    
    @isTest static void answerUtilTest_IntegrationError(){
        // Send the code and the concatenate the error
        strCode		=	'Integration_Error';
		objError2	=	CRAN_VAS_ON_AnswerUtils_CLS.createErrorObject(strCode, strError);
        System.assertEquals(strCode, objError2.code);
    }
    
    @isTest static void answerUtilTest_KO(){
        // Generate a custom error
        strCodeFail	=	'fake';
		objError3	=	CRAN_VAS_ON_AnswerUtils_CLS.createErrorObject(strCodeFail, strError);
        System.assertEquals(true, objError3.code.contains('9999'));
    } 
}