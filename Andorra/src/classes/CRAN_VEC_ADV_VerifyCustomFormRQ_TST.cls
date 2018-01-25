@isTest
private class CRAN_VEC_ADV_VerifyCustomFormRQ_TST {
	
	@isTest static void test_method_onload() {
		CRAN_VEC_ADV_VerifyCustomFormRQ_CLS c = new CRAN_VEC_ADV_VerifyCustomFormRQ_CLS();
    	c.getLang();
    	c.setLang('es');
	}

	@isTest static void test_VerifyCustomFormRQ_verify() {
		String jsonPrueba = '{\"order\":{\"isNew\":false,\"orderNr\":99485433},\"lang\":\"es\"}';
     
		CRAN_VEC_ADV_VerifyCustomFormRQ_CLS response = (CRAN_VEC_ADV_VerifyCustomFormRQ_CLS)JSON.deserialize(jsonPrueba, CRAN_VEC_ADV_VerifyCustomFormRQ_CLS.class);
		String jsonRequest =JSON.serialize(response);		
	}
}