@RestResource(urlMapping='/CRAS/CRAS_ICA_ASS_ventasobjetivos3/*')
global with sharing class CRAS_ICA_ASS_VentasObjetivosSavings_WSR {

    @RemoteAction
    @HttpGet
    @ReadOnly
    global static List<String> getVentasObjetivos(){
		return CRAS_ICA_ASS_VentasObjetivos_CTR.getVentasObjetivosSavings();
    }
    
}