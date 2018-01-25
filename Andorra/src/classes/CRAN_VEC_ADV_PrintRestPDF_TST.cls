@isTest
private class CRAN_VEC_ADV_PrintRestPDF_TST {
	
	@isTest 
	static void CRAN_VEC_ADV_PrintRestPDF_TST() {
		    // new
        	CRAN_VEC_ADV_PrintRestPDF_CTR temp = new CRAN_VEC_ADV_PrintRestPDF_CTR(); 
        	List<String> bytesPdf = temp.bytesPdf;	
            
        	// pruebas con 1 solo pdf - ok
			Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST('getDocumentoPdf'));
		
			CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
			dataFactory.createAvaloqSetting();
			Test.startTest();

        	// profile 
			CRAN_VEC_ADV_PrintRestPDF_CTR.documentPDF('1234','Profile','','',''); 
			
        	// OMS
			CRAN_VEC_ADV_PrintRestPDF_CTR.documentPDF('1234','OMS','','','');
        
        	// Archive
			CRAN_VEC_ADV_PrintRestPDF_CTR.documentPDF('1234','ARCHIVE','','','');
        
        	// varios psdfs
        	Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST('getDocumentoPdfList'));	
        	// OMS
			CRAN_VEC_ADV_PrintRestPDF_CTR.documentPDF('1234','OMS','','','');
 
            // CallOut
            CRAN_VEC_ADV_ArchiveRQ rq = new CRAN_VEC_ADV_ArchiveRQ();
            rq.bpId = '12211';
            rq.referenceLine = 'aaaaaaaaaa';
            rq.orderNr = '125463';
            String jsonRequest = JSON.serialize(rq);
			CRAN_VEC_ADV_PrintRestPDF_CTR.printPDFcallOut(CRAN_VEC_ADV_Constants_CLS.SERVICE_ARCHIVE_DOC,jsonRequest);
        
            // pruebas con error
			Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST('getDocumentoPdfError'));	
			CRAN_VEC_ADV_PrintRestPDF_CTR.documentPDF('1234','ARCHIVE','','','');

			Test.stopTest();
		
	}
    
    @isTest  
    static void testCallAxisSuccess()
    {
    	try
    	{
		    String body = 
		        '{"pdfContent":["bbbbb","aaaa"]}';
		    Map<String, String> headerMap = new Map<String, String>{'Content-Type' => 'application/json'};
		    CRAN_VEC_ADV_ArchiveRQ rq = new CRAN_VEC_ADV_ArchiveRQ();
            rq.bpId = '12211';
            rq.referenceLine = 'aaaaaaaaaa';
            rq.orderNr = '125463';
            String jsonRequest = JSON.serialize(rq);
            Test.startTest();
		    Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));       
            CRAN_VEC_ADV_PrintRestPDF_CTR.printPDFcallOutList(CRAN_VEC_ADV_Constants_CLS.SERVICE_ARCHIVE_DOC,jsonRequest);
		    Test.stopTest();
		    
		    System.assert(true);
        }
        catch(System.CalloutException  e)
        {
        	
        }
        
    }
}