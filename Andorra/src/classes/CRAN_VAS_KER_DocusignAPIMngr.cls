/**
* Class that manages call outs to DocuSign REST API
*
* @author  Luís Velasco
* @author  Zuinglio Lopes Ribeiro Júnior
* @version 2.0
*/
public with sharing class CRAN_VAS_KER_DocusignAPIMngr {
	
	private static CRAN_VAS_KER_DocusignAPIMngr instance;
	private CRAN_VAS_KER_Docusign__c settings;
	private CRAN_VAS_KER_DocusignLoginResponse.LoginAccounts loginAccount;	
	
	/**
	* Constructor
	*/
	private CRAN_VAS_KER_DocusignAPIMngr() {

		// Gets the custom setting
		settings = CRAN_VAS_KER_Docusign__c.getOrgDefaults();

		// Starting event log
		CRAN_VAS_KER_EventLogHelper_CLS.getInstance().setLogType('CRAN_VAS_KER_General', CRAN_VAS_KER_DocusignAPIMngr.class.getName());
	}
	
    /**
    * Returns an instance of the class
    */ 		
	public static CRAN_VAS_KER_DocusignAPIMngr getInstance() {
		if (instance == null) {
			instance = new CRAN_VAS_KER_DocusignAPIMngr();
		}
		return instance;
	}
	
    /**
    * Log in DocuSign account and gets the baseUrl for subsequent calls 
    */ 	
	public void userLogin() {
		
		CRAN_VAS_KER_RestCallOutHelper_CLS restCallOut;
		HttpResponse res;

		try {

			// Since DocuSign API is sessionless we must send an authentication header in every callout
			Map<String, String> header = new Map<String, String> { 'X-DocuSign-Authentication' => getAuthHeader() }; 
			restCallOut = new CRAN_VAS_KER_RestCallOutHelper_CLS(settings.Login_URL__c, header);		
			res = restCallOut.sendJSONRequest(null, 'GET');
			
			// Checks whether or not the call out was successful
			if (res.getStatusCode() == 200) {   
	        	
				// Stores the response
	        	CRAN_VAS_KER_DocusignLoginResponse loginAcc = (CRAN_VAS_KER_DocusignLoginResponse) JSON.deserialize(res.getBody(), CRAN_VAS_KER_DocusignLoginResponse.class);
	        	loginAccount = loginAcc.getLoginAccounts().get(0);
	        	
	        } else {
	        	throw new CRAN_VAS_KER_SignatureException(System.Label.CRAN_VAS_KER_SignatureExceptionDSLoginRespError +
	        											  res.getStatusCode() + ' <> 200)');
	        }

        } catch (Exception ex) {

        	CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(ex, 
        		restCallOut, 
        		res, 
        		CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10030.name());

        	// If invoked by the user, throws a friendly message
        	if (!isAsynchronous()) {
        		throw new CRAN_VAS_KER_SignatureException(String.format(Label.CRAN_VAS_KER_SigningCeremonyError, new String[] {
        			CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10030.name()
        		}));
        	}
        }
		
	}
	
	/** 
	 * Gets the Authentication Header which will be used for all subsequent call outs
	 * @param sendOnBehalfOf e-mail of a valid DocuSign user
	 * @return Authentication Header
	 */
    public String getAuthHeader(String sendOnBehalfOf) {
			
		JSONGenerator gen = JSON.createGenerator(false);
		gen.writeStartObject();
		gen.writeStringField('Username', settings.Username__c );
		gen.writeStringField('Password', settings.Password__c);
		gen.writeStringField('IntegratorKey', settings.Integration_Key__c);
		
		// Adds the SendOnBehalfOf property - https://docs.docusign.com/esign/guide/authentication/sobo.html
		if (String.isNotBlank(sendOnBehalfOf))		
			gen.writeStringField('SendOnBehalfOf', sendOnBehalfOf);
		
		gen.writeEndObject();
		gen.close();	
		
    	return gen.getAsString();
    }
	
	/** 
	 * Gets the Authentication Header which will be used for all subsequent call outs
	 * @return Authentication Header
	 */	
    public String getAuthHeader() {
    	return getAuthHeader(null);
    }	
	
	/** 
	 * Creates a DocuSign envelope which will be used in a signing ceremony
	 * @param envelope object containing all necessary data to start to create a envelope
	 * @return envelope id
	 */	
	public String createEnvelope(CRAN_VAS_KER_DocuSignEnvelope_CLS envelope) {
		
		CRAN_VAS_KER_RestCallOutHelper_CLS restCallOut;
		HttpResponse res;
		String envelopeId;
		
		try {

			String endPoint = String.format('{0}/envelopes', new String[] { loginAccount.baseUrl} );

			// Since DocuSign API is sessionless we must send an authentication header in every callout
			Map<String, String> header = new Map<String, String> { 'X-DocuSign-Authentication' => getAuthHeader() }; 
			restCallOut = new CRAN_VAS_KER_RestCallOutHelper_CLS(endPoint, header);
	        res = restCallOut.sendJSONRequest(JSON.serialize(envelope, true));

	       	// If success, sets the envelope id
			if (res.getStatusCode() == 201) {
				CRAN_VAS_KER_DocusignEnvelopeResponse envelopeResponse = (CRAN_VAS_KER_DocusignEnvelopeResponse) JSON.deserialize(res.getBody(), CRAN_VAS_KER_DocusignEnvelopeResponse.class);
				envelopeId = envelopeResponse.envelopeId;	
			} else {
				throw new CRAN_VAS_KER_SignatureException(System.Label.CRAN_VAS_KER_SignatureExceptionDSEnvCreate +
	        											  res.getStatusCode() + ' <> 200)');
			}

		} catch (Exception ex) {

        	CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(ex, 
        		restCallOut, 
        		res, 
        		CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10031.name());

        	// If invoked by the user, throws a friendly message
        	if (!isAsynchronous()) {
        		throw new CRAN_VAS_KER_SignatureException(String.format(Label.CRAN_VAS_KER_SigningCeremonyError, new String[] {
        			CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10031.name()
        		}));
        	}

		}
		
		return envelopeId;		
	}	

    /**
    * Gets an URL to start a DocuSign ceremony
    * @param envelopeId the envelope Id
    * @param userName set in the envelope
    * @param email set in the envelope
    * @param clientUserId set in the envelope
    * @param recipientId set in the envelope
    * @param recordId set in the envelope            
	* @return url to start the ceremony
    */
	public String getUrlForEnvelope(String envelopeId, String userName, String email, 
		String clientUserId, String recipientId, String recordId) {

		CRAN_VAS_KER_RestCallOutHelper_CLS restCallOut;
		HttpResponse res;

		try {

			// JSON to be sent in the request to retrieve the time-limited URL
			// https://docs.docusign.com/esign/restapi/Envelopes/EnvelopeViews/createRecipient/
	        JSONGenerator gen = JSON.createGenerator(false);
	        gen.writeStartObject();
	        gen.writeStringField('authenticationMethod', 'PaperDocuments');
			gen.writeStringField('clientUserId', clientUserId);
			gen.writeStringField('email', email);
			gen.writeStringField('recipientId', recipientId);
			gen.writeStringField('returnUrl', String.format('{0}/apex/CRAN_VAS_KER_SelfCloseWindow', new String[] {
									 URL.getSalesforceBaseUrl().toExternalForm() }));
			gen.writeStringField('userName', userName);
	        gen.writeEndObject();
	        gen.close();				

			String endPoint = String.format('{0}/envelopes/{1}/views/recipient', new String[] { loginAccount.baseUrl, envelopeId } );
			
			// Since DocuSign API is sessionless we must send an authentication header in every callout
			Map<String, String> header = new Map<String, String> { 'X-DocuSign-Authentication' => getAuthHeader() };

			restCallOut = new CRAN_VAS_KER_RestCallOutHelper_CLS(endPoint, header);		
			res = restCallOut.sendJSONRequest(gen.getAsString());
			
			if (res.getStatusCode() == 201) {
				CRAN_VAS_KER_DocusignRecViewURLResponse	urlResponse = (CRAN_VAS_KER_DocusignRecViewURLResponse) JSON.deserialize(res.getBody(), CRAN_VAS_KER_DocusignRecViewURLResponse.class);
				return urlResponse.url;			
			} else {		
				throw new CRAN_VAS_KER_SignatureException(System.Label.CRAN_VAS_KER_SignatureExceptionDSInPersonSignURL +
	        											  res.getStatusCode() + ' <> 200)');
			}

		} catch (Exception ex) {

        	CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(ex, 
        		restCallOut, 
        		res, 
        		CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10032.name());

        	// If invoked by the user, throws a friendly message
        	if (!isAsynchronous()) {
        		throw new CRAN_VAS_KER_SignatureException(String.format(Label.CRAN_VAS_KER_SigningCeremonyError, new String[] {
        			CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10032.name()
        		}));
        	}
		}
		
		return null;
	}

    /**
    * Sends an envelope to the purge queue on DocuSign
    * @param envelopeId to be purged
    */
	public void purgeEnvelope(String envelopeId) {
			
		CRAN_VAS_KER_RestCallOutHelper_CLS restCallOut;
		HttpResponse res;
		
		try {

			String endPoint = String.format('{0}/envelopes/{1}', 
												new String[] { loginAccount.baseUrl,
																envelopeId
											});		
													
			// Since DocuSign API is sessionless we must send an authentication header in every callout
			Map<String, String> header = new Map<String, String> { 'X-DocuSign-Authentication' => getAuthHeader() };
			
	        JSONGenerator gen = JSON.createGenerator(false);
	        gen.writeStartObject();
	        gen.writeStringField('purgeState', 'documents_and_metadata_queued');
	        gen.writeEndObject();
	        gen.close();					

			restCallOut = new CRAN_VAS_KER_RestCallOutHelper_CLS(endPoint, header);
	        res = restCallOut.sendJSONRequest(gen.getAsString(), 'PUT');

			if (res.getStatusCode() != 200) {
				throw new CRAN_VAS_KER_SignatureException(System.Label.CRAN_VAS_KER_UnexpectedErrorPurging);
			}

		} catch (Exception ex) {
            CRAN_VAS_KER_EventLogHelper_CLS.getInstance().writeEvent(ex, restCallOut, res, 
            	CRAN_VAS_KER_EventLogHelper_CLS.StatusCode.CRAN_ERR_10033.name());
            
            if (isAsynchronous())
            	throw ex;
		}
        
        CRAN_VAS_KER_EventLogHelper_CLS.getInstance().commitLog(CRAN_VAS_KER_DocusignAPIMngr.class.getName());    
	}		

    /**
    * Checks if the transaction is running in asynchronous mode
    * @return true if it's an asynchronous context
    */ 
    private static Boolean isAsynchronous() {
        return System.isBatch() || System.isFuture() || System.isQueueable() || System.isScheduled();
    }    	
	    
}