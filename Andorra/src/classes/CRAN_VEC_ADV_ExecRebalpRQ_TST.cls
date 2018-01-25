@isTest
private class CRAN_VEC_ADV_ExecRebalpRQ_TST {

	@isTest static void test_ExecRebalpRQ_test() {
		String jsonPrueba = '{\"lang\": \"es\",\"mode\": \"get\",\"order\":{\"orderNr\":99485433,\"isNew\":true},\"transList\":[{\"orderNr\":\"123456789\",\"action\":true}]}';

		CRAN_VEC_ADV_ExecRebalpRQ_CLS response = (CRAN_VEC_ADV_ExecRebalpRQ_CLS)JSON.deserialize(jsonPrueba, CRAN_VEC_ADV_ExecRebalpRQ_CLS.class);

		System.debug('response '+response);

		String jsonRequest =JSON.serialize(response);	
		System.debug('jsonRequest '+ jsonRequest);
	}
}