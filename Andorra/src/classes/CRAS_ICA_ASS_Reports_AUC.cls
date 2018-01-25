public class CRAS_ICA_ASS_Reports_AUC{
    @AuraEnabled
    public static string getUserCurrency(){
        return CRAS_ICA_ASS_Helpers_CLS.getUserCurrency();
    }
    
    @AuraEnabled
    public static String getUserId() {
        return Userinfo.getUserId();
    }
    
    @AuraEnabled
    public static String getRiskSet(Id userId){
		return CRAS_ICA_ASS_Home_CLS.getRiskSet(userId);
    }
    
    
    @AuraEnabled
    public static String getRiskInsSet(Id userId){
    	return CRAS_ICA_ASS_Home_CLS.getRiskInsSet(userId);
    }
    
    @AuraEnabled
    public static String getSavingsSet(Id userId){
    	return CRAS_ICA_ASS_Home_CLS.getSavingsSet(userId);
    }
    
    @AuraEnabled    
    public static String getVentasObjetivos(String market){
		return CRAS_ICA_ASS_Home_CLS.getVentasObjetivos(market);
    }
    
    @AuraEnabled
    public static String getRecibosDevueltos(){
		return CRAS_ICA_ASS_Home_CLS.getRecibosDevueltos();
    }
    
    @AuraEnabled
    public static String getPropuestasPendientes(){
		return CRAS_ICA_ASS_Home_CLS.getPropuestasPendientes();
    }
    
    
    
    @AuraEnabled
    public static String getReportPrimeCountMarket(){
		return CRAS_ICA_ASS_Cartera_CLS.getReportPrimeCountMarket();
    }
    
    @AuraEnabled
    public static String getReportInsuredsMarket(){
		return CRAS_ICA_ASS_Cartera_CLS.getReportInsuredsMarket();
    }
    
    @AuraEnabled
    public static String getReportPrimeCountProduct(){
		return CRAS_ICA_ASS_Cartera_CLS.getReportPrimeCountProduct();
    }
    
    @AuraEnabled
    public static String getReportInsuredsProduct(){
		return CRAS_ICA_ASS_Cartera_CLS.getReportInsuredsProduct();
    }
    
 	@AuraEnabled
    public static String getReportPrimeCountSVProduct(){  
		return CRAS_ICA_ASS_Cartera_CLS.getReportPrimeCountSVProduct();
    }
    
    @AuraEnabled
    public static String getReportInsuredsSVProduct(){
		return CRAS_ICA_ASS_Cartera_CLS.getReportInsuredsSVProduct();
    }
    
    @AuraEnabled
    public static String getSntByMarket(String groupType, String byYear){
		return CRAS_ICA_ASS_Cartera_CLS.getSntByMarket(groupType,byYear);
    }    
    
}