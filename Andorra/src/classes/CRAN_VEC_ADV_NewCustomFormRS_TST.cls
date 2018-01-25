@isTest
private class CRAN_VEC_ADV_NewCustomFormRS_TST {
	
	@isTest static void test_methods_onload() {
		CRAN_VEC_ADV_NewCustomFormRS_CLS c = new CRAN_VEC_ADV_NewCustomFormRS_CLS();
		CRAN_VEC_ADV_Order_CLS t = new CRAN_VEC_ADV_Order_CLS();
		c.getOrder();
		c.setOrder(t);
		c.getErrors();
		c.setErrors(new List<CRAN_VEC_ADV_ProcessSTError_CLS>());
	}

	@isTest static void test_NewCustomFormRS_test() {
		
		String jsonPrueba = '{\"order\":{\"orderNr\":533217594,\"isNew\":true},\"objList\":[{\"objType\":\"bp\",\"obj\":[{\"avqId\":9143985,\"keyList\":[{\"keyType\":\"sort_nr\",\"value\":\"1199600\"}]}]}],\"avisos\":null,\"errores\":null}';
        
		CRAN_VEC_ADV_NewCustomFormRS_CLS response = (CRAN_VEC_ADV_NewCustomFormRS_CLS)JSON.deserialize(jsonPrueba, CRAN_VEC_ADV_NewCustomFormRS_CLS.class);

		String jsonRequest =JSON.serialize(response);		
	}

	
}