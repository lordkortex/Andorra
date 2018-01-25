@isTest
private class CRAN_VEC_ADV_DiscardCustomFormRQ_TST {
	
	@isTest static void test_method_onLoad() {
		CRAN_VEC_ADV_DiscardCustomFormRQ_CLS c = new CRAN_VEC_ADV_DiscardCustomFormRQ_CLS();
		c.setLang('es');
	}
	
	@isTest static void test_DiscardCustomFormRQ() {
        String jsonPrueba = '{\"order\":{\"isNew\":false,\"orderNr\":99485433},\"lang\":\"es\"}';
       
		CRAN_VEC_ADV_DiscardCustomFormRQ_CLS response = (CRAN_VEC_ADV_DiscardCustomFormRQ_CLS)JSON.deserialize(jsonPrueba, CRAN_VEC_ADV_DiscardCustomFormRQ_CLS.class);       

		String jsonRequest =JSON.serialize(response);		
	}
	
}