@isTest
private class CRAN_VEC_ADV_ProcessBPCustomFormRQ_TST {
	
	@isTest static void test_method_onload() {
		// Implement test code
		CRAN_VEC_ADV_ProcessBPCustomFormRQ_CLS c = new CRAN_VEC_ADV_ProcessBPCustomFormRQ_CLS();
		c.setLang('es');
		c.getLang();

	}	

	@isTest static void test_ProcessBPCustomFormRQ_method_create() {
		system.debug('test_ProcessBPCustomFormRQ_method_001');
		String jsonPrueba = '{\"lang\":\"es\",\"objList\":[{\"obj\":[{\"avqId\":6287251,\"keyList\":[{\"value\":\"948554\",\"keyType\":\"sort_nr\"},{\"value\":\"4C12440\",\"keyType\":\"sort_alpha\"}]}],\"objType\":\"bp\"}],\"questType\":\"cran$advisory\",\"questVersion\":\"1.0\",\"questStatus\":\"hold\"}';

		System.debug('entra deserializar');        
		CRAN_VEC_ADV_ProcessBPCustomFormRQ_CLS response = (CRAN_VEC_ADV_ProcessBPCustomFormRQ_CLS)JSON.deserialize(jsonPrueba, CRAN_VEC_ADV_ProcessBPCustomFormRQ_CLS.class);

		System.debug(response);
		System.debug('sale deserializar');        

		System.debug('entra en serializar');
		String jsonRequest =JSON.serialize(response);		
		System.debug(jsonRequest);
		System.debug('sale de serializar');
	}






}