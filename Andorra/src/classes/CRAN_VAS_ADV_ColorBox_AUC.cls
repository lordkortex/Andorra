public without sharing class CRAN_VAS_ADV_ColorBox_AUC {
    
    public static final String CURRENCY_ISO_CODE = 'CurrencyIsoCode';
    
    @AuraEnabled  
    public static Map<String,Object> getObjectInfo(String recordId, String fieldNames) {        

        //Caso especial if (BP Type == Managed Portfolio) then Risk Profile = CRAN_ICA_ADV_P_RiskProfileAccountManaged__c
		Map<String,Object> mapRiskProfileAccountManaged = getRiskProfileAccountManaged(recordId, fieldNames);
        if (mapRiskProfileAccountManaged != null){return mapRiskProfileAccountManaged;}
		//Fin caso especial        

        Id castedRecordId = (Id) recordId;
        fieldNames = fieldNames + ','+CURRENCY_ISO_CODE;
        String objectName = castedRecordId.getSobjectType().getDescribe().getName();
        String query = String.format('SELECT {0} FROM {1} WHERE Id =: recordId LIMIT 1', 
                                     new String[]{ fieldNames,objectName});
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(objectName).getDescribe().fields.getMap(); 
        Map<String,Object> fieldNamesByAPIName = new Map<String,Object>();
        sObject queryResult = (sObject) Database.query(query);
        
        
        for (String fieldAPIName:fieldNames.split(',')) {   
            try {
                getValue(queryResult, fieldAPIName, fieldNamesByAPIName);
            } catch(Exception ex){
                system.debug(ex.getMessage());
            }
        }
        
        return fieldNamesByAPIName;  
    }    
    


    
    public static void getValue(sObject queryResult, String path, Map<String,Object> fieldNamesByAPIName) {
        List<String> paths = new List<String>();                
        
        if (path.contains('.')) {
            paths = path.split('\\.');
        } else {            
            paths.add(path);
        }
        
        Object value;
        sObject relativeSObject = queryResult;        
        
        for (Integer i = 0; i < paths.size(); i++) {
            
            if (paths[i].contains('__r')) {
                relativeSObject = queryResult.getSObject(paths[i]);
            } else {
                Schema.DescribeSObjectResult describeSObjectResult = relativeSObject.getSObjectType().getDescribe();  
                Map<String, Schema.SObjectField> fieldMap = describeSObjectResult.fields.getMap(); 
                DescribeFieldResult describeResult = fieldMap.get(paths[i]).getDescribe();     
                Schema.DisplayType displayType = describeResult.getType();                
                
                if (displayType == Schema.DisplayType.BOOLEAN) {
                    Boolean bool = (Boolean)relativeSObject.get(paths[i]);
                    value = bool ? Label.CRAN_VAS_ADV_CF_LBL_Yes:Label.CRAN_VAS_ADV_CF_LBL_No;
                } else if (displayType == Schema.DisplayType.CURRENCY){
                    String currencyCode = (String) relativeSObject.get(CURRENCY_ISO_CODE);   
                    value = relativeSObject.get(paths[i]) ==  null ? '-' : currencyCode + ' ' +  Decimal.valueOf(String.valueOf(relativeSObject.get(paths[i]))).format();
                } 
                else if (displayType == Schema.DisplayType.PICKLIST) {
                    value = getPickListValue(describeResult, relativeSObject.get(paths[i]));
                } 
                else {
                    value = relativeSObject.get(paths[i]) ==  null ? '-' : relativeSObject.get(paths[i]);
                }
                
                String labelStr = describeResult.getLabel();
                if (paths[i] == CURRENCY_ISO_CODE){                    
                    labelStr = paths[i];
                    value = (String) relativeSObject.get(CURRENCY_ISO_CODE);
                }
                
                fieldNamesByAPIName.put(labelStr, value);  
            }
        }              
    }
    
    private static Object getPicklistValue(DescribeFieldResult describeResult, Object originalValue){
        Object value = originalValue ==  null ? '-' : originalValue;        
        
        List<Schema.PicklistEntry> values = describeResult.getPicklistValues();           
        Object valueInsteadOfAPIName = originalValue;        
        
        for(Schema.PicklistEntry v : values) {
            if (v.getValue() == originalValue){
                value = v.getLabel();
                break;
            }            
        }
        
        return value;
    }
    
    
    
    
    
    
    
   public static Map<String,Object> getRiskProfileAccountManaged(String recordId, String fieldNames) { 

        //El componente CRAN_VAS_ADV_ColorBox_AUC es generico y se usa hasta ahora en 2 casos
        //caso 1 (caja azul): select CRAN_VEC_ADV_P_RiskProfile__c,CurrencyIsoCode from account where id= ...   
        //caso 2 (caja marron): SELECT CRAN_VAS_KER_F_T_BP_Type__c,CurrencyIsoCode from account where id= ...   

        //Esto es un caso especial para caja azul (select CRAN_VEC_ADV_P_RiskProfile__c):
        //If CRAN_VEC_ADV_P_MngdAccount__c = '500506' o '500507' (Managed Portfolio) 
        //then mostrar el valor del picklist de CRAN_ICA_ADV_P_RiskProfileAccountManaged__c
        //Para este caso especial se ha creado este nuevo campo: CRAN_ICA_ADV_P_RiskProfileAccountManaged__c 
        
        if(fieldNames != null &&  fieldNames.contains('CRAN_VEC_ADV_P_RiskProfile__c')){
               String query = 'SELECT CRAN_VEC_ADV_P_RiskProfile__c, ' +
                                      'CurrencyIsoCode, ' +
                                      'CRAN_VEC_ADV_P_MngdAccount__c, ' +
                                      'toLabel(CRAN_ICA_ADV_P_RiskProfileAccountManaged__c) ' +
                               'FROM Account ' +
                               'WHERE Id =: recordId LIMIT 1 ';
               Account acc = Database.query(query);
               Schema.DescribeSObjectResult describeSObjectResult = acc.getSObjectType().getDescribe();
               Map<String, Schema.SObjectField> fieldMap = describeSObjectResult.fields.getMap(); 
               DescribeFieldResult describeResult = fieldMap.get('CRAN_VEC_ADV_P_RiskProfile__c').getDescribe();   
               String riskScoringLabel = describeResult.getLabel();
               //No preguntamos el campo CRAN_VAS_KER_F_T_BP_Type__c porque es una textformula de CRAN_VEC_ADV_P_MngdAccount__c
               if(acc != null){
                   if(acc.CRAN_VEC_ADV_P_MngdAccount__c == '500506' || acc.CRAN_VEC_ADV_P_MngdAccount__c == '500507' ){     
                       Map<String,Object> fieldNamesByAPINameTMP = new Map<String,Object>();
                       if( acc.CRAN_ICA_ADV_P_RiskProfileAccountManaged__c != null ){
                            fieldNamesByAPINameTMP.put( riskScoringLabel , acc.CRAN_ICA_ADV_P_RiskProfileAccountManaged__c ); //'Risk Profile'
                       }else{
                            fieldNamesByAPINameTMP.put( riskScoringLabel , '-' ); //'Risk Profile'
                       }
                       return fieldNamesByAPINameTMP;
                   }  
                }
 
                
         } 
        
        return null;
        
        
    }
    

    
}