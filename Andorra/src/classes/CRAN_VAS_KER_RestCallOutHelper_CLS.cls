/**
* Class that handles REST call out requests
* @author      Zuinglio Lopes Ribeiro Júnior
* @version     1.0
*/
public with sharing class CRAN_VAS_KER_RestCallOutHelper_CLS {

	/** Http request object */
	private HttpRequest httpRequest;
	
	/** String endpoint URL */
	private String endPointUrl;

	/** Settings */
	public	CRAN_VAS_KER_SignatureBus__c settings;
	
    /**
    * Class constructor
    * @param endPointUrl string endpoint url
    * @param additionalHeaders map containing additional headers   
    */    	
	public CRAN_VAS_KER_RestCallOutHelper_CLS(String endPointUrl, Map<String, String> additionalHeaders) {
		
		this.endPointUrl = endPointUrl;
		httpRequest = new HttpRequest();
		settings = CRAN_VAS_KER_SignatureBus__c.getOrgDefaults();
        
        if (additionalHeaders != null) {
            
            for (String headerName : additionalHeaders.keySet()) {
                String value = additionalHeaders.get(headerName);
                httpRequest.setHeader(headerName, value);
            }
        }
		
	}
  
    /**
    * Class constructor
    * @param endPointUrl string endpoint url  
    */   
	public CRAN_VAS_KER_RestCallOutHelper_CLS(String endPointUrl) {
		this(endPointUrl, null);		
	}    
	
    /**
    * Sends a REST request with a JSON body
    * @param jsonContent JSON content
    * @param method Http method
    * @return returns a http response object    
    */      	
	public HttpResponse sendJSONRequest(String jsonContent, String method) {
		
        httpRequest.setEndpoint(endPointUrl);
		httpRequest.setHeader('Content-Type', 'application/json');
		httpRequest.setHeader('Accept', 'application/json');        
		httpRequest.setTimeout(settings.HttpRequestTimeout__c.intValue());
		httpRequest.setMethod(method);
		
		if (String.isNotBlank(jsonContent))		
			httpRequest.setBody(jsonContent);

		Http http = new Http();
		return http.send(httpRequest);		
		
	}

    /**
    * Sends a POST REST request with a JSON body
    * @param jsonContent JSON content
    * @return returns a http response object
    */        
	public HttpResponse sendJSONRequest(String jsonContent) {
		return sendJSONRequest(jsonContent, 'POST');		
	}    

    /**
    * Sends a SSL POST REST request with a JSON body
    * @param jsonContent JSON content
    * @return returns a http response object
    */  
	public HttpResponse sendSSLJSONRequest(String jsonContent) {
		
		// Sets the header and certificate
        httpRequest.setHeader('X-DPE-Origin','Salesforce');	
		httpRequest.setClientCertificateName(settings.CertificateName__c);

		return sendJSONRequest(jsonContent);		
	}
	
    /**
    * Sends a SSL POST REST request with a JSON body and additional encryption
    * @param jsonContent JSON content
    * @return returns a http response object
    */  	
	public HttpResponse sendSSLJSONRequestWithEncryption(String jsonContent) {

		// Encrypts the request body
		CRAN_VEC_ADV_UtilEncryption_CLS encrypUtil = new CRAN_VEC_ADV_UtilEncryption_CLS();		
		CRAN_ICA_KER_JSONhttpRequest_OBJ wrap = new CRAN_ICA_KER_JSONhttpRequest_OBJ();
 		wrap.encrypted = encrypUtil.encryptManaged(jsonContent);	
		
		// Sends the request
		HttpResponse response = sendSSLJSONRequest(JSON.serialize(wrap));
		
		// Decrypts the response and gets its body
        CRAN_ICA_KER_JSONhttpResponse wrapResponse = (CRAN_ICA_KER_JSONhttpResponse) JSON.deserialize(response.getBody(),
        													 CRAN_ICA_KER_JSONhttpResponse.class);
        
        response.setBody(encrypUtil.decryptManaged(wrapResponse.encrypted));			
	
		return response;
	}

    /**
    * Returns a http request object
    * @return returns a http request object
    */  
	public HttpRequest getHttpRequest() {
		return httpRequest;
	}

}