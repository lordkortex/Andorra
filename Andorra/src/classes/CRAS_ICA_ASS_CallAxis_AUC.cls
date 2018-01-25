public with sharing class CRAS_ICA_ASS_CallAxis_AUC {
    
    @AuraEnabled
    public static List<CRAS_ICA_ASS_ClaimDetails_OBJ> callAxis(Id claimsId){
        //Variables
        CRAS_ICA_ASS_JSONClaimSend_OBJ wrapINT = new CRAS_ICA_ASS_JSONClaimSend_OBJ();
        CRAS_ICA_ASS_InsuranceGlobal_CS__c myCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
        Http http = new Http();
        
        List<CRAS_ICA_ASS_ClaimAmountHistory__c> claim = 
            [Select CRAS_ICA_ASS_N_Year__c, CRAS_ICA_ASS_L_Role__r.CRAS_ICA_ASS_T_AxisFARoleID__c 
             FROM CRAS_ICA_ASS_ClaimAmountHistory__c 
             WHERE Id = :claimsId];
        
        if(claim.size() != 0)
        {
            Blob privateKeyBlob = Blob.valueOf(
                Test.isRunningTest() ? '00000000000000000000000000000000' : myCS.CRAS_ICA_ASS_T_PrivateKeyAxis__c
            );
            
            wrapINT.accountNumber = claim[0].CRAS_ICA_ASS_L_Role__r.CRAS_ICA_ASS_T_AxisFARoleID__c;
            wrapINT.beginDate = (Integer)claim[0].CRAS_ICA_ASS_N_Year__c;
            String jsonBody = json.serialize(wrapINT);
            
            Blob data = Blob.valueOf(jsonBody);
            
            Blob encrypted = Crypto.encryptWithManagedIV('AES256', privateKeyBlob, data);
            String encryptedStringBase64 = EncodingUtil.base64Encode(encrypted);
            
            Map<String, String> encryptedMessage = new Map<String, String>{'encrypted' => encryptedStringBase64};
            String jsonBodyHTTP = json.serialize(encryptedMessage);
            
            HttpRequest req = new HttpRequest();
            req.setHeader('Content-Type','application/json');
            req.setHeader('X-DPE-Origin', 'Salesforce');
            
            req.setClientCertificateName(
                Test.isRunningTest() ? 'salesforceclient' : myCS.CRAS_ICA_ASS_CertificadoAxis__c
            );
            req.setEndpoint(
                Test.isRunningTest() ? 'https://www.salesforce.com' : myCS.CRAS_ICA_ASS_URL_UrlAxis__c
            );
            
            req.setMethod('POST');
            req.setBody(jsonBodyHTTP);
            
            HttpResponse res = http.send(req);
            
            if(res.getStatusCode() == 200)
            {
                Map<String, Object> results = (Map<String, Object>) json.deserializeUntyped(res.getBody());
                Blob decrypted = Crypto.decryptWithManagedIV('AES256', privateKeyBlob, EncodingUtil.base64Decode((String)results.get('encrypted')));
                CRAS_ICA_ASS_ResponseJSONClaims_OBJ response = (CRAS_ICA_ASS_ResponseJSONClaims_OBJ) json.deserialize(decrypted.toString(), CRAS_ICA_ASS_ResponseJSONClaims_OBJ.class);
                
                return response.Claims; 
            }
            
            return new List<CRAS_ICA_ASS_ClaimDetails_OBJ>();
        }
        else
        {
            return new List<CRAS_ICA_ASS_ClaimDetails_OBJ>();
        }
        
    }
}