public class CRAS_ICA_ASS_Cartera_CLS {

    public static String getReportPrimeCountMarket(){
        return CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_mkt1Rest');

    }

    public static String getReportInsuredsMarket(){
        return CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_mkt2Rest');
        
    }
    
    public static String getReportPrimeCountProduct(){
		return CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_pdt1Rest');
        
    }
    
    public static String getReportInsuredsProduct(){   
        return CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_pdt2Rest');
        
    }
    
 	@AuraEnabled
    public static String getReportPrimeCountSVProduct(){  
		return CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_svpdt1Rest');
        
    }
    
    public static String getReportInsuredsSVProduct(){
		return CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_svpdt2Rest');
        
    }
    
    public static String getSntByMarket(String groupType, String byYear){
        List<List<String>> resultList = new List<List<String>>();
        if(groupType=='market'){
            if(byYear=='false'){
                return CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_sntRest');
            } else {
                return CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_sntRestYear');
            }
                           
        } else {//product            
            if(byYear=='false'){
                return CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_sntProductRest');
            } else {
                return CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_sntProductRestYear');
            }                        
            
        }
    }
    

    

    
}