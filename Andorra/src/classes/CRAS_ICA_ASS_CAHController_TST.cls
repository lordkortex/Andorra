@isTest
public class CRAS_ICA_ASS_CAHController_TST {
    
    @testSetup 
    static void loadTestData() {
        CRAS_ICA_ASS_TestDataFactory_TST.testLoadData();
    }
    
    @isTest 
    static void testGetClaimDetails(){
        List<CRAS_ICA_ASS_ClaimAmountHistory__c> faLst = [SELECT ID FROM CRAS_ICA_ASS_ClaimAmountHistory__c Limit 1];
        try{
            CRAS_ICA_ASS_ClaimAmountHistory__c insGuaLst = CRAS_ICA_ASS_CAHController_AUC.getClaimDetails(faLst[0].ID);            
            system.assert(insGuaLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }
    
    @isTest 
    static void testGetCompactLayoutFieldNames(){
        try{
            List<CRAS_ICA_ASS_SFField_OBJ> clmFNLst = CRAS_ICA_ASS_CAHController_AUC.getCompactLayoutFieldNames();         
            system.assert(clmFNLst != null);            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        } 
    }

}