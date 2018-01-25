@RestResource(urlMapping='/CRAS/CRAS_ICA_ASS_RecibosDevueltos/*')
global with sharing class CRAS_ICA_ASS_RecibosDevueltos_WSR {
    @RemoteAction
    @HttpGet
    @ReadOnly
    global static List<List<String>> getRecibosDevueltos() {
		return CRAS_ICA_ASS_Recibos_CTR.getRecibosDevueltos();
    }    
}