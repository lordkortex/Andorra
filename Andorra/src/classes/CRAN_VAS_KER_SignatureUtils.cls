/**
* Util class to aid during a DocuSign ceremony
* 
* @author Zuinglio Lopes Ribeiro Júnior
* @version 1.0
*/
public with sharing class CRAN_VAS_KER_SignatureUtils {
    
    /** DocuSign Advanced signature provider */
   	public final static String SBS_PROVIDER_NAME = 'UniversalSignaturePen_OpenTrust_Hash_TSP';

    /** DocuSign  callback events */    
    public final static List<String> DOCUSIGN_EVENTS = new List<String> { 'delivered', 'completed', 'sent', 'declined' }; 

    /** DocuSign supported languages */
	private final static Set<String> DOCUSIGN_LANGUAGES = new Set<String> {'ar', 'id', 'ms', 'bg', 'cs', 'zh_CN', 'zh_TW', 'hr', 'da', 'nl', 'en', 'en_GB', 'et', 'fa', 'fi', 'fr', 'fr_CA', 'de', 'el', 'he', 'hi', 'hu', 'it', 'ja', 'ko', 'lv', 'lt', 'no', 'pl', 'pt', 'pt_BR', 'ro', 'ru', 'sr', 'sk', 'sl', 'es', 'es_MX', 'sv', 'th', 'tr', 'uk', 'vi'};    
    
    /**
    * Method that validates a phone number format 
    * @param mobilePhone phone number
    * @param userName user name
    * @return formatted phone number
    */    
    public static String buildString4Phones(String mobilePhone, String userName) {
        
        if (String.isBlank(mobilePhone)) {
            throw new CRAN_VAS_KER_SignatureException(String.format(Label.CRAN_VAS_KER_SignerPhoneNumberIsBlank,
                                                                    new String[] {
                                                                        userName
                                                                            }));
        }
        
        if (!mobilePhone.contains('+'))
            mobilePhone = '+' + mobilePhone.replaceAll('(\\s+)', '');		
        
        return mobilePhone;		
    }
    
    /**
    * Formats a date and time to ICA's standard
    * @param fecha date and time to be formatted
    * @return formatted date and time string
    */     
    public static String formatToICAStandard(Datetime fecha) {
        return fecha.format('YYYYMMdd hh:mm:ss', UserInfo.getTimeZone().getID());
    }
    
    /**
    * Builds a XML file in Archive format
    * @param metadata metadata response sObject
    * @param signInfo eletronic signature sObject
    * @return metadata xml in Archive format
    */    
    public static String buildArchivalXMLFromMetadata(CRAN_VAS_KER_MetadataResponse metadata, CRAN_VAS_KER_ESignature__c signInfo) {

        ArchiveXMLFormat archiveXmlFormat = new ArchiveXMLFormat();
        archiveXmlFormat.buId = signInfo.CRAN_VAS_KER_BU_Id__c;
        archiveXmlFormat.bpId = signInfo.CRAN_VAS_KER_BP_Id__c;
        archiveXmlFormat.personId = signInfo.CRAN_VAS_KER_Person_Id__c;
        archiveXmlFormat.personName = signInfo.CRAN_VAS_KER_Client_Name__c;
        archiveXmlFormat.documentId = signInfo.CRAN_VAS_KER_Core_Id__c;
        archiveXmlFormat.metaTypeId = metadata.orderList.order.metadaTypeId;
        archiveXmlFormat.metaTypeName = metadata.orderList.order.metadaTypeName;
        archiveXmlFormat.orderType = 'SF';
        archiveXmlFormat.orderNumber = signInfo.CRAN_VAS_KER_Core_Id__c;
        archiveXmlFormat.referenceLine = signInfo.CRAN_VAS_KER_Reference_Line__c;
        archiveXmlFormat.createTime = metadata.orderList.order.timeStampCreate;
        archiveXmlFormat.expiryTime = metadata.orderList.order.timeStampExpiry;
        archiveXmlFormat.source = metadata.orderList.order.source;
        archiveXmlFormat.langId = metadata.orderList.order.langId;
        archiveXmlFormat.langName = metadata.orderList.order.langName;
        archiveXmlFormat.mailActionId = metadata.orderList.order.mailActionId;
        archiveXmlFormat.mailAction = metadata.orderList.order.mailAction;
        archiveXmlFormat.mailId = metadata.orderList.order.mailId;
        archiveXmlFormat.mailType = metadata.orderList.order.mailType;
        archiveXmlFormat.mail = metadata.orderList.order.mail;

        return buildArchivalXMLFromMetadata(archiveXmlFormat);

    }

    /**
    * Builds a XML file in Archive format
    * @param contract contract sObject
    * @param signInfo eletronic signature sObject
    * @return metadata xml in Archive format
    */    
    public static String buildArchivalXMLFromMetadata(Contract contract, CRAN_VAS_KER_ESignature__c signInfo) {

        String lang = contract.CRAN_VAS_KER_Account_Language__c;
        String longFormLang = 'English';
        
        if (lang == 'es') {
            longFormLang = 'Spanish';
        } else if (lang == 'ca') {
            longFormLang = 'Catalan';
        } else if (lang == 'fr') {
            longFormLang = 'French'; 
        } else {
            if (CRAN_VAS_KER_EventLogHelper_CLS.getInstance().isDebugEnabled())
                System.debug('Unexpected language - Defaulting to English');
            lang = 'en';
        }        

        ArchiveXMLFormat archiveXmlFormat = new ArchiveXMLFormat();
        archiveXmlFormat.buId = contract.CRAN_VAS_KER_BP__r.CRAN_VEC_ADV_P_Bunit__c;
        archiveXmlFormat.bpId = contract.CRAN_VAS_KER_BP__r.CRAN_VEC_ADV_N_Number__c;
        archiveXmlFormat.personId = contract.CRAN_VAS_KER_Person_Id__c;
        archiveXmlFormat.personName = contract.CRAN_VAS_KER_Client_Name__c;
        archiveXmlFormat.documentId = signInfo.CRAN_VAS_KER_Core_Id__c;
        archiveXmlFormat.metaTypeId = 'DOCM';
        archiveXmlFormat.metaTypeName = 'Document SF';
        archiveXmlFormat.orderType = 'SF';
        archiveXmlFormat.orderNumber = signInfo.CRAN_VAS_KER_Core_Id__c;
        archiveXmlFormat.referenceLine = signInfo.CRAN_VAS_KER_Reference_Line__c;
        archiveXmlFormat.createTime = formatToICAStandard(System.now());
        archiveXmlFormat.expiryTime = formatToICAStandard(System.now().addDays(1));
        archiveXmlFormat.source = CRAN_VAS_KER_SignatureBus__c.getOrgDefaults().ArchivalSource__c;
        archiveXmlFormat.langId = lang;
        archiveXmlFormat.langName = longFormLang;
        archiveXmlFormat.mailActionId = 'HOLD_MAIL';
        archiveXmlFormat.mailAction = 'Hold Mail';
        archiveXmlFormat.mailId = 'AdvisoryContractSFC';
        archiveXmlFormat.mailType = 'adv';
        archiveXmlFormat.mail = 'AdvisoryContractSFC';

        return buildArchivalXMLFromMetadata(archiveXmlFormat);

    }    

    /**
    * Builds a XML file in Archive format
    * @param archiveXmlFormat archive xml file object
    * @return metadata xml in Archive format
    */    
    public static String buildArchivalXMLFromMetadata(ArchiveXMLFormat archiveXmlFormat) {
        
        String xml = '<?xml version="1.0" encoding="ISO-8859-1"?>'+
                     '<mailing>'+
                        '<header>' +
                                '<bu id="' + archiveXmlFormat.buId + '"/>' + 
                                '<bp id="' + archiveXmlFormat.bpId + '"/>' +
                                '<pers id="' + archiveXmlFormat.personId + '">' +
                                        '<name>' + archiveXmlFormat.personName + '</name>' +
                                '</pers>' +
                                '<doc id="' + archiveXmlFormat.documentId + '">'+
                                        '<metaTyp id="' + archiveXmlFormat.metaTypeId + '">'
                                             + archiveXmlFormat.metaTypeName +
                                        '</metaTyp>' +
                                        '<orderType>' + archiveXmlFormat.orderType + '</orderType>' +
                                        '<orderNr>' + archiveXmlFormat.orderNumber + '</orderNr>' +
                                        '<reference>' +
                                            '<line>' + archiveXmlFormat.referenceLine + '</line>' +
                                        '</reference>' +
                                 '</doc>' +
                        '</header>' +
                        '<metadata>' +
                                '<timeStampCreate>' + archiveXmlFormat.createTime + '</timeStampCreate>' +
                                '<timeStampExpiry>' + archiveXmlFormat.expiryTime + '</timeStampExpiry>' +
                                '<source>' + archiveXmlFormat.source + ' </source>' +
                                '<lang id="' + archiveXmlFormat.langId + '">' + archiveXmlFormat.langName + '</lang>' +
                                '<mailAction id="' + archiveXmlFormat.mailActionId + '">' + archiveXmlFormat.mailAction  + '</mailAction>' + 
                                '<mail id="' + archiveXmlFormat.mailId  + '" type="' + archiveXmlFormat.mailType + '">' +  archiveXmlFormat.mail + '</mail>' +
                        '</metadata>' +
                    '</mailing>';

        if (CRAN_VAS_KER_EventLogHelper_CLS.getInstance().isDebugEnabled()) {
            System.debug('XML TO ARCHIVE');
            System.debug(xml);
        }
        
        return EncodingUtil.convertToHex(Blob.valueOf(xml));			  
    }    
    
    /**
    * Gets a map of phone numbers by user's name
    * @param recId record id sObject
    * @return map of phone numbers
    */    
    public static Map<String, String> getMobilePhoneInfo(Id recId) {
        return getMobilePhoneInfo(recId, false);
    }   
    
    /**
    * Gets a map of phone numbers by user's name
    * @param recId record id 
    * @param hasOrder true if it's returning phone numbers for an Order  
    * @return map of phone numbers
    */         
    public static Map<String, String> getMobilePhoneInfo(Id recId, Boolean hasOrder) {

        Map<String, String> phones = new Map<String, String>();        
        
        try {
            
            if (recId.getSobjectType() == Contract.sObjectType) {
                
                Contract contract = [SELECT Account.FinServ__PrimaryContact__r.MobilePhone,
                                     Account.FinServ__PrimaryContact__r.Name,
                                     Account.FinServ__PrimaryContact__r.Email,
                                     Account.FinServ__PrimaryContact__r.CRAN_VEC_ADV_P_Language__c,
                                     CRAN_VAS_KER_Signer2__r.MobilePhone,
                                     CRAN_VAS_KER_Signer2__r.Name,
                                     CRAN_VAS_KER_Signer3__r.MobilePhone,
                                     CRAN_VAS_KER_Signer3__r.Name,
                                     Status
                                     FROM Contract
                                     WHERE Id =: recId];
                
                if (String.isBlank(contract.Account.FinServ__PrimaryContact__r.Email) || 
                    String.isBlank(contract.Account.FinServ__PrimaryContact__r.CRAN_VEC_ADV_P_Language__c))
                    throw new CRAN_VAS_KER_SignatureException(String.format(Label.CRAN_VAS_KER_NameOrEmailOrLanguageIsBlank,
                                                                            new String[] {
                                                                                contract.Account.FinServ__PrimaryContact__r.Name
                                                                                    }));
                
                if (contract.Status == 'Signed')
                    throw new CRAN_VAS_KER_SignatureException(Label.CRAN_VAS_KER_ContractAlreadySigned);
                
                String mobilePhone = buildString4Phones(contract.Account.FinServ__PrimaryContact__r.MobilePhone, contract.Account.FinServ__PrimaryContact__r.Name);
                phones.put('#1 ' + Label.CRAN_VAS_KER_Signer + contract.Account.FinServ__PrimaryContact__r.Name, mobilePhone);
                
                mobilePhone = buildString4Phones(contract.CRAN_VAS_KER_Signer2__r.MobilePhone, contract.CRAN_VAS_KER_Signer2__r.Name);
                phones.put('#2 ' + Label.CRAN_VAS_KER_Signer + contract.CRAN_VAS_KER_Signer2__r.Name, mobilePhone);  
                
                mobilePhone = buildString4Phones(contract.CRAN_VAS_KER_Signer3__r.MobilePhone, contract.CRAN_VAS_KER_Signer3__r.Name);
                phones.put('#3 ' + Label.CRAN_VAS_KER_Signer + contract.CRAN_VAS_KER_Signer3__r.Name, mobilePhone);                    
                
            } else if (recId.getSobjectType() == CRAN_VEC_ADV_CustomForm_Response__c.sObjectType) {
                
                CRAN_VEC_ADV_CustomForm_Response__c customForm = [SELECT CRAN_VEC_ADV_L_Contact__r.Name,                                                            
                                                                  CRAN_VEC_ADV_L_Contact__r.MobilePhone,
                                                                  CRAN_VEC_ADV_L_Contact__r.Email,
                                                                  CRAN_VEC_ADV_L_Contact__r.CRAN_VEC_ADV_P_Language__c
                                                                  FROM CRAN_VEC_ADV_CustomForm_Response__c
                                                                  WHERE Id =: recId];
                
                if (String.isBlank(customForm.CRAN_VEC_ADV_L_Contact__r.Email) || 
                    String.isBlank(customForm.CRAN_VEC_ADV_L_Contact__r.CRAN_VEC_ADV_P_Language__c))
                    throw new CRAN_VAS_KER_SignatureException(String.format(Label.CRAN_VAS_KER_NameOrEmailOrLanguageIsBlank,
                                                                            new String[] {
                                                                                customForm.CRAN_VEC_ADV_L_Contact__r.Name
                                                                                    }));
                
                
                String mobilePhone = buildString4Phones(customForm.CRAN_VEC_ADV_L_Contact__r.MobilePhone, customForm.CRAN_VEC_ADV_L_Contact__r.Name);
                phones.put('#1 ' + Label.CRAN_VAS_KER_Signer + customForm.CRAN_VEC_ADV_L_Contact__r.Name, mobilePhone); 
                
            } else {
                
                Opportunity opp = [ SELECT  Id,
                                   CRAN_VEC_ADV_F_ValidPerson__c,
                                   CRAN_VEC_ADV_L_PersonId__r.MobilePhone,
                                   CRAN_VEC_ADV_L_PersonId__r.Name,
                                   CRAN_VEC_ADV_L_PersonId__r.Email,
                                   CRAN_VEC_ADV_L_PersonId__r.CRAN_VEC_ADV_P_Language__c,
                                   StageName
                                   FROM    Opportunity
                                   WHERE   Id=: recId];

                if (hasOrder) {

                    List<Order> listOrdersToSendSimulated = [   SELECT  Id
                                                                FROM    Order 
                                                                WHERE   OpportunityId =: recId 
                                                                AND     CRAN_VEC_ADV_B_Execute__c = TRUE 
                                                                AND     CRAN_VEC_ADV_F_isEdit__c = TRUE 
                                                                AND     CRAN_VEC_ADV_B_Signed__c = FALSE 
                                                                LIMIT 1];

                    if (listOrdersToSendSimulated.isEmpty())
                        throw new CRAN_VAS_KER_SignatureException(Label.CRAN_VEC_ADV_IP_MSG_ERR_Exec_Num);
                        
                } else {

                    if (opp.StageName != 'advSimulated' && opp.StageName != 'advToSign')
                        throw new CRAN_VAS_KER_SignatureException(Label.CRAN_VAS_KER_OpportunityInvalidStage);                    
                }
                
                if (!opp.CRAN_VEC_ADV_F_ValidPerson__c)
                    throw new CRAN_VAS_KER_SignatureException(Label.CRAN_VEC_ADV_IP_MSG_NoContactToFirm); 
                
                if (String.isBlank(opp.CRAN_VEC_ADV_L_PersonId__r.Email) || 
                    String.isBlank(opp.CRAN_VEC_ADV_L_PersonId__r.CRAN_VEC_ADV_P_Language__c))
                    throw new CRAN_VAS_KER_SignatureException(String.format(Label.CRAN_VAS_KER_NameOrEmailOrLanguageIsBlank,
                                                                            new String[] {
                                                                                opp.CRAN_VEC_ADV_L_PersonId__r.Name
                                                                                    }));
                
                String mobilePhone = buildString4Phones(opp.CRAN_VEC_ADV_L_PersonId__r.MobilePhone, opp.CRAN_VEC_ADV_L_PersonId__r.Name);
                phones.put('#1 ' + Label.CRAN_VAS_KER_Signer + opp.CRAN_VEC_ADV_L_PersonId__r.Name, mobilePhone);                      
                
            }
            
        } catch (Exception ex) {
            AuraHandledException e = new AuraHandledException(ex.getMessage());
            e.setMessage(ex.getMessage());
            system.debug(ex.getMessage());
            system.debug(ex.getLineNumber());
            system.debug(ex.getStackTraceString());
            throw e;            
        }
        
        return phones;
    }
    
    /**
    * Normalizes a langague key to a format supported by DocuSign
    * @param languageKey language key to be normalized
    * @return language key supported by DocuSign
    */             
   public static String getDocusignLanguage(String languageKey) {

        Boolean validLanguage = false;

        // Workaround to set Catalan as Spanish since
        // DocuSign does not support Catalan
        if (languageKey == 'ca')
            languageKey = 'es';
        
        if (String.isNotBlank(languageKey)) {
            
            if (DOCUSIGN_LANGUAGES.contains(languageKey)) {
                validLanguage = true;
            } else {
                
                languageKey = languageKey.substring(0, 2);
                if (DOCUSIGN_LANGUAGES.contains(languageKey))
                    validLanguage = true;
            }
        }
        
        if (!validLanguage) {
            return 'en';
        } else {
            return languageKey;
        }       
    }

    /**
    * Gets a translated label based on a language key
    * @param label to get the translation for
    * @param languageKey language key that determines the language
    * @return translated label 
    */ 
    public static String getTranslatedLabel(String label, String languageKey) {
        String translatedLabel = CRAN_VAS_KER_LabelTranslatorHelper_CLS.getInstance().translate(label, getDocusignLanguage(languageKey));
        return String.format(translatedLabel, new String[] { UserInfo.getName() });
    }

    /**
    * Class to struct an object in Archive XML format
    */ 
    private class ArchiveXMLFormat {
        public String buId;
        public String bpId;
        public String personId;
        public String personName;
        public String documentId;
        public String metaTypeId;
        public String metaTypeName;
        public String orderType;
        public String orderNumber;
        public String referenceLine;
        public String createTime;
        public String expiryTime;
        public String source;
        public String langId;
        public String langName;
        public String mailActionId;
        public String mailAction;
        public String mailId;
        public String mailType;
        public String mail;

    }       
}