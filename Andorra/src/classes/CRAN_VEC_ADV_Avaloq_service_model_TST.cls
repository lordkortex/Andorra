@isTest
private class CRAN_VEC_ADV_Avaloq_service_model_TST {

	@isTest static void CRAN_VEC_ADV_SignContract_model_TST() {
		CRAN_VEC_ADV_SignContractRS signRS = new CRAN_VEC_ADV_SignContractRS();
		CRAN_VEC_ADV_ObjList_CLS objListPerson = new CRAN_VEC_ADV_ObjList_CLS();
		objListPerson.setObjType('person');
		objListPerson.getObjType();
		signRS.setObjList(objListPerson);
		CRAN_VEC_ADV_ObjList_CLS objListPerson2 = signRS.getObjList();
		signRS.setStatus('test');
		String tmp = signRS.getStatus();
		List<CRAN_VEC_ADV_ProcessSTError_CLS> errors = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
		signRS.setErrors(errors);
	}

	@isTest static void CRAN_VEC_ADV_PortfolioRQ_TST() {
		CRAN_VEC_ADV_PortfolioRQ_CLS portRQ = new CRAN_VEC_ADV_PortfolioRQ_CLS();
		List<CRAN_VEC_ADV_Portfolio_ObjAvaloq_CLS> listAva = new List<CRAN_VEC_ADV_Portfolio_ObjAvaloq_CLS>();
		portRQ.setDateTo('Date');
		portRQ.setLang('spanish');
		portRQ.setObjList(listAva);
		portRQ.getLang();
		portRQ.getDateTo();
		portRQ.getObjList();
	}

	@isTest static void CRAN_VEC_ADV_DiscardCustomForm_TST() {
		CRAN_VEC_ADV_DiscardCustomFormRQ_CLS discardRQ = new CRAN_VEC_ADV_DiscardCustomFormRQ_CLS();
		discardRQ.setLang('es');
		discardRQ.getLang();
		List<CRAN_VEC_ADV_Order_CLS> orderList = new List<CRAN_VEC_ADV_Order_CLS>();
		CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
		order.setOrderNr('OrderNr');
		order.getOrderNr();
		order.setIsNew(true);
		order.getIsNew();
		orderList.add(order);
		discardRQ.setOrderList(orderList);
		discardRQ.getOrderList();


		String jsonNuevo = '{\"orderList\":[{\"order\":{\"orderNr\":\"2000\",\"isNew\":\"false\"}},{\"order\":{\"orderNr\":\"2000\",\"isNew\":\"false\"}}],\"errors\":[{\"code\":\"sf_999005\",\"desc\":\"1000 - Received order is not in hold state\"},{\"code\":\"sf_999005\",\"desc\":\"3000 - Received order is not in hold state\"}]}';
		String jsonPrueba = '{\"order\":{\"isNew\":false,\"orderNr\":99485433},\"lang\":\"es\"}';

		CRAN_VEC_ADV_DiscardCustomFormRQ_CLS response = (CRAN_VEC_ADV_DiscardCustomFormRQ_CLS)JSON.deserialize(jsonPrueba, CRAN_VEC_ADV_DiscardCustomFormRQ_CLS.class);
		String jsonRequest = JSON.serialize(response);

		CRAN_VEC_ADV_DiscardCustomFormRS_CLS discardRS = new CRAN_VEC_ADV_DiscardCustomFormRS_CLS();
		List<CRAN_VEC_ADV_ProcessSTError_CLS> error = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
		discardRS.setErrors(error);
		discardRS.getErrors();

		CRAN_VEC_ADV_Order_CLS orderRs = new CRAN_VEC_ADV_Order_CLS();
		List<CRAN_VEC_ADV_Order_CLS> orderListRs = new List<CRAN_VEC_ADV_Order_CLS>();
		orderListRs.add(orderRs);

		orderRs.setOrderNr('orderNr');
		orderRs.getOrderNr();
		orderRs.setIsNew(false);
		orderRs.getIsNew();
		discardRS.setOrderList(orderListRs);
		discardRS.getOrderList();

		String jsonPruebaRs = '{\"order\":{\"isNew\":false,\"orderNr\":99485433},\"errores\":null,\"avisos\":null}';
		CRAN_VEC_ADV_DiscardCustomFormRS_CLS responseRs = (CRAN_VEC_ADV_DiscardCustomFormRS_CLS)JSON.deserialize(jsonPruebaRs, CRAN_VEC_ADV_DiscardCustomFormRS_CLS.class);
		String jsonRequestRs = JSON.serialize(responseRs);
	}

	@isTest
	static void CRAN_VEC_ADV_NewCustomForm_TST() {
		CRAN_VEC_ADV_NewCustomFormRQ_CLS newRQ = new CRAN_VEC_ADV_NewCustomFormRQ_CLS();
		newRQ.setLang('es');
		newRQ.getLang();
		newRQ.setQuestType('type');
		newRQ.getQuestType();

		CRAN_VEC_ADV_Obj_CLS objPerson = new CRAN_VEC_ADV_Obj_CLS();
		objPerson.setAvqId('contactId');
		objPerson.getAvqId();

		CRAN_VEC_ADV_ObjList_CLS objListPerson = new CRAN_VEC_ADV_ObjList_CLS();
		objListPerson.setObjType('person');
		objListPerson.getObjType();
		List<CRAN_VEC_ADV_Obj_CLS> x = new List<CRAN_VEC_ADV_Obj_CLS>();
		x.add(objPerson);
		CRAN_VEC_ADV_keyList_CLS p = new CRAN_VEC_ADV_keyList_CLS();
		p.setKeyType('keytype');
		p.getKeyType();
		p.setValue('value');
		p.getValue();

		List<CRAN_VEC_ADV_ObjList_CLS> objList = new List<CRAN_VEC_ADV_ObjList_CLS>();
		objList.add(objListPerson);
		newRQ.setObjList(objList);
		newRQ.getObjList();

		String jsonPrueba = '{\"lang\":\"es\",\"objList\":[{\"obj\":[{\"avqId\":400916}],\"objType\":\"person\"},{\"obj\":[{\"avqId\":6287251}],\"objType\":\"bp\"}],\"questType\":\"mdb$mifid\"}';

		CRAN_VEC_ADV_NewCustomFormRQ_CLS response = (CRAN_VEC_ADV_NewCustomFormRQ_CLS)JSON.deserialize(jsonPrueba, CRAN_VEC_ADV_NewCustomFormRQ_CLS.class);

		String jsonRequest = JSON.serialize(response);


		CRAN_VEC_ADV_NewCustomFormRS_CLS newRS = new CRAN_VEC_ADV_NewCustomFormRS_CLS();
		CRAN_VEC_ADV_ProcessSTError_CLS error = new CRAN_VEC_ADV_ProcessSTError_CLS();

		error.setCode('codError');
		error.getCode();
		error.setDesc('descError');
		error.getDesc();

		newRS.setErrors(new List<CRAN_VEC_ADV_ProcessSTError_CLS>());
		newRS.getErrors();
		CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
		order.setOrderNr('orderNr');
		order.getOrderNr();
		order.setIsNew(false);
		order.getIsNew();
		CRAN_VEC_ADV_ObjListRS_CLS element = new CRAN_VEC_ADV_ObjListRS_CLS();
		element.setObjType('type');
		element.getObjType();
		List<CRAN_VEC_ADV_ObjRS_CLS> listObj = new List<CRAN_VEC_ADV_ObjRS_CLS>();
		CRAN_VEC_ADV_ObjRS_CLS o = new CRAN_VEC_ADV_ObjRS_CLS();
		listObj.add(o);
		element.setObj(listObj);
		element.getObj();
		List<CRAN_VEC_ADV_ObjListRS_CLS> objList1 = new List<CRAN_VEC_ADV_ObjListRS_CLS>();
		objList1.add(element);
		newRS.setObjList(objList1);
		newRS.getObjList();
		newRS.setOrder(order);
		newRS.getOrder();

		String jsonPruebaRs = '{\"order\":{\"orderNr\":548918427,\"new\":true},\"objList\":[{\"objType\":\"bp\",\"obj\":[{\"avqId\":9396876,\"keyList\":[{\"keyType\":\"sort_nr\",\"value\":\"1202269\"}]}]}],\"avisos\":null,\"errores\":null}';
		CRAN_VEC_ADV_NewCustomFormRS_CLS responseRs = (CRAN_VEC_ADV_NewCustomFormRS_CLS)JSON.deserialize(jsonPruebaRs, CRAN_VEC_ADV_NewCustomFormRS_CLS.class);
		String jsonRequestRs = JSON.serialize(responseRs);
	}

