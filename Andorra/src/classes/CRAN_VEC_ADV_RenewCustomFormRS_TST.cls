@isTest
private class CRAN_VEC_ADV_RenewCustomFormRS_TST {
	
	@isTest static void test_method_onload() {
		CRAN_VEC_ADV_RenewCustomFormRS_CLS c = new CRAN_VEC_ADV_RenewCustomFormRS_CLS();
	}


	@isTest static void test_RenewCustomFormRS_method_renew() {
		String jsonPrueba = '{\"order\":{\"orderNr\":99485433,\"isNew\":true},\"avisos\":null,\"errores\":null}';
        
		CRAN_VEC_ADV_RenewCustomFormRS_CLS response = (CRAN_VEC_ADV_RenewCustomFormRS_CLS)JSON.deserialize(jsonPrueba, CRAN_VEC_ADV_RenewCustomFormRS_CLS.class);       

		String jsonRequest =JSON.serialize(response);		
	}
	
}