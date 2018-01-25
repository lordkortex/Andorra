@RestResource(urlMapping='/CRAS/CRAS_ICA_ASS_sntProductRestYear/*')
global class CRAS_ICA_ASS_sntProductRestYear_WSR {
    @RemoteAction
    @HttpGet
    @ReadOnly
    global static List<List<String>> getSntByProduct() {
		return CRAS_ICA_ASS_Siniestros_CTR.getSntByProductYear();
    }
}