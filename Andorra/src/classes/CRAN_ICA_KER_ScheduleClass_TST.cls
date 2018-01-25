@isTest
public class CRAN_ICA_KER_ScheduleClass_TST {
    @testSetup 
    static void loadTestData() {
        CRAS_ICA_ASS_TestDataFactory_TST.testLoadData();
    }
    
    @isTest
    static void testDeleteInvoiceANDClaims(){
        Test.startTest();
        CRAN_ICA_KER_DeleteInvoiceANDClaims_CLS sh1 = new CRAN_ICA_KER_DeleteInvoiceANDClaims_CLS();      
     	String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, sh1);
        Test.stopTest();
    }
    
    @isTest
    static void testUpdateIdentity(){
        Test.startTest();
        CRAN_ICA_KER_UpdateIdentity_CLS sh1 = new CRAN_ICA_KER_UpdateIdentity_CLS();      
     	String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, sh1);
        Test.stopTest();
    }
    
    @isTest
    static void testChangeOwnersSchedulable(){
        Test.startTest();
        CRAN_ICA_KER_ChangeOwnersSchedulable_CLS sh1 = new CRAN_ICA_KER_ChangeOwnersSchedulable_CLS();      
     	String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, sh1);
        Test.stopTest();
    }
    
    @isTest
    static void testDeleteAClaims_Batch(){
        Test.startTest();
        CRAN_ICA_KER_DeleteAClaims_Batch cleanBatch = new CRAN_ICA_KER_DeleteAClaims_Batch();
        Database.executeBatch(cleanBatch);
        Test.stopTest();
    }
    
    @isTest
    static void testChangeOwners_Batch(){
        Test.startTest();
        CRAN_ICA_KER_ChangeOwners_Batch batch = new CRAN_ICA_KER_ChangeOwners_Batch();
        Database.executeBatch(batch);
        Test.stopTest();
    }
    
}