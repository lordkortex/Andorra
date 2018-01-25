@isTest
public class CRAS_ICA_ASS_CleanFullData_Batch_TST {
    @testSetup 
    static void loadTestData() {
        CRAS_ICA_ASS_TestDataFactory_TST.testLoadData();
    }
    
    @isTest
    static void testBatchClass(){
        CRAS_ICA_ASS_CleanFullData_Batch cleanBatch = new CRAS_ICA_ASS_CleanFullData_Batch();
        Database.executeBatch(cleanBatch);
    }
}