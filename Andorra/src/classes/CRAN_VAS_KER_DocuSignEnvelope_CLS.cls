public with sharing class CRAN_VAS_KER_DocuSignEnvelope_CLS {
    
    public String brandId;
    public String brandLock;
    public CustomFields customFields;
    public List<CompositeTemplate> compositeTemplates;	
    public List<Document> documents;
    public String emailSubject;
    public EventNotification eventNotification;
    public Recipients recipients;
    public String status;
    
    public class CompositeTemplate {
        
        public List<InlineTemplate> inlineTemplates;
        public List<ServerTemplate> serverTemplates;
        
    }
    
    public class CustomFields {
        
        public List<TextCustomField> textCustomFields;
        
    }
    
    public class Document {
        
        public String documentBase64;
        public String documentId;
        public String fileExtension;
        public String name;
        
    }	
    
    public class EnvelopeEvent {
        
        public String envelopeEventStatusCode;
        public String includeDocuments;
        
    }	
    
    public class EventNotification {
        
        public List<EnvelopeEvent> envelopeEvents;
        public List<RecipientEvent> recipientEvents;
        
    }
    
    public class InPersonSigner {
        
        public String clientUserId;
        public RecipientEmailNotification emailNotification;
        public String embeddedRecipientStartURL;
        public String hostEmail;
        public String hostName;
        public String idCheckConfigurationName;
        public String recipientId;
        public List<RecipientSignatureProvider> recipientSignatureProviders;
        public String requireIdLookup;
        public String roleName;
        public String routingOrder;
        public String signerEmail;
        public String signerName;
        public RecipientSMSAuthentication smsAuthentication;
        public Tabs tabs;
        
    } 	
    
    public class InlineTemplate {
        
        public CustomFields customFields;
        public Recipients recipients;
        public String sequence;
    }
    
    public class RecipientEmailNotification {
        
        public String emailBody;
        public String emailSubject;
        public String supportedLanguage;
        
    }
    
    public class RecipientEvent {
        
        public String includeDocuments;
        public String recipientEventStatusCode;
    }
    
    public class RecipientSMSAuthentication {
        
        public List<String> senderProvidedNumbers;
        
    }	
    
    public class RecipientSignatureProvider {
        
        public String signatureProviderName;
        public RecipientSignatureProviderOptions signatureProviderOptions;
        
    }
    
    public class RecipientSignatureProviderOptions {
        
        public String oneTimePassword;
        public String sms;
        
    }
    
    public class Recipients {
        
        public String currentRoutingOrder;
        public List<InPersonSigner> inPersonSigners;
        public String recipientCount;
        public List<Signer> signers;
        
    }	
    
    public class ServerTemplate {
        
        public String sequence;
        public String templateId;
        
    } 
    
    public class Signer {
        
        public String clientUserId;
        public String email;
        public RecipientEmailNotification emailNotification;
        public String embeddedRecipientStartURL;
        public String idCheckConfigurationName;        
        public String name;
        public String recipientId;
        public List<RecipientSignatureProvider> recipientSignatureProviders;
        public String requireIdLookup;
        public String roleName;
        public String routingOrder;
        public RecipientSMSAuthentication smsAuthentication;
        public String status;
        
    }   
    
    public class SignHere {
        
        public String anchorIgnoreIfNotPresent;
        public String anchorString;
        public String anchorUnits;
        public String anchorXOffset;
        public String anchorYOffset;
        
    }	
    
    public class Tabs {
        
        public List<SignHere> signHereTabs;
        public List<SignHere> dateSignedTabs;
        public List<SignHere> fullNameTabs;
        
    }
    
    public class TextCustomField {
        
        public String fieldId;
        public String name;
        public String required;
        public String show;
        public String value;
        
    }	
    
}