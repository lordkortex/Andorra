/**
 * CRAN_VAS_KER_CampInfluTriggerHandler_TST Campaign Influence Trigger Handler Test Class
 * Fecha: Abril 2017
 * @author VASS
 * @version 1.0
*/
@isTest
public class CRAN_VAS_KER_CampInfluTriggerHandler_TST {
	
    /*
     * Initialize Data Factory
     */
    @testSetup
    static void testSetup() {        
        Account indClient = CRAN_VAS_KER_TestDataFactory_TST.createIndividualClient();
		Account bp = CRAN_VAS_KER_TestDataFactory_TST.createBP();
		
        List<Campaign> camps = CRAN_VAS_KER_TestDataFactory_TST.createSistematicaMarketingCampaigns();
        Campaign maqCampaign1 = camps.get(0);
		
        //Create sales associated to campaigns
        Opportunity objMaq = CRAN_VAS_KER_TestDataFactory_TST.createMarketingGoal('Test MKT goal 1', maqCampaign1.Id,indClient.Id);
        CRAN_VAS_KER_TestDataFactory_TST.createSistematicaSale('Test MKT sale 1', maqCampaign1.Id,bp.Id,indClient.Id,objMaq.Id);     
    }
    
    /**
	 * Create Sale from Goal
	*/
	@isTest    
    static void campaignChangeTest() {
		List<String> salesNames = new List<String>();
		salesNames.add('Test MKT sale 1');
		
		//Update sales as Closed Won and Update Opportunities Quantity and Validated fields
		updateOpps(salesNames, 9, true) ;
				
        //Check campaign Result
        List<Campaign> campaigns = [SELECT Id, CRAN_VAS_MAQ_C_AmountSalesValidated__c,CRAN_VAS_MAQ_N_SalesValidated__c, CRAN_VAS_MAQ_N_QuantitySalesValidated__c,CRAN_VAS_MAQ_N_QuantitySalesWon__c  
                             		FROM Campaign];
        Campaign camp = campaigns.get(0);
        
        System.assertEquals(camp.CRAN_VAS_MAQ_N_SalesValidated__c, 1);
        System.assertEquals(camp.CRAN_VAS_MAQ_C_AmountSalesValidated__c, 100);
        System.assertEquals(camp.CRAN_VAS_MAQ_N_QuantitySalesWon__c, 9);
        System.assertEquals(camp.CRAN_VAS_MAQ_N_QuantitySalesValidated__c, 9);
        
	}
    
    
   /**
	* Delete
	*/
	@isTest    
    static void campaignDeleteTest() {		
        //Create campaignInfluence
        List<String> salesNames = new List<String>();
		salesNames.add('Test MKT sale 1');		
		//Update sales as Closed Won and Update Opportunities Quantity and Validated fields
		updateOpps(salesNames, 9, true) ;
        
        List<CampaignInfluence> campsInflu = [SELECT Id, CampaignId, RevenueShare, CRAN_VAS_MAQ_F_N_QuantityShare__c, CRAN_VAS_MAQ_F_B_SaleValidated__c  
	       							FROM CampaignInfluence LIMIT 1];
		Id campId = campsInflu.get(0).CampaignId;
        
        //Get associated campaign data
        List<Campaign> campaigns = [SELECT Id, CRAN_VAS_MAQ_C_AmountSalesValidated__c,CRAN_VAS_MAQ_N_SalesValidated__c, CRAN_VAS_MAQ_N_QuantitySalesValidated__c,CRAN_VAS_MAQ_N_QuantitySalesWon__c  
                             		FROM Campaign WHERE Id=:campId];
        Campaign camp = campaigns.get(0);
        
        //Delete campaign influence
        delete campsInflu.get(0);  
        
        //Get associated campaign data again
        campaigns = [SELECT Id, CRAN_VAS_MAQ_C_AmountSalesValidated__c,CRAN_VAS_MAQ_N_SalesValidated__c, CRAN_VAS_MAQ_N_QuantitySalesValidated__c,CRAN_VAS_MAQ_N_QuantitySalesWon__c  
                             		FROM Campaign WHERE Id=:campId];
        Campaign newCamp = campaigns.get(0);
        
        //Check delete result
        System.assert(newCamp.CRAN_VAS_MAQ_N_SalesValidated__c == (camp.CRAN_VAS_MAQ_N_SalesValidated__c - 1));
        System.assert(newCamp.CRAN_VAS_MAQ_C_AmountSalesValidated__c < camp.CRAN_VAS_MAQ_C_AmountSalesValidated__c);
        System.assert(newCamp.CRAN_VAS_MAQ_N_QuantitySalesWon__c < camp.CRAN_VAS_MAQ_N_QuantitySalesWon__c);
        System.assert(newCamp.CRAN_VAS_MAQ_N_QuantitySalesValidated__c < camp.CRAN_VAS_MAQ_N_QuantitySalesValidated__c);     
        
	}


 	/**
	* Update sales to stage Closed Won.
	* Update sale Quantity and Validated Sale fields from Opportunities 
	*/
    static void updateOpps(List<String> salesNames, Decimal totalOppQuantity, Boolean isSaleValidated) {
		List<Opportunity> opps = [SELECT Id,TotalOpportunityQuantity,CRAN_VAS_MAQ_B_Validation__c  
                                   FROM Opportunity WHERE Name =: salesNames];
        
        for (Opportunity opp:opps){
        	opp.StageName = 'Closed Won';
        	opp.CRAN_VAS_MAQ_T_IdOperacionComercial__c = '132456';
            opp.TotalOpportunityQuantity = totalOppQuantity;
    		opp.CRAN_VAS_MAQ_B_Validation__c = isSaleValidated;
        }
       
        update opps;
	}
   
}