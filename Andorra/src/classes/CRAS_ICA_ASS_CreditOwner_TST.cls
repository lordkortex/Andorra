@isTest
public class CRAS_ICA_ASS_CreditOwner_TST {
    @testSetup 
    static void loadTestData() {
        CRAS_ICA_ASS_TestDataFactory_TST.testLoadData();
    }
    
    @isTest
    static void testBatchClass(){
        CRAS_ICA_ASS_CreditOwner_Batch reportBatch = new CRAS_ICA_ASS_CreditOwner_Batch();
        Database.executeBatch(reportBatch);
    }
}