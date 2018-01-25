@isTest
private class CRAN_VEC_ADV_UtilEncryption_TST {
	
	@isTest static void encryptionTest() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFactory.createAvaloqSetting();
		CRAN_VEC_ADV_UtilEncryption_CLS utilEnc = new CRAN_VEC_ADV_UtilEncryption_CLS();

		String stringJson = '{"service":"service","content":"contenido a encriptar","codModAppOrigin":null,"codEnv":null,"codAppOrigin":"SF_CA"}';
		String encryptedManage = utilEnc.encryptManaged(stringJson);
		String decryptedManage = utilEnc.decryptManaged(encryptedManage);
		System.Assert(stringJson.equals(decryptedManage));	
	}
    
    @isTest static void restManagerEncryptTest() {
        String contentToEncrypt = 'contenido a encriptar';
        CRAN_VEC_ADV_GenericAvaloqRequest GARQ = new CRAN_VEC_ADV_GenericAvaloqRequest();
		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFactory.createAvaloqSettingEncrypted();

		CRAN_VEC_ADV_AvaloqRestManager restMngr = new CRAN_VEC_ADV_AvaloqRestManager('service','9',contentToEncrypt);
        restMngr.genericRQ.getCodEnv();
        restMngr.genericRQ.getCodModAppOrigin();
        restMngr.genericRQ.getCodAppOrigin();
        System.debug(restMngr.jsonContent);
        CRAN_VEC_ADV_AvaloqRestManager restRsp = new CRAN_VEC_ADV_AvaloqRestManager(restMngr.jsonContent);
        System.Assert(contentToEncrypt.equals(restRsp.content));	
	}
}