@isTest
public class CRAS_ICA_ASS_SVProductShareReport_TST {
    /*@testSetup 
    static void loadTestData() {
        CRAS_ICA_ASS_TestDataFactory_TST.testLoadData();
    }*/
    
    @isTest(SeeAllData='true')  
    static void testGetReportPrimeCount(){
        try{
            String repPrmCnt = CRAS_ICA_ASS_SVProductShareReport_AUC.getReportPrimeCount();         
            system.assert(repPrmCnt != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest(SeeAllData='true')  
    static void testGetReportInsureds(){
        try{
            String repIns = CRAS_ICA_ASS_SVProductShareReport_AUC.getReportInsureds();          
            system.assert(repIns != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
}