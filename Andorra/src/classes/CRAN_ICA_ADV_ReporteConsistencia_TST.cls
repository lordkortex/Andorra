@isTest
public class CRAN_ICA_ADV_ReporteConsistencia_TST {
    
    @testSetup 
    static void loadTestData() {
        CRAS_ICA_ASS_TestDataFactory_TST.testLoadData();
    }

    
    @isTest
    static void testGetReportDetail(){
        try{
            Map<String, List<Integer>> repDet = CRAN_ICA_ADV_ReporteConsistencia_CTR.getReportDetail();
            system.assert(repDet != null);           
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void getReportTotalesContact(){
        try{
            Map<String, Integer> repTot = CRAN_ICA_ADV_ReporteConsistencia_CTR.getReportTotalesContact();
            system.assert(repTot != null);           
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void getReportTotalesAccount(){
        try{
            Map<String, Integer> repTot = CRAN_ICA_ADV_ReporteConsistencia_CTR.getReportTotalesAccount();
            system.assert(repTot != null);           
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void getReportTotalesBP(){
        try{
            Map<String, Integer> repTot = CRAN_ICA_ADV_ReporteConsistencia_CTR.getReportTotalesBP();
            system.assert(repTot != null);           
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void getReportTotalesFA(){
        try{
            Map<String, Integer> repTot = CRAN_ICA_ADV_ReporteConsistencia_CTR.getReportTotalesFA();
            system.assert(repTot != null);           
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void getReportTotalesRolesPO(){
        try{
            Map<String, Integer> repTot = CRAN_ICA_ADV_ReporteConsistencia_CTR.getReportTotalesRolesPO();
            system.assert(repTot != null);           
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void getReportTotalesRolesBK(){
        try{
            Map<String, Integer> repTot = CRAN_ICA_ADV_ReporteConsistencia_CTR.getReportTotalesRolesBK();
            system.assert(repTot != null);           
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    @isTest 
    static void getReportTotalesRolesASS(){
        try{
            Map<String, Integer> repTot = CRAN_ICA_ADV_ReporteConsistencia_CTR.getReportTotalesRolesASS();
            system.assert(repTot != null);           
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
}