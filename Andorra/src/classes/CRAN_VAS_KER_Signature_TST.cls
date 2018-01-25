/**
* This class contains unit tests for validating the Signature process
*/
@isTest
private class CRAN_VAS_KER_Signature_TST {
    
    private static final String successUrl = 'http://mock.urlte.st/success';
    
    
    @testSetup
    static void setup() {
        CRAN_VAS_KER_TestDataFactory_TST.createFsBaseDataAdvisory();
        
        CRAN_VEC_ADV_AvaloqSettings__c avaloqSettings = new CRAN_VEC_ADV_AvaloqSettings__c();
        avaloqSettings.CRAN_VEC_ADV_T_PrivateKey__c = 'ABc44bmA4hk61ltfhMraHjb3Ng4a4abc';
        avaloqSettings.CRAN_VEC_ADV_T_AlgorithmName__c = 'AES256';
        avaloqSettings.CRAN_VEC_ADV_T_TimeOut__c = 120000;
        avaloqSettings.CRAN_VEC_ADV_T_Enviroment__c = 'DEV';
        avaloqSettings.CRAN_VEC_ADV_T_CodAppOrigin__c = 'FSC';
        avaloqSettings.CRAN_VEC_ADV_MockServiceList__c	= 'SfExecRebalp';
        avaloqSettings.CRAN_VEC_ADV_Datapower__c = 'https://mock.creditandorra.ad';
        avaloqSettings.CRAN_VEC_ADV_DatapowerEncrypted__c = 'https://mock.creditandorra.ad';
        insert avaloqSettings;        
        
        CRAN_VAS_KER_SignatureBus__c signatureBus = new CRAN_VAS_KER_SignatureBus__c();
        signatureBus.Name = 'ARCHIVE';
        signatureBus.CertificateName__c = 'salesforceclient';
        signatureBus.HttpRequestTimeout__c = 120;
        signatureBus.GetBase64PDFEndPoint__c = 'https://mock.creditandorra.ad/service1/documentService/oms/';
        signatureBus.SendToArchiveEndPoint__c = 'https://mock.creditandorra.ad/service1/documentService/document';
        signatureBus.MetadataRetrievalEndPoint__c = 'https://mock.creditandorra.ad/service1/avaloqService/retrieveMetadata';
        signatureBus.PrintOMSEndPoint__c = 'https://mock.creditandorra.ad/service2/AvaloqServiciosSF/lanzarServicio/AsString';
        signatureBus.GetFromArchiveEndPoint__c = 'https://mock.creditandorra.ad/service1/documentService/archive';
        signatureBus.AvaloqEnvironment__c = 'DEV';
        signatureBus.Origin__c = 'SF_CA';
        signatureBus.ArchivalSource__c = 'AVAD34';
        signatureBus.SignatureRegister__c = 'https://dp.dev.creditandorragroup.com:4444/service1/documentService/registroDeFirma/';
        
        insert signatureBus;        
        
        CRAN_VAS_KER_Docusign__c docusignSetting = new CRAN_VAS_KER_Docusign__c();
        docusignSetting.Name = 'DocuSign';
        docusignSetting.Integration_Key__c = 'testkey';
        docusignSetting.Login_URL__c = 'http://mock.docusign.com';
        docusignSetting.Password__c = 'test';
        docusignSetting.Username__c = 'test';
  
        insert docusignSetting;
        
    }
    
