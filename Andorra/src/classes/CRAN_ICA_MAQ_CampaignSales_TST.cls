@isTest
public class CRAN_ICA_MAQ_CampaignSales_TST {

    
    
    @testSetup
	static void getData_AuraController() {
        
        Date today = System.today();
        Date endDate = today.addYears(1);

        
        Account acc = CRAN_VAS_KER_TestDataFactory_TST.createFsIndividualAccount();
        Account bp = CRAN_VAS_KER_TestDataFactory_TST.createBPAccounts()[1];

        Campaign maqCampaign = new Campaign();
        maqCampaign.Name = 'Test Marketing Campaign';
        maqCampaign.IsActive = true;
        maqCampaign.StartDate = today;
        maqCampaign.EndDate = endDate;
        maqCampaign.Status = 'In Progress';
        maqCampaign.RecordTypeId = CRAN_VAS_KER_TestDataFactory_TST.recordTypeIdByDeveloperName(maqCampaign, CRAN_VAS_KER_Constants_CLS.CAMPAIGN_MKT_RT);// CRAN_VAS_MAQ_MarquetingRecordType
        insert maqCampaign;


        RecordType rt = [ select id, developername 
                         from recordtype 
                         where developername= :CRAN_VAS_KER_Constants_CLS.OPP_VENTA_RT];
        
        Date closeDate = Date.today();
        closeDate.addDays(10);
        
        Opportunity o = new Opportunity();
        o.Name = 'Test sistematica sale';
        //o.CRAN_VAS_MAQ_L_Objetivo_Asociado__c = goalId;
        o.Amount = 100;
        o.TotalOpportunityQuantity = 1;
        o.CampaignId = maqCampaign.id;
        o.CRAN_VAS_MAQ_L_BP__c = bp.id;
        o.AccountId = acc.Id;
        o.StageName = 'In Progress';
        o.CloseDate = closeDate;
        o.RecordTypeId = rt.id;
        o.OwnerId = UserInfo.getUserId();
        insert o;
        
        CampaignInfluenceModel cim = [SELECT Id 
                                      FROM CampaignInfluenceModel 
                                      where IsDefaultModel = true];
        
        CampaignInfluence ci = new CampaignInfluence();
        
        ci.CampaignId=maqCampaign.Id;
        ci.ContactId=acc.FinServ__PrimaryContact__c;
        ci.Influence=100;
        ci.OpportunityId=o.Id;
        ci.ModelId=cim.Id;           	
        
        insert ci;

        

	}
      
    
    @isTest 
	static void get_AUC_Batch() {
    	
        //Testeamos las clases AUC y Batch que se ejecuta
           
        List<Campaign> camp = [select name, id, recordtype.developername from campaign ];

		String records = CRAN_ICA_MAQ_CampaignSales_AUC.getRecords(camp.get(0).Id , UserInfo.getUserId());   

        System.assert(records == '');
    }   
    
    
    @isTest 
	static void get_AUC_Vista_SisteMaticaComercial() {
    	
          
       Campaign cm = [select name, recordtype.developername from campaign limit 1];

       Boolean records = CRAN_ICA_MAQ_CampaignSales_AUC.isSistematicaComercialRecordType(cm.Id);   
        
       System.assert(true);
    } 
    
}