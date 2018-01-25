@RestResource(urlMapping='/CRAS/CRAS_ICA_ASS_ventasobjetivos2/*')
global with sharing class CRAS_ICA_ASS_VentasObjetivosLife_WSR {


    @RemoteAction
    @HttpGet
    @ReadOnly
    global static List<String> getVentasObjetivos(){
		return CRAS_ICA_ASS_VentasObjetivos_CTR.getVentasObjetivosLife();
    }
    
}