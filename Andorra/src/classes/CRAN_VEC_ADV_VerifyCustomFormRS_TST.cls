@isTest
	private class CRAN_VEC_ADV_VerifyCustomFormRS_TST {
		
		@isTest static void test_method_onload() {
			CRAN_VEC_ADV_VerifyCustomFormRQ_CLS c = new CRAN_VEC_ADV_VerifyCustomFormRQ_CLS();
	    	c.getLang();
	    	c.setLang('es');
		}

		@isTest static void test_VerifyCustomFormRS_verify() {
			String jsonPrueba = '{\"objList\":[{\"obj\":[{\"avqId\":485433}],\"objType\":\"quest\"}],\"errores\":null,\"avisos\":null}';

			CRAN_VEC_ADV_VerifyCustomFormRS_CLS response = (CRAN_VEC_ADV_VerifyCustomFormRS_CLS)JSON.deserialize(jsonPrueba, CRAN_VEC_ADV_VerifyCustomFormRS_CLS.class);     

			String jsonRequest =JSON.serialize(response);		
		}
}