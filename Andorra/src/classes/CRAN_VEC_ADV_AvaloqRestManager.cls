/**
 * CRAN_VEC_ADV_AvaloqRestManager  Manager Class for Avaloq Rest services
 *
 * Wrap Request content in generic Avaloq RQ model (Service + Content) and Encrypt the HttpBody
 *
 * Fecha: 28/11/2016
 *
 * Fecha Edicion: 14/06/2017  (Eliminados parametros y headerDate ya no es necesario ya que no se utiliza la encriptacion con IV custom)
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.1
 *
*/

public class CRAN_VEC_ADV_AvaloqRestManager {
	public String service;
	public String content;
	public String jsonContent;
	public String bu;
	public CRAN_VEC_ADV_GenericAvaloqRequest genericRQ{get;set;}
	private static CRAN_VEC_ADV_AvaloqSettings__c cs = CRAN_VEC_ADV_AvaloqSettings__c.getInstance();

	//Contructor for request jsoncontent
	public CRAN_VEC_ADV_AvaloqRestManager(String service, String bu, String content) {
		this.service = service;
		this.content = content;
		CRAN_VEC_ADV_GenericAvaloqRequest genRq = new CRAN_VEC_ADV_GenericAvaloqRequest();
		genRq.setContent(content);
		genRq.setService(service);
		genRq.setCodEnv(cs.CRAN_VEC_ADV_T_Enviroment__c);
		genRq.setCodAppOrigin(CRAN_VEC_ADV_Constants_CLS.BU_AVALOQ_MAP.get(bu));
		genRq.setCodModAppOrigin(cs.CRAN_VEC_ADV_ModuleAppOrigin__c);
		this.genericRQ = genRq;
		this.jsonContent = JSON.serialize(genericRQ);
	}
	
	public CRAN_VEC_ADV_AvaloqRestManager(String content){
		this.genericRQ = (CRAN_VEC_ADV_GenericAvaloqRequest)JSON.deserialize(content,CRAN_VEC_ADV_GenericAvaloqRequest.class);
		this.service = genericRQ.getService();
		this.content = genericRQ.getContent();
	}

}