	@isTest
	static void CRAN_VEC_ADV_PrintDocumentPdf_TST() {
		CRAN_VEC_ADV_PrintDocumentPdfRQ_CLS printRQ = new CRAN_VEC_ADV_PrintDocumentPdfRQ_CLS();
		printRQ.setIdCustomForm('idBP');
		printRQ.getIdCustomForm();

		CRAN_VEC_ADV_PrintDocumentPdfRS_CLS printRS = new CRAN_VEC_ADV_PrintDocumentPdfRS_CLS();
		List<CRAN_VEC_ADV_ProcessSTError_CLS> errors = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
		CRAN_VEC_ADV_ProcessSTError_CLS error = new CRAN_VEC_ADV_ProcessSTError_CLS();
		errors.add(error);
		printRS.setBlobPDF('blob');
		printRS.getBlobPDF();
		printRS.setErrors(errors);
		printRS.getErrors();
	}

	@isTest
	static void CRAN_VEC_ADV_PortfolioJSON_TST() {
		String jsonPruebaRs = '{\"sum\":1517830.0,\"valIntr\":1517830.0,\"bp\":{\"bpId\":6266158,\"bpName\":\"Quint M Rivero\",\"sum\":1517830.0,\"valIntr\":1517830.0,\"containers\":[{\"id\":6266159,\"contType\":\"Cartera del cliente\",\"name\":\"Quint M Rivero\",\"sum\":1517830.0,\"valIntr\":1517830.0,\"categories\":[{\"id\":504000,\"name\":\"Efectivo y mercado monetario\",\"sum\":320245.55,\"valIntr\":320245.55,\"subCategories\":[{\"id\":504001,\"name\":\"Cuentas de efectivo y mercado monetario\",\"sum\":320245.55,\"valIntr\":320245.55,\"positions\":[{\"reference\":6266183,\"name\":\"Cuenta corriente - EUR - AD0400031101116739610101\",\"posTypeId\":1512,\"posTypeDesc\":\"Money Account p�blica\",\"accr\":\" \",\"costPrice\":null,\"quantity\":232714.33,\"curry\":\"EUR\",\"consolidateQuantity\":232714.33,\"isin\":null,\"finalDate\":null,\"importCost\":232714.33,\"averageCost\":null,\"priceDate\":null,\"marketPrice\":232714.33,\"change\":null,\"groupContext\":\"maccs\",\"valIntr\":232714.33,\"pan\":null,\"pSafeKeep\":null},{\"reference\":6266184,\"name\":\"Cuenta corriente - USD - AD7400031101116739610102\",\"posTypeId\":1512,\"posTypeDesc\":\"Money Account p�blica\",\"accr\":\" \",\"costPrice\":null,\"quantity\":81777.32,\"curry\":\"USD\",\"consolidateQuantity\":77580.23,\"isin\":null,\"finalDate\":null,\"importCost\":81777.32,\"averageCost\":null,\"priceDate\":null,\"marketPrice\":81777.32,\"change\":1.0541,\"groupContext\":\"maccs\",\"valIntr\":77580.23,\"pan\":null,\"pSafeKeep\":null},{\"reference\":6402590,\"name\":\"CREDIINVEST SICAV MONEY M. USD (A)\",\"posTypeId\":1583,\"posTypeDesc\":\"Fondo - mercado monetario\",\"accr\":\"0.98\",\"costPrice\":10.0949,\"quantity\":1039.073,\"curry\":\"USD\",\"consolidateQuantity\":9950.99,\"isin\":\"LU0470294223\",\"finalDate\":null,\"importCost\":10387.2,\"averageCost\":9.9966,\"priceDate\":\"30-12-2016 00:00:00\",\"marketPrice\":10489.34,\"change\":1.0541,\"groupContext\":\"stocks\",\"valIntr\":9950.99,\"pan\":null,\"pSafeKeep\":null}]}]},{\"id\":504050,\"name\":\"Acciones\",\"sum\":428662.79,\"valIntr\":428662.79,\"subCategories\":[{\"id\":504051,\"name\":\"Acciones\",\"sum\":4124.2,\"valIntr\":4124.2,\"positions\":[{\"reference\":6484020,\"name\":\"BBVA\",\"posTypeId\":1585,\"posTypeDesc\":\"Acci�n - portador\",\"accr\":\"-37.58\",\"costPrice\":6.414,\"quantity\":643.0,\"curry\":\"EUR\",\"consolidateQuantity\":4124.2,\"isin\":\"ES0113211835\",\"finalDate\":null,\"importCost\":6607.53,\"averageCost\":10.2761,\"priceDate\":\"30-12-2016 00:00:00\",\"marketPrice\":4124.2,\"change\":null,\"groupContext\":\"stocks\",\"valIntr\":4124.2,\"pan\":null,\"pSafeKeep\":null}]},{\"id\":504070,\"name\":\"Fondos renta variable\",\"sum\":424538.59,\"valIntr\":424538.59,\"positions\":[{\"reference\":8197588,\"name\":\"ALLIANZ RCM EUROPE EQUITY GROWTH\",\"posTypeId\":1623,\"posTypeDesc\":\"Fondo - acciones\",\"accr\":\"-4.97\",\"costPrice\":211.46,\"quantity\":310.0,\"curry\":\"EUR\",\"consolidateQuantity\":65552.6,\"isin\":\"LU0256839860\",\"finalDate\":null,\"importCost\":68981.2,\"averageCost\":222.52,\"priceDate\":\"30-12-2016 00:00:00\",\"marketPrice\":65552.6,\"change\":null,\"groupContext\":\"stocks\",\"valIntr\":65552.6,\"pan\":null,\"pSafeKeep\":null},{\"reference\":6402589,\"name\":\"CREDIINVEST SICAV BIG CAP VALUE (I)\",\"posTypeId\":1623,\"posTypeDesc\":\"Fondo - acciones\",\"accr\":\"74.99\",\"costPrice\":16.7746,\"quantity\":3216.007,\"curry\":\"EUR\",\"consolidateQuantity\":53947.23,\"isin\":\"LU0436007537\",\"finalDate\":null,\"importCost\":30829.61,\"averageCost\":9.5863,\"priceDate\":\"30-12-2016 00:00:00\",\"marketPrice\":53947.23,\"change\":null,\"groupContext\":\"stocks\",\"valIntr\":53947.23,\"pan\":null,\"pSafeKeep\":null},{\"reference\":6402592,\"name\":\"CREDIINVEST SICAV INTERNATIONAL VALUE (A)\",\"posTypeId\":1623,\"posTypeDesc\":\"Fondo - acciones\",\"accr\":\"19.98\",\"costPrice\":246.458,\"quantity\":958.0,\"curry\":\"EUR\",\"consolidateQuantity\":236106.76,\"isin\":\"LU0299048719\",\"finalDate\":null,\"importCost\":196780.3,\"averageCost\":205.4074,\"priceDate\":\"30-12-2016 00:00:00\",\"marketPrice\":236106.76,\"change\":null,\"groupContext\":\"stocks\",\"valIntr\":236106.76,\"pan\":null,\"pSafeKeep\":null},{\"reference\":8197590,\"name\":\"MFS MERIDIAN FUND EUROPEAN VALUE EUR\",\"posTypeId\":1623,\"posTypeDesc\":\"Fondo - acciones\",\"accr\":\"-2.76\",\"costPrice\":36.28,\"quantity\":1900.0,\"curry\":\"EUR\",\"consolidateQuantity\":68932.0,\"isin\":\"LU0125951151\",\"finalDate\":null,\"importCost\":70889.0,\"averageCost\":37.31,\"priceDate\":\"29-12-2016 00:00:00\",\"marketPrice\":68932.0,\"change\":null,\"groupContext\":\"stocks\",\"valIntr\":68932.0,\"pan\":null,\"pSafeKeep\":null}]}]},{\"id\":504074,\"name\":\"Renta fija\",\"sum\":51310.12,\"valIntr\":51310.12,\"subCategories\":[{\"id\":504075,\"name\":\"Bonos\",\"sum\":51310.12,\"valIntr\":51310.12,\"positions\":[{\"reference\":6402588,\"name\":\"C.A. PREFERENCE LTD SERIES A 1.015%\",\"posTypeId\":1616,\"posTypeDesc\":\"Acci�n - preferente\",\"accr\":\"-2.88\",\"costPrice\":100.0197,\"quantity\":513.0,\"curry\":\"EUR\",\"consolidateQuantity\":51310.12,\"isin\":\"XS0238428584\",\"finalDate\":\"31-12-2099 00:00:00\",\"importCost\":52833.46,\"averageCost\":102.9892,\"priceDate\":\"30-12-2016 00:00:00\",\"marketPrice\":51310.12,\"change\":null,\"groupContext\":\"stocks\",\"valIntr\":51310.12,\"pan\":null,\"pSafeKeep\":\"BEL\"}]}]},{\"id\":504085,\"name\":\"Inversiones en activos mixtos\",\"sum\":450524.3,\"valIntr\":450524.3,\"subCategories\":[{\"id\":504086,\"name\":\"Fondos mixtos\",\"sum\":450524.3,\"valIntr\":450524.3,\"positions\":[{\"reference\":7508917,\"name\":\"BLACKROCK GLOBAL ALLOCATION FD-EURA2\",\"posTypeId\":6000,\"posTypeDesc\":\"Fondo - estrategia\",\"accr\":\"8.39\",\"costPrice\":48.03,\"quantity\":1200.0,\"curry\":\"EUR\",\"consolidateQuantity\":57636.0,\"isin\":\"LU0171283459\",\"finalDate\":null,\"importCost\":53174.06,\"averageCost\":44.3117,\"priceDate\":\"30-12-2016 00:00:00\",\"marketPrice\":57636.0,\"change\":null,\"groupContext\":\"stocks\",\"valIntr\":57636.0,\"pan\":null,\"pSafeKeep\":null},{\"reference\":7182557,\"name\":\"CARMIGNAC PATRIMOINE-A EUR A \",\"posTypeId\":6000,\"posTypeDesc\":\"Fondo - estrategia\",\"accr\":\"6.98\",\"costPrice\":652.88,\"quantity\":280.0,\"curry\":\"EUR\",\"consolidateQuantity\":182806.4,\"isin\":\"FR0010135103\",\"finalDate\":null,\"importCost\":170875.04,\"averageCost\":610.268,\"priceDate\":\"29-12-2016 00:00:00\",\"marketPrice\":182806.4,\"change\":null,\"groupContext\":\"stocks\",\"valIntr\":182806.4,\"pan\":null,\"pSafeKeep\":null},{\"reference\":7508884,\"name\":\"CREDIINVEST SICAV PROACTIVE PROTECTION I1 EUR\",\"posTypeId\":6000,\"posTypeDesc\":\"Fondo - estrategia\",\"accr\":\"-6.72\",\"costPrice\":9.5247,\"quantity\":5000.0,\"curry\":\"EUR\",\"consolidateQuantity\":47623.5,\"isin\":\"LU0908760829\",\"finalDate\":null,\"importCost\":51056.5,\"averageCost\":10.2113,\"priceDate\":\"30-12-2016 00:00:00\",\"marketPrice\":47623.5,\"change\":null,\"groupContext\":\"stocks\",\"valIntr\":47623.5,\"pan\":null,\"pSafeKeep\":null},{\"reference\":7182556,\"name\":\"ETHNA - AKTIV E-T\",\"posTypeId\":6000,\"posTypeDesc\":\"Fondo - estrategia\",\"accr\":\"-3.99\",\"costPrice\":127.92,\"quantity\":1270.0,\"curry\":\"EUR\",\"consolidateQuantity\":162458.4,\"isin\":\"LU0431139764\",\"finalDate\":null,\"importCost\":169205.25,\"averageCost\":133.2325,\"priceDate\":\"30-12-2016 00:00:00\",\"marketPrice\":162458.4,\"change\":null,\"groupContext\":\"stocks\",\"valIntr\":162458.4,\"pan\":null,\"pSafeKeep\":null}]}]},{\"id\":504124,\"name\":\"Gesti�n alternativa\",\"sum\":129363.03,\"valIntr\":129363.03,\"subCategories\":[{\"id\":504125,\"name\":\"Gesti�n alternativa\",\"sum\":129363.03,\"valIntr\":129363.03,\"positions\":[{\"reference\":8589577,\"name\":\"GAMCO MERGER ARBITRAGE-A EUR\",\"posTypeId\":1621,\"posTypeDesc\":\"Fondo - otro\",\"accr\":\"3.21\",\"costPrice\":11.2934,\"quantity\":10000.0,\"curry\":\"EUR\",\"consolidateQuantity\":112934.0,\"isin\":\"LU0687943661\",\"finalDate\":null,\"importCost\":109420.0,\"averageCost\":10.942,\"priceDate\":\"29-12-2016 00:00:00\",\"marketPrice\":112934.0,\"change\":null,\"groupContext\":\"stocks\",\"valIntr\":112934.0,\"pan\":null,\"pSafeKeep\":null},{\"reference\":6402415,\"name\":\"HEADSTART FOF SSP B1\",\"posTypeId\":1621,\"posTypeDesc\":\"Fondo - otro\",\"accr\":\"-53.74\",\"costPrice\":516.18,\"quantity\":2.7898,\"curry\":\"USD\",\"consolidateQuantity\":1366.13,\"isin\":\"000000622632\",\"finalDate\":null,\"importCost\":3113.09,\"averageCost\":1115.8829,\"priceDate\":\"30-09-2016 00:00:00\",\"marketPrice\":1440.04,\"change\":1.0541,\"groupContext\":null,\"valIntr\":1366.13,\"pan\":null,\"pSafeKeep\":null},{\"reference\":6402417,\"name\":\"INVESTCREDIT VALIRA CONSERVATIVE USD (A)\",\"posTypeId\":1621,\"posTypeDesc\":\"Fondo - otro\",\"accr\":\"-81.69\",\"costPrice\":0.7902,\"quantity\":11935.7505,\"curry\":\"USD\",\"consolidateQuantity\":8947.57,\"isin\":\"LU0352078645\",\"finalDate\":null,\"importCost\":51515.87,\"averageCost\":4.3161,\"priceDate\":\"30-09-2016 00:00:00\",\"marketPrice\":9431.63,\"change\":1.0541,\"groupContext\":\"stocks\",\"valIntr\":8947.57,\"pan\":null,\"pSafeKeep\":null},{\"reference\":6402416,\"name\":\"CREDIT FONS GESTIO ALT. DOLAR\",\"posTypeId\":1627,\"posTypeDesc\":\"Fondo - nuestros de otros activos\",\"accr\":\"-77.06\",\"costPrice\":0.9264,\"quantity\":6958.3049,\"curry\":\"USD\",\"consolidateQuantity\":6115.33,\"isin\":\"609104000000\",\"finalDate\":null,\"importCost\":28098.57,\"averageCost\":4.0381,\"priceDate\":\"30-11-2016 00:00:00\",\"marketPrice\":6446.17,\"change\":1.0541,\"groupContext\":\"stocks\",\"valIntr\":6115.33,\"pan\":null,\"pSafeKeep\":null}]}]},{\"id\":504127,\"name\":\"Capital privado\",\"sum\":137724.21,\"valIntr\":137724.21,\"subCategories\":[{\"id\":504128,\"name\":\"Capital privado\",\"sum\":137724.21,\"valIntr\":137724.21,\"positions\":[{\"reference\":8489949,\"name\":\"CA -SELECT PRIVATE EQ. SICAV-SIF  EUR\",\"posTypeId\":1621,\"posTypeDesc\":\"Fondo - otro\",\"accr\":\"7.56\",\"costPrice\":10.7563,\"quantity\":12500.0,\"curry\":\"EUR\",\"consolidateQuantity\":134453.75,\"isin\":\"LU1217286217\",\"finalDate\":null,\"importCost\":125000.0,\"averageCost\":10.0,\"priceDate\":\"30-09-2016 00:00:00\",\"marketPrice\":134453.75,\"change\":null,\"groupContext\":null,\"valIntr\":134453.75,\"pan\":null,\"pSafeKeep\":null},{\"reference\":6402598,\"name\":\"DELTA SPAIN S.A.R.L. (SICAR) - EMP\",\"posTypeId\":1848,\"posTypeDesc\":\"Producto estructurado (opciones)\",\"accr\":\"-53.99\",\"costPrice\":6.8598,\"quantity\":476.76,\"curry\":\"EUR\",\"consolidateQuantity\":3270.46,\"isin\":\"000002721622\",\"finalDate\":null,\"importCost\":7108.14,\"averageCost\":14.9093,\"priceDate\":\"30-12-2016 00:00:00\",\"marketPrice\":3270.46,\"change\":null,\"groupContext\":null,\"valIntr\":3270.46,\"pan\":null,\"pSafeKeep\":null}]}]}]}]},\"errors\":null}';
		CRAN_VEC_ADV_PortfolioRS_CLS responseRs = (CRAN_VEC_ADV_PortfolioRS_CLS)JSON.deserialize(jsonPruebaRs, CRAN_VEC_ADV_PortfolioRS_CLS.class);
		String jsonRequestRs = JSON.serialize(responseRs);
	}

