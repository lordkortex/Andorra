/**
 * CRAN_VEC_ADV_AvaloqServiceResponse  Class for Avaloq Rest services
 *
 * Avaloq RS model (Service + Content)
 *
 * Fecha: 25/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * 
 * Edit add dataPower header & encryption
 * @version 1.1
 *
*/

public class CRAN_VEC_ADV_AvaloqServiceResponse {
	public String service;
	public String content;
	public String bu;
	public CRAN_VEC_ADV_ProcessSTError_CLS error{get;set;}

	public CRAN_VEC_ADV_AvaloqServiceResponse(String response) {
		 if(String.isNotBlank(response)){
            CRAN_VEC_ADV_UtilEncryption_CLS encrypUtil = new CRAN_VEC_ADV_UtilEncryption_CLS();
            CRAN_ICA_KER_JSONhttpResponse wrapResponse = (CRAN_ICA_KER_JSONhttpResponse) JSON.deserialize(response, CRAN_ICA_KER_JSONhttpResponse.class);
            String bodyDecrypted = encrypUtil.decryptManaged(wrapResponse.encrypted);
             
            CRAN_VEC_ADV_AvaloqRestManager restManager = new CRAN_VEC_ADV_AvaloqRestManager(bodyDecrypted);
           	this.content = restManager.content;
           	this.service = restManager.service;
        }
	}
}