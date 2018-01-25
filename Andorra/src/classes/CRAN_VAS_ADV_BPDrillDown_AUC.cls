public with sharing class CRAN_VAS_ADV_BPDrillDown_AUC {
    
    @AuraEnabled
    public static String getRecords(String recIdStr) {
          
        Set<String> bpNumbers = new Set<String>();
        WrapperClass wrapper = new WrapperClass();
        
        Map<Id, String> bpByAccount = new Map<Id, String>();
        
        Account acc = [SELECT FinServ__PrimaryContact__c FROM Account WHERE	Id =: recIdStr LIMIT 1];

        for (FinServ__FinancialAccountRole__c far : [	SELECT 	CRAN_VEC_ADV_T_BPId__c 
                            							FROM 	FinServ__FinancialAccountRole__c 
                            							WHERE 	FinServ__Role__c = '1'
                                                    	AND		FinServ__RelatedContact__c =: acc.FinServ__PrimaryContact__c]) {
				bpNumbers.add(far.CRAN_VEC_ADV_T_BPId__c);
			}
           
        for (Account bp : [SELECT Id, Name, Cash_and_Money_BP__c, CurrencyIsoCode FROM Account WHERE CRAN_VEC_ADV_T_BPId__c =: bpNumbers]) {
            GenericObjectClass obj = new GenericObjectClass();
            obj.Id = bp.Id;
            obj.Name = bp.Name;
            obj.Amount = formatCurrency(bp.Cash_and_Money_BP__c, bp.CurrencyIsoCode);
            wrapper.bps.put(bp.Id, obj);
            wrapper.fas.put(bp.Id, new  List<GenericObjectClass>());
        }
        
        for (FinServ__FinancialAccount__c fa : [SELECT Id, Name, FinServ__PrimaryOwner__c,
                                                Cash_and_Money_FH__c, CurrencyIsoCode,
                                                (SELECT Id, Name, CRAN_VEC_ADV_N_currValNoAccr__c, CurrencyIsoCode,
                                                 		ToLabel(CRAN_VEC_ADV_P_PFMMktCat__c) FROM FinServ__FinancialHoldings__r)
                                                FROM 	FinServ__FinancialAccount__c 
                                                WHERE	FinServ__PrimaryOwner__c =: wrapper.fas.keySet()]) {
                                                    
                                                    GenericObjectClass obj = new GenericObjectClass();
                                                    obj.Id = fa.Id;
                                                    obj.Name = fa.Name;
                                                    
                                                    Decimal finalAmount = 0;
                                                    for (FinServ__FinancialHolding__c fah : fa.FinServ__FinancialHoldings__r) {
                                                        finalAmount += fah.CRAN_VEC_ADV_N_currValNoAccr__c;
                                                        GenericObjectClass childObj = new GenericObjectClass();
                                                        childObj.Id = fah.Id;
                                                        childObj.Name = fah.Name;
                                                        childObj.Amount = formatCurrency(fah.CRAN_VEC_ADV_N_currValNoAccr__c, fah.CurrencyIsoCode); 
                                                        childObj.Category = fah.CRAN_VEC_ADV_P_PFMMktCat__c;
                                                        obj.objects.add(childObj);
                                                    }
                                                    obj.Amount = formatCurrency(finalAmount, fa.CurrencyIsoCode);
                                                        
                                                        
                                                    wrapper.fas.get(fa.FinServ__PrimaryOwner__c).add(obj);
                                                }
        
        
        return JSON.serialize(wrapper);
    }
    
    private static String formatCurrency(Decimal value, String currencyIsoCode) {
        String strValue = '';
        
        if (value == null || value == 0)
            return strValue;
        else
            return strValue = currencyIsoCode + ' ' + value.format();
    }
    
    @TestVisible
    private class WrapperClass {
        
        public Map<Id, GenericObjectClass> bps;
        public Map<Id, List<GenericObjectClass>> fas;
        
        WrapperClass() {
            bps = new Map<Id, GenericObjectClass>();
            fas = new Map<Id, List<GenericObjectClass>>();
        }
        
    }
		
    @TestVisible
    private class GenericObjectClass {
        
        String Id;
        String Name;
        String Amount;
        String Category;
        
        public List<GenericObjectClass> objects;
        
        GenericObjectClass() {
            objects = new List<GenericObjectClass>();
        }
        
    }    
}