@RestResource(urlMapping='/CRAS/CRAS_ICA_ASS_vc1Rest/*')
global class CRAS_ICA_ASS_vc1Rest_WSR {
    @RemoteAction
    @HttpGet
    @ReadOnly
    global static String getVentasCancelacionesYear(){
        System.debug(CRAS_ICA_ASS_VentasCancelaciones_CTR.getVentasCancelacionesYear1());
        return CRAS_ICA_ASS_VentasCancelaciones_CTR.getVentasCancelacionesYear1();
    }
}