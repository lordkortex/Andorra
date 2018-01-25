@RestResource(urlMapping='/CRAS/CRAS_ICA_ASS_vcIns2Rest/*')
global class CRAS_ICA_ASS_vcIns2Rest_WSR {
    @RemoteAction
    @HttpGet
    @ReadOnly
    global static String getVentasCancelacionesYearIns(){
        return CRAS_ICA_ASS_VentasCancelaciones_CTR.getVentasCancelacionesYearIns2();
    }
}