	@isTest
	static void CRAN_VEC_ADV_ProcessBPCustomForm_TST() {
		CRAN_VEC_ADV_ProcessBPCustomFormRQ_CLS processRQ = new CRAN_VEC_ADV_ProcessBPCustomFormRQ_CLS();
		processRQ.setLang('es');
		processRQ.getLang();
		processRQ.setQuestType('type');
		processRQ.getQuestType();
		processRQ.setQuestVersion('version');
		processRQ.getQuestVersion();
		processRQ.setQuestStatus('status');
		processRQ.getQuestStatus();

		CRAN_VEC_ADV_ObjList_CLS element = new CRAN_VEC_ADV_ObjList_CLS();
		element.setObjType('type');
		element.getObjType();
		List<CRAN_VEC_ADV_Obj_CLS> listObj = new List<CRAN_VEC_ADV_Obj_CLS>();
		CRAN_VEC_ADV_Obj_CLS o = new CRAN_VEC_ADV_Obj_CLS();
		listObj.add(o);
		element.setObj(listObj);
		element.getObj();
		List<CRAN_VEC_ADV_ObjList_CLS> objList1 = new List<CRAN_VEC_ADV_ObjList_CLS>();
		objList1.add(element);
		processRQ.setObjList(objList1);
		processRQ.getObjList();

		String jsonPrueba = '{\"lang\":\"es\",\"objList\":[{\"obj\":[{\"avqId\":6287251,\"keyList\":[{\"value\":\"948554\",\"keyType\":\"sort_nr\"},{\"value\":\"4C12440\",\"keyType\":\"sort_alpha\"}]}],\"objType\":\"bp\"}],\"questType\":\"cran$advisory\",\"questVersion\":\"1.0\",\"questStatus\":\"hold\"}';
		CRAN_VEC_ADV_ProcessBPCustomFormRQ_CLS response = (CRAN_VEC_ADV_ProcessBPCustomFormRQ_CLS)JSON.deserialize(jsonPrueba, CRAN_VEC_ADV_ProcessBPCustomFormRQ_CLS.class);
		String jsonRequest = JSON.serialize(response);

		//CRAN_VEC_ADV_ProcessBPCustomFormRS_TST
		CRAN_VEC_ADV_ProcessBPCustomFormRS_CLS processRS = new CRAN_VEC_ADV_ProcessBPCustomFormRS_CLS();
		List<CRAN_VEC_ADV_ProcessSTError_CLS> errors = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
		processRS.setErrors(errors);
		processRS.getErrors();

		List<CRAN_VEC_ADV_ObjList_getForms_CLS> listForms = new List<CRAN_VEC_ADV_ObjList_getForms_CLS>();
		CRAN_VEC_ADV_ObjList_getForms_CLS objList = new CRAN_VEC_ADV_ObjList_getForms_CLS();
		objList.setObjType('objType');
		objList.getObjType();

		List<CRAN_VEC_ADV_Obj_getForms_CLS> objTemp = new List<CRAN_VEC_ADV_Obj_getForms_CLS>();
		CRAN_VEC_ADV_Obj_getForms_CLS temp = new CRAN_VEC_ADV_Obj_getForms_CLS();
		temp.setAvqId('avqId');
		temp.getAvqId();
		temp.setType('type');
		temp.getType();
		temp.setVersion('version');
		temp.getVersion();
		temp.setStatus('status');
		temp.getStatus();

		objTemp.add(temp);
		objList.setObj(objTemp);
		objList.getObj();

		listForms.add(objList);

		processRS.setObjList(listForms);
		processRS.getObjList();

	}

