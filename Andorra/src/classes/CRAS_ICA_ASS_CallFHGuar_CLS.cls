public class CRAS_ICA_ASS_CallFHGuar_CLS {

    public static List<FinServ__FinancialHolding__c> callAxis(String sseguro){
        //Variables;
        CRAS_ICA_ASS_InsuranceGlobal_CS__c myCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
        Http http = new Http();
        
        if(string.isNotBlank(sseguro))
        {
            Blob privateKeyBlob = Blob.valueOf(
                Test.isRunningTest() ? '00000000000000000000000000000000' : myCS.CRAS_ICA_ASS_T_PrivateKeyAxis__c
            );

            String jsonBody = json.serialize(new Map<String, String>{'sseguro' => sseguro});
            
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
                Test.isRunningTest() ? 'https://www.salesforce.com' : myCS.CRAS_ICA_ASS_URL_UrlAxisFH__c
            );
            
            req.setMethod('POST');
            req.setBody(jsonBodyHTTP);
            
            HttpResponse res = http.send(req);
            
            if(res.getStatusCode() == 200)
            {
                Map<String, Object> results = (Map<String, Object>) json.deserializeUntyped(res.getBody());
                Blob decrypted = Crypto.decryptWithManagedIV('AES256', privateKeyBlob, EncodingUtil.base64Decode((String)results.get('encrypted')));
                CRAS_ICA_ASS_ResponseJSONFH_OBJ response = (CRAS_ICA_ASS_ResponseJSONFH_OBJ) json.deserialize(decrypted.toString(), CRAS_ICA_ASS_ResponseJSONFH_OBJ.class);
                
                return response.financialHoldings; 
            }
            
            return new List<FinServ__FinancialHolding__c>();
        }
        else
        {
            return new List<FinServ__FinancialHolding__c>();
        }
        
    }
    
    public class CRAS_ICA_ASS_ResponseJSONFH_OBJ {
        public List<FinServ__FinancialHolding__c> financialHoldings;
    }

}