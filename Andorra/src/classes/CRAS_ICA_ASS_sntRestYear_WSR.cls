@RestResource(urlMapping='/CRAS/CRAS_ICA_ASS_sntRestYear/*')
global with sharing class CRAS_ICA_ASS_sntRestYear_WSR {
    @RemoteAction
    @HttpGet
    @ReadOnly
    global static List<List<String>> getSntByMarket() {
		return CRAS_ICA_ASS_Siniestros_CTR.getSntByMarketYear();
    }
}