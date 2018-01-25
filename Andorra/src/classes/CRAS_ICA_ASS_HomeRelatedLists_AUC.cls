public class CRAS_ICA_ASS_HomeRelatedLists_AUC {
	
    @AuraEnabled
    public static List<List<CRAN_ICA_KER_JoinListViewProvider_CLS.AuraFieldModel>> getRecords(String objName, String listViewName, Integer rpp, Integer offset, String selectProvider, String recordId){
        if(selectProvider.equals('CRAN_ICA_KER_JoinListViewProvider_CLS'))
        {
            CRAN_ICA_KER_JoinListViewProvider_CLS provider = new CRAN_ICA_KER_JoinListViewProvider_CLS();
            rpp = Integer.valueOf(rpp);
            offset = Integer.valueOf(offset);
            
            Map<String, Object> params = new Map<String, Object>{
                'recordId' => null,
                'sObjectApiName' => objName, //'FinServ__FinancialAccount__c',
                'listViewName' => listViewName, //'Propuestas Pendientes',
                'strFieldApiNames' => '',
                'parentFieldApiName' => '',
                'childFieldApiName' => '',
                'displayLimit' => rpp //'10'
            };
            /*
            CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper result = provider.getRecordsSObject(params, rpp,  offset);
            List<List<AuraFieldModel>> response = new List<List<AuraFieldModel>>();
                    
            if (result != null){
                List<List<CRAN_VAS_KER_LCUtil_CLS.FieldModel>> records = result.records;
                if (records.size() > 0){
                    for (List<CRAN_VAS_KER_LCUtil_CLS.FieldModel> lfm: records){
                        List<AuraFieldModel> row = new List<AuraFieldModel>();
                        for (CRAN_VAS_KER_LCUtil_CLS.FieldModel fm: lfm){
                            AuraFieldModel afm = new AuraFieldModel();
                            afm.apiName = fm.apiName;
                            afm.value = fm.value;
                            afm.label = fm.label;
                            afm.fieldType = fm.fieldType;
                            afm.recId = fm.recId;
                            afm.referenceName = fm.referenceName;
                            row.add(afm);
                        }
                        response.add(row);
                    }
                }
            }
        
            return response;
            */
            return provider.getRecordsSObject(params, rpp,  offset);
        }
        else if (selectProvider.equals('CRAS_ICA_ASS_HTTPRequestProvider_CLS'))
        {
           CRAS_ICA_ASS_HTTPRequestProvider_CLS provider = new CRAS_ICA_ASS_HTTPRequestProvider_CLS(); 
            rpp = Integer.valueOf(rpp);
            offset = Integer.valueOf(offset);
            
            Map<String, Object> params = new Map<String, Object>
            {
                'recordId' => recordId,
                'sObjectApiName' => objName,
                'listViewName' => '',
                'strFieldApiNames' => '',
                'parentFieldApiName' => '',
                'childFieldApiName' => '',
                'displayLimit' => rpp
            };
                
            return provider.getRecordsSObject(params, rpp,  offset);
        }
        
        return null;
        
    }
    
    @AuraEnabled
    public static String getRecordsJSON(String objName, String listViewName, Integer rpp, Integer offset, String selectProvider, String id){
        rpp = Integer.valueOf(rpp);
        offset = Integer.valueOf(offset);
        return JSON.serialize(getRecords(objName, listViewName, rpp, offset, selectProvider, id));
    } 
    
    @AuraEnabled
    public static Integer getRecordsCount(String objName, String listViewName, String providerName, String recordId){
        if(providerName.equals('CRAS_ICA_ASS_HTTPRequestProvider_CLS'))
        {
            return CRAS_ICA_ASS_CallFHGuar_CLS.callAxis(recordId).Size();
        }
        
        CRAN_ICA_KER_JoinListViewProvider_CLS provider = new CRAN_ICA_KER_JoinListViewProvider_CLS();
        Map<String, Object> params = new Map<String, Object>{
            'recordId' => null,
            'sObjectApiName' => objName, //'FinServ__FinancialAccount__c',
            'listViewName' => listViewName, //'Propuestas Pendientes',
            'strFieldApiNames' => '',
            'parentFieldApiName' => '',
            'childFieldApiName' => '',
            'displayLimit' => 10000 //'10'
        };
        
        Integer response = 0;
            
        //CRAN_VAS_KER_LCUtil_CLS.SObjectWrapper result = provider.getRecordsSObject(params, -1, -1);
        List<List<CRAN_ICA_KER_JoinListViewProvider_CLS.AuraFieldModel>> result = provider.getRecordsSObject(params, -1, -1);
        if (result != null){
            response = result.size();
        }
        
        return response;
    }
        
    
        
    
}