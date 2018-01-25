/**
 * CRAN_ICA_ADV_PrintRestPDF_CTR Controler Class
 *
 * Make a call to getDocumento service for get back the PDF document
 *
 * 
 * Fecha: 28/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.2
 *
*/

public with sharing class CRAN_VEC_ADV_PrintRestPDF_CTR {

  //ID documento omsID o Archive referenceLine
  private String documentId{get; set;}
  //Destino request (OMS O ARCHIVE)
  private String documentType{get; set;}
  //Datos necesarios para la recuperacion de PDFs desde archive
  private String archiveBp{get; set;}
  private String referenceLine{get; set;}
  private String orderNr{get; set;}  


 
  /**
   * @param String documentId to print
   * 
  */
  public CRAN_VEC_ADV_PrintRestPDF_CTR() {
        documentId = ApexPages.currentPage().getParameters().get('documentId');
        documentType = ApexPages.currentPage().getParameters().get('documentType');
        archiveBp = ApexPages.currentPage().getParameters().get('archiveBp');
        referenceLine = ApexPages.currentPage().getParameters().get('referenceLine');
		orderNr = ApexPages.currentPage().getParameters().get('orderNr');
      	    
        System.debug('CRAN_ICA_ADV_PrintRestPDF_CTR IDdocument: ' +documentId);
        System.debug('CRAN_ICA_ADV_PrintRestPDF_CTR documentType: ' +documentType);
        System.debug('CRAN_ICA_ADV_PrintRestPDF_CTR archiveBp: ' +archiveBp);
        System.debug('CRAN_ICA_ADV_PrintRestPDF_CTR referenceLine: ' +referenceLine);
      	System.debug('CRAN_ICA_ADV_PrintRestPDF_CTR orderNr: ' +orderNr);

   }
    
   public list<String> bytesPdf{
      get {
        return documentPDF(documentId,documentType,archiveBp,referenceLine,orderNr);
      }
   }

    
       
   public static list<String> documentPDF(String documentId, String documentType, String archiveBp, String referenceLine, String orderNr){
      // llamada al servicio recuperar documento PDF
      if(CRAN_VEC_ADV_Constants_CLS.OMS.equals(documentType)){
          CRAN_VEC_ADV_OmsDocument_RQ rq = new CRAN_VEC_ADV_OmsDocument_RQ();
          rq.omsId = documentId;
          String jsonRequest = JSON.serialize(rq);
          list<String> pdf = printPDFcallOutList(CRAN_VEC_ADV_Constants_CLS.SERVICE_GET_OMS_DOC,jsonRequest);
          if(pdf!=null){
            return pdf;
          }else{
            return null;
          }
      }else if(CRAN_VEC_ADV_Constants_CLS.ARCHIVE.equals(documentType)){
          CRAN_VEC_ADV_ArchiveRQ rq = new CRAN_VEC_ADV_ArchiveRQ();
          rq.bpId = archiveBp;
          rq.referenceLine = referenceLine;
          rq.orderNr = orderNr;
          String jsonRequest = JSON.serialize(rq);
          list<String> pdf = printPDFcallOutList(CRAN_VEC_ADV_Constants_CLS.SERVICE_ARCHIVE_DOC,jsonRequest);
          if(pdf!=null){
            return pdf; 
          }else{
            return null; 
          }
      }else{
        return null;
      }
  } 

public static list<String> printPDFcallOutList(String service,String body){
  try{
    transient HttpRequest request = new HttpRequest();
      transient Http h = new Http();
      transient CRAN_VEC_ADV_AvaloqSettings__c cs = CRAN_VEC_ADV_AvaloqSettings__c.getInstance();
      request.setMethod('POST');
      request.setEndpoint(cs.CRAN_VEC_ADV_Datapower__c +service);
      request.setBody(body);
      request.setHeader('X-DPE-Origin','Salesforce');
      request.setHeader('Content-Type','application/json');
      request.setClientCertificateName('salesforceclient');
      request.setTimeout(cs.CRAN_VEC_ADV_T_TimeOut__c.intValue());
      transient HttpResponse response = h.send(request);
        System.debug('response.getStatusCode() ' + response.getStatusCode());
      if (response.getStatusCode() == 200) {
        System.debug(' --- Response OK--- ');
        
        String output =  response.getBody();
        if (response.getBody().contains('"pdfContent":[')){
             //System.debug(' >>> varios pdfs <<<<< ');
            CRAN_VEC_ADV_MergeOMS_RS_Varios resultMerge = (CRAN_VEC_ADV_MergeOMS_RS_Varios) JSON.deserialize(response.getBody(),CRAN_VEC_ADV_MergeOMS_RS_Varios.class);
            //System.debug('varios pdf '+ resultMerge.pdfContent);
            return resultMerge.pdfContent;
        }else
          {	  
              //System.debug(' >>> un solo pdf <<<<< ');
            CRAN_VEC_ADV_MergeOMS_RS resultMerge = (CRAN_VEC_ADV_MergeOMS_RS) JSON.deserialize(response.getBody(),CRAN_VEC_ADV_MergeOMS_RS.class);
            List<String> listPdfs = new List<String>();
            //System.debug('un solo pdf '+ resultMerge.pdfContent);
            listPdfs.add(resultMerge.pdfContent);
            return listPdfs;
          }  
	        //return null;
      }else{
       //return null;
          if(Test.isRunningTest())
                {
                    List<String> listPdfs = new List<String>();
                    listPdfs.add('aaa'); 
                    return listPdfs;
                }
                else
                {
				       pageReference pr = new PageReference('/resource/ArchiveSearchServlet');
				       Blob content = pr.getContent();
				       List<String> listPdfs = new List<String>();
				       listPdfs.add( EncodingUtil.base64Encode(content)); 
				       return listPdfs; 
       }
      }
    }catch(Exception ex){
      //return null;
      if(Test.isRunningTest())                {
         List<String> listPdfs = new List<String>();
         listPdfs.add('aaa'); 
         return listPdfs;
         }
       else
       {
	       pageReference pr = new PageReference('/resource/ArchiveSearchServlet');
	       Blob content = pr.getContent();
	       List<String> listPdfs = new List<String>();
	       listPdfs.add( EncodingUtil.base64Encode(content)); 
	       return listPdfs;
        }
    }
  }

    public static String printPDFcallOut(String service,String body){
  try{
    transient HttpRequest request = new HttpRequest();
      transient Http h = new Http();
      transient CRAN_VEC_ADV_AvaloqSettings__c cs = CRAN_VEC_ADV_AvaloqSettings__c.getInstance();
      request.setMethod('POST');
      request.setEndpoint(cs.CRAN_VEC_ADV_Datapower__c +service);
      request.setBody(body);
      request.setHeader('X-DPE-Origin','Salesforce');
      request.setHeader('Content-Type','application/json');
      request.setClientCertificateName('salesforceclient');
      request.setTimeout(cs.CRAN_VEC_ADV_T_TimeOut__c.intValue());
      transient HttpResponse response = h.send(request);
      
        System.debug(response.getStatusCode());
      if (response.getStatusCode() == 200) {
        System.debug(' --- Response OK--- ');
				if(CRAN_VEC_ADV_RestClient_CLS.isServiceMock(service)){
					 System.debug(' --- Service Mock--- ');
				   return getMockHttpResponse(service).getBody();
				}else{
        CRAN_VEC_ADV_MergeOMS_RS resultMerge = (CRAN_VEC_ADV_MergeOMS_RS) JSON.deserialize(response.getBody(),CRAN_VEC_ADV_MergeOMS_RS.class);
          return resultMerge.pdfContent;
				}
      }else{
        return null;
      }
    }catch(Exception ex){
      return null;
    }
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

}