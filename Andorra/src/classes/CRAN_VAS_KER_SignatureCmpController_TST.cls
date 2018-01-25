@isTest
public class CRAN_VAS_KER_SignatureCmpController_TST {
    
    @testSetup
    static void setup() {
        
        CRAN_VAS_KER_TestDataFactory_TST.createFsBaseDataAdvisory();
        
        Account 		acc = [SELECT Id, FinServ__PrimaryContact__c FROM Account WHERE RecordTypeId =: CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account','CRAN_VEC_ADV_Individual')];
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
        
        Opportunity opp = new Opportunity(AccountId = bps[0].Id,
                                          Name = 'Test Opportunity',
                                          RecordTypeId = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', 'General'),
                                          StageName = 'advToSign',
                                          CRAN_VEC_ADV_L_PersonId__c = acc.FinServ__PrimaryContact__c,
                                          CRAN_VEC_ADV_T_AvaloqPropId__c  = '583705395',
                                          CloseDate = System.today(),
                                          CRAN_VEC_ADV_B_Expired__c = false,
                                          CurrencyIsoCode = 'EUR');
        
        insert opp;
        
        CRAN_VEC_ADV_CustomForm__c cf = new CRAN_VEC_ADV_CustomForm__c();
        cf.CRAN_VEC_ADV_B_Enable__c = true;
        cf.CRAN_VEC_ADV_N_Version__c = 1;
        cf.CRAN_VEC_ADV_P_PersonType__c = '120';
        cf.CRAN_VEC_ADV_P_Type__c = 'mdb$mifid';
        cf.CRAN_VEC_ADV_T_Metadata_Types_ID__c = 'CRAN_VEC_ADV_CF_SUIV2PF';
        insert cf;        
        
        CRAN_VEC_ADV_CustomForm_Response__c pSuitableTestRespond = new CRAN_VEC_ADV_CustomForm_Response__c();
        pSuitableTestRespond.CRAN_VEC_ADV_L_Contact__c = acc.FinServ__PrimaryContact__c;
        pSuitableTestRespond.CRAN_VEC_ADV_MD_CustomForm__c = cf.Id;
        pSuitableTestRespond.CRAN_VEC_ADV_DT_StartDate__c = Datetime.now();
        insert pSuitableTestRespond;        
        
    }
    
    @isTest
    static void testFailingSignature() {
        try {
            CRAN_VAS_KER_SignatureCmpController.startSignatureProcess(UserInfo.getUserId());    
        } catch(AuraHandledException ex) {
            system.debug(ex);
            System.assertEquals(ex.getMessage(), System.Label.CRAN_VAS_KER_SignatureExceptionNoController + ' ' + UserInfo.getUserId());
        }         
    }
    
    @isTest
    static void testGetMobilePhoneNumber() {
        
        User usr = new User ( Id = UserInfo.getUserId(), MobilePhone = '34256874567');
        update usr;
        
        System.runAs(usr) {
            
            Contract con = [SELECT Id FROM Contract LIMIT 1];
            
            Map<String, String> phones = CRAN_VAS_KER_SignatureCmpController.getMobilePhoneInfo(con.Id);  
            
            system.assert(!phones.isEmpty());
            
            Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
            
            phones = CRAN_VAS_KER_SignatureCmpController.getMobilePhoneInfo(opp.Id);  
            
            system.assert(!phones.isEmpty());  
            
            CRAN_VEC_ADV_CustomForm_Response__c customForm = [SELECT Id, CRAN_VEC_ADV_L_Contact__r.Name FROM CRAN_VEC_ADV_CustomForm_Response__c LIMIT 1];
            
            phones = CRAN_VAS_KER_SignatureCmpController.getMobilePhoneInfo(customForm.Id);  
            
            system.assert(!phones.isEmpty());                  
            
        }
    } 
    
    @isTest
    static void testGetInvalidMobilePhoneNumber() {
        
        
        try {
            
            Contract con = [SELECT Id FROM Contract LIMIT 1];
            
            CRAN_VAS_KER_SignatureCmpController.getMobilePhoneInfo(con.Id);  
            
            
        } catch(AuraHandledException ex) {
            system.debug(ex);
            System.assertEquals(ex.getMessage(), String.format(Label.CRAN_VAS_KER_SignerPhoneNumberIsBlank,
                                                               new String[] {
                                                                   UserInfo.getName()
                                                                       }));
        }         
        
    }      
}