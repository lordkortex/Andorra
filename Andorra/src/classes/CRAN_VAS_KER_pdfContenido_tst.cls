@isTest

private class CRAN_VAS_KER_pdfContenido_tst
{
    @isTest static  void testGetCallout()
    {
        apexpages.currentpage().getparameters().put('BP' , 'BP_0001');
        apexpages.currentpage().getparameters().put('Order' , 'Order_0001');
        apexpages.currentpage().getparameters().put('RF' , 'RF_0001');  
        
        CRAN_VAS_KER_SignatureBus__c endPoint = new CRAN_VAS_KER_SignatureBus__c();
        endPoint.Name = 'ARCHIVE';
        endPoint.ArchivalSource__c = 'https://dp.dev.creditandorragroup.com:4444/service1/documentService/archive/';
        endPoint.GetBase64PDFEndPoint__c = 'https://dp.dev.creditandorragroup.com:4444/service1/documentService/archive/GetFromArchiveEndPoint';
        endPoint.GetFromArchiveEndPoint__c = 'https://dp.dev.creditandorragroup.com:4444/service1/documentService/archive/';
        endPoint.SendToArchiveEndPoint__c = 'https://dp.dev.creditandorragroup.com:4444/service1/documentService/archive/';
        endPoint.CertificateName__c = 'salesforce';
        endPoint.HttpRequestTimeout__c = 120;
        endPoint.SignatureRegister__c = 'https://dp.dev.creditandorragroup.com:4444/service1/documentService/registroDeFirma/';
        insert endPoint;
        
        Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_pdfContenidoCallout_tst());                     
        CRAN_VAS_KER_pdfContenido_ctr objctr = new CRAN_VAS_KER_pdfContenido_ctr();
        CRAN_VAS_KER_pdfContenido_ctr.retornarBase64('BP_0001','Order_0001','RF_0001');
        
    }            
}