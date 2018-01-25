/**
 * CRAN_VEC_ADV_RestClient_TST
 *
 * Fecha: 01/06/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
@isTest
public class CRAN_VEC_ADV_RestClient_TST {

    @isTest 
	static void DatapowerClient() {
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
        dataFactory.createAvaloqSettingMockTrue();
		Test.startTest();
        CRAN_VEC_ADV_RestClient_CLS client = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_OMS_PRINT,'',false); 	
    }
    
    @isTest 
	static void buildRequestNoHeaders() {
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
        dataFactory.createAvaloqSettingMockTrue();
		Test.startTest();
        CRAN_VEC_ADV_RestClient_CLS client = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_OMS_PRINT,'',false); 	
        CRAN_VEC_ADV_RestClient_CLS.buildRequest(null, 'URL', 'POST', 'BODY');
    }
       
}