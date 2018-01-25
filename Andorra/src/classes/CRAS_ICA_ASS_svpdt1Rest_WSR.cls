@RestResource(urlMapping='/CRAS/CRAS_ICA_ASS_svpdt1Rest/*')
global class CRAS_ICA_ASS_svpdt1Rest_WSR {
    @RemoteAction
    @HttpGet
    @ReadOnly
    global static List<List<String>> getReportPrimeCount(){
        return CRAS_ICA_ASS_MarketShare_CTR.getReportPrimeCountSVP();
    }
}