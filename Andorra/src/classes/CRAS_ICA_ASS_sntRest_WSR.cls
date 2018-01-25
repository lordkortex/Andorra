@RestResource(urlMapping='/CRAS/CRAS_ICA_ASS_sntRest/*')
global with sharing class CRAS_ICA_ASS_sntRest_WSR {
    @RemoteAction
    @HttpGet
    @ReadOnly
    global static List<List<String>> getSntByMarket() {
		return CRAS_ICA_ASS_Siniestros_CTR.getSntByMarketAll();
    }
}