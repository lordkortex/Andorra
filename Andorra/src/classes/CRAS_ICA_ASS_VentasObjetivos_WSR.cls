@RestResource(urlMapping='/CRAS/CRAS_ICA_ASS_ventasobjetivos/*')
global with sharing class CRAS_ICA_ASS_VentasObjetivos_WSR {
    
    @RemoteAction
    @HttpGet
    @ReadOnly
    global static List<String> getVentasObjetivos(){
		return CRAS_ICA_ASS_VentasObjetivos_CTR.getVentasObjetivos();
    }
    
}