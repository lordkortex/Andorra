@RestResource(urlMapping='/CRAS/CRAN_ICA_KER_campaignSalesRest/*')
global class CRAN_ICA_KER_campaignSalesRest_WSR {
    /*@RemoteAction
    @HttpGet
    @ReadOnly
    global static List<CRAN_ICA_KER_CampaignSales_DTO> getCampaignSales(){

        RestRequest req = RestContext.request;
        if(!Test.isRunningTest()){
        	return CRAN_ICA_KER_CampaignSales_CTR.getCampaignSales( req.requestURI.substring(req.requestURI.lastIndexOf('/')+1) );
        }else{
            return new  List<CRAN_ICA_KER_CampaignSales_DTO>();
        }
    }*/
}