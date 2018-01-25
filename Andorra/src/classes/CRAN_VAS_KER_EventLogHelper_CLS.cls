/**
* CRAN_VAS_KER_EventLogHelper_CLS is a class that aims to make easier and more precise the
* creation of log records within the CRAN_VAS_KER_EventLog__c and CRAN_VAS_KER_EventLogItem__c sObjects.
* Use this class whenever you want to create a custom log, for example, after an outbound 
* or inbound message.
* 
* @author Zuinglio Lopes Ribeiro Júnior
* @version 1.0
*/
public with sharing class CRAN_VAS_KER_EventLogHelper_CLS {

    /** Singleton approach */
    private static final CRAN_VAS_KER_EventLogHelper_CLS instance = new CRAN_VAS_KER_EventLogHelper_CLS();
    
    /** Custom metadata settings */
    private CRAN_VAS_KER_EventLogSetting__mdt eventLogSettings;

    /** Event log type - Must be the same name of a record type api name and a custom metadata record */
    private String eventLogType;

    /** Source that started the Event log */
    private String sourceClass;
    
    /** Private constructor to prevent the creation of instances of this class.*/
    private CRAN_VAS_KER_EventLogHelper_CLS() {}
    
    /** Indexed map containing the event log items that will be stored */
    private Map<Integer, CRAN_VAS_KER_EventLogItem__c> logItems;

    /** Indexed map containing the files that will be stored */
    private Map<Integer, List<ContentVersion>> logItemsFiles;
    
    /** Number of DML successes */
    private Integer numSuccess = 0;
    
    /** Number of DML errors */
    private Integer numErrors = 0;
    
    /**
    * Method responsible for providing the instance of this class.
    * @return CRAN_VAS_KER_EventLogHelper_CLS instance.
    */
    public static CRAN_VAS_KER_EventLogHelper_CLS getInstance() {
        return instance;
    }
    
    /**
    * Method that creates the event log, log items, files and sends or not an e-mail 
    * reporting the results.
    * @param sourceClass source that is starting the event log
    */
    public void commitLog(String sourceClass) {

        // If the commit is triggered from a difference source, the commit is ignored
        if (this.sourceClass != sourceClass || eventLogSettings == null)
            return;
        
        Id recTypeId = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('CRAN_VAS_KER_EventLog__c', eventLogType);
        CRAN_VAS_KER_EventLog__c eventLog = (CRAN_VAS_KER_EventLog__c)CRAN_VAS_KER_EventLog__c.getSObjectType().newSObject(recTypeId, true);        
        eventLog.CRAN_VAS_KER_N_Failures__c = numErrors;
        eventLog.CRAN_VAS_KER_N_Successes__c = numSuccess;
        eventLog.CRAN_VAS_KER_T_Source__c = sourceClass;

		if (isRecordLogEnabled()) {        

			try {          

		        /** Inserts the log header */
		        insert eventLog;
		        
		        /** If there are items, inserts them */
		        if (logItems != null) {
		            
		            Map<String, ContentVersion> filesToInsert = new Map<String, ContentVersion>();
		            
		            for (Integer num : logItems.keySet()) {

                        CRAN_VAS_KER_EventLogItem__c logItem = logItems.get(num);
		                
		                logItem.CRAN_VAS_KER_L_EventLog__c = eventLog.Id;

                        // If there is related files to an item, maps them to be insertd
                        if (logItemsFiles != null) {
    	                	List<ContentVersion> files = logItemsFiles.get(num);

    	                	if (files != null) {
                                for (ContentVersion file : files) {
                                    filesToInsert.put(file.Title, file);
                                }
                            }
                        }
	                		
		            }
		            
		            insert logItems.values();                

                    // If there is related files to an item, inserts them querying
                    // them afterwards to link them with the item
		            if (!filesToInsert.isEmpty()) {

			            insert filesToInsert.values();

                        for (ContentVersion fileVersion : [ SELECT Title, ContentDocumentId 
                                                            FROM ContentVersion 
                                                            WHERE Id =: filesToInsert.values()]) {
                            filesToInsert.put(fileVersion.Title, fileVersion);                            
                        }

                        List<ContentDocumentLink> fileLinks = new List<ContentDocumentLink>();
			            for (Integer num : logItems.keySet()) {

			            	List<ContentVersion> files = logItemsFiles.get(num);

			            	if (files != null) {
			            		for (ContentVersion file : files) {

			            			ContentDocumentLink contentLink = new ContentDocumentLink();
			            			contentLink.ContentDocumentId = filesToInsert.get(file.Title).ContentDocumentId;
			            			contentLink.LinkedEntityId = logItems.get(num).Id;
			            			contentLink.ShareType = 'I';
			            			contentLink.Visibility = 'AllUsers';
                                    fileLinks.add(contentLink);
			            		}
			            	}

			            }

                        insert fileLinks;                        
		        	}

		        }

	    	} catch (Exception ex) {

            	if (isDebugEnabled()) {
                    System.debug('ERROR COMMITING THE LOG');
            		System.debug(getFormattedException(ex));
                }

	    	}
    	}
        
        /** When true, sends an e-mail reporting the outcome. In case of failure,
		* an exception is thrown */
        if (isEmailNotificationOn()) {

            try {
                CRAN_VAS_KER_EmailHelper.sendLogInterfaceMail(eventLog);
            } catch (Exception ex) {

            	if (isDebugEnabled())
            		System.debug(ex);

            	if (isRecordLogEnabled()) {

	                CRAN_VAS_KER_EventLogItem__c logItem = new CRAN_VAS_KER_EventLogItem__c();
	                logItem.CRAN_VAS_KER_L_EventLog__c = eventLog.Id;
	                logItem.CRAN_VAS_KER_TAL_Description__c	= String.format(Label.CRAN_VAS_KER_EmailNotification,
                                                                            new String[] { 
                                                                                getFormattedException(ex) 
                                                                                });
	                logItem.CRAN_VAS_KER_T_Code__c = StatusCode.CRAN_ERR_10021.name();
	                
                    try {
	                   insert logItem;
                    } catch (Exception emailEx) {
                        if (isDebugEnabled()) {
                            System.debug('ERROR COMMITING THE LOG');
                            System.debug(getFormattedException(emailEx));
                        }
                    }
            	}
            }
        }        
        
        // Resets values after commit
        logItems = null;
        logItemsFiles = null;
        numSuccess = 0;
        numErrors = 0;          
    }
    
    /**
    * Writes an event of a call out exception
    * @param ex exception
    * @param httpRequest http request object
    * @param httpResponse http response object
    * @param errorCode error code that identify the error    
    */     
    public void writeEvent(Exception ex, CRAN_VAS_KER_RestCallOutHelper_CLS httpRequest, HttpResponse httpResponse, String errorCode) {

        CRAN_VAS_KER_EventLogItem__c logItem = new CRAN_VAS_KER_EventLogItem__c();
        logItem.CRAN_VAS_KER_TAL_Description__c	= String.format(Label.CRAN_VAS_KER_ExceptionRequestAndResponseTitle, new String [] {
        	getFormattedException(ex),
        	httpRequest != null ? httpRequest.getHttpRequest().toString() : ''
        });

        logItem.CRAN_VAS_KER_T_RelatedTo__c	= 'Callout';
        logItem.CRAN_VAS_KER_T_Code__c = errorCode;
        
        // If there is a response, stores its details
       	if (httpResponse != null) {

       		String header = '';

            Set<String> headers = new Set<String>(httpResponse.getHeaderKeys());
            headers.remove(null);

            for (String key : headers) {
                header += String.format(Label.CRAN_VAS_KER_ResponseHeader, new String[] {
                                                            key,
                                                            httpResponse.getHeader(key)
                                                        });
            }    

	        logItem.CRAN_VAS_KER_TAL_Description__c	+= String.format(Label.CRAN_VAS_KER_HeaderAndStatusResponseTitle, new String [] {
		        	header,
		        	String.valueOf(httpResponse.getStatusCode()) + ' ' + httpResponse.getStatus()
	        });     	
	            
        }

        // If true stores a file containing the request and response body
        if (storeRequestAndResponseBody() && httpRequest != null) {
            List<ContentVersion> filesToInsert = new List<ContentVersion>();
            filesToInsert.add(newFileVersion('HttpResquest', httpRequest.getHttpRequest().getBodyAsBlob()));

            if (httpResponse != null)
                filesToInsert.add(newFileVersion('HttpResponse', httpResponse.getBodyAsBlob()));

        	addLogItem(logItem, filesToInsert);
        } else {
       		addLogItem(logItem);                   
        }

        if (isDebugEnabled()) {
            System.debug(errorCode);
            System.debug(ex);
            System.debug(httpRequest);
            System.debug(httpResponse);
        }
        
    }

    /**
    * Return an instance for a new file
    * @param fileName name of the file
    * @param fileBody file content
    * @return file
    */     
    private ContentVersion newFileVersion(String fileName, Blob fileBody) {

    	ContentVersion newFileVersion = new ContentVersion();
        newFileVersion.VersionData = fileBody;
        newFileVersion.Title =  fileName + ' ' + Crypto.getRandomInteger();
        newFileVersion.Description = newFileVersion.Title;
        newFileVersion.PathOnClient = '/' + newFileVersion.Title + '.txt';

        return newFileVersion;

    }     

    /**
    * Method that populates the log items with detailed information of the errors
    * @param errors array of Database.Error that contains detailed information
    * @param relatedTo label of the sObject in the transaction
    */        
    private void setErrors(Database.Error[] errors, String relatedTo) {
        
        for (Database.Error error : errors) {

            CRAN_VAS_KER_EventLogItem__c logItem = new CRAN_VAS_KER_EventLogItem__c();
            logItem.CRAN_VAS_KER_TAL_Description__c	=  String.format(Label.CRAN_VAS_KER_DmlErrorMessage, new String[] {
                                                                                error.getMessage(),
                                                                                String.join(error.getFields(), ','),
                                                                                String.valueOf(error.getStatusCode())
                                                                                });
            logItem.CRAN_VAS_KER_T_Code__c = StatusCode.CRAN_ERR_10008.name();   
            logItem.CRAN_VAS_KER_T_RelatedTo__c	= relatedTo;
            addLogItem(logItem);
        }
        
    }

    /**
    * Writes an event of DML results of an insert or update operation,
    * counting and registering errors and success.
    * @param results collection of Dabase.SaveResult object
    * @param relatedTo label of the sObject in the transaction
    */            
    public void writeEvent(Database.SaveResult[] results, String relatedTo) {

        if (isDebugEnabled())
            System.debug(results);        
        
        for (Database.SaveResult result: results) {
            if (result.isSuccess()) {
                numSuccess++;
            } else {
                numErrors++;
                setErrors(result.getErrors(), relatedTo);
            } 
        }
    }

    /**
    * Writes an event of a DML result of an insert or update operation,
    * counting and registering errors and success.
    * @param result Dabase.SaveResult object
    * @param relatedTo label of the sObject in the transaction
    */            
    public void writeEvent(Database.SaveResult result, String relatedTo) {

        if (isDebugEnabled())
            System.debug(result);        

        if (result.isSuccess()) {
            numSuccess++;
        } else {
            numErrors++;
            setErrors(result.getErrors(), relatedTo);
        } 
    }    

    /**
    * Writes an event of DML results of an upsert operation,
    * counting and registering errors and success.
    * @param results collection of Dabase.UpsertResult object
    * @param relatedTo label of the sObject in the transaction
    */           
    public Boolean writeEvent(Database.UpsertResult[] results, String relatedTo) {
        
    	if (isDebugEnabled())
    		System.debug(results);        

        for (Database.UpsertResult result: results) {
            if (result.isSuccess()) {
                numSuccess++;
            } else {
                numErrors++;
                setErrors(result.getErrors(), relatedTo);
            } 
        }   
        
        return numErrors == 0;
    }
    
    /**
    * Writes an event of DML results of deletion,
    * counting and registering errors and success.
    * @param results collection of Dabase.DeleteResult object
    * @param relatedTo label of the sObject in the transaction
    */           
    public Boolean writeEvent(Database.DeleteResult[] results, String relatedTo) {

    	if (isDebugEnabled())
    		System.debug(results);        

        for (Database.DeleteResult result: results) {
            if (result.isSuccess()) {
                numSuccess++;
            } else {
                numErrors++;
                setErrors(result.getErrors(), relatedTo);
            } 
        }   
        
        return numErrors == 0;
    }    
    
    /**
    * Writes an event for an exception
    * @param ex exception
    * @param relatedTo process, object or anything that is related to the error
    * @param errorCode error code that identify the error
    */    
    public void writeEvent(Exception ex, String relatedTo, String errorCode) {

    	if (isDebugEnabled())
    		System.debug(ex);

        CRAN_VAS_KER_EventLogItem__c logItem = new CRAN_VAS_KER_EventLogItem__c();
        logItem.CRAN_VAS_KER_TAL_Description__c	= getFormattedException(ex);
        logItem.CRAN_VAS_KER_T_RelatedTo__c = relatedTo;
        logItem.CRAN_VAS_KER_T_Code__c = errorCode;

      	addLogItem(logItem);   
    }

    /**
    * Returns a formatted message from an exception
    * @param ex exception
    * @return formatted string containing the exception details
    */       
    public String getFormattedException(Exception ex) {

    	return String.format(Label.CRAN_VAS_KER_ExceptionMessage, new String[] {
            ex.getMessage(),
            ex.getCause() != null ? getFormattedException(ex) : '',
            String.valueOf(ex.getLineNumber()),
            ex.getStackTraceString()
            });
    }
    
    /**
    * Writes an event for an error message
    * @param message error message
    * @param relatedTo process, object or anything that is related to the error
    * @param errorCode error code that identify the error
    */       
    public void writeEvent(String message, String relatedTo, String errorCode) {

        CRAN_VAS_KER_EventLogItem__c logItem = new CRAN_VAS_KER_EventLogItem__c();
        logItem.CRAN_VAS_KER_TAL_Description__c	= message;
        logItem.CRAN_VAS_KER_T_RelatedTo__c	= relatedTo;
        logItem.CRAN_VAS_KER_T_Code__c = errorCode;        

      	addLogItem(logItem);   
    }          
    
    /**
    * Method that adds a CRAN_VAS_KER_EventLogItem__c sObject to a collection 
    * that will be persisted when the method createLog be invoked. 
    * @param logItem event log item
    */      
    private void addLogItem(CRAN_VAS_KER_EventLogItem__c logItem) {

        if (logItems == null)
            logItems = new Map<Integer, CRAN_VAS_KER_EventLogItem__c>();
        
        logItems.put(logItems.size(), logItem);   
    }

    /**
    * Method that adds a CRAN_VAS_KER_EventLogItem__c sObject and its related files to an indexed map 
    * that will be persisted when the method createLog be invoked. 
    * @param logItem event log item
    * @param fileToInsert list of files related to an event log item
    */      
    private void addLogItem(CRAN_VAS_KER_EventLogItem__c logItem, List<ContentVersion> fileToInsert) {

        if (logItems == null)
            logItems = new Map<Integer, CRAN_VAS_KER_EventLogItem__c>();

        if (logItemsFiles == null)
            logItemsFiles = new Map<Integer, List<ContentVersion>>();

        List<ContentVersion> files = logItemsFiles.get(logItems.size());
        if (files == null) {
        	files = new List<ContentVersion>();
        	logItemsFiles.put(logItems.size(), files); 
        }
        
        files.addAll(fileToInsert);

        logItems.put(logItems.size(), logItem); 
    }

    /**
     * Returns the number of Event Log Items
     * @return size of the list
     */      
    public Integer size() {
        return logItems == null ? null : logItems.size();
    }
    
    /**
     * Returns if errors occurred
     * @return true if has error
     */    
    public Boolean hasErrors() {
        return numErrors > 0;
    }

    /**
     * Returns whether records must be stored in the Event Log and Event Log Item sObject
     * @param eventLogType type of the Event Log to retrieve proper settings
     * @param sourceClass class that is instantiating the Event Log
     */
    public void setLogType(String eventLogType, String sourceClass) {

        // If the log was started by another source this step is ignored
        if (this.eventLogType != null && this.sourceClass != null)
            return;

    	this.eventLogType = eventLogType;
    	this.sourceClass = sourceClass;

        try {

        	eventLogSettings = [SELECT 	CRAN_VAS_KER_B_TurnOnDebug__c, 
        								CRAN_VAS_KER_B_TurnOnEmailNotification__c,
        								CRAN_VAS_KER_B_TurnOnRecordLog__c,
                                        CRAN_VAS_KER_B_StoreRequestAndResponse__c
        						FROM	CRAN_VAS_KER_EventLogSetting__mdt
        						WHERE 	DeveloperName =: eventLogType];
        } catch (Exception ex) {
            System.debug('EVENT LOG SETTINGS WERE NOT FOUND. THE LOG WON\'T RECORD ANY EVENT.');
            System.debug(eventLogSettings);
        }
        
   	
    }

    /**
     * Returns whether records must be stored in the Event Log and Event Log Item sObject
     * @return true if must be stored
     */
    public Boolean isRecordLogEnabled() {
    	return eventLogSettings != null && eventLogSettings.CRAN_VAS_KER_B_TurnOnRecordLog__c;
    }

    /**
     * Returns whether a System.debug statement must be issued
     * @return true if must be issued
     */
    public Boolean isDebugEnabled() {
    	return eventLogSettings != null && eventLogSettings.CRAN_VAS_KER_B_TurnOnDebug__c;
    }     

    /**
     * Returns whether an email notification must be sent when the log is comitted
     * @return true if must be sent
     */
    public Boolean isEmailNotificationOn() {
    	return eventLogSettings != null && eventLogSettings.CRAN_VAS_KER_B_TurnOnEmailNotification__c;
    }

    /**
     * Returns whether the Http Response and Request should be stored
     * @return true if must be stored
     */
    public Boolean storeRequestAndResponseBody() {
    	return eventLogSettings != null && eventLogSettings.CRAN_VAS_KER_B_StoreRequestAndResponse__c;
    }

    /**
     *  Enum containing error codes that will aid when identifying exceptionss 
     */
    public enum StatusCode { 
        CRAN_ERR_10001, 
        CRAN_ERR_10002, 
        CRAN_ERR_10003,
        CRAN_ERR_10004, 
        CRAN_ERR_10005,
        CRAN_ERR_10006, 
        CRAN_ERR_10007,
        CRAN_ERR_10008,
        CRAN_ERR_10009,
        CRAN_ERR_10010,
        CRAN_ERR_10011,
        CRAN_ERR_10012,
        CRAN_ERR_10013,
        CRAN_ERR_10014,
        CRAN_ERR_10015,
        CRAN_ERR_10016,
        CRAN_ERR_10017,
        CRAN_ERR_10018,
        CRAN_ERR_10019,
        CRAN_ERR_10020,
        CRAN_ERR_10021,
        CRAN_ERR_10030,
        CRAN_ERR_10031,
        CRAN_ERR_10032,
        CRAN_ERR_10033,
        CRAN_ERR_10034,
        CRAN_ERR_10035,
        CRAN_ERR_10036
    }

}