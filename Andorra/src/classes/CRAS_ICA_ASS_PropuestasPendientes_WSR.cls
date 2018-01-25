@RestResource(urlMapping='/CRAS/CRAS_ICA_ASS_PropuestasPendientes/*')
global with sharing class CRAS_ICA_ASS_PropuestasPendientes_WSR {
    @RemoteAction
    @HttpGet
    @ReadOnly
    global static List<List<String>> getPropuestasPendientes() {
		return CRAS_ICA_ASS_Propuestas_CTR.getPropuestasPendientes();
    } 
    
}