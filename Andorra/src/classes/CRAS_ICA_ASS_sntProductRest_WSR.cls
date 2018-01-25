@RestResource(urlMapping='/CRAS/CRAS_ICA_ASS_sntProductRest/*')
global class CRAS_ICA_ASS_sntProductRest_WSR {
    @RemoteAction
    @HttpGet
    @ReadOnly
    global static List<List<String>> getSntByProduct() {
		return CRAS_ICA_ASS_Siniestros_CTR.getSntByProductAll();
    }
}