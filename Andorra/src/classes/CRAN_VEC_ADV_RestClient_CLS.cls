/**
 * CRAN_VEC_ADV_RestClient_CLS generic Rest client manager
 *
 * Fecha: 28/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * 
 * Edit Añadido control para respuestas de error Datapower y Content-Type application/json
 * @version 1.4
 *
*/

public with sharing virtual class CRAN_VEC_ADV_RestClient_CLS {
    Public class CRAN_VEC_ADV_RestClientException extends Exception {}

    /*
     * class variable creation - DO NOT EDIT
     */

    Public Map<String,String> headers;
    Public String url;
    Public String method;
    Public String body;
    private transient HttpRequest request;
    private transient HttpResponse response;
    Public String responseBody;
    private transient Http h;

    private Static CRAN_VEC_ADV_AvaloqSettings__c cs = CRAN_VEC_ADV_AvaloqSettings__c.getInstance();
    private Static Integer TIMEOUT = cs.CRAN_VEC_ADV_T_TimeOut__c.intValue();
    private Static Boolean MOCKSERVICES = cs.CRAN_VEC_ADV_B_MockServices__c;
    private Static String SERVICE_MOCK_LIST = cs.CRAN_VEC_ADV_MockServiceList__c;
    private Static Set<String> SERVICE_MOCK_SET = getServicesMockList(SERVICE_MOCK_LIST);

    //master constructor for Avaloq Rest services POST method. 
    Public CRAN_VEC_ADV_RestClient_CLS(String service, String bu, String body) {
        try {
            Datetime init = Datetime.now();
            this.h = new Http();
            System.debug('-- RestClient -- ' + service + ' bu ' + bu + ' body '+body);
            CRAN_VEC_ADV_AvaloqServiceRequest avaloqServiceRq = new CRAN_VEC_ADV_AvaloqServiceRequest(service,bu,body);
            this.request = avaloqServiceRq.avaloqRequest;
            this.request.setBody(avaloqServiceRq.avaloqRequest.getBody());
            this.request.setClientCertificateName('salesforceclient');
            this.request.setHeader('X-DPE-Origin','Salesforce');
            this.request.setHeader('Content-Type','application/json');

             if(isServiceMock(service)){
                System.debug('Mock services ENABLED');
                this.response = getMockHttpResponse(service);
                this.responseBody = handleResponse(this.response);

                Datetime finish = Datetime.now();
                decimal millisecs = decimal.valueOf(finish.getTime() - init.getTime());
                System.debug('-- Response Times '+service+':  '+ millisecs +' ms');
            }else{
                this.response = makeRequest(this.h, this.request);
                handleResponse(this.response);
                String dateHeader = this.request.getHeader(CRAN_VEC_ADV_Constants_CLS.DATE_HEADER);
                //Si se han producido errores en el datapower los devolvemos a la peticion origen para su tratamiento
                if(response.getStatusCode() == 200){
                    CRAN_VEC_ADV_AvaloqServiceResponse avaloqServiceRs = new CRAN_VEC_ADV_AvaloqServiceResponse(this.response.getBody());
                    this.responseBody = avaloqServiceRs.content;
                }else{
                    this.responseBody = createJsonError(String.valueOf(response.getStatusCode()),response.getStatus());
                }

                Datetime finish = Datetime.now();
                decimal millisecs = decimal.valueOf(finish.getTime() - init.getTime());
                System.debug('-- Response Times '+service+':  '+ millisecs +' ms');
            }
        } catch(Exception e) {
            //log the error, but set as much as we can with the input given
            log(CRAN_VEC_ADV_Constants_CLS.CALLOUT_FAIL,e, e.getMessage());
            if(headers != null) this.headers = headers;
            this.body = body;
            this.url = url;
            this.responseBody = createJsonError(e.getTypeName(),e.getMessage());
        }
    }

    //DataPower without encryption ONLY USE FOR RETRIEVE PDF  services. 
    Public CRAN_VEC_ADV_RestClient_CLS(String service, String body, Boolean encrypted) {
        try {
            Datetime init = Datetime.now();
            this.h = new Http();
            CRAN_VEC_ADV_UtilEncryption_CLS encrypUtil = new CRAN_VEC_ADV_UtilEncryption_CLS();
            System.debug('-- DataPower Services -- ' + service + ' body '+body + ' encrypted ' + encrypted);
            if(encrypted){
                //Encriptacion AES256
                CRAN_ICA_KER_JSONhttpRequest_OBJ wrap = new CRAN_ICA_KER_JSONhttpRequest_OBJ();
                wrap.encrypted = encrypUtil.encryptManaged(body);
                String wrapBody = JSON.serialize(wrap);
                System.debug('-- Encrypted Services -- ' + service + ' Wrap body '+ wrapBody);
                this.request = buildRequest(null, cs.CRAN_VEC_ADV_DatapowerEncrypted__c+service, 'POST', wrapBody);
            }else{
                this.request = buildRequest(null, cs.CRAN_VEC_ADV_Datapower__c + service, 'POST', body);
            }
            this.request.setHeader('X-DPE-Origin','Salesforce');
            this.request.setHeader('Content-Type','application/json');
            this.request.setClientCertificateName('salesforceclient');
            
            Datetime finish = Datetime.now();
            decimal millisecs = decimal.valueOf(finish.getTime() - init.getTime());
            System.debug('-- Response Times '+service+':  '+ millisecs +' ms');
            if(encrypted){
                 System.debug('Mock encrypted ENABLED' + encrypted);
                if(isServiceMock(service)){
                    System.debug('Mock services ENABLED');
                    this.response = getMockHttpResponse(service);
                    this.responseBody = response.getBody();
                }else{
                    this.response = makeRequest(this.h, this.request);
                    CRAN_ICA_KER_JSONhttpResponse wrapResponse = (CRAN_ICA_KER_JSONhttpResponse) JSON.deserialize(this.response.getBody(), CRAN_ICA_KER_JSONhttpResponse.class);
                    try{
                        this.responseBody = encrypUtil.decryptManaged(wrapResponse.encrypted);
                    }catch(Exception e){
                        //El contenido no esta encriptado o no se puede desencriptar
                        this.responseBody = response.getBody();
                    }
                    log('Response ', response, this.responseBody);
                }
            }else{
                this.response = makeRequest(this.h, this.request);
                this.responseBody = response.getBody();
                log('Response ', response, this.responseBody);
            }
        } catch(Exception e) {
            //log the error, but set as much as we can with the input given
            log(CRAN_VEC_ADV_Constants_CLS.CALLOUT_FAIL,e, e.getMessage());
            if(headers != null) this.headers = headers;
            this.body = body;
            this.url = url;
            this.responseBody = createJsonError(e.getTypeName(),e.getMessage());
        }
    }

    /*
     * Helper Methods - These do the actual work.
     */

  Public Static HttpRequest buildRequest(map<String,String> headers, String url, String method, String body){
    HttpRequest request = new HttpRequest();
    request.setTimeout(TIMEOUT); // timeout in milliseconds 
    if (headers != null) {
            for(String hkey : headers.keySet()){
            request.setHeader(hkey, headers.get(hkey)); 
        }   
    }
      request.setEndpoint(url);
      request.setMethod(method);
      if (body != null && body.length() > 0) {
        request.setBody(body);
      }
      return request;
  }

    Public Static HttpResponse makeRequest(HttpRequest request){
        Http h = new Http();
        HttpResponse response = h.send(request);
        if (response.getStatusCode() > 299) {
             response.setBody(createJsonError(String.valueof(response.getStatusCode()),response.getStatus()));
            CRAN_VEC_ADV_RestClientException logException = new CRAN_VEC_ADV_RestClientException('Failed to recieve a success code from remote. Code was: ' + response.getStatusCode() + ' request was ' + request + ' Response Body is: ' + response.getBody());
            log(CRAN_VEC_ADV_Constants_CLS.CALLOUT_FAIL,(Object)logException, logException.getMessage());
        }
        return response;    
    }  

    Public Static HttpResponse makeRequest(Http h, HttpRequest request){
        HttpResponse response = h.send(request);
        if (response.getStatusCode() > 299) {
            response.setBody(createJsonError(String.valueof(response.getStatusCode()),response.getStatus()));
            CRAN_VEC_ADV_RestClientException logException = new CRAN_VEC_ADV_RestClientException('Failed to recieve a success code from remote. Code was: ' + response.getStatusCode() + ' request was ' + request + ' Response Body is: ' + response.getBody());
            log(CRAN_VEC_ADV_Constants_CLS.CALLOUT_FAIL,(Object)logException, logException.getMessage());
        }
        return response;
    }  

    Public string handleResponse(HttpResponse response){
        log('Response', response, response.getBody());
        return response.getBody();
    }
    

    /*
     * Private helper methods: Only this class should use them.
     */
    
    public static void log(String header, Object obj, String msg) {
        String startStop = '\n===============================================================================';
        String logOutput = startStop;
        logOutput += (header != null) ? '\n== Header: ' + header : 'Header: No Header Set';
        logOutput += (obj != null) ? '\n== Obj string Rep: ' + obj : '\n No Obj set';
        logOutput += (msg != null) ? '\n== ' + msg : '';
        logOutput += startStop;
        // should we print debug statements?
        if(cs.CRAN_VEC_ADV_B_Debug__c){
            System.debug(logOutput);
        }
    }

    private static String createJsonError(String code, String descError){
        String jsonCode = '{\"errors\":[{\"code\":\"';
        String jsonDesc = '\",\"descError\":"';
        String jsonEnd = '"}]}';
        return jsonCode + code + jsonDesc + descError + jsonEnd;
    }

    private static HTTPResponse getMockHttpResponse(String service){
        HttpResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/JSON');    
        res.setHeader(CRAN_VEC_ADV_Constants_CLS.DATE_HEADER,'2016-11-10 15:29:51.660');
        res.setStatusCode(200);
        res.setStatus('OK');
        res.setBody(CRAN_VEC_ADV_Utils.getMockBody(service));
        return res;
    }

    /**
     * Comprueba si el nombre del servicio recibido por parametro esta dentro de la lista de servicios a devolver respuesta mock
     * @param  String [nombre del servicio a evaluar]
     * @retun Boolean 
     *  
    */
    public static Boolean isServiceMock(String serviceName){
       try{
        if(MOCKSERVICES && SERVICE_MOCK_SET.contains(serviceName)){
            return true;
       }else{
            return false;
        }
       }catch(Exception e){
            return false;
       }
    }

    private static Set<String> getServicesMockList(String serviceList){
        if(serviceList != null){
            return new Set<String>(SERVICE_MOCK_LIST.split(';'));
        }else{
            return null;
        }
    }
}