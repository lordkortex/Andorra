/**
 * CRAN_VEC_ADV_AvaloqServiceRequest  Class for Avaloq Rest services
 *
 * Avaloq RQ model (Service + Content)
 *
 * Fecha: 25/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * 
 * Edit add dataPower header & encryption
 * @version 1.1
 *
*/

public class CRAN_VEC_ADV_AvaloqServiceRequest {

  private String service;
  private String content;
  private String bu;
  public HttpRequest avaloqRequest{get;set;}
  private Static String CONTENT_TYPE = 'application/json';
  private Static String METHOD = 'POST';

  //Fills all fields and returns an HttpRequest for the methods that use continuation
  public CRAN_VEC_ADV_AvaloqServiceRequest(String service,String bu,String content){
    this.service = service;
    this.content = content;
    this.bu = bu;
    CRAN_VEC_ADV_AvaloqSettings__c cs = CRAN_VEC_ADV_AvaloqSettings__c.getInstance();
    HttpRequest req = new HttpRequest();
        req.setMethod(METHOD);
    req.setEndpoint(cs.CRAN_VEC_ADV_DatapowerEncrypted__c+'/service2/AvaloqServiciosSF/lanzarServicio/AsString');
        req.setHeader('Content-Type', CONTENT_TYPE);
        req.setClientCertificateName('salesforceclient');
        req.setHeader('X-DPE-Origin','Salesforce');

        Datetime now = Datetime.now();
        String headerDate = now +':'+  now.millisecond();
        System.debug('-----------------------------------------------');
        System.debug('CRAN_VEC_ADV_AvaloqServiceRequest Class');
        System.debug('Service : '+ service);
        System.debug('-----------------------------------------------');
        req.setHeader('Date', headerDate);

        req.setTimeout(cs.CRAN_VEC_ADV_T_TimeOut__c.intValue());
        CRAN_VEC_ADV_AvaloqRestManager restManager = new CRAN_VEC_ADV_AvaloqRestManager(service,bu,content);
        
        CRAN_ICA_KER_JSONhttpRequest_OBJ wrap = new CRAN_ICA_KER_JSONhttpRequest_OBJ();
        CRAN_VEC_ADV_UtilEncryption_CLS encrypUtil = new CRAN_VEC_ADV_UtilEncryption_CLS();
        wrap.encrypted = encrypUtil.encryptManaged(restManager.jsonContent);
        String wrapBody = JSON.serialize(wrap);
        
        req.setBody(wrapBody);
        this.avaloqRequest = req;
  }
}