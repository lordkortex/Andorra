@isTest
private class CRAN_VEC_ADV_RenewCustomFormRQ_TST {
	
	@isTest static void test_method_onload() {
		CRAN_VEC_ADV_RenewCustomFormRQ_CLS c = new CRAN_VEC_ADV_RenewCustomFormRQ_CLS();
		c.setLang('es');
		c.getLang();
		List<CRAN_VEC_ADV_ObjList_CLS> l = new List<CRAN_VEC_ADV_ObjList_CLS>();
		c.setObjList(l);
		c.getObjList();

	}	

	@isTest static void test_RenewCustomFormRQ_test() {
		String jsonPrueba = '{\"objList\":[{\"obj\":[{\"avqId\":400916,\"keyList\":null}],\"objType\":\"bp\"},{\"obj\":[{\"avqId\":3343221,\"keyList\":null}],\"objType\":\"quest\"}],\"lang\":\"es\"}';

		CRAN_VEC_ADV_RenewCustomFormRQ_CLS response = (CRAN_VEC_ADV_RenewCustomFormRQ_CLS)JSON.deserialize(jsonPrueba, CRAN_VEC_ADV_RenewCustomFormRQ_CLS.class);

		String jsonRequest =JSON.serialize(response);		
	}
}