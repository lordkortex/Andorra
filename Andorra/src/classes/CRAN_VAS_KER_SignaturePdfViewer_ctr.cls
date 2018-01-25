public class CRAN_VAS_KER_SignaturePdfViewer_ctr 
{
    @AuraEnabled
    public static List<CRAN_VAS_KER_ESignature__c> getSignatures (Id recordId) {  

        List<CRAN_VAS_KER_ESignature__c> lstSignatures = [SELECT 	CRAN_VAS_KER_Account__c,
                                                          			CRAN_VAS_KER_Client__c, 
                                                                    CRAN_VAS_KER_Archive_Date__c,
                                                                    CRAN_VAS_KER_BP_Id__c,                                                                    
                                                                    CRAN_VAS_KER_File_Name__c,
                                                                    CRAN_VAS_KER_Reference_Line__c,
                                                          			CRAN_VAS_KER_Core_Id__c,
                                                          			CRAN_VAS_KER_Contract__c,
                                                          			CRAN_VAS_KER_Signature_Type__c,
                                                                    Name 
                                                          FROM CRAN_VAS_KER_ESignature__c 
                                                          WHERE CRAN_VAS_KER_Status__c = 'Sent to Archive' 
                                                          AND (CRAN_VAS_KER_Account__c=: recordId 
                                                          OR CRAN_VAS_KER_Client__c =: recordId 
                                                          OR CRAN_VAS_KER_Contract__c =: recordId 
                                                          OR CRAN_VAS_KER_Opportunity__c =:recordId
                                                          OR CRAN_VAS_KER_Order__c = :recordId)
                                                          ORDER BY CRAN_VAS_KER_Archive_Date__c DESC];

        return lstSignatures;
    }
       
}