	@isTest
	static void CRAN_VEC_ADV_VerifyCustomFormRQ_TST() {
		CRAN_VEC_ADV_VerifyCustomFormRQ_CLS verifyRQ = new CRAN_VEC_ADV_VerifyCustomFormRQ_CLS();
		verifyRQ.setLang('es');
		verifyRQ.getLang();
		CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
		verifyRQ.setOrder(order);
		verifyRQ.getOrder();

		String jsonPrueba = '{\"order\":{\"isNew\":false,\"orderNr\":99485433},\"lang\":\"es\"}';
		CRAN_VEC_ADV_VerifyCustomFormRQ_CLS response = (CRAN_VEC_ADV_VerifyCustomFormRQ_CLS)JSON.deserialize(jsonPrueba, CRAN_VEC_ADV_VerifyCustomFormRQ_CLS.class);
		String jsonRequest = JSON.serialize(response);


		//CRAN_VEC_ADV_VerifyCustomFormRS_TST
		CRAN_VEC_ADV_VerifyCustomFormRS_CLS verifyRS = new CRAN_VEC_ADV_VerifyCustomFormRS_CLS();
		List<CRAN_VEC_ADV_ProcessSTError_CLS> errorS = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
		CRAN_VEC_ADV_ProcessSTError_CLS error = new CRAN_VEC_ADV_ProcessSTError_CLS();
		error.setCode('code');
		error.setDesc('desc');
		errors.add(error);
		verifyRS.setErrors(errors);
		verifyRS.getErrors();
		verifyRS.setAvisos('avisos');
		verifyRS.getAvisos();
		List<CRAN_VEC_ADV_ObjList_CLS> objList = new List<CRAN_VEC_ADV_ObjList_CLS>();
		verifyRS.setObjList(objList);
		verifyRS.getObjList();

		String jsonPruebaRs = '{\"objList\":[{\"obj\":[{\"avqId\":485433}],\"objType\":\"quest\"}],\"errores\":null,\"avisos\":null}';

		CRAN_VEC_ADV_VerifyCustomFormRS_CLS responseRs = (CRAN_VEC_ADV_VerifyCustomFormRS_CLS)JSON.deserialize(jsonPruebaRs, CRAN_VEC_ADV_VerifyCustomFormRS_CLS.class);

		String jsonRequestRs = JSON.serialize(responseRs);

	}

	@isTest
	static void CRAN_VEC_ADV_RenewCustomForm_TST() {

		CRAN_VEC_ADV_RenewCustomFormRQ_CLS reNewRQ = new CRAN_VEC_ADV_RenewCustomFormRQ_CLS();
		reNewRQ.setLang('es');
		reNewRQ.getLang();
		CRAN_VEC_ADV_ObjList_CLS element = new CRAN_VEC_ADV_ObjList_CLS();
		element.setObjType('type');
		element.getObjType();
		List<CRAN_VEC_ADV_Obj_CLS> listObj = new List<CRAN_VEC_ADV_Obj_CLS>();
		CRAN_VEC_ADV_Obj_CLS o = new CRAN_VEC_ADV_Obj_CLS();
		listObj.add(o);
		element.setObj(listObj);
		element.getObj();
		List<CRAN_VEC_ADV_ObjList_CLS> objList = new List<CRAN_VEC_ADV_ObjList_CLS>();
		objList.add(element);
		reNewRQ.setObjList(objList);
		reNewRQ.GetObjList();

		String jsonPrueba = '{\"objList\":[{\"obj\":[{\"avqId\":400916,\"keyList\":null}],\"objType\":\"bp\"},{\"obj\":[{\"avqId\":3343221,\"keyList\":null}],\"objType\":\"quest\"}],\"lang\":\"es\"}';

		CRAN_VEC_ADV_RenewCustomFormRQ_CLS response = (CRAN_VEC_ADV_RenewCustomFormRQ_CLS)JSON.deserialize(jsonPrueba, CRAN_VEC_ADV_RenewCustomFormRQ_CLS.class);

		String jsonRequest = JSON.serialize(response);


		//CRAN_VEC_ADV_RenewCustomFormRS_TST
		CRAN_VEC_ADV_RenewCustomFormRS_CLS reNewRS = new CRAN_VEC_ADV_RenewCustomFormRS_CLS();
		List<CRAN_VEC_ADV_ProcessSTError_CLS> errors = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();

		reNewRS.setErrors(errors);
		reNewRS.getErrors();

		CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
		reNewRS.setOrder(order);
		reNewRS.getOrder();

		String jsonPruebaRS = '{\"order\":{\"orderNr\":99485433,\"isNew\":true},\"avisos\":null,\"errores\":null}';

		CRAN_VEC_ADV_RenewCustomFormRS_CLS responseRS = (CRAN_VEC_ADV_RenewCustomFormRS_CLS)JSON.deserialize(jsonPruebaRS, CRAN_VEC_ADV_RenewCustomFormRS_CLS.class);

		String jsonRequestRS = JSON.serialize(responseRS);


	}


