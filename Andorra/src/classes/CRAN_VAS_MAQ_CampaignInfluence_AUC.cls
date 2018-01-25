public with sharing class CRAN_VAS_MAQ_CampaignInfluence_AUC {
    
    @AuraEnabled
    public static String getInfluencedCampaigns(Id opportunityId) {
        
        List<CampaignInfluence> influencedCampaigns = new List<CampaignInfluence>();
        
        influencedCampaigns = [	SELECT CampaignId, ContactId, Campaign.Name, Contact.Name, Influence
                               FROM CampaignInfluence
                               WHERE OpportunityId = :opportunityId];
        
        Id recordTypeOpp = [SELECT RecordTypeId FROM Opportunity WHERE Id = :opportunityId].get(0).RecordTypeId;
        
        List<Object> result = new List<Object>();

        result.add(recordTypeOpp == CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_RT));
        result.add(influencedCampaigns);

        return JSON.serialize(result);
    }
    
    @AuraEnabled
    public static Boolean createInfluencedCampaign(Id opportunityId, Id campaignId) {
        
        try {
            
            Opportunity opp = [SELECT Id, Amount, Account.FinServ__PrimaryContact__c
                               FROM Opportunity
                               WHERE Id = :opportunityId];
            
            CampaignInfluenceModel cim = [SELECT Id FROM CampaignInfluenceModel where IsDefaultModel = true];
            
            
            CampaignInfluence ci = new CampaignInfluence();
            
            ci.CampaignId=campaignId;
            ci.ContactId=opp.Account.FinServ__PrimaryContact__c;
            ci.Influence=100;
            ci.OpportunityId=opportunityId;
            ci.ModelId=cim.Id;           	
            
            insert ci;
            CRAN_VAS_MAQ_CampaignInfluence_AUC.updateVentaObjetivoRelationship(opportunityId);
            
        } catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            return false;
        }
        
        return true;
        
    }
    
    @AuraEnabled
    public static Boolean deleteInfluencedCampaign(Id opportunityId, Id campaignId) {
        
        try {
            
            Database.delete(campaignId);            
            CRAN_VAS_MAQ_CampaignInfluence_AUC.updateVentaObjetivoRelationship(opportunityId);
            
        } catch(DmlException e) {
            System.debug('An unexpected error has occurred: ' + e.getMessage());
            return false;
        }
        
        return true;
        
    }
    
    private static void updateVentaObjetivoRelationship (Id opportunityId) {
        Database.update(new Opportunity( Id = opportunityId));
    }
}