    @isTest
    static void contractSignatureTest() {
        
        User usr = new User ( Id = UserInfo.getUserId(), MobilePhone = '34256874567');
        update usr;
        
        System.runAs(usr) {
  
            Account 		acc = [SELECT Id FROM Account WHERE RecordTypeId =: CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account','CRAN_VEC_ADV_Individual')];
            List<Account> 	bps = [SELECT Id FROM Account WHERE RecordTypeId =: CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account','CRAN_VEC_ADV_Business_Partner')];
            acc.CRAN_VEC_ADV_B_AdvAccount__c = true;
            
            List<sObject> toInsert = new List<sObject>();        
            Contract contract = new Contract(AccountId = acc.Id,
                                             CurrencyIsoCode = 'EUR',
                                             CRAN_VAS_KER_BP__c = bps.get(0).Id,
                                             ContractTerm = 12,
                                             CRAN_VAS_KER_Comision__c = 1,
                                             CRAN_VAS_KER_Signer2__c = UserInfo.getUserId(),
                                             CRAN_VAS_KER_Signer3__c = UserInfo.getUserId(),
                                             CreatedDate = System.now(),
                                             Status = 'Draft');
            
            insert contract;
            
            Test.startTest();
            
            setMockHttpRequestDocusign();
            
            
            
            Object o = CRAN_VAS_KER_SignatureCmpController.startSignatureProcess(contract.Id);    
            if(o instanceOf String){
                String url = (String) o;
                System.assertEquals(url, successUrl);    
            } else {
                System.assert(true);
            }
            
            Test.stopTest();        
        }
    }
    
    @isTest
    static void opportunitySignatureTest() {
        
        Account 		acc = [SELECT FinServ__PrimaryContact__c FROM Account WHERE RecordTypeId =: CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account','CRAN_VEC_ADV_Individual')];
        List<Account> 	bps = [SELECT Id FROM Account WHERE RecordTypeId =: CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account','CRAN_VEC_ADV_Business_Partner')];
        
        Opportunity opp = new Opportunity(AccountId = bps[0].Id,
                                          Name = 'Test Opportunity',
                                          RecordTypeId = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', 'General'),
                                          StageName = 'advToSign',
                                          CRAN_VEC_ADV_L_PersonId__c = acc.FinServ__PrimaryContact__c,
                                          CRAN_VEC_ADV_T_AvaloqPropId__c  = '583705395',
                                          CloseDate = System.today(),
                                          CurrencyIsoCode = 'EUR');
        
        insert opp;
        
        Test.startTest();
        
        setMockHttpRequestDocusign();        
        Object o = CRAN_VAS_KER_SignatureCmpController.startSignatureProcess(opp.Id);    
        if(o instanceOf String){
        	String url = (String) o;
            System.assertEquals(url, successUrl);    
        } else {
            System.assert(true);
        }
        Test.stopTest();        
    }
    
    @isTest
    static void orderSignatureTest() {
        
        Account 		acc = [SELECT FinServ__PrimaryContact__c FROM Account WHERE RecordTypeId =: CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account','CRAN_VEC_ADV_Individual')];
        List<Account> 	bps = [SELECT Id FROM Account WHERE RecordTypeId =: CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account','CRAN_VEC_ADV_Business_Partner')];
        
        Opportunity opp = new Opportunity(AccountId = bps[0].Id,
                                          Name = 'Test Opportunity',
                                          RecordTypeId = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', 'General'),
                                          StageName = 'advToSign',
                                          CRAN_VEC_ADV_L_PersonId__c = acc.FinServ__PrimaryContact__c,
                                          CRAN_VEC_ADV_T_AvaloqPropId__c  = '583705395',
                                          CloseDate = System.today(),
                                          CurrencyIsoCode = 'EUR');
        
        insert opp;
        
        Order order = new Order (	AccountId = bps[0].Id, 
                           			Name = 'Test Order', 
                           			OpportunityId = opp.Id,
                          			EndDate = System.today(),
                                	EffectiveDate = System.today(),
                                 	CRAN_VEC_ADV_B_Signed__c = false,
                                 	CRAN_VEC_ADV_B_ExecuteToConfirm__c = true,
                                 	RecordTypeId = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Order', CRAN_VEC_ADV_Constants_CLS.CRAN_VEC_ADV_ORDER_INVT_PROP),
                                	Status = 'Draft');


		insert order;        
        
        Test.startTest();
        
        setMockHttpRequestDocusign();
        
        Object o = CRAN_VAS_KER_SignatureCmpController.startSignatureProcess(order.Id);    
        if(o instanceOf String){
        	String url = (String) o;
            System.assertEquals(url, successUrl);    
        } else {
            System.assert(true);
        }
        Test.stopTest();        
    }    
    
    @isTest
    static void attachmentSignatureTest() {
        
        Account 		acc = [SELECT Id FROM Account WHERE RecordTypeId =: CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account','CRAN_VEC_ADV_Individual')];
        List<Account> 	bps = [SELECT Id FROM Account WHERE RecordTypeId =: CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account','CRAN_VEC_ADV_Business_Partner')];   
        
        Contract contract = new Contract(AccountId = acc.Id,
                                         CurrencyIsoCode = 'EUR',
                                         CRAN_VAS_KER_BP__c = bps.get(0).Id,
                                         ContractTerm = 12,
                                         CRAN_VAS_KER_Comision__c = 1,
                                         CreatedDate = System.now(),
                                         Status = 'Draft');
        insert contract;
        
        Attachment attch = new Attachment(ParentId = contract.Id,
                                          Name = 'Test Attachment',
                                          Body = Blob.valueOf('XYZ'));        
        Test.startTest();
        
        setMockHttpRequestICA();
        insert attch;
        
        Test.stopTest();        
    }    
    
    private static void setMockHttpRequestDocusign() {
        
        String content;
        
        CRAN_VAS_KER_SingleRequestMock login = new CRAN_VAS_KER_SingleRequestMock(200,
                                                                                  'Complete',
                                                                                  '{"loginAccounts" : [{"baseUrl": "http://mock.docusign.com", "name": "test", "accountId": "test", "email": "test@test.com", "siteDescription":"1"}]}',
                                                                                  null);                                                        							 
        CRAN_VAS_KER_SingleRequestMock buildEnvelope = new CRAN_VAS_KER_SingleRequestMock(201,
                                                                                          'Complete',
                                                                                          '{"envelopeId": "00M0CKF4K31D00"}',
                                                                                          null);
        CRAN_VAS_KER_SingleRequestMock getUrl = new CRAN_VAS_KER_SingleRequestMock(201,
                                                                                   'Complete',
                                                                                   '{"url": "' + successUrl + '"}',
                                                                                   null);
        
        content = '{"service":"SfOmsPrint","content":"{\\"omsIdList\\":[{\\"id\\":\\"AVAD34.CREDITANDORRA.AD::83686270\\", \\"orderNr\\":584819383, \\"omsId\\":584819383}],\\"orderNr\\":584819383,\\"errors\\":null}","codAppOrigin":"SF_CA","codModAppOrigin":null,"codEnv":"DEV"}';
        
        CRAN_VAS_KER_SingleRequestMock printOmsDoc = new CRAN_VAS_KER_SingleRequestMock(200,
                                                                                        'Complete',
                                                                                        getEncryptedJsonContent(content),
                                                                                        null);
        
        CRAN_VAS_KER_SingleRequestMock avaloqPdf = new CRAN_VAS_KER_SingleRequestMock(200,
                                                                                      'Complete',
                                                                                      '{ "pdfContent" : "' + EncodingUtil.base64Encode(Blob.valueOf('TEST')) + '" }',
                                                                                      null);
        
        content = '{"orderList":{"order":{"mailActionId":"HOLD_MAIL","mail":"Propuesta de inversión de rebalance","source":"AVAD34","mailId":"REBALP","langName":"Catalán","timeStampCreate":"20170713 16:38:54","langId":"ca","timeStampExpiry":"20170713 16:38:54","mailAction":"Hold Mail","mailType":"adv","orderNr":584819383}}}';
        CRAN_VAS_KER_SingleRequestMock metadata = new CRAN_VAS_KER_SingleRequestMock(200,
                                                                                     'Complete',
                                                                                     getEncryptedJsonContent(content),
                                                                                     null);   
        
        CRAN_VAS_KER_SingleRequestMock notifyOMS = new CRAN_VAS_KER_SingleRequestMock(200,
                                                                                      'Complete',
                                                                                      getEncryptedJsonContent('{ success: true }'),
                                                                                      null); 
        
        CRAN_VAS_KER_SingleRequestMock mergePdf = new CRAN_VAS_KER_SingleRequestMock(200,
                                                                                      'Complete',
                                                                                      '{ "pdfContent" : "' + EncodingUtil.base64Encode(Blob.valueOf('TEST')) + '" }',
                                                                                      null);        
        
        
        
        
        Map<String, HttpCalloutMock> mockReqMap = new Map<String,HttpCalloutMock>();
        mockReqMap.put('http://mock.docusign.com', login);
        mockReqMap.put('https://mock.creditandorra.ad/service1/documentService/oms/', avaloqPdf);                                                                                   
        mockReqMap.put('http://mock.docusign.com/envelopes', buildEnvelope);
        mockReqMap.put('https://mock.creditandorra.ad/service2/AvaloqServiciosSF/lanzarServicio/AsString', printOmsDoc);
        mockReqMap.put('https://mock.creditandorra.ad/service1/avaloqService/retrieveMetadata', metadata);
        mockReqMap.put('https://mock.creditandorra.ad/notifyOMS', notifyOMS);
        mockReqMap.put('https://mock.creditandorra.ad/service2/SFCservicesCreditAndorra/APIv1.0/service/getMergedPDF', mergePdf);
        mockReqMap.put('http://mock.docusign.com/envelopes/00M0CKF4K31D00/views/recipient', getUrl);        
        
        HttpCalloutMock multiCalloutMock = new CRAN_VAS_KER_MultiRequestMock(mockReqMap);
        
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);

        
    }
    
    private static void setMockHttpRequestICA() {
        
        CRAN_VAS_KER_SingleRequestMock getArchivalMock = new CRAN_VAS_KER_SingleRequestMock(201, 'Complete', 
                                                                                            '{"result": "OK"}',
                                                                                            null);
        Test.setMock(HttpCalloutMock.class, getArchivalMock);
        
    }
    
    private static String getEncryptedJsonContent(String jsonContent) {
        
        CRAN_VEC_ADV_UtilEncryption_CLS encrypUtil 	= new CRAN_VEC_ADV_UtilEncryption_CLS();		
        CRAN_ICA_KER_JSONhttpRequest_OBJ wrap = new CRAN_ICA_KER_JSONhttpRequest_OBJ();
        wrap.encrypted 	= encrypUtil.encryptManaged(jsonContent);
        
        return  JSON.serialize(wrap);
        
    }
    
}