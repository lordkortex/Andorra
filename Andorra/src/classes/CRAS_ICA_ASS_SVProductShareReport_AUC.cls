public class CRAS_ICA_ASS_SVProductShareReport_AUC {
 
    @AuraEnabled
    public static string getUserCurrency(){
        return CRAS_ICA_ASS_Helpers_CLS.getUserCurrency();
    }
    
 	@AuraEnabled
    public static String getReportPrimeCount(){  
        if(!Test.isRunningTest()){
			return CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_svpdt1Rest');
        } else {
            return JSON.serialize(new List<List<String>>());
        }
    }
    
    @AuraEnabled
    public static String getReportInsureds(){
        if(!Test.isRunningTest()){
			return CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_svpdt2Rest');
        } else {
            return JSON.serialize(new List<List<String>>());
        }
    }
}