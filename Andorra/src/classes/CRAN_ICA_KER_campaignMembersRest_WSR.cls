@RestResource(urlMapping='/CRAS/CRAN_ICA_KER_campaignMembersRest/*')
global class CRAN_ICA_KER_campaignMembersRest_WSR {
    
    /*@RemoteAction
    @HttpGet
    @ReadOnly
    global static List<CRAN_ICA_KER_CampaignMembers_DTO> getCampaignSales(){    

        RestRequest req = RestContext.request;

   		if(!Test.isRunningTest()){
             
            List<CRAN_ICA_KER_CampaignMembers_DTO> response = CRAN_ICA_KER_CampaignMembers_CTR.getCampaignMembers( req.requestURI.substring(req.requestURI.lastIndexOf('/')+1));

            //Map<Id, String> mapResponse = CRAN_ICA_KER_CampaignMembers_CTR.getCampaignMembers( req.requestURI.substring(req.requestURI.lastIndexOf('/')+1));
            return response;
        }else{
            return null;
        }
   
    }*/
}