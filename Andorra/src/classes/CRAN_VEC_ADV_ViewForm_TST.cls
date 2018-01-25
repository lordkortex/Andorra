@isTest
private class CRAN_VEC_ADV_ViewForm_TST {

    @testSetup  
    static void loadTestData() {
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
        Contact c = dataFactory.createIndividualContactWithTwoBps();
        CRAN_VEC_ADV_CustomForm__c cf = dataFactory.create_CustomForm_TemplatePF();
        dataFactory.addCustomFormResponse(cf.Id,c.Id);
        dataFactory.createAvaloqSetting();
    }
    
    @isTest 
    static void CRAN_VEC_ADV_ViewForm_TST_test1() {
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

        Account bp = new Account();
        Contact c = [SELECT Id,AccountId FROM Contact LIMIT 1];
        ID recordTypeId_BP = dataFactory.recordTypeIdByDeveloperName(bp,CRAN_VEC_ADV_TestDataFactory_TST.Account_BusinessPartner_Name);
        bp = [SELECT Id FROM Account WHERE RecordTypeId= :recordTypeId_BP LIMIT 1];
        List<CRAN_VEC_ADV_CustomForm__c> lstCustomForms = [SELECT Id FROM CRAN_VEC_ADV_CustomForm__c ORDER BY Id LIMIT 1];

        CRAN_VEC_ADV_CustomForm_Response__c temp = new CRAN_VEC_ADV_CustomForm_Response__c();
        temp.CRAN_VEC_ADV_L_Business_Partner__c = bp.Id;                             
        temp.CRAN_VEC_ADV_MD_CustomForm__c = lstCustomForms[0].Id;
        temp.CRAN_VEC_ADV_P_Acceptance_Status__c = CRAN_VEC_ADV_Constants_CLS.SIGNED;
        temp.CRAN_VEC_ADV_L_Contact__c = c.Id;

        insert temp;

        Test.startTest();
        CRAN_VEC_ADV_ViewForm_AUC.recuperarCuestionariosDone(c.AccountId);
        Test.stopTest();

    }

    @isTest 
    static void CRAN_VEC_ADV_ViewForm_TST_WithoutResp() {
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

        Account bp = new Account();
        Contact c = [SELECT Id,AccountId FROM Contact LIMIT 1];
        ID recordTypeId_BP = dataFactory.recordTypeIdByDeveloperName(bp,CRAN_VEC_ADV_TestDataFactory_TST.Account_BusinessPartner_Name);
        bp = [SELECT Id FROM Account WHERE RecordTypeId= :recordTypeId_BP LIMIT 1];
        List<CRAN_VEC_ADV_CustomForm__c> lstCustomForms = [SELECT Id FROM CRAN_VEC_ADV_CustomForm__c ORDER BY Id LIMIT 1];

        Test.startTest();
        CRAN_VEC_ADV_ViewForm_AUC.recuperarCuestionariosDone(c.AccountId);
        Test.stopTest();
    }

    @isTest 
    static void CRAN_VEC_ADV_ViewForm_TST_getFormsEmpty() {
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

        Account bp = new Account();
        Contact c = [SELECT Id,AccountId FROM Contact LIMIT 1];
        ID recordTypeId_BP = dataFactory.recordTypeIdByDeveloperName(bp,CRAN_VEC_ADV_TestDataFactory_TST.Account_BusinessPartner_Name);
        bp = [SELECT Id FROM Account WHERE RecordTypeId= :recordTypeId_BP LIMIT 1];
        List<CRAN_VEC_ADV_CustomForm__c> lstCustomForms = [SELECT Id FROM CRAN_VEC_ADV_CustomForm__c ORDER BY Id];

        CRAN_VEC_ADV_ViewForm_AUC.initApex(c.AccountId);

        Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST('getFormsEmpty'));
        Test.startTest();
        CRAN_VEC_ADV_ViewForm_AUC.recuperarCuestionariosDone(bp.Id);
        Test.stopTest();
    }

    @isTest 
    static void CRAN_VEC_ADV_ViewForm_TST_getFormsOnlyErrors() {
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();

        Account bp = new Account();
        Contact c = [SELECT Id,AccountId FROM Contact LIMIT 1];
        ID recordTypeId_BP = dataFactory.recordTypeIdByDeveloperName(bp,CRAN_VEC_ADV_TestDataFactory_TST.Account_BusinessPartner_Name);
        bp = [SELECT Id FROM Account WHERE RecordTypeId= :recordTypeId_BP LIMIT 1];
        List<CRAN_VEC_ADV_CustomForm__c> lstCustomForms = [SELECT Id FROM CRAN_VEC_ADV_CustomForm__c ORDER BY Id];

        CRAN_VEC_ADV_ViewForm_AUC.initApex(c.AccountId);

        Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST('getFormsOnlyErrors'));
        Test.startTest();
        CRAN_VEC_ADV_ViewForm_AUC.recuperarCuestionariosDone(bp.Id);
        Test.stopTest();

    }

    @isTest 
    static void retrieveReferenceLine_Test1() {
        CRAN_VAS_KER_ESignature__c mylistRefLine = new CRAN_VAS_KER_ESignature__c();
        mylistRefLine.CRAN_VAS_KER_Reference_Line__c = '11111';
        mylistRefLine.CRAN_VAS_KER_Core_Id__c = '2222';

        insert mylistRefLine;

        Test.startTest();
        CRAN_VEC_ADV_ViewForm_AUC.retrieveReferenceLine('2222');
        Test.stopTest();
    }

    @isTest 
    static void retrieveReferenceLine_Empty() {
        Test.startTest();
        CRAN_VEC_ADV_ViewForm_AUC.retrieveReferenceLine('3333');
        Test.stopTest();
    }
}