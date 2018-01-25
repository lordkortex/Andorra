public class CRAN_VAS_KER_CampaignHelper_CLS {

	public static void deleteCampaignInfluence(List<Campaign> oldCampaign) {
        delete [Select Id from CampaignInfluence where CampaignId in :oldCampaign];
    }
    
    public static void executeTasks(Map<Id,Campaign> cmpsMap){
        
        List<CampaignMemberStatus> cmsUpsert = new List<CampaignMemberStatus>();
        List<CampaignMemberStatus> cmsDelete = new List<CampaignMemberStatus>();
        List<CampaignMemberStatus> cmsOld = [select Id, 
                                             IsDefault,
                                             CampaignId
                                             from CampaignMemberStatus 
                                             where CampaignId IN :cmpsMap.keySet()];         
        
        if(Test.isRunningTest()){
            cmsOld = new List<CampaignMemberStatus>();
            for (Campaign c: cmpsMap.values()){
               	
            
            	CampaignMemberStatus cmsTest1 = new CampaignMemberStatus(
                CampaignId=c.Id,
                HasResponded=false,
				IsDefault = true,
                Label='Sent Test'); 
                
                CampaignMemberStatus cmsTest2 = new CampaignMemberStatus(
                CampaignId=c.Id,
                HasResponded=true,
                IsDefault = false,
                Label='Responded Test'); 
                
                cmsOld.add(cmsTest1);
                cmsOld.add(cmsTest2);                                
            }   
            insert cmsOld;
        }
        
        for(CampaignMemberStatus cms: cmsOld){
            if(cms.IsDefault){
                cms.HasResponded=true;
                cms.Label=CRAN_VAS_KER_Constants_CLS.CAMPAIGNMEMBER_STATUS_WORKED;
                
                CampaignMemberStatus cms1 = new CampaignMemberStatus(
                CampaignId=cms.CampaignId,
                HasResponded=false,
                Label=CRAN_VAS_KER_Constants_CLS.CAMPAIGNMEMBER_STATUS_NOTWORKED);
                
				CampaignMemberStatus cms2 = new CampaignMemberStatus(
                CampaignId=cms.CampaignId,
                HasResponded=true,
                Label=CRAN_VAS_KER_Constants_CLS.CAMPAIGNMEMBER_STATUS_WON);
                
                cmsUpsert.add(cms);
                cmsUpsert.add(cms1);
              	cmsUpsert.add(cms2);
            } else {
                cmsDelete.add(cms);
            }
        }       
       	upsert cmsUpsert;
        delete cmsDelete;                 
    }
}