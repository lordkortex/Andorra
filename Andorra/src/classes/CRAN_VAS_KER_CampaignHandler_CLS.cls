public class CRAN_VAS_KER_CampaignHandler_CLS extends TriggerHandler{

    private Map<Id, Campaign> 	newCampaignMap;
    private Map<Id, Campaign> 	oldCampaignMap;
    private List<Campaign> 		newCampaignList;
    private List<Campaign> 		oldCampaignList;

    public CRAN_VAS_KER_CampaignHandler_CLS(SObjectType objectType) {
        super(objectType);
        this.newCampaignMap 	= (Map<id, Campaign>) 	Trigger.newMap;
        this.oldCampaignMap 	= (Map<id, Campaign>) 	Trigger.oldMap;
        this.newCampaignList = (List<Campaign>) 		Trigger.new;
        this.oldCampaignList = (List<Campaign>) 		Trigger.old;    
    }
    
    public override void beforeDelete() {

        Id 	recordTypeSistematica = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Campaign', CRAN_VAS_KER_Constants_CLS.CAMPAIGN_MKT_RT);
        Id 	recordTypeMarketing = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Campaign', CRAN_VAS_KER_Constants_CLS.CAMPAIGN_SIST_RT);
        List<Campaign> campaignsMKT = new List<Campaign>();
        
        Set<Id> campaignsMAQRT = new Set<Id>();
        campaignsMAQRT.add(recordTypeSistematica);
        campaignsMAQRT.add(recordTypeMarketing);
        
		for (Campaign c: oldCampaignList) {
            if (campaignsMAQRT.contains(c.RecordTypeId)){
                campaignsMKT.add(c);
			}
        }
        
        if(!campaignsMKT.isEmpty()){
        	CRAN_VAS_KER_CampaignHelper_CLS.deleteCampaignInfluence(campaignsMKT);    
        }
        
    }
    
    public override void afterInsert() {
        
        Id 	recordTypeSistematica = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Campaign', CRAN_VAS_KER_Constants_CLS.CAMPAIGN_MKT_RT);
        Id 	recordTypeMarketing = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Campaign', CRAN_VAS_KER_Constants_CLS.CAMPAIGN_SIST_RT);
        Map<Id,Campaign> campaignsMAQ = new Map<Id,Campaign>();
        Set<Id> campaignsMAQRT = new Set<Id>();
        campaignsMAQRT.add(recordTypeSistematica);
        campaignsMAQRT.add(recordTypeMarketing);
        
		for (Id c: newCampaignMap.keySet()) {
            if (campaignsMAQRT.contains(newCampaignMap.get(c).RecordTypeId)){
                campaignsMAQ.put(c,newCampaignMap.get(c));
			}
        }
        
        if(!campaignsMAQ.isEmpty()){
        	CRAN_VAS_KER_CampaignHelper_CLS.executeTasks(campaignsMAQ);    
        }
        
    }
}