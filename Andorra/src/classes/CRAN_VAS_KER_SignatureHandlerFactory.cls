public with sharing class CRAN_VAS_KER_SignatureHandlerFactory { 
    
    public static CRAN_VAS_KER_ISignatureHandler createSignatureHandler(String id) {
        CRAN_VAS_KER_ISignatureHandler handler = getSignatureHandler(id);
        if (handler == null)
            throw new CRAN_VAS_KER_SignatureException(System.Label.CRAN_VAS_KER_SignatureExceptionNoController + ' ' + id);
        return handler;
    }

    /** 
	* @author Luis Velasco
	* @date 01/03/2017
	* @description Dynamically get the appropiate handler based on the Type of the id.
	*				Handler's name has to follow this format:
	*				<ObjectName>SignHndlr, f.ex. for the CRAN_VEC_ADV_CustomForm__c object, the dispatcher has to be named
	*				CRAN_VEC_ADV_CustomFormSignHndlr. Take into account that limit for class name size is 40 char!
	* @param String Id for the record for which to create the SignatureHandler
	* @return CRAN_VAS_KER_ISignatureHandler A handler if it exists or null if it doesn't.
	*/
    private static CRAN_VAS_KER_ISignatureHandler getSignatureHandler(String strId) {
        
        try {
        
    	String originalTypeName = Id.valueOf(strId).getSObjectType().getDescribe().getName();
    	String handlerTypeName = null;
System.debug('@@@ID SENT TO FACTORY: ' + strId);    	
    	if (originalTypeName.toLowerCase().endsWith('__c')) {
    		Integer index = originalTypeName.toLowerCase().indexOf('__c');
    		if (index > 31) {
    			index = 31;
    		}
    		handlerTypeName = originalTypeName.substring(0, index) + 'SignHndlr';
    	}
    	else
    		handlerTypeName = 'CRAN_VAS_KER_' + originalTypeName + 'SignHndlr';
		Type obType = Type.forName(handlerTypeName);
		CRAN_VAS_KER_ISignatureHandler dispatcher = (obType == null) ? null : (CRAN_VAS_KER_ISignatureHandler)obType.newInstance();
    	return dispatcher;
            
        } catch (Exception ex) {
            return null;
        }
    }
    
}