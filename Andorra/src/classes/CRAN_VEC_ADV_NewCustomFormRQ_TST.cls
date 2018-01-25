@isTest
private class CRAN_VEC_ADV_NewCustomFormRQ_TST {
	
	@isTest static void test_method_onload() {
		CRAN_VEC_ADV_NewCustomFormRQ_CLS c = new CRAN_VEC_ADV_NewCustomFormRQ_CLS();

		c.setLang('es');
		c.getLang();
		c.setQuestType('type');
		c.getQuestType();
		c.getObjList();

	}
	
	@isTest static void test_NewCustomFormRQ_test() {
		
        String jsonPrueba = '{\"lang\":\"es\",\"objList\":[{\"obj\":[{\"avqId\":400916}],\"objType\":\"person\"},{\"obj\":[{\"avqId\":6287251}],\"objType\":\"bp\"}],\"questType\":\"mdb$mifid\"}';

		CRAN_VEC_ADV_NewCustomFormRQ_CLS response = (CRAN_VEC_ADV_NewCustomFormRQ_CLS)JSON.deserialize(jsonPrueba, CRAN_VEC_ADV_NewCustomFormRQ_CLS.class);

		String jsonRequest =JSON.serialize(response);		
	}
	
}