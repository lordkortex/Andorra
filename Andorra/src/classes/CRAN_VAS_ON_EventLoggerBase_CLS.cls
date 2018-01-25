public with sharing class CRAN_VAS_ON_EventLoggerBase_CLS {
	    /** Singleton approach */
		private static final CRAN_VAS_ON_EventLoggerBase_CLS instance = new CRAN_VAS_ON_EventLoggerBase_CLS();

		/** Source that started the Event log */
		private String sourceClass;
		
		/** Private constructor to prevent the creation of instances of this class.*/
		private CRAN_VAS_ON_EventLoggerBase_CLS() {}
		
		/**
		* Method responsible for providing the instance of this class.
		* @return CRAN_VAS_KER_EventLogHelper_CLS instance.
		*/
		public static CRAN_VAS_ON_EventLoggerBase_CLS getInstance() {
			return instance;
		}
		
		public void commitLog(Exception ex) {
			try {
				//Event_Log__c log = new Event_Log__c();
				//log.Error_Line_Number__c =  ex.getLineNumber();
				//log.Error_Message__c = ex.getMessage();
				//log.Error_Class_Name__c = sourceClass ;
				//log.Error_Status_Code__c = ex.getStackTraceString();
				//insert log;
				//EventLogEmailer.notifyEmailer(ex, log);   
	 		}
			catch(Exception exc) {
				System.debug('ERROR COMMITING THE LOG');
				System.debug(getFormattedException(ex));
			}		
		}
		
		/**
		    * Returns a formatted message from an exception
		    * @param ex exception
		    * @return formatted string containing the exception details
		*/       
		public String getFormattedException(Exception ex) {
			String rtr = '';
		    return rtr;
		        	//String.format(Label.ExceptionMsg, new String[] {
		            //ex.getMessage(),
		            //ex.getCause() != null ? getFormattedException(ex) : '',
		            //String.valueOf(ex.getLineNumber()),
		            //ex.getStackTraceString()
		            //});
		}
		
		
		 /**
		     * @param sourceClass class that is instantiating the Event Log
		  */
		 public void setLogType(String sourceClass) {
		        // If the log was started by another source this step is ignored
		        if (this.sourceClass != null)
		            return;
		        this.sourceClass = sourceClass; 
		 }
}