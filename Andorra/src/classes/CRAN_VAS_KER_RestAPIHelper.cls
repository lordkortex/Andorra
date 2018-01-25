/**
* Class responsible for handling SFDC REST API calls
*
* @author  ZLR
* @version 1.0
*/
public with sharing class CRAN_VAS_KER_RestAPIHelper {
    
    private static 			CRAN_VAS_KER_RestAPIHelper instance = null;
    private 				String baseEndPoint;
    private 				String baseUrl;
    private 				String authorizationToken;
    
    // Default API version
    private					String apiVersion = '39.0';
    
    /**
    * Class constructor specifying whether to user or not the last API version when calling the API
    *
    * @param  	useLastestApiVersion  	True to user the latest API version available
    */     
    private CRAN_VAS_KER_RestAPIHelper(Boolean useLastestApiVersion) {
        
        // Base URL used in every call out
        baseUrl				= System.URL.getSalesforceBaseURL().toExternalForm();
        
        // Token for call out authentication
        authorizationToken 	= 'Bearer ' + getSessionId();
        
        // If true calls the REST API to get the latest available API version
        if (useLastestApiVersion) {
            apiVersion = getLastestApiVersion();
        }
        
        // Sets the base endpoint url for every REST API call
        baseEndPoint =  baseUrl + '/services/data/v' + apiVersion;
    }
    
    /**
    * Singleton method to return a instance of the class
    *
    * @param  	useLastestApiVersion  	True to use the latest API version available
    * @return an instance of the class
    */       
    public static CRAN_VAS_KER_RestAPIHelper getInstance(Boolean useLastestApiVersion) {
        
        if (instance == null) 
            instance = new CRAN_VAS_KER_RestAPIHelper(useLastestApiVersion);
        
        return instance;
    }  
  
    /**
    * Singleton method to return a instance of the class
    * 
    * @return an instance of the class
    */    
    public static CRAN_VAS_KER_RestAPIHelper getInstance() {
        
        if (instance == null) 
            instance = new CRAN_VAS_KER_RestAPIHelper(false);
        
        return instance;
    }         

    /**
     * Method responsible for sending a request to the REST API
     *
     * @param  	endPointUrl  	Relative path URL
     * @return the response
     */       
    private HttpResponse sendRequest(String endPointUrl) {
        
        String baseEndPointUrl;
        // If the base endpoint url is not set use the org's base url 
        if (String.isBlank(baseEndPoint))
            baseEndPointUrl = baseUrl;
        else
            baseEndPointUrl = baseEndPoint;
        
        // Concats the base and relative url
        String finalEndPointUrl = baseEndPointUrl + endPointUrl;
        
        // Sets the request parameters
        HttpRequest req = new HttpRequest();
        req.setEndpoint(finalEndPointUrl);
        req.setHeader('Authorization', authorizationToken);
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('GET');
        
        Http 	httpreq = new Http();
        
        HttpResponse res = httpreq.send(req);
        
        // If the response is OK returns the response object otherwise throws an error
        if (res.getStatusCode() != 200) {
            system.debug('Authorization Token');
            system.debug(authorizationToken);                 
            system.debug('Endpoint URL');
            system.debug(finalEndPointUrl);            
            system.debug('Response');
            system.debug(res);
            throw new CRAN_VAS_KER_RestAPIException('An error has occured when accessing the REST API. Status: ' + res.getStatus() + ' ' + res.getStatusCode());
        }
        
        return res;        
        
    }

    /**
     * Gets the latest API version available in the org
     *
     * @return the latest available API number
     */      
    private String getLastestApiVersion() {
        
        // Call the REST API to retrieve all available api versions
        HttpResponse res = sendRequest('/services/data/'); 
        
        List<CRAN_VAS_KER_RestAPIModel.ApiVersion> apiVersions = (List<CRAN_VAS_KER_RestAPIModel.ApiVersion>)
            JSON.deserialize(res.getBody(), 
                             List<CRAN_VAS_KER_RestAPIModel.ApiVersion>.class);
        
        // Gets the latest
        return apiVersions[apiVersions.size() - 1].version;
        
    }
    
    /**
     * Gets a List View's describe
     *
     * @param  	listViewId  	List View's Id
     * @param  	sObjectName  	Relative path URL 
     * @return object containing the definition of the requested List View
     */      
    public CRAN_VAS_KER_RestAPIModel.ListViewDescribe getListViewDescribe (Id listViewId, String sObjectName) {
        
        // Prepares the REST API's url for getting the list view's describe
        String endPointUrl = String.format('/sobjects/{0}/listviews/{1}/describe', 
                                           new String[] {
                                               sObjectName,
                                                   listViewId
                                                   });
        
        HttpResponse res = sendRequest(endPointUrl);
        
        return (CRAN_VAS_KER_RestAPIModel.ListViewDescribe)JSON.deserialize(res.getBody(), 
                                                                            CRAN_VAS_KER_RestAPIModel.ListViewDescribe.class);
        
    }

    /**
     * Gets the user session id
     *
     * @return the user session id
     */          
    private static String getSessionId() {
        
        // Once API calls are not allowed within AURA controllers
        // use a visualforce page as a workaround to get the user's session id
        PageReference pg = Page.UserSessionId;
        Map<String, Object> obj = new Map<String, Object>();
        if (!test.isRunningTest()) obj = (Map<String, Object>)JSON.deserializeUntyped(pg.getContent().toString());
        else obj.put('sessionId', '');
        
       
        return String.valueOf(obj.get('sessionId'));
        
    }    
    
    /**
     * Custom Exception
     */          
    private class CRAN_VAS_KER_RestAPIException extends Exception {}
}