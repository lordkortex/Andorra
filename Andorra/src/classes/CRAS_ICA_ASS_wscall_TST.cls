@isTest
public class CRAS_ICA_ASS_wscall_TST {
	private static String body = '';
	private static Map<String, String> headerMap = new Map<String, String>{'Authorization' => 'OAuth ' + UserInfo.getSessionId()};
    
    @testSetup 
    static void loadTestData() {
        CRAS_ICA_ASS_TestDataFactory_TST.testLoadData();
    }
    
    
    @isTest
    public static void test_CRAS_ICA_ASS_sntRestYear_WSRWithOwner()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            List<List<String>> res = CRAS_ICA_ASS_sntRestYear_WSR.getSntByMarket();
            System.assert(res != null);
        }
        Test.stopTest();  
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_sntRestYear_WSRWithoutOwner()
    {
        Test.startTest();
        List<List<String>> res = CRAS_ICA_ASS_sntRestYear_WSR.getSntByMarket();
        System.assert(res != null);
        Test.stopTest(); 
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_sntProductRestYearWithOwner()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            List<List<String>> res = CRAS_ICA_ASS_sntProductRestYear_WSR.getSntByProduct();
            System.assert(res != null);
        }
        Test.stopTest();  
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_sntProductRestYearWithoutOwner()
    {
        Test.startTest();
        List<List<String>> res = CRAS_ICA_ASS_sntProductRestYear_WSR.getSntByProduct();
        System.assert(res != null);
        Test.stopTest(); 
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_mkt1RestWithOwner()
    {
    	try
    	{
	        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
	        
	        System.runAs(userTest) 
	        {
	            Test.startTest();
	            Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	            
	            String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_mkt1Rest');
	            System.assert(res != null);
	            Test.stopTest(); 
	        }
        }
        catch(System.CalloutException  e)
        {
        	
        }
        
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_mkt1RestWithoutOwner()
    {
    	try
    	{
	        Test.startTest();
	        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        
	        String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_mkt1Rest');
	        System.assert(res != null);
	        Test.stopTest();  
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_mkt2RestWithOwner()
    {
    	try
    	{
	        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
	        
	        System.runAs(userTest) 
	        {
	            Test.startTest();
	        	Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	            
	            String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_mkt2Rest');
	            System.assert(res != null);
	            Test.stopTest();  
	        }
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_mkt2RestWitoutOwner()
    {
    	try
    	{
	        Test.startTest();
	        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        
	        String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_mkt2Rest');
	        System.assert(res != null);
	        Test.stopTest();   
        }
        catch(System.CalloutException  e)
        {
        	
        } 
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_pdt1RestWithOwner()
    {
    	try
    	{
	        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
	        
	        System.runAs(userTest) 
	        {
	            Test.startTest();
	       		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	            
	            String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_pdt1Rest');
	            System.assert(res != null);
	            Test.stopTest();  
	        }
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_pdt1RestWithoutOwner()
    {
    	try
    	{
	        Test.startTest();
	   		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        
	        String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_pdt1Rest');
	        System.assert(res != null);
	        Test.stopTest();  
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_pdt2RestWithOwner()
    {
    	try
    	{
	        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
	        
	        System.runAs(userTest) 
	        {
	            Test.startTest();
	       		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	            
	            String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_pdt2Rest');
	            System.assert(res != null);
	            Test.stopTest(); 
	        }  
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_pdt2RestWithoutOwner()
    {
    	try
    	{
	        Test.startTest();
	   		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        
	        String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_pdt2Rest');
	        System.assert(res != null);
	        Test.stopTest();
        }
        catch(System.CalloutException  e)
        {
        	
        }    
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_svpdt1RestWithOwner()
    {
    	try
    	{
	        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
	        
	        System.runAs(userTest) 
	        {
	            Test.startTest();
	       		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	            
	            String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_svpdt1Rest');
	            System.assert(res != null);
	            Test.stopTest();
	        }
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_svpdt1RestWithoutOwner()
    {
    	try
    	{
	        Test.startTest();
	   		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        
	        String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_svpdt1Rest');
	        System.assert(res != null);
	        Test.stopTest();  
        }
        catch(System.CalloutException  e)
        {
        	
        } 
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_svpdt2RestWithOwner()
    {
    	try
    	{
	        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
	        
	        System.runAs(userTest) 
	        {
	            Test.startTest();
	       		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	            
	            String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_svpdt2Rest');
	            System.assert(res != null);
	            Test.stopTest(); 
	        }
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_svpdt2RestWithoutOwner()
    {
    	try
    	{
	        Test.startTest();
	   		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        
	        String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_svpdt2Rest');
	        System.assert(res != null);
	        Test.stopTest();
        }
        catch(System.CalloutException  e)
        {
        	
        }   
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vcInsRestWithOwner()
    {
    	try
    	{
	        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
	        
	        System.runAs(userTest) 
	        {
	            Test.startTest();
	       		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	            
	            String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_vcInsRest');
	            System.assert(res != null);
	            Test.stopTest(); 
	        }
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vcInsRestWithoutOwner()
    {
    	try
    	{
	        Test.startTest();
	   		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        
	        String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_vcInsRest');
	        System.assert(res != null);
	        Test.stopTest();  
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vcIns2RestWithOwner()
    {
    	try
    	{
	        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
	        
	        System.runAs(userTest) 
	        {
	            Test.startTest();
	       		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	            
	            String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_vcIns2Rest');
	            System.assert(res != null);
	            
	            Test.stopTest();
	        }
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vcIns2RestWithoutOwner()
    {
    	try
    	{
	        Test.startTest();
       		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        
	        String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_vcIns2Rest');
	        System.assert(res != null);
	        Test.stopTest();  
        }
        catch(System.CalloutException  e)
        {
        	
        } 
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vc1RestWithOwner()
    {
    	try
    	{
	        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
	        
	        System.runAs(userTest) 
	        {
	            Test.startTest();
	       		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	            
	            String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_vc1Rest');
	            System.assert(res != null);
	            Test.stopTest(); 
	        }   
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vc1RestWithoutOwner()
    {
    	try
    	{
	        Test.startTest();
	   		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        
	        String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_vc1Rest');
	        System.assert(res != null);
	        Test.stopTest();   
        }
        catch(System.CalloutException  e)
        {
        	
        } 
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vc2RestWithOwner()
    {
    	try
    	{
	        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
	        
	        System.runAs(userTest) 
	        {    
	            Test.startTest();
	       		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	            
	            String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_vc2Rest');
	            System.assert(res != null);
	            
	            Test.stopTest();  
	        }
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vc2RestWithoutOwner()
    {
    	try
    	{
	        Test.startTest();
	   		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	       		
	        String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_vc2Rest');
	        System.assert(res != null);
	        Test.stopTest();  
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vc3RestWithOwner()
    {
    	try
    	{
	        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
	        
	        System.runAs(userTest) 
	        {
	            Test.startTest();
	       		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	            
	            String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_vc3Rest');
	            System.assert(res != null);
	            Test.stopTest(); 
	        }  
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vc3RestWithoutOwner()
    {
    	try
    	{
	        Test.startTest();
	   		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        
	        String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_vc3Rest');
	        System.assert(res != null);
	        Test.stopTest();   
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vc4RestWithOwner()
    {
    	try
    	{
	        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
	        
	        System.runAs(userTest) 
	        {
	            Test.startTest();
	       		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	            
	            String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_vc4Rest');
	            System.assert(res != null);
	            Test.stopTest(); 
	        } 
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vc4RestWithoutOwner()
    {
    	try
    	{
	        Test.startTest();
	   		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        
	        String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_vc4Rest');
	        System.assert(res != null);
	        Test.stopTest();   
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_ventasobjetivosWithOwner()
    {
    	try
    	{
	        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
	        
	        System.runAs(userTest) 
	        {
	            Test.startTest();
	       		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	            
	            String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_ventasobjetivos');
	            System.assert(res != null);
	            Test.stopTest();  
	        }
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_ventasobjetivosWithoutOwner()
    {
    	try
    	{
	        Test.startTest();
	   		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        
	        String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_ventasobjetivos');
	        System.assert(res != null);
	        Test.stopTest();  
        }
        catch(System.CalloutException  e)
        {
        	
        }    
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_ventasobjetivos2WithOwner()
    {
    	try
    	{
	        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
	        
	        System.runAs(userTest) 
	        {
	            Test.startTest();
	       		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	            
	            String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_ventasobjetivos2');
	            System.assert(res != null);
	            Test.stopTest(); 
	        }
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_ventasobjetivos2WithoutOwner()
    {
    	try
    	{
	        Test.startTest();
	   		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        
	        String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_ventasobjetivos2');
	        System.assert(res != null);
	        Test.stopTest();  
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_ventasobjetivos3WithOwner()
    {
    	try
    	{
	        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
	        
	        System.runAs(userTest) 
	        {
	            Test.startTest();
	       		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	            
	            String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_ventasobjetivos3');
	            System.assert(res != null);
	            Test.stopTest(); 
	        }  
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_ventasobjetivos3WithoutOwner()
    {
    	try
    	{
	        Test.startTest();
	   		Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        
	        String res = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_ventasobjetivos3');
	        System.assert(res != null);
	        Test.stopTest();   
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_mkt1Rest_WSR_getReportPrimeCountWithOwner ()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            List<List<String>> res = CRAS_ICA_ASS_mkt1Rest_WSR.getReportPrimeCount();
            System.assert(res != null);
        }
        Test.stopTest();  
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_mkt1Rest_WSR_getReportPrimeCountWithoutOnwer ()
    {
        Test.startTest();
        List<List<String>> res = CRAS_ICA_ASS_mkt1Rest_WSR.getReportPrimeCount();
        System.assert(res != null);
        Test.stopTest();    
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_mkt2Rest_WSR_getReportInsuredsWithOwner ()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            List<List<String>> res = CRAS_ICA_ASS_mkt2Rest_WSR.getReportInsureds();
            System.assert(res != null);
        }
        Test.stopTest();    
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_mkt2Rest_WSR_getReportInsuredsWithOwnerChangeLanguage ()
    {
        User userTest = [SELECT id, LanguageLocaleKey FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        userTest.LanguageLocaleKey = 'fr';
        update userTest;
        
        Test.startTest();
        System.runAs(userTest) {
            List<List<String>> res = CRAS_ICA_ASS_mkt2Rest_WSR.getReportInsureds();
            System.assert(res != null);
        }
        Test.stopTest();    
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_mkt2Rest_WSR_getReportInsuredsWithoutOwner ()
    {
        Test.startTest();
        List<List<String>> res = CRAS_ICA_ASS_mkt2Rest_WSR.getReportInsureds();
        System.assert(res != null);
        Test.stopTest();   
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_pdt1Rest_WSR_getReportPrimeCountWithOwner ()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            List<List<String>> res = CRAS_ICA_ASS_pdt1Rest_WSR.getReportPrimeCount();
            System.assert(res != null);
        }
        Test.stopTest();   
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_pdt1Rest_WSR_getReportPrimeCountWithoutOwner ()
    {
        Test.startTest();
        List<List<String>> res = CRAS_ICA_ASS_pdt1Rest_WSR.getReportPrimeCount();
        System.assert(res != null);
        Test.stopTest();   
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_pdt2Rest_WSR_getReportInsuredsWithOwner ()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            List<List<String>> res = CRAS_ICA_ASS_pdt2Rest_WSR.getReportInsureds();
            System.assert(res != null);
        }
        Test.stopTest();  
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_pdt2Rest_WSR_getReportInsuredsWithoutOwner ()
    {
        Test.startTest();
        List<List<String>> res = CRAS_ICA_ASS_pdt2Rest_WSR.getReportInsureds();
        System.assert(res != null);
        Test.stopTest();    
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_svpdt1Rest_WSR_getReportPrimeCountWithOwner ()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            List<List<String>> res = CRAS_ICA_ASS_svpdt1Rest_WSR.getReportPrimeCount();
            System.assert(res != null);
        }
        Test.stopTest();      
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_svpdt1Rest_WSR_getReportPrimeCountWithoutOwner ()
    {
        Test.startTest();
        List<List<String>> res = CRAS_ICA_ASS_svpdt1Rest_WSR.getReportPrimeCount();
        System.assert(res != null);
        Test.stopTest();   
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_svpdt2Rest_WSR_getReportInsuredsWithOwner ()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            List<List<String>> res = CRAS_ICA_ASS_svpdt2Rest_WSR.getReportInsureds();
            System.assert(res != null);
        }
        Test.stopTest();    
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_svpdt2Rest_WSR_getReportInsuredsWithoutOwner ()
    {
        Test.startTest();
        List<List<String>> res = CRAS_ICA_ASS_svpdt2Rest_WSR.getReportInsureds();
        System.assert(res != null);
        Test.stopTest();  
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vcInsRest_WSR_getVentasCancelacionesYearInsWithOwner ()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            String res = CRAS_ICA_ASS_vcInsRest_WSR.getVentasCancelacionesYearIns();
            System.assert(res != null);
        }
        Test.stopTest();   
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vcInsRest_WSR_getVentasCancelacionesYearInsWithoutOwner ()
    {
        Test.startTest();
        String res = CRAS_ICA_ASS_vcInsRest_WSR.getVentasCancelacionesYearIns();
        System.assert(res != null);
        Test.stopTest(); 
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vcIns2Rest_WSR_getVentasCancelacionesYearInsWithOwner ()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            String res = CRAS_ICA_ASS_vcIns2Rest_WSR.getVentasCancelacionesYearIns();
            System.assert(res != null);
        }
        Test.stopTest();   
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vcIns2Rest_WSR_getVentasCancelacionesYearInsWithoutOwner ()
    {
        Test.startTest();
        String res = CRAS_ICA_ASS_vcIns2Rest_WSR.getVentasCancelacionesYearIns();
        System.assert(res != null);
        Test.stopTest();   
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vc1Rest_WSR_getVentasCancelacionesYearWithOwner ()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            String res = CRAS_ICA_ASS_vc1Rest_WSR.getVentasCancelacionesYear();
            System.assert(res != null);
        }
        Test.stopTest();  
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vc1Rest_WSR_getVentasCancelacionesYearWithoutOwner ()
    {
        Test.startTest();
        String res = CRAS_ICA_ASS_vc1Rest_WSR.getVentasCancelacionesYear();
        System.assert(res != null);
        Test.stopTest();    
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vc2Rest_WSR_getVentasCancelacionesYearWithOwner ()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            String res = CRAS_ICA_ASS_vc2Rest_WSR.getVentasCancelacionesYear();
            System.assert(res != null);
        }
        Test.stopTest();  
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vc2Rest_WSR_getVentasCancelacionesYearWithoutOwner ()
    {
        Test.startTest();
        String res = CRAS_ICA_ASS_vc2Rest_WSR.getVentasCancelacionesYear();
        System.assert(res != null);
        Test.stopTest();  
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vc3Rest_WSR_getVentasCancelacionesYearWithOwner ()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            String res = CRAS_ICA_ASS_vc3Rest_WSR.getVentasCancelacionesYear();
            System.assert(res != null);
        }
        Test.stopTest();   
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vc3Rest_WSR_getVentasCancelacionesYearWithoutOwner ()
    {
        Test.startTest();
        String res = CRAS_ICA_ASS_vc3Rest_WSR.getVentasCancelacionesYear();
        System.assert(res != null);
        Test.stopTest();   
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vc4Rest_WSR_getVentasCancelacionesYearWithOwner ()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            String res = CRAS_ICA_ASS_vc4Rest_WSR.getVentasCancelacionesYear();
            System.assert(res != null);
        }
        Test.stopTest();   
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_vc4Rest_WSR_getVentasCancelacionesYearWithoutOwner ()
    {
        Test.startTest();
        String res = CRAS_ICA_ASS_vc4Rest_WSR.getVentasCancelacionesYear();
        System.assert(res != null);
        Test.stopTest();   
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_sntRest_WSR_getSntByMarketWithOwner ()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            List<List<String>> res = CRAS_ICA_ASS_sntRest_WSR.getSntByMarket();
            System.assert(res != null);
        }
        Test.stopTest();   
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_sntRest_WSR_getSntByMarketWithoutOwner ()
    {
        Test.startTest();
        List<List<String>> res = CRAS_ICA_ASS_sntRest_WSR.getSntByMarket();
        System.assert(res != null);
        Test.stopTest();   
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_sntProductRest_WSR_getSntByProductWithOwner ()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            List<List<String>> res = CRAS_ICA_ASS_sntProductRest_WSR.getSntByProduct();
            System.assert(res != null);
        }
        Test.stopTest();   
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_sntProductRest_WSR_getSntByProductWithoutOwner ()
    {
        Test.startTest();
        List<List<String>> res = CRAS_ICA_ASS_sntProductRest_WSR.getSntByProduct();
        System.assert(res != null);
        Test.stopTest();    
    }
    
    @isTest  
    public static void testgestorGetVentasObjetivosSavingsWithOwner()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            List<String> res = CRAS_ICA_ASS_VentasObjetivosSavings_WSR.getVentasObjetivos();
            System.assert(res != null);
        }
        Test.stopTest();  
        
    }
    
    @isTest  
    public static void testgestorGetVentasObjetivosSavingsWithoutOwner()
    {
        Test.startTest();
        List<String> res = CRAS_ICA_ASS_VentasObjetivosSavings_WSR.getVentasObjetivos();
        Test.stopTest(); 
        
        System.assert(res != null);
    }
    
    @isTest  
    public static void testgestorGetVentasObjetivosLifeWithOwner()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            List<String> res = CRAS_ICA_ASS_VentasObjetivosLife_WSR.getVentasObjetivos();
            System.assert(res != null);
        }
        Test.stopTest(); 
    }
    
    @isTest  
    public static void testgestorGetVentasObjetivosLifeWithoutOwner()
    {
        Test.startTest();
        List<String> res = CRAS_ICA_ASS_VentasObjetivosLife_WSR.getVentasObjetivos();
        Test.stopTest(); 
        
        System.assert(res != null);
    }
    
    @isTest  
    public static void testgestorGetVentasObjetivosWithOwner()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            List<String> res = CRAS_ICA_ASS_VentasObjetivos_WSR.getVentasObjetivos();
            System.assert(res != null);
        }
        Test.stopTest();
        
    }
    
    @isTest  
    public static void testgestorGetVentasObjetivosWithoutOwner()
    {
        Test.startTest();
        List<String> res = CRAS_ICA_ASS_VentasObjetivos_WSR.getVentasObjetivos();
        System.assert(res != null);
        Test.stopTest();
    }
    
    @isTest
    public static void CRAS_ICA_ASS_RecibosDevueltos_WSR_getRecibosDevueltosWithOwner()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            List<List<String>> res = CRAS_ICA_ASS_RecibosDevueltos_WSR.getRecibosDevueltos();
            System.assert(res != null);
        }
        Test.stopTest();   
    }
    
    @isTest
    public static void CRAS_ICA_ASS_RecibosDevueltos_WSR_getRecibosDevueltosWithoutOwner()
    {
        Test.startTest();
        List<List<String>> res = CRAS_ICA_ASS_RecibosDevueltos_WSR.getRecibosDevueltos();
        System.assert(res != null);
        Test.stopTest();   
    }
    
    @isTest
    public static void CRAS_ICA_ASS_PropuestasPendientes_WSR_getPropuestasPendientesWithOwner()
    {
        User userTest = [SELECT id FROM User WHERE UserName = 'testingUserCRAS@testingUserCRAS.com'];
        
        Test.startTest();
        System.runAs(userTest) {
            List<List<String>> res = CRAS_ICA_ASS_PropuestasPendientes_WSR.getPropuestasPendientes();
            System.assert(res != null);
        }
        Test.stopTest();     
    }
    
    @isTest
    public static void CRAS_ICA_ASS_PropuestasPendientes_WSR_getPropuestasPendientesWithoutOwner()
    {
        Test.startTest();
        List<List<String>> res = CRAS_ICA_ASS_PropuestasPendientes_WSR.getPropuestasPendientes();
        System.assert(res != null);
        Test.stopTest();   
    } 
}