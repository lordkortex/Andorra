@RestResource(urlMapping='/CRAS/CRAS_ICA_ASS_vc3Rest/*')
global class CRAS_ICA_ASS_vc3Rest_WSR {
    @RemoteAction
    @HttpGet
    @ReadOnly
    global static String getVentasCancelacionesYear(){
        return CRAS_ICA_ASS_VentasCancelaciones_CTR.getVentasCancelacionesYear3();
    }
}