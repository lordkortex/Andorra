/**
 * CRAN_VAS_MAQ_CampaignInfluence_TST Campaign Influence Aura Controller Test Class
 * Fecha: Marzo 2017
 * @author VASS
 * @version 1.0
*/
@isTest
public class CRAN_VAS_MAQ_CampaignInfluence_TST {
    
    /*
     * Initialize Data Factory
     */
    @testSetup
    static void testSetup() {
        
        Account 		indClient 		= CRAN_VAS_KER_TestDataFactory_TST.createIndividualClient();
		Account 		bp 				= CRAN_VAS_KER_TestDataFactory_TST.createBP();
        List<Campaign> 	camps 			= CRAN_VAS_KER_TestDataFactory_TST.createSistematicaMarketingCampaigns();
        Campaign 		maqCampaign 	= camps.get(0);
        Campaign 		sistCampaign 	= camps.get(1);
        Opportunity 	objMaq 			= CRAN_VAS_KER_TestDataFactory_TST.createMarketingGoal('Marketing Goal Test',maqCampaign.Id,indClient.Id);
        Opportunity 	objSist 		= CRAN_VAS_KER_TestDataFactory_TST.createSistematicaGoal('Sistematica Goal Test',sistCampaign.Id,bp.Id,indClient.Id);
        Opportunity 	sale 			= CRAN_VAS_KER_TestDataFactory_TST.createSistematicaSale('Sistematica Sale Test',sistCampaign.Id,bp.Id,indClient.Id,objSist.Id);
    } 
    
    /**
	 * Create Campaign Influence from Opportunity Page
	*/
	@isTest    
    static void testCreateCampaignInfluence() {
        
        Opportunity 			opp = [SELECT Id FROM Opportunity WHERE Name = 'Sistematica Sale Test'][0];
		Campaign 				c 	= [SELECT Id FROM Campaign WHERE Name = 'Test Marketing Campaign'][0];
       	String response 	= CRAN_VAS_MAQ_CampaignInfluence_AUC.getInfluencedCampaigns(opp.Id);	
        List<Object> parsedResponse = (List<Object>) JSON.deserializeUntyped(response);
        System.debug('Parsed Response: '+parsedResponse);
        
        System.assert(CRAN_VAS_MAQ_CampaignInfluence_AUC.createInfluencedCampaign(opp.Id, c.Id));
        System.assert(!CRAN_VAS_MAQ_CampaignInfluence_AUC.createInfluencedCampaign(opp.Id, c.Id));
 
	}
    
    /**
	 * Delete Campaign Influence from Opportunity Page
	*/
	@isTest 
    static void testDeleteCampaignInfluence() {
        
		Opportunity opp = [SELECT Id FROM Opportunity where Name = 'Sistematica Sale Test'][0];
		Campaign c = [SELECT Id FROM Campaign where Name = 'Test Sistematica Campaign'][0];
        
        System.assert(CRAN_VAS_MAQ_CampaignInfluence_AUC.deleteInfluencedCampaign(opp.Id, c.Id));	
        System.assert(!CRAN_VAS_MAQ_CampaignInfluence_AUC.deleteInfluencedCampaign(opp.Id, c.Id));
        
	}    
}