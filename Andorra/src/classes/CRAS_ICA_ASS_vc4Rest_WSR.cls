@RestResource(urlMapping='/CRAS/CRAS_ICA_ASS_vc4Rest/*')
global class CRAS_ICA_ASS_vc4Rest_WSR {
    @RemoteAction
    @HttpGet
    @ReadOnly
    global static String getVentasCancelacionesYear(){
        return CRAS_ICA_ASS_VentasCancelaciones_CTR.getVentasCancelacionesYear4();
    }
}