@isTest
public class CRAS_ICA_ASS_Reports_TST {
    
    private static String body = '';
	private static Map<String, String> headerMap = new Map<String, String>{'Authorization' => 'OAuth ' + UserInfo.getSessionId()};
    
    @testSetup 
    static void loadTestData() {
        CRAS_ICA_ASS_TestDataFactory_TST.testLoadData();
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_TestGetRiskSet()
    {
        Id uId = UserInfo.getUserId();
        String res = CRAS_ICA_ASS_Reports_AUC.getRiskSet(uId);
        System.assert(res != null);
              
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_TestGetRiskInsSet()
    {
        Id uId = UserInfo.getUserId();
        String res = CRAS_ICA_ASS_Reports_AUC.getRiskInsSet(uId);
        System.assert(res != null);
              
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_TestGetSavingsSet()
    {
        Id uId = UserInfo.getUserId();
        String res = CRAS_ICA_ASS_Reports_AUC.getSavingsSet(uId);
        System.assert(res != null);
              
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_TestGetVentasObjetivosHealth()
    {
    	try
    	{
	        Test.startTest();
	        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        String res = CRAS_ICA_ASS_Reports_AUC.getVentasObjetivos('health');
	        System.assert(res != null);
	        Test.stopTest();
        }
        catch(System.CalloutException  e)
        {
        	
        }
              
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_TestGetVentasObjetivosLife()
    {
    	try
    	{
	        Test.startTest();
	        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        String res = CRAS_ICA_ASS_Reports_AUC.getVentasObjetivos('life');
	        System.assert(res != null);
	        Test.stopTest();
        }
        catch(System.CalloutException  e)
        {
        	
        }
              
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_TestGetVentasObjetivosSavings()
    {
    	try
    	{	           
	        Test.startTest();
	        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        String res = CRAS_ICA_ASS_Reports_AUC.getVentasObjetivos('savings');
	        System.assert(res != null);
	        Test.stopTest();
        }
        catch(System.CalloutException  e)
        {
        	
        }
              
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_TestGetRecibosDevueltos()
    {
    	try
    	{
	        Test.startTest();
	        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        String res = CRAS_ICA_ASS_Reports_AUC.getRecibosDevueltos();
	        System.assert(res != null);
	        Test.stopTest();
        }
        catch(System.CalloutException  e)
        {
        	
        }
              
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_TestGetPropuestasPendientes()
    {
    	try
    	{
	        Test.startTest();
	        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        String res = CRAS_ICA_ASS_Reports_AUC.getPropuestasPendientes();
	        System.assert(res != null);
	        Test.stopTest();
        }
        catch(System.CalloutException  e)
        {
        	
        }
              
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_TestGetReportPrimeCountMarket()
    {
    	try
    	{ 
	        Test.startTest();
	        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        String res = CRAS_ICA_ASS_Reports_AUC.getReportPrimeCountMarket();
	        System.assert(res != null);
	        Test.stopTest();
        }
        catch(System.CalloutException  e)
        {
        	
        }
              
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_TestGetReportInsuredsMarket()
    {
    	try
    	{
	        Test.startTest();
	        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        String res = CRAS_ICA_ASS_Reports_AUC.getReportInsuredsMarket();
	        System.assert(res != null);
	        Test.stopTest();
        }
        catch(System.CalloutException  e)
        {
        	
        }
              
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_TestGetReportPrimeCountProduct()
    {
    	try
    	{
	        Test.startTest();
	        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        String res = CRAS_ICA_ASS_Reports_AUC.getReportPrimeCountProduct();
	        System.assert(res != null);
	        Test.stopTest();
        }
        catch(System.CalloutException  e)
        {
        	
        }
              
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_TestGetReportInsuredsProduct()
    {
    	try
    	{
	        Test.startTest();
	        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        String res = CRAS_ICA_ASS_Reports_AUC.getReportInsuredsProduct();
	        System.assert(res != null);
	        Test.stopTest();  
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_TestGetReportPrimeCountSVProduct()
    {
    	try
    	{  
	        Test.startTest();
	        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        String res = CRAS_ICA_ASS_Reports_AUC.getReportPrimeCountSVProduct();
	        System.assert(res != null);
	        Test.stopTest();
        }
        catch(System.CalloutException  e)
        {
        	
        }
              
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_TestGetReportInsuredsSVProduct()
    {
    	try
    	{ 
	        Test.startTest();
	        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        String res = CRAS_ICA_ASS_Reports_AUC.getReportInsuredsSVProduct();
	        System.assert(res != null);
	        Test.stopTest();
        }
        catch(System.CalloutException  e)
        {
        	
        }
              
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_TestGetSntByMarketTrue()
    {
    	try
    	{
	        Test.startTest();
	        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        String res = CRAS_ICA_ASS_Reports_AUC.getSntByMarket('market','true');
	        System.assert(res != null);
	        Test.stopTest();
        }
        catch(System.CalloutException  e)
        {
        	
        }
              
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_TestGetSntByMarketFalse()
    {
    	try
    	{ 
	        Test.startTest();
	        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        String res = CRAS_ICA_ASS_Reports_AUC.getSntByMarket('market','false');
	        System.assert(res != null);
	        Test.stopTest();
        }
        catch(System.CalloutException  e)
        {
        	
        }
              
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_TestGetSntByProductTrue()
    {
    	try
    	{
	        Test.startTest();
	        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        String res = CRAS_ICA_ASS_Reports_AUC.getSntByMarket('product','true');
	        System.assert(res != null);
	        Test.stopTest();
        }
        catch(System.CalloutException  e)
        {
        	
        }
              
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_TestGetSntByProductFalse()
    {
    	try
    	{
	        Test.startTest();
	        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
	        String res = CRAS_ICA_ASS_Reports_AUC.getSntByMarket('product','false');
	        System.assert(res != null);
	        Test.stopTest();   
        }
        catch(System.CalloutException  e)
        {
        	
        }
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_TestGetUserCurrency()
    {
        String res = CRAS_ICA_ASS_Reports_AUC.getUserCurrency();
        System.assert(res != null);
              
    }
    
    @isTest
    public static void test_CRAS_ICA_ASS_TestGetUserId()
    {
        String res = CRAS_ICA_ASS_Reports_AUC.getUserId();
        System.assert(res != null);
              
    }
    
}