	@isTest
	static void CRAN_VEC_ADV_Portfolio_TST() {
		CRAN_VEC_ADV_PortfolioRQ_CLS portfolioRQ = new CRAN_VEC_ADV_PortfolioRQ_CLS();
		portfolioRQ.setDateTo('01/01/2017');
		portfolioRQ.getDateTo();
		portfolioRQ.setLang('es');
		portfolioRQ.getLang();

		List<CRAN_VEC_ADV_Portfolio_ObjAvaloq_CLS> objAvaloqList = new List<CRAN_VEC_ADV_Portfolio_ObjAvaloq_CLS>();

		CRAN_VEC_ADV_Portfolio_ObjAvaloq_CLS objAvaloq = new CRAN_VEC_ADV_Portfolio_ObjAvaloq_CLS();
		objAvaloq.setObjType('type');
		objAvaloq.getObjType();

		List<CRAN_VEC_ADV_Portfolio_id_CLS> idportfolioList = new List<CRAN_VEC_ADV_Portfolio_id_CLS>();
		CRAN_VEC_ADV_Portfolio_id_CLS idportfolio = new CRAN_VEC_ADV_Portfolio_id_CLS();

		idportfolio.setAvqId(2121);
		idportfolio.getAvqId();
		idportfolioList.add(idportfolio);
		objAvaloq.setObjLst(idportfolioList);
		objAvaloq.getObjLst();

		objAvaloqList.add(objAvaloq);
		portfolioRQ.setObjList(objAvaloqList);
		portfolioRQ.getObjList();

		//CRAN_VEC_ADV_PortfolioRS_TST
		CRAN_VEC_ADV_PortfolioRS_CLS portfolioRS = new CRAN_VEC_ADV_PortfolioRS_CLS();
		List<CRAN_VEC_ADV_ProcessSTError_CLS> errors = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
		CRAN_VEC_ADV_PorfGrandTotal_CLS grand = new CRAN_VEC_ADV_PorfGrandTotal_CLS();
		portfolioRS.setPorfGrandTotal(grand);
		portfolioRS.getPorfGrandTotal();

		portfolioRS.setErrors(errors);
		portfolioRS.getErrors();

		grand.setCurrValNoAccr(11);
		grand.getCurrValNoAccr();
		grand.setCurrVal(11);
		grand.getCurrVal();
		grand.setAllocParent(11);
		grand.getAllocParent();
		grand.getBp();

		List<CRAN_VEC_ADV_Portfolio_BpRS_CLS> listBp = new List<CRAN_VEC_ADV_Portfolio_BpRS_CLS>();

		CRAN_VEC_ADV_Portfolio_BpRS_CLS bp = new CRAN_VEC_ADV_Portfolio_BpRS_CLS();
		bp.setId(11);
		bp.getId();
		bp.setName('bpname');
		bp.getName();
		bp.setCurrValNoAccr(11);
		bp.getCurrValNoAccr();
		bp.setCurrVal(11);
		bp.getCurrVal();
		bp.setAllocParent(11);
		bp.getAllocParent();

		List<CRAN_VEC_ADV_Portfolio_Container_CLS> containers = new List<CRAN_VEC_ADV_Portfolio_Container_CLS>();
		CRAN_VEC_ADV_Portfolio_Container_CLS container = new CRAN_VEC_ADV_Portfolio_Container_CLS();
		container.setId(11);
		container.getId();
		container.setName('name');
		container.getName();
		container.setCurrValNoAccr(11);
		container.getCurrValNoAccr();
		container.setCurrVal(11);
		container.getCurrVal();
		container.setAllocParent(11);
		container.getAllocParent();
		container.setType('type');
		container.getType();


		List<CRAN_VEC_ADV_CategoriesLv1_CLS> categoriesLv1 = new List<CRAN_VEC_ADV_CategoriesLv1_CLS>();
		CRAN_VEC_ADV_CategoriesLv1_CLS categoryLv1 = new CRAN_VEC_ADV_CategoriesLv1_CLS();
		categoryLv1.setId(11);
		categoryLv1.getId();
		categoryLv1.setName('name');
		categoryLv1.getName();
		categoryLv1.setCurrValNoAccr(11);
		categoryLv1.getCurrValNoAccr();
		categoryLv1.setCurrVal(11);
		categoryLv1.getCurrVal();
		categoryLv1.setAllocParent(11);
		categoryLv1.getAllocParent();


		List<CRAN_VEC_ADV_CategoriesLv2_CLS> categoriesLv2 = new List<CRAN_VEC_ADV_CategoriesLv2_CLS>();

		CRAN_VEC_ADV_CategoriesLv2_CLS categoryLv2 = new CRAN_VEC_ADV_CategoriesLv2_CLS();

		categoryLv2.setId(11);
		categoryLv2.getId();
		categoryLv2.setName('name');
		categoryLv2.getName();
		categoryLv2.setCurrValNoAccr(11);
		categoryLv2.getCurrValNoAccr();
		categoryLv2.setCurrVal(11);
		categoryLv2.getCurrVal();
		categoryLv2.setAllocParent(11);
		categoryLv2.getAllocParent();


		List<CRAN_VEC_ADV_CategoriesLv3_CLS> categoriesLv3 = new List<CRAN_VEC_ADV_CategoriesLv3_CLS>();

		CRAN_VEC_ADV_CategoriesLv3_CLS categoryLv3 = new CRAN_VEC_ADV_CategoriesLv3_CLS();

		categoryLv3.setId(11);
		categoryLv3.getId();
		categoryLv3.setName('name');
		categoryLv3.getName();
		categoryLv3.setCurrValNoAccr(11);
		categoryLv3.getCurrValNoAccr();
		categoryLv3.setCurrVal(11);
		categoryLv3.getCurrVal();
		categoryLv3.setAllocParent(11);
		categoryLv3.getAllocParent();


		List<CRAN_VEC_ADV_Portfolio_Positions_CLS> positions = new List<CRAN_VEC_ADV_Portfolio_Positions_CLS>();
		CRAN_VEC_ADV_Portfolio_Positions_CLS position = new CRAN_VEC_ADV_Portfolio_Positions_CLS();

		position.setId(11);
		position.getId();
		position.setName('name');
		position.getName();
		position.setPercVar('posTypeDesc');
		position.getPercVar();
		position.setQuantity(11);
		position.getQuantity();
		position.setCurry('11');
		position.getCurry();
		position.setPSafeKeep('11');
		position.getPSafeKeep();
		position.setQuantity2(11);
		position.getQuantity2();
		position.setCurrPrice(11);
		position.getCurrPrice();
		position.setCurrValAssetCcy(11);
		position.getCurrValAssetCcy();
		position.setHistPrice(11);
		position.getHistPrice();
		position.setQtyHistPrice(11);
		position.getQtyHistPrice();
		position.setHistXrate(11);
		position.getHistXrate();
		position.setCurrXrate(11);
		position.getCurrXrate();
		position.setCurrValNoAccr(11);
		position.getCurrValNoAccr();
		position.setYtm(11);
		position.getYtm();
		position.setCurrVal(11);
		position.getCurrVal();
		position.setAllocParent(11);
		position.getAllocParent();


		List<CRAN_VEC_ADV_Asset_CLS> assets = new List<CRAN_VEC_ADV_Asset_CLS>();
		CRAN_VEC_ADV_Asset_CLS asset = new CRAN_VEC_ADV_Asset_CLS();
		asset.setAssetID(1233);
		asset.getAssetID();
		asset.setCranCode(1233);
		asset.getCranCode();
		asset.setAssetBU(1234);
		asset.getAssetBU();

		assets.add(asset);
		position.setAssets(assets);
		position.getAssets();

		positions.add(position);


		categoryLv3.setPositions(positions);
		categoryLv3.getPositions();

		categoriesLv3.add(categoryLv3);

		categoriesLv2.add(categoryLv2);
		categoryLv2.setcategoriesLv3(categoriesLv3);
		categoryLv2.getcategoriesLv3();

		categoryLv1.setCategoriesLv2(categoriesLv2);
		categoryLv1.getCategoriesLv2();

		categoriesLv1.add(categoryLv1);
		container.setCategoriesLv1(categoriesLv1);
		container.getCategoriesLv1();

		containers.add(container);

		bp.setContainers(containers);
		bp.getContainers();

		listBp.add(bp);
		grand.setBp(listBp);
	}


	@isTest
	static void CRAN_VEC_ADV_GenericAvaloqRequest_TST() {
		CRAN_VEC_ADV_GenericAvaloqRequest  temp = new CRAN_VEC_ADV_GenericAvaloqRequest();
		temp.getCodAppOrigin();
		temp.getCodModAppOrigin();
		temp.getCodEnv();

	}


	@isTest
	static void CRAN_VEC_ADV_BatchDeleteCFResponse_TST() {

		CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact c = dataFactory.createIndividualContactWithTwoBps();

		CRAN_VEC_ADV_CustomForm__c cf = dataFactory.create_CustomForm_TemplatePF();
		CRAN_VEC_ADV_CustomForm_Response__c cfr = dataFactory.addCustomFormResponseBatch(cf.Id, c.Id);

		dataFactory.createAvaloqSetting();

		List<CRAN_VEC_ADV_CustomForm_Response__c> myResponses = [SELECT    Id,
		                                          Name,
		                                          CreatedDate,
		                                          CRAN_VEC_ADV_P_Acceptance_Status__c,
		                                          CRAN_VEC_ADV_MD_CustomForm__c,
		                                          CRAN_VEC_ADV_L_Contact__c,
		                                          CRAN_VEC_ADV_L_Contact__r.Name,
		                                          CRAN_VEC_ADV_T_Avaloq_ID__c
		                                          FROM CRAN_VEC_ADV_CustomForm_Response__c ];


		List<CRAN_VEC_ADV_CustomForm__c> myCustom = [SELECT    Id, Name FROM CRAN_VEC_ADV_CustomForm__c ];

		String myId = myCustom[0].Id;

		List<CRAN_VEC_ADV_CustomForm_Response__c> consult = [SELECT Id, CRAN_VEC_ADV_T_Bu_Id__c, CRAN_VEC_ADV_T_Avaloq_External_Id__c FROM CRAN_VEC_ADV_CustomForm_Response__c WHERE CRAN_VEC_ADV_P_Acceptance_Status__c = 'On Hold' and CRAN_VEC_ADV_MD_CustomForm__c = :myId order by CRAN_VEC_ADV_DT_StartDate__c desc];

		Test.setMock(HTTPCalloutMock.class, new CRAN_VEC_ADV_AvaloqMockWS_TST(CRAN_VEC_ADV_Constants_CLS.SERVICE_DESCARTAR_ORDEN));
		Test.startTest();
		CRAN_VEC_ADV_BatchDeleteCFResponse_CLS batchDelete = new CRAN_VEC_ADV_BatchDeleteCFResponse_CLS(myCustom[0].Id);
		Database.executeBatch(batchDelete);
		Test.stopTest();
	}


	@isTest
	static void CRAN_VEC_ADV_BatchDeleteCFError_TST() {

		CRAN_VEC_ADV_BatchDeleteCFResponse_CLS batchDelete = new CRAN_VEC_ADV_BatchDeleteCFResponse_CLS('');

		CRAN_VEC_ADV_BatchDeleteCFResponse_CLS.CRAN_VEC_ADV_deleteError temp = new CRAN_VEC_ADV_BatchDeleteCFResponse_CLS.CRAN_VEC_ADV_deleteError();

		temp.getIdSalesforce();
		temp.getIdAvaloqOrder();
		temp.getErrorMessageAvaloqr();
		temp.getErrorMessageSF();
		temp.setIdAvaloqOrder('');
		temp.setErrorMessageAvaloq('');
		temp.setErrorMessageSF('');

				/*public void setIdSalesforce(ID idSalesforce){
				this.idSalesforce = idSalesforce;
			}*/

	}




	@isTest
	static void CRAN_VEC_ADV_CalcRebalpRQ_TST() {

		CRAN_VEC_ADV_CalcRebalpRQ rq = new CRAN_VEC_ADV_CalcRebalpRQ();

		rq.setLang('');
		rq.getLang();
		rq.setPrintMode('');
		rq.getPrintMode();
		CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
		order.setOrderNr('');
		order.getOrderNr();
		order.setIsNew(true);
		order.getIsNew();
		rq.setOrder(order);

		CRAN_VEC_ADV_CalcRebalpVersion version = new CRAN_VEC_ADV_CalcRebalpVersion();
		List<CRAN_VEC_ADV_CalcRebalpRestriction> restrList = new List<CRAN_VEC_ADV_CalcRebalpRestriction>();
		CRAN_VEC_ADV_CalcRebalpRestriction rest = new CRAN_VEC_ADV_CalcRebalpRestriction();
		rest.setId('');
		rest.getId();
		rest.setOverride(true);
		rest.getOverride();
		rest.setJustif('');
		rest.getJustif();

		restrList.add(rest);

		version.setRestrList(restrList);

		version.setIsFinal(true);
		version.getIsFinal();
		version.setName('');
		version.getName();
		version.setId('');
		version.getId();
		version.setInvstAmount(124);
		version.getInvstAmount();
		version.setInvstCurry('');
		version.getInvstCurry();

		List<CRAN_VEC_ADV_CalcRebalpNodeList> nodeList = new List<CRAN_VEC_ADV_CalcRebalpNodeList>();
		CRAN_VEC_ADV_CalcRebalpNodeList node = new CRAN_VEC_ADV_CalcRebalpNodeList();
		List<CRAN_VEC_ADV_CalcRebalpNode> elemen = new List<CRAN_VEC_ADV_CalcRebalpNode>();
		CRAN_VEC_ADV_CalcRebalpNode aux = new CRAN_VEC_ADV_CalcRebalpNode();

		aux.setCranCode('');
		aux.getCranCode();
		aux.setAssetId('');
		aux.getAssetId();
		aux.setAssetBuId('');
		aux.getAssetBuId();
		aux.setCpfQty('');
		aux.getCpfQty();
		aux.setCpfMktVal('');
		aux.getCpfMktVal();
		aux.setCpfPerc('');
		aux.getCpfPerc();
		aux.setRemark('');
		aux.getRemark();
		CRAN_VEC_ADV_CalcRebalpNodeId nodeId = new CRAN_VEC_ADV_CalcRebalpNodeId();
		nodeId.setNodeType('');
		nodeId.getNodeType();
		nodeId.setValue('');
		nodeId.getValue();
		aux.setNodeId(nodeId);				
		aux.getNodeId();

		elemen.add(aux);

		node.setNode(elemen);
		node.getNode();

		nodeList.add(node);

		version.setNodeList(nodeList);
		version.getNodeList();

		List<CRAN_VEC_ADV_CalcRebalpVersion> myList = new List<CRAN_VEC_ADV_CalcRebalpVersion>();
		myList.add(version);
		rq.setVersionList(myList);
		rq.getVersionList();

	}


	@isTest
	static void CRAN_VEC_ADV_CalcRebalpRS_TST() {

		CRAN_VEC_ADV_CalcRebalpRS rq = new CRAN_VEC_ADV_CalcRebalpRS();
		CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
		order.setOrderNr('');
		order.getOrderNr();
		order.setIsNew(true);
		order.getIsNew();
		rq.setOrder(order);
		rq.getOrder();


		List<CRAN_VEC_ADV_CalcRebalpVersionRS> versionList = new List<CRAN_VEC_ADV_CalcRebalpVersionRS>();
		CRAN_VEC_ADV_CalcRebalpVersionRS version = new CRAN_VEC_ADV_CalcRebalpVersionRS();
		version.setIsFinal('');
		version.getIsFinal();
		version.setName('');
		version.getName();
		version.setId('');
		version.getId();
		version.setInvstAmount(12);
		version.getInvstAmount();
		version.setInvstCurry('');
		version.getInvstCurry();
	
		CRAN_VEC_ADV_CalcRebalpNodeRS node = new CRAN_VEC_ADV_CalcRebalpNodeRS();
		CRAN_VEC_ADV_CalcRebalpNodeDet nodeDet = new CRAN_VEC_ADV_CalcRebalpNodeDet();

		nodeDet.setAssetId('');
		nodeDet.getAssetId();
		nodeDet.setCranCode('');
		nodeDet.getCranCode();
		nodeDet.setName('');
		nodeDet.getName();
		nodeDet.setAssetBuId('');
		nodeDet.getAssetBuId();	
		nodeDet.setRestrInfo('');
		nodeDet.getRestrInfo();	
		nodeDet.setRestrIcon('');
		nodeDet.getRestrIcon();	
		nodeDet.setPrice(23);
		nodeDet.getPrice();	
		nodeDet.setCurry('');
		nodeDet.getCurry();	
		nodeDet.setRat('');
		nodeDet.getRat();			
		nodeDet.setCpfQty(12);
		nodeDet.getCpfQty();
		nodeDet.setSpfQty(12);
		nodeDet.getSpfQty();	
		nodeDet.setCpfAccr(12);
		nodeDet.getCpfAccr();
		nodeDet.setSpfAccr(12);
		nodeDet.getSpfAccr();		
		nodeDet.setCpfMktVal(12);
		nodeDet.getCpfMktVal();	
		nodeDet.setSpfMktVal(12);
		nodeDet.getSpfMktVal();			
		nodeDet.setCpfPerc(12);
		nodeDet.getCpfPerc();	
		nodeDet.setSpfPerc(12);
		nodeDet.getSpfPerc();
		nodeDet.setMpfPerc(12);
		nodeDet.getMpfPerc();
		nodeDet.setExtl(true);
		nodeDet.getExtl();
		nodeDet.setAggrPos(true);
		nodeDet.getAggrPos();
		nodeDet.setRemark('');
		nodeDet.getRemark();
		nodeDet.setIsEdit(true);
		nodeDet.getIsEdit();		


		CRAN_VEC_ADV_CalcRebalpNodeId nodeId = new CRAN_VEC_ADV_CalcRebalpNodeId();
		nodeId.setNodeType('');
		nodeId.getNodeType();
		nodeId.setValue('');
		nodeId.getValue();
		nodeDet.setNodeId(nodeId);

		node.setNodeDet(nodeDet);

		/**/
		List<CRAN_VEC_ADV_CalcRebalpNodeListRS> nodeList = new List<CRAN_VEC_ADV_CalcRebalpNodeListRS>();
		CRAN_VEC_ADV_CalcRebalpNodeListRS nodeElem = new CRAN_VEC_ADV_CalcRebalpNodeListRS();
		nodeElem.setNodeList(nodeList);



		nodeList.add(nodeElem);
		node.setNodeList(nodeList);
		node.getNodeList();
		/**/


		List<CRAN_VEC_ADV_CalcRebalpRestrictionRS> restrList = new List<CRAN_VEC_ADV_CalcRebalpRestrictionRS>();
		CRAN_VEC_ADV_CalcRebalpRestrictionRS rest = new CRAN_VEC_ADV_CalcRebalpRestrictionRS();
		rest.setId('');
		rest.getId();		
		rest.setName('');
		rest.getName();		
		rest.setTypeName('');
		rest.getTypeName();		
		rest.setTopRestr('');
		rest.getTopRestr();				
		rest.setEvalResult('');
		rest.getEvalResult();			
		rest.setRemark('');
		rest.getRemark();				
		rest.setViolObj('');
		rest.getViolObj();		
		rest.setViolClass('');
		rest.getViolClass();			
		rest.setViolValue('');
		rest.getViolValue();		
		rest.setValueFrom('');
		rest.getValueFrom();		
		rest.setValueTo('');
		rest.getValueTo();		
		rest.setPrio('');
		rest.getPrio();		
		rest.setOverrideRestr(true);
		rest.getOverrideRestr();		
		rest.setJustif('');
		rest.getJustif();			
	
		restrList.add(rest);

		version.setRestrList(restrList);

		//rq.setNode(node);
		versionList.add(version);
		rq.setVersionList(versionList);
		rq.getVersionList();
	

		List<CRAN_VEC_ADV_ProcessSTError_CLS> errors = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
		CRAN_VEC_ADV_ProcessSTError_CLS error = new CRAN_VEC_ADV_ProcessSTError_CLS();
		error.setCode('');
		error.getCode();
		error.getDesc();
		error.setDesc('');

		rq.setErrors(errors);
		rq.getErrors();


	}

	@isTest static void CRAN_VEC_ADV_SignContractRQ_TST() {
		CRAN_VEC_ADV_SignContractRQ rq = new CRAN_VEC_ADV_SignContractRQ();
		List<CRAN_VEC_ADV_Portfolio_ObjAvaloq_CLS> listAva = new List<CRAN_VEC_ADV_Portfolio_ObjAvaloq_CLS>();
		rq.setLang('spanish');
		rq.getLang();
		rq.getObjList();
		CRAN_VEC_ADV_ObjList_CLS objList = new CRAN_VEC_ADV_ObjList_CLS();
		rq.setObjList(objList);
		rq.getKeyValue(); 
		CRAN_VEC_ADV_SignContractKeyValue keyValue = new CRAN_VEC_ADV_SignContractKeyValue();
		keyValue.getKeyType();
		keyValue.setKeyType('');
		keyValue.getValue();
		keyValue.setValue('');

		rq.setKeyValue(keyValue);
		rq.getSigntDate();
		rq.setSigntDate('');	
	}

	@isTest 
	static void CRAN_VEC_ADV_RebalpDetRQ_TST() {
		CRAN_VEC_ADV_RebalpDetRQ_CLS rq = new CRAN_VEC_ADV_RebalpDetRQ_CLS();
		rq.lang = 'es';
		CRAN_VEC_ADV_Order_CLS myOrder = new CRAN_VEC_ADV_Order_CLS();
		myOrder.setOrderNr ('');
		myOrder.getOrderNr ();
		myOrder.setIsNew(true);
		myOrder.getIsNew();
		rq.order = myOrder;
	}

	@isTest 
	static void CRAN_VEC_ADV_WaitSignRS_TST() {
		CRAN_VEC_ADV_WaitSignRS_CLS rq = new CRAN_VEC_ADV_WaitSignRS_CLS();
		rq.omsId = '';
		CRAN_VEC_ADV_Order_CLS myOrder = new CRAN_VEC_ADV_Order_CLS();
		myOrder.setOrderNr ('');
		myOrder.getOrderNr ();
		myOrder.setIsNew(true);
		myOrder.getIsNew();
		rq.order = myOrder;

		List<CRAN_VEC_ADV_ProcessSTError_CLS> errors = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
		CRAN_VEC_ADV_ProcessSTError_CLS error = new CRAN_VEC_ADV_ProcessSTError_CLS();
		errors.add(error);
		rq.errors = errors;
	}


	@isTest 
	static void CRAN_VEC_ADV_WaitSignRQ_TST() {
		CRAN_VEC_ADV_WaitSignRQ_CLS rq = new CRAN_VEC_ADV_WaitSignRQ_CLS();
		rq.lang = 'es';
		CRAN_VEC_ADV_Order_CLS myOrder = new CRAN_VEC_ADV_Order_CLS();
		myOrder.setOrderNr ('');
		myOrder.getOrderNr ();
		myOrder.setIsNew(true);
		myOrder.getIsNew();
		rq.order = myOrder;
	}

	@isTest 
	static void CRAN_VEC_ADV_RebalpListRS_TST() {
		CRAN_VEC_ADV_RebalpList_RS rq = new CRAN_VEC_ADV_RebalpList_RS();
		List<CRAN_VEC_ADV_RebalpList_RS.Proposal> rebalPropList = new List<CRAN_VEC_ADV_RebalpList_RS.Proposal>();
		
		CRAN_VEC_ADV_RebalpList_RS.Proposal proposal = new CRAN_VEC_ADV_RebalpList_RS.Proposal();
		proposal.bpId = '';
        proposal.contId = '';
		proposal.propStatusId = '';
		proposal.propDate = '';
		proposal.propOrderNr = '';
		proposal.propDesc = '';
		proposal.propInvMeth = '';
		proposal.propCurry = '';
		proposal.propAmount = '';
		List<CRAN_VEC_ADV_RebalpList_RS.OrderItem> refOrderList = new List<CRAN_VEC_ADV_RebalpList_RS.OrderItem>();
		CRAN_VEC_ADV_RebalpList_RS.OrderItem temp = new CRAN_VEC_ADV_RebalpList_RS.OrderItem();

	 	temp.orderNr = '';
		temp.metaType = '';
		temp.type = '';
		temp.orderStatusId = '';
		temp.orderStatus = '';
		temp.orderPrcEstim = 12;
		temp.orderQty = 12;
		temp.orderTrxDate = '';
		temp.apprAmount = 12;
		temp.omsId = '';
		CRAN_VEC_ADV_RebalpList_RS.AssetItem aux = new CRAN_VEC_ADV_RebalpList_RS.AssetItem();
		aux.assetName = '';
		aux.isin = '';
		aux.assetType ='';
		aux.assetRefCurry = '';
		temp.assetItem = aux;

		refOrderList.add(temp);
		proposal.refOrderList = refOrderList;

		rq.rebalPropList = rebalPropList;

		List<CRAN_VEC_ADV_ProcessSTError_CLS> errors = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
		CRAN_VEC_ADV_ProcessSTError_CLS error = new CRAN_VEC_ADV_ProcessSTError_CLS();
		errors.add(error);
		rq.errors = errors;
	}

	@isTest 
	static void CRAN_VEC_ADV_NewRebalpRQ_TST() {
		CRAN_VEC_ADV_NewRebalpRQ rq = new CRAN_VEC_ADV_NewRebalpRQ();
		rq.setLang('es');
		rq.getLang();
		rq.setRebalMethod('');
		rq.getRebalMethod();
		rq.setInvstAmount('');
		rq.getInvstAmount();
		rq.setInvstCurry('');
		rq.getInvstCurry();
		
		List<CRAN_VEC_ADV_ObjList_CLS> objList = new List<CRAN_VEC_ADV_ObjList_CLS>();
		CRAN_VEC_ADV_ObjList_CLS temp = new CRAN_VEC_ADV_ObjList_CLS();

		temp.setObjType('');
		temp.getObjType();
		List<CRAN_VEC_ADV_Obj_CLS> obj = new List<CRAN_VEC_ADV_Obj_CLS>();
		CRAN_VEC_ADV_Obj_CLS aux = new CRAN_VEC_ADV_Obj_CLS();
		aux.setAvqId('');
		aux.getAvqId();
		obj.add(aux);

		temp.setObj(obj);
		temp.getObj();

		objList.add(temp);
		rq.setObjList(objList);

		rq.getObjList();
	}


	@isTest 
	static void CRAN_VEC_ADV_ObjRS_TST() {
		CRAN_VEC_ADV_ObjRS_CLS rq = new CRAN_VEC_ADV_ObjRS_CLS();
		rq.setAvqId('');
		rq.getAvqId();
		List<CRAN_VEC_ADV_keyList_CLS> keyList = new List<CRAN_VEC_ADV_keyList_CLS>();
		CRAN_VEC_ADV_keyList_CLS key = new CRAN_VEC_ADV_keyList_CLS();
		key.setKeyType('');
		key.getKeyType();
		key.setValue('');
		key.getValue();
		keyList.add(key);
		rq.setKeyList(keyList);
		rq.getKeyList();
	}

	@isTest 
	static void CRAN_VEC_ADV_Trade_TST() {
		CRAN_VEC_ADV_Trade_CLS temp = new CRAN_VEC_ADV_Trade_CLS();
		temp.warning = '';
		temp.estimQty = '';
		temp.effQty = '';
		temp.assetId = '';
		temp.assetBuId = '';
		temp.assetName = '';
		temp.price = '';
		temp.curry = '';
		temp.marketId = '';
		temp.marketBuId = '';
		temp.marketName = '';
		temp.amount = '';
		temp.cost = '';
		temp.maccId = '';
		temp.maccName = '';
		temp.mnyDrv = '';
		temp.gen = '';
		temp.extl = '';
		temp.aggrPos = '';			
	}

	@isTest 
	static void CRAN_VEC_ADV_RebalpDetRS_TST() {
		CRAN_VEC_ADV_RebalpDetRS_CLS rq = new CRAN_VEC_ADV_RebalpDetRS_CLS();

		CRAN_VEC_ADV_Order_CLS myOrder = new CRAN_VEC_ADV_Order_CLS();
		myOrder.setOrderNr ('');
		myOrder.getOrderNr ();
		myOrder.setIsNew(true);
		myOrder.getIsNew();
		rq.order = myOrder;
		rq.status = '';
		rq.statusId = 122;

		List<CRAN_VEC_ADV_CalcRebalpVersionRS> versionList = new List<CRAN_VEC_ADV_CalcRebalpVersionRS>();
		CRAN_VEC_ADV_CalcRebalpVersionRS version = new CRAN_VEC_ADV_CalcRebalpVersionRS();
		version.setIsFinal('');
		version.getIsFinal();
		version.setName('');
		version.getName();
		version.setId('');
		version.getId();
		version.setInvstAmount(12);
		version.getInvstAmount();
		version.setInvstCurry('');
		version.getInvstCurry();
		version.setOmsId('');
		version.getOmsId();

		versionList.add(version);
		rq.setVersionList(versionList);
		rq.getVersionList();

		List<CRAN_VEC_ADV_ProcessSTError_CLS> errors = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
		CRAN_VEC_ADV_ProcessSTError_CLS error = new CRAN_VEC_ADV_ProcessSTError_CLS();
		errors.add(error);
		rq.errors = errors;

	}			

	@isTest 
	static void CRAN_VEC_ADV_RebalpRS_TST() {
		CRAN_VEC_ADV_RebalpRS temp = new CRAN_VEC_ADV_RebalpRS();
		temp.setStatus('');
		temp.getStatus();
		CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
		temp.setOrder(order);
		temp.getOrder();
		List<CRAN_VEC_ADV_ProcessSTError_CLS> errors = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
		temp.setErrors(errors);
		temp.getErrors();	
	}

 	@isTest 
	static void CRAN_VEC_ADV_RebalpRQ_TST() {
		CRAN_VEC_ADV_RebalpRQ temp = new CRAN_VEC_ADV_RebalpRQ();
		temp.setLang('');
		temp.getLang();
		CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
		temp.setOrder(order);
		temp.getOrder();
	}

	@isTest 
	static void CRAN_VEC_ADV_ExecRebalRS_TST() {
		CRAN_VEC_ADV_ExecRebalpRS_CLS temp = new CRAN_VEC_ADV_ExecRebalpRS_CLS();
		temp.orderNr= '';
		//List<CRAN_VEC_ADV_ExecRebalpRS_CLS.CRAN_VEC_ADV_TransListRS_CLS> transList = new List<CRAN_VEC_ADV_ExecRebalpRS_CLS.CRAN_VEC_ADV_TransListRS_CLS>();

		/*CRAN_VEC_ADV_ExecRebalpRS_CLS.CRAN_VEC_ADV_TransListRS_CLS trans = new CRAN_VEC_ADV_ExecRebalpRS_CLS.CRAN_VEC_ADV_TransListRS_CLS();
		trans.orderNr = '';
		trans.metaType = '';
		trans.assetType = '';
		trans.propName = '';
		trans.orderType = '';
		trans.type ='';
		trans.orderStatus ='';*/
		CRAN_VEC_ADV_ExecRebalpRS_CLS.CRAN_VEC_ADV_AssetItem assetItem = new CRAN_VEC_ADV_ExecRebalpRS_CLS.CRAN_VEC_ADV_AssetItem();
		assetItem.assetName ='';
		assetItem.assetId ='';
		assetItem.assetBuId ='';
		assetItem.isin ='';
		assetItem.assetType ='';
		assetItem.assetRefCurry ='';
		//trans.assetItem = assetItem;
		/*trans.price = 1;
		trans.amount = 1;
		trans.var ='';
		trans.sellAmount = 1;
		trans.sellCurry ='';
		trans.buyAmount = 1;
		trans.buyCurry ='';
		trans.xrateType = 1;
		transList.add(trans);*/
		//temp.transList = transList;

		//List<CRAN_VEC_ADV_ExecRebalpRS_CLS.CRAN_VEC_ADV_ExecutedOrderList_CLS> executedOrderList = new List<CRAN_VEC_ADV_ExecRebalpRS_CLS.CRAN_VEC_ADV_ExecutedOrderList_CLS>();
		/*CRAN_VEC_ADV_ExecRebalpRS_CLS.CRAN_VEC_ADV_ExecutedOrderList_CLS executedOrder = new CRAN_VEC_ADV_ExecRebalpRS_CLS.CRAN_VEC_ADV_ExecutedOrderList_CLS();
		executedOrder.orderNr = '';
		executedOrder.metaType = '';
		executedOrder.type = '';
		executedOrder.asset = '';
		executedOrder.price = 1;
		executedOrder.qty = 1;
		executedOrder.orderType = '';
		executedOrder.amount = 1;
		executedOrder.omsId = 1;
		executedOrder.sellAmount = 1;
		executedOrder.sellCurry = '';
		executedOrder.buyAmount = 1;
		executedOrder.buyCurry = '';
		executedOrder.xrateType = 1;

		executedOrderList.add(executedOrder);*/
		//temp.executedOrderList = executedOrderList;
		List<CRAN_VEC_ADV_CalcRebalpRestrictionRS> restrList = new List<CRAN_VEC_ADV_CalcRebalpRestrictionRS>();
		//temp.restrList = restrList;
		List<CRAN_VEC_ADV_ProcessSTError_CLS> errors = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
		temp.errors = errors;
	}
}