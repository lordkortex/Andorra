public class CRAS_ICA_ASS_HTTPRequestProvider_CLS implements CRAN_VAS_KER_DatatableProvider_CLS {
    
    public List<List<CRAN_ICA_KER_JoinListViewProvider_CLS.AuraFieldModel>> getRecordsSObject(Map<String, Object> params, Integer rpp, Integer offset) {
        
        String 		sObjectName			= (String)params.get('sObjectApiName');        
        String 		recordId 			= (String)params.get('recordId');  
        String 		strFieldApiNames	= 'CRAS_ICA_ASS_T_Name__c,CRAS_ICA_ASS_C_CapitalAsegurado__c,CRAS_ICA_ASS_PE_Descuento__c,CRAS_ICA_ASS_C_ImporteDescuento__c,CRAS_ICA_ASS_PE_Sobreprima__c,CRAS_ICA_ASS_C_ImporteSobreprima__c,CRAS_ICA_ASS_C_PrimaAnual__c';
        
        List<String> fieldNames = CRAN_VAS_KER_LCUtil_CLS.getStringAsList(strFieldApiNames);
        return getRelatedList(sObjectName, recordId, fieldNames);
    }
    
    public String getRecords(Map<String, Object> params) {
        return JSON.serialize(getRecords(params, -1, -1));
    }
    
    public String getRecords(Map<String, Object> params, Integer rpp, Integer offset) {
        return JSON.serialize(getRecords(params, rpp, offset));
    }
    
    public static List<List<CRAN_ICA_KER_JoinListViewProvider_CLS.AuraFieldModel>> getRelatedList(String objName, String recordId, List<String> fieldNames) 
    {
        Set<String> fieldNamesSet = new Set<String>();
        fieldNamesSet.addAll(fieldNames);
        
        Schema.DescribeSobjectResult[] results = Schema.describeSObjects(new String[]{objName});
        
        if (results.size() > 0)
        {
            Schema.DescribeSobjectResult obj = results[0];
            Map<String, Schema.SObjectField> objFields = obj.fields.getMap();
            
            fieldNames.clear();
            for (String field: fieldNamesSet)
            {
                String fType = String.valueOf(objFields.get(field).getDescribe().getType());
                System.debug(fType);
                if (fType == 'PICKLIST'){
                    field = 'toLabel(' + field + ')';
                }
                else if (fType == 'DATE' || fType == 'CURRENCY' || fType == 'DATETIME' || fType == 'NUMBER'){
                    field = 'FORMAT(' + field + ')';
                }
                fieldNames.add(field);
            }
            
            List<List<CRAN_ICA_KER_JoinListViewProvider_CLS.AuraFieldModel>> records = new List<List<CRAN_ICA_KER_JoinListViewProvider_CLS.AuraFieldModel>>();
            
            List<FinServ__FinancialHolding__c> fhList = CRAS_ICA_ASS_CallFHGuar_CLS.callAxis(recordId);
            
            for (sObject record : fhList) 
            {
                Map<String, Object> fieldsToValue = record.getPopulatedFieldsAsMap();
                List<CRAN_ICA_KER_JoinListViewProvider_CLS.AuraFieldModel> fields = new List<CRAN_ICA_KER_JoinListViewProvider_CLS.AuraFieldModel>();
                
                for (String fieldName : fieldsToValue.keySet())
                {
                    CRAN_ICA_KER_JoinListViewProvider_CLS.AuraFieldModel fm = new CRAN_ICA_KER_JoinListViewProvider_CLS.AuraFieldModel();
                    
                    fm.value 			= String.valueOf(fieldsToValue.get(fieldName));
                    fm.label 			= objFields.get(fieldName).getDescribe().getLabel();
                    fm.apiName 		= objFields.get(fieldName).getDescribe().getName();
                    fm.fieldType		= String.valueOf(objFields.get(fieldName).getDescribe().getType());
                    
                    fields.add(fm);                   
                }
                
                records.add(fields);
            }
            return records; 
        }
        
        return null; 
        
    }
}