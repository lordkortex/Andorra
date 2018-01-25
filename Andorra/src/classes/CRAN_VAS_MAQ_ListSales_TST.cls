@isTest
public class CRAN_VAS_MAQ_ListSales_TST {

    
    @testSetup 
	static void loadTestData() {
        CRAN_VAS_KER_TestDataFactory_TST dataFactory = new CRAN_VAS_KER_TestDataFactory_TST();                              				        
        Account 	client 			= CRAN_VAS_KER_TestDataFactory_TST.createFsIndividualAccount();
        Contact		con 			= [SELECT Id, AccountId FROM Contact WHERE AccountId =: client.Id];
        Account 	bp 				= dataFactory.createBPAccount();       
        List<Campaign> camps 		= CRAN_VAS_KER_TestDataFactory_TST.createSistematicaMarketingCampaigns();
        Campaign 	c 				= camps.get(1);        
        Opportunity sale1 			= CRAN_VAS_KER_TestDataFactory_TST.createSistematicaSale('Sale1', c.Id, bp.Id, client.Id,null);
        Opportunity sale2 			= CRAN_VAS_KER_TestDataFactory_TST.createSistematicaSale('Sale2', c.Id, bp.Id, client.Id,null);
        
        
        sale1 = new Opportunity ( Id = sale1.Id, CloseDate =  Date.today().addDays(40));
		update sale1;                
	}
    
    /**
     * Test method getGoalsAssignedToDummy(campaign, fieldNames) and getGoalsAssignedToDummyByOffice(campaign,office,fieldNames) with a user with global view.
     * */
    @isTest static void testListSales() {       	
        List<Opportunity> opps = CRAN_VAS_MAQ_ListSales_AUC.getSales();
        System.assert(opps.size()==1);
        
        System.assert(String.isNotBlank(CRAN_VAS_MAQ_ListSales_AUC.getListViewId()));
        
        CRAN_VAS_MAQ_ListSales_AUC.listViewLabel = 'TEST';
        System.assert(String.isBlank(CRAN_VAS_MAQ_ListSales_AUC.getListViewId()));        
    }
    
}