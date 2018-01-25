@isTest

private class CRAN_VAS_KER_SignaturePdfViewer_tst 
{
	@isTest static  void testGetSignature() 
	{
		
		CRAN_VAS_KER_ESignature__c objSignature= new CRAN_VAS_KER_ESignature__c();
		objSignature.CRAN_VAS_KER_Account__c 		= null;
		objSignature.CRAN_VAS_KER_Archive_Date__c	= system.today();
		objSignature.CRAN_VAS_KER_File_Name__c 		= 'test file';
		objSignature.CRAN_VAS_KER_Reference_Line__c = 'rf_0001';
		objSignature.CRAN_VAS_KER_Core_Id__c		= 'core_0001';
		objSignature.CRAN_VAS_KER_Contract__c		= null;
		insert  objSignature;
		CRAN_VAS_KER_SignaturePdfViewer_ctr.getSignatures(objSignature.id);	
	}
    
}