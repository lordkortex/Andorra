@isTest
private class CRAN_VEC_ADV_ExecRebalpRS_TST {

	@isTest static void test_ExecRebalpRS_test() {
		String jsonPrueba = '{\"orderNr\": \"443243242\",\"transList\": [{\"orderNr\": \"123456789\",\"metaType\": \"FX\",\"assetType\": \"tipo prueba\",\"propName\": \"prop prueba\",\"orderType\": \"buy\",\"type\": \"At Market\",\"limit\": \"12\",\"price\": 10.22,\"amount\": 12.44,\"var\": \"var prueba\"},{\"orderNr\": \"123456789\",\"metaType\": \"FX\",\"orderType\": \"sell\",\"type\": \"At Market\",\"sellAmount\": 12,\"sellCurry\": \"EUR\",\"buyAmount\": 12.44,\"buyCurry\": \"USD\",\"xrateType\": 0.51}],\"executedOrderList\":[{\"orderNr\":\"2342344234\", \"metaType\":\"STEX\",\"type\":\"RV\",\"asset\":\"AMERICAN CAPITAL AGENCY CORP\",\"price\":34,\"qty\":3,\"orderType\":\"buy\",\"amount\":122,\"date\":\"01-01-2012 00:00:00\",\"omsId\":1232432423},{\"orderNr\":2342344234, \"metaType\":\"FXTR\",\"type\":\"RV\",\"orderType\":\"buy\",\"sellAmount\":154444.32,\"sellCurry\":\"EUR\",\"buyAmount\":33000.33,\"buyCurry\":\"USD\",\"xrateType\":0.44,\"date\":\"01-01-2012 00:00:00\",\"omsId\":3323334}],\"restrList\":[{\"id\":\"343535\",\"name\":\"3534535\",\"typeName\":\"3535345\",\"topRestr\":\"3453535\",\"evalResult\":\"34535\",\"remark\":\"34535\",\"violObj\":\"34535\",\"violClass\":\"34767376\",\"violValue\":\"67367\",\"valueFrom\":\"3657376\",\"valueTo\":\"365737\",\"prio\":\"3567765\",\"overrideRestr\":true,\"justif\":\"36736577\"}]}';

		CRAN_VEC_ADV_ExecRebalpRS_CLS response = (CRAN_VEC_ADV_ExecRebalpRS_CLS)JSON.deserialize(jsonPrueba, CRAN_VEC_ADV_ExecRebalpRS_CLS.class);

		System.debug('response '+response);

		String jsonRequest =JSON.serialize(response);	
		System.debug('jsonRequest '+ jsonRequest);
	}
}