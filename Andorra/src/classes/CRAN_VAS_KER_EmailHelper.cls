/**
* Class that handles email notifications
* @author Zuinglio Lopes Ribeiro Júnior
* @version 2.0
*/
public with sharing class CRAN_VAS_KER_EmailHelper {
    
    /** Org wide email addresses list */
    private static OrgWideEmailAddress[] owea;

    /** Custom setting containing email addresses  */
    private static List<CRAN_VAS_KER_InterfaceEmailNotification__c> customSettingsEmail;
    
    /** Static block to fetch settings  */
    static {
        owea = [SELECT Id FROM OrgWideEmailAddress WHERE DisplayName = 'Interface_Email'];
        customSettingsEmail = CRAN_VAS_KER_InterfaceEmailNotification__c.getall().values();
    }
    
    /**
    * Sends an email notification based on an exception
    * @param thrownEx exception
    * @param sourceClassName source from where the notification was invoked
    * @param intType type of interface
    * @param bpEmail BP's email          
    */    
    public static void sendInterfaceEmailNotification(Exception thrownEx, String sourceClassName, InterfaceType intType, String bpEmail) {
        
        try {
            
            List<String> toAddresses = new List<String>();
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            
            // If the outbound email limit is reached, throws an exception
            if (Limits.getEmailInvocations() == Limits.getLimitEmailInvocations())
                throw new EmailHelperException('The email limit has been reached. Interface email notification has not been sent.');
            
            // If there is not email address to send the email to, throws an exception
            if (customSettingsEmail.isEmpty() && String.isNotBlank(bpEmail))
                throw new EmailHelperException('Custom setting CRAN_VAS_KER_InterfaceEmailNotification__c empty and/or BP E-mail not found.');
            
            for (CRAN_VAS_KER_InterfaceEmailNotification__c customSetting : customSettingsEmail)
                toAddresses.add(customSetting.CRAN_VAS_KER_T_EmailTo__c);
            
            if (String.isNotBlank(bpEmail))
                toAddresses.add(bpEmail);
            
            // If there is not org wide email address, throws an exception
            if (owea.isEmpty())
                throw new EmailHelperException('Org-Wide Address display name Interface_Email has not been found.');
            
            // Sets the notification detail
            message.setOrgWideEmailAddressId(owea[0].Id);   
            message.setToAddresses(toAddresses);
            message.setSubject(Label.CRAN_VAS_KER_InterfaceEmailSubject);
            message.setPlainTextBody(getEmailFormattedException(thrownEx, sourceClassName, intType));
            
            Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage> {message};
            Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
            // If an error occurred when sending the email, throws an exception
            if (!results[0].success)
                throw new EmailHelperException('The email failed to send: ' + results[0].errors[0].message);
                
        } catch (Exception ex) {
            System.debug('Error when sending interface email notification.\n\n' + ex.getMessage());
        }
        
    }
    
    /**
    * Sends an email notification based on an exception
    * @param thrownEx exception
    * @param sourceClassName source from where the notification was invoked
    * @param intType type of interface       
    */    
    public static void sendInterfaceEmailNotification(Exception thrownEx, String sourceClassName, InterfaceType intType) {
        // Calls overload
        sendInterfaceEmailNotification(thrownEx, sourceClassName, intType, null);
    }
    
    /**
    * Returns a formatted message from an exception
    * @param ex exception
    * @param sourceClassName source from where the notification was invoked
    * @param intType type of interface   
    * @return formatted string containing the exception details
    */         
    private static String getEmailFormattedException(Exception thrownEx, String sourceClassName, InterfaceType intType) {
       
        String exceptionMsg = Label.CRAN_VAS_KER_InterfaceEmailMessage;
        Exception cause;
        
        while (thrownEx.getCause() != null)
            cause = thrownEx.getCause();
                
        List<String> arguments = new String [] {
                intType.name(),
                String.valueOf(thrownEx.getLineNumber()),
                thrownEx.getTypeName(),
                sourceClassName,
                UserInfo.getName() + ' (' + UserInfo.getUserId() + ')',                
                (cause != null ? cause.getMessage() : ''),
                thrownEx.getMessage(),
                thrownEx.getStackTraceString()
                };

        return String.format(exceptionMsg, arguments);
    }
    
    /**
     *  Enum containing the interface types
     */    
    public enum InterfaceType { DOCUSIGN_SIGNBUTTON, DOCUSIGN_INPERSONSIGN, ARCHIVE }
    
    /**
     *  Custom exception
     */    
    private class EmailHelperException extends Exception {}

    public static void sendEmailCSVAttach( String csvFile, String nameFile, String subject, String body ){    
    
                try{
                    
                    String userName = UserInfo.getUserName();
                    User activeUser = [Select Email From User where Username = : userName limit 1];
                    String userEmail = activeUser.Email;
                    
                    String base64Data = CRAS_ICA_ASS_Helpers_CLS.createBase64File(csvFile);
                    base64Data = EncodingUtil.urlDecode( base64Data, 'UTF-8 BOM');
                    Blob b = EncodingUtil.base64Decode(base64Data);
                        
                    Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setFileName(nameFile);
                    efa.setBody(b);
                    
                    
                    List<String> lMail =  new String[]{userEmail};
                        
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setOrgWideEmailAddressId(owea[0].Id); 
                    email.setSubject(subject);
                    email.setToAddresses(lMail);
                    email.setPlainTextBody(body);
                    email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});    
                    
                    Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {email};
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);

            
                    if (results != null &&  results[0] != null && results[0].success) {
                        System.debug('The email was sent successfully.');
                    } else {
                        if(results != null &&  results[0] != null ){
                           System.debug('The email failed to send: ' + results[0].errors[0].message); 
                        }else{
                           System.debug('The email failed to send ');  
                        }
                        
                    }
                            
                    }catch(Exception e){
                        System.debug('email exception ' + e.getMessage());
                    }
        } 

    /**
    * Sends an email notification based on an event log
    * @param eventLog event log sObejct        
    */    
    public static void sendLogInterfaceMail(CRAN_VAS_KER_EventLog__c eventLog) {
        
        List<String> toAddresses = new List<String>();
        String logMessage = '';

        // If the outbound email limit is reached, throws an exception
        if (Limits.getEmailInvocations() == Limits.getLimitEmailInvocations())
            throw new EmailHelperException('The email limit has been reached. Interface email notification has not been sent.');
        
        // If there is not email address to send the email to, throws an exception
        if (customSettingsEmail.isEmpty())
            throw new EmailHelperException('Custom setting CRAN_VAS_KER_InterfaceEmailNotification__c empty and/or BP E-mail not found.');
        
        // If there is not org wide email address, throws an exception
        if (owea.isEmpty())
            throw new EmailHelperException('Org-Wide Address display name Interface_Email has not been found.');

        for (CRAN_VAS_KER_InterfaceEmailNotification__c customSetting : customSettingsEmail)
            toAddresses.add(customSetting.CRAN_VAS_KER_T_EmailTo__c);

        // Sets the notification detail
        Map<String, Schema.SObjectField> fields = CRAN_VAS_KER_EventLog__c.sObjectType.getDescribe().fields.getMap();
        
        logMessage =    fields.get('CRAN_VAS_KER_T_Source__c').getDescribe().getLabel()     + ': ' + eventLog.CRAN_VAS_KER_T_Source__c + '\n' +
                        fields.get('RecordTypeId').getDescribe().getLabel()                 + ': ' +  CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeLabelById('CRAN_VAS_KER_EventLog__c', eventLog.RecordTypeId) + '\n' +
                        fields.get('CreatedDate').getDescribe().getLabel()                  + ': ' + eventLog.CreatedDate + '\n' +
                        fields.get('CreatedById').getDescribe().getLabel()                  + ': ' + eventLog.CreatedById  + ' ( ' + UserInfo.getUserName() + ' )\n' +
                        fields.get('CRAN_VAS_KER_N_Failures__c').getDescribe().getLabel()   + ': ' + eventLog.CRAN_VAS_KER_N_Failures__c + '\n' +
                        fields.get('CRAN_VAS_KER_N_Successes__c').getDescribe().getLabel()  + ': ' + eventLog.CRAN_VAS_KER_N_Successes__c + '\n' +
                        'URL : ' + URL.getSalesforceBaseUrl().toExternalForm()              + '/'  + eventLog.Id;                
                     
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        message.setOrgWideEmailAddressId(owea[0].Id); 
        message.setSubject(Label.CRAN_VAS_KER_InterfaceEmailSubject);
        message.setPlainTextBody(logMessage);
        message.setToAddresses(toAddresses);
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { message });

        // If an error occurred when sending the email, throws an exception
        if (!results[0].success)
            throw new EmailHelperException('The email failed to send: ' + results[0].errors[0].message);        
       
    }               
    
}