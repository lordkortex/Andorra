@isTest
private class CRAN_VEC_ADV_NewIPL_TST {
    @testSetup
    static void loadTestData() {
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
        Contact mainContact = dataFactory.createIndividualContactWithTwoBps();
        Id bpAccRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName='CRAN_VEC_ADV_Business_Partner'][0].Id;
		Account accBP = [SELECT Id FROM Account WHERE RecordTypeId = :bpAccRecordTypeId LIMIT 1];
        FinServ__FinancialAccount__c finAcc = [SELECT Id FROM FinServ__FinancialAccount__c WHERE Name = 'Test Finacial Account' LIMIT 1];
        Opportunity opp = dataFactory.createOppwithVersionwithIPLs(finAcc.Id, accBP.Id);
    }

    @isTest
    static void CRAN_VEC_ADV_NewIPLController_isOK() {
        Quote quot = [SELECT Id FROM QUOTE LIMIT 1];
        FinServ__Securities__c asset = new FinServ__Securities__c(Name = 'Security', FinServ__SecuritiesName__c = 'Security ', FinServ__SourceSystemId__c = '9_');
        insert asset;
        Test.startTest();
        CRAN_VEC_ADV_Investment_Proposition_Line__c ipl = new CRAN_VEC_ADV_Investment_Proposition_Line__c();
        ipl.CRAN_VEC_ADV_FieldChangedbyUser__c = 'Quantity';
        ipl.CRAN_VEC_ADV_N_PercentQtty__c = 100;
        CRAN_VEC_ADV_NewIPL_AUC.saveIPL(ipl, quot.Id, asset.Id,57,null,null);
        Test.stopTest();
    }

    @isTest
    static void CRAN_VEC_ADV_NewIPLController_isNotEdit() {
        Quote quot = [SELECT Id FROM QUOTE LIMIT 1];
        FinServ__Securities__c asset = new FinServ__Securities__c(Name = 'Security', FinServ__SecuritiesName__c = 'Security ', FinServ__SourceSystemId__c = '9_');
        insert asset;
        Opportunity o  = [SELECT StageName FROM Opportunity WHERE Id IN (SELECT OpportunityId FROM Quote WHERE Id = :quot.Id)];
        o.StageName  = 'advClosed';
        update o;
        Test.startTest();
        CRAN_VEC_ADV_NewIPL_AUC.checkQuoteStatus(quot.Id);
        Test.stopTest();
    }

    @isTest
    static void CRAN_VEC_ADV_NewIPLController_duplicateAsset() {
        Quote quot = [SELECT Id FROM QUOTE LIMIT 1];
        FinServ__Securities__c asset = new FinServ__Securities__c(Name = 'Security', FinServ__SecuritiesName__c = 'Security ', FinServ__SourceSystemId__c = '9_');
        insert asset;
        CRAN_VEC_ADV_Investment_Proposition_Line__c ipl = new CRAN_VEC_ADV_Investment_Proposition_Line__c(Name = 'Test', CRAN_VEC_ADV_L_Assets__c = asset.Id, CRAN_VEC_ADV_FieldChangedbyUser__c = 'Quantity', CRAN_VEC_ADV_N_PropQtty__c = 100);
        CRAN_VEC_ADV_NewIPL_AUC.saveIPL(ipl, quot.Id, asset.Id,57,null,null );
        Test.startTest();
        CRAN_VEC_ADV_Investment_Proposition_Line__c ipl2 = new CRAN_VEC_ADV_Investment_Proposition_Line__c();
        ipl2.CRAN_VEC_ADV_FieldChangedbyUser__c = 'Market Value';
        ipl2.CRAN_VEC_ADV_N_PropMktValue__c = 50;
        CRAN_VEC_ADV_NewIPL_AUC.saveIPL(ipl2, quot.Id, asset.Id,57,null,null );
        Test.stopTest();
    }

    @isTest
    static void CRAN_VEC_ADV_NewIPLController_fetchAsset() {
        Test.startTest();
        CRAN_VEC_ADV_NewIPL_AUC.fetchAsset('test');
        Test.stopTest();
    }

    @isTest
    static void CRAN_VEC_ADV_NewIPLController_checkQuoteStatus() {
        Test.startTest();
        Quote quot = [SELECT Id FROM QUOTE LIMIT 1];
        CRAN_VEC_ADV_NewIPL_AUC.checkQuoteStatus(quot.Id);
        Test.stopTest();
    }

    @isTest
    static void CRAN_VEC_ADV_NewIPLController_DMLInsertNotAllowed() {
        Quote quot = [SELECT Id FROM QUOTE LIMIT 1];
        FinServ__Securities__c asset = new FinServ__Securities__c(Name = 'Security', FinServ__SecuritiesName__c = 'Security ', FinServ__SourceSystemId__c = '9_');
        insert asset;
        Test.startTest();
        CRAN_VEC_ADV_Investment_Proposition_Line__c ipl = new CRAN_VEC_ADV_Investment_Proposition_Line__c();
        ipl.CRAN_VEC_ADV_FieldChangedbyUser__c = 'Quantity';
        ipl.CRAN_VEC_ADV_N_PropQtty__c = 100;
        try{
            insert ipl;
            } catch (Exception e){
                Boolean expectedExceptionThrown =  e.getMessage().contains('Function not available, use button') ? true : false;
                //System.AssertEquals(expectedExceptionThrown, true);
            }
        Test.stopTest();
    }
}