@isTest
private class CRAN_VAS_ADV_BPDrillDown_TST {
    
    @testSetup
    static void setupDate() {
        CRAN_VAS_KER_TestDataFactory_TST.createFsBaseDataAdvisory();
    }
    
	@isTest static void testBPDrillDownData() {       	
        try{
          Account acc = [SELECT Id 
                         FROM Account 
                         WHERE CRAN_VEC_ADV_T_BPId__c = '9_998877'
                         AND RecordTypeId =: CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account','CRAN_VEC_ADV_Individual') LIMIT 1];
            
         String response = CRAN_VAS_ADV_BPDrillDown_AUC.getRecords(acc.Id);
            
         CRAN_VAS_ADV_BPDrillDown_AUC.WrapperClass wrapper = (CRAN_VAS_ADV_BPDrillDown_AUC.WrapperClass)JSON.deserialize(response, CRAN_VAS_ADV_BPDrillDown_AUC.WrapperClass.class);
            
         system.assert(wrapper.bps.keySet().size() == 2);
                
            for (Id key : wrapper.fas.keySet()) {
                List<CRAN_VAS_ADV_BPDrillDown_AUC.GenericObjectClass> fas = wrapper.fas.get(key);
                system.assert(fas.size() == 1);
                
                for (CRAN_VAS_ADV_BPDrillDown_AUC.GenericObjectClass fa : fas) {
                    system.assert(fa.objects.size() == 2);
                }
            }
             
        } catch (Exception ex) { 
            system.debug(ex.getMessage() + ' ' + ex.getLineNumber());
            system.assert(false);
        }
    }
}