@RestResource(urlMapping='/CRAS/CRAS_ICA_ASS_vcInsRest/*')
global class CRAS_ICA_ASS_vcInsRest_WSR {
    @RemoteAction
    @HttpGet
    @ReadOnly
    global static String getVentasCancelacionesYearIns(){
        return CRAS_ICA_ASS_VentasCancelaciones_CTR.getVentasCancelacionesYearIns1();
    }
}