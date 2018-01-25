public class CRAN_VAS_KER_SignatureCmpController {
    
    @AuraEnabled
    public static Object startSignatureProcess(Id id) {
    	try {
    		CRAN_VAS_KER_ISignatureHandler handler = CRAN_VAS_KER_SignatureHandlerFactory.createSignatureHandler(id);
        	return handler.getSignatureUrl(id);    		
    	} catch (Exception ex) {
            return ex;
    	}
    }

    @AuraEnabled 
    public static Map<String, String> getMobilePhoneInfo(Id recId) {
        return CRAN_VAS_KER_SignatureUtils.getMobilePhoneInfo(recId);
    }
}