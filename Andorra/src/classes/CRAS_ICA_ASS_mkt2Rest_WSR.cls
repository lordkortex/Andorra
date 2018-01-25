@RestResource(urlMapping='/CRAS/CRAS_ICA_ASS_mkt2Rest/*')
global class CRAS_ICA_ASS_mkt2Rest_WSR {
    @RemoteAction
    @HttpGet
    @ReadOnly
    global static List<List<String>> getReportInsureds(){
		return CRAS_ICA_ASS_MarketShare_CTR.getReportInsuredsMarket();
    }
}