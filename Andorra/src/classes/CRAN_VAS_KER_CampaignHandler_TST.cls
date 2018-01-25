@isTest
public class CRAN_VAS_KER_CampaignHandler_TST {
	
    @testSetup
    static void testSetup() {        
       CRAN_VAS_KER_TestDataFactory_TST.createSistematicaMarketingCampaigns();      
    }
    
    /**
	 * Create Sale from Goal
	*/
	@isTest    
    static void testCampaignStatus() {        
        for (CampaignMemberStatus cms: [SELECT Label, IsDefault 
                                      from CampaignMemberStatus]){
			System.assert((CRAN_VAS_KER_Constants_CLS.CAMPAIGNMEMBER_STATUS_WORKED.equalsIgnoreCase(cms.Label) && cms.IsDefault)
                          || (CRAN_VAS_KER_Constants_CLS.CAMPAIGNMEMBER_STATUS_NOTWORKED.equalsIgnoreCase(cms.Label))
                          || (CRAN_VAS_KER_Constants_CLS.CAMPAIGNMEMBER_STATUS_WON.equalsIgnoreCase(cms.Label)));
        }
	}
}