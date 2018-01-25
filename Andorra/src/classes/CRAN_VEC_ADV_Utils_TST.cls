@isTest
private class CRAN_VEC_ADV_Utils_TST {

	@isTest static void CRAN_VEC_ADV_Utils_Test() {
		String temp = '6_6803099';
		String sol = CRAN_VEC_ADV_Utils.getIdAvaloq(temp);
		String sol1 = CRAN_VEC_ADV_Utils.getBUAvaloq(temp);
		temp = '_6803099';
		sol = CRAN_VEC_ADV_Utils.getIdAvaloq(temp);
		sol1 = CRAN_VEC_ADV_Utils.getBUAvaloq(temp);
	}

	@isTest
	static void CRAN_VEC_ADV_Utils_stringToDate_001_Test() {
		String format = 'dd/MM/yyyy';
		Datetime dOrigin = Date.newInstance(2017, 05, 12);
		String value = dOrigin.format(format);
		System.debug('Value: ' + value);
		Date dConverted = CRAN_VEC_ADV_Utils.stringToDate(value, format);
		System.assertEquals(dOrigin, dConverted);
	}

	@isTest
	static void CRAN_VEC_ADV_Utils_stringToDate_002_Test() {
		String format = 'dd-MM-yyyy';
		Datetime dOrigin = Date.newInstance(2017, 05, 12);
		String value = dOrigin.format(format);
		System.debug('Value: ' + value);
		Date dConverted = CRAN_VEC_ADV_Utils.stringToDate(value, format);
		System.assertEquals(dOrigin, dConverted);
	}

	@isTest
	static void CRAN_VEC_ADV_Utils_stringToDate_003_Test() {
		String format = 'MM-dd-yyyy';
		Datetime dOrigin = Date.newInstance(2017, 05, 12);
		String value = dOrigin.format(format);
		System.debug('Value: ' + value);
		Date dConverted = CRAN_VEC_ADV_Utils.stringToDate(value, format);
		System.assertEquals(dOrigin, dConverted);
	}

	@isTest
	static void CRAN_VEC_ADV_Utils_stringToDate_004_Test() {
		String format = 'MM/dd/yyyy';
		Datetime dOrigin = Date.newInstance(2017, 05, 12);
		String value = dOrigin.format(format);
		System.debug('Value: ' + value);
		Date dConverted = CRAN_VEC_ADV_Utils.stringToDate(value, format);
		System.assertEquals(dOrigin, dConverted);
	}

	@isTest
	static void CRAN_VEC_ADV_Utils_stringToDate_ExceptionFormat_Test() {
		String format = 'MM#dd#yyyy';
		Datetime dOrigin = Date.newInstance(2017, 05, 12);
		String value = dOrigin.format(format);
		System.debug('Value: ' + value);
		try {
			Date dConverted = CRAN_VEC_ADV_Utils.stringToDate(value, format);
		} catch (Exception e) {
		}
	}

	@isTest
	static void CRAN_VEC_ADV_Utils_stringToTime_Test() {
		try {
			CRAN_VEC_ADV_Utils.stringToTime('12:23:34', 'HH:mm:ss');
			CRAN_VEC_ADV_Utils.stringToTime('12.23.34', 'HH.mm.ss');
			CRAN_VEC_ADV_Utils.stringToTime('12:23:34', 'HHmmss');
			CRAN_VEC_ADV_Utils.stringToTime('122334', 'xx');
		} catch (Exception e) {
		}
	}

	/*@isTest
	static void CRAN_VEC_ADV_Utils_stringToDateTime_Test() {
		try{
			CRAN_VEC_ADV_Utils.stringToDatetime('12/12/2012','dd/MM/yyyy ');
			CRAN_VEC_ADV_Utils.stringToDatetime('12/12/2012T','dd/MM/yyyyT ');
			CRAN_VEC_ADV_Utils.stringToDatetime('2012-12-21 12:12:12','yyyy-MM-dd HH:mm:ss');
			CRAN_VEC_ADV_Utils.stringToDatetime('2012-12-21T12:12:12','yyyy-MM-ddTHH:mm:ss');
			CRAN_VEC_ADV_Utils.stringToDatetime('2012-12-21T12:12:12','yyyy-MM');
		}catch(Exception e){

		}
	}	*/

	@isTest
	static void CRAN_VEC_ADV_Utils_FormatNumber_Test() {
		try {
			CRAN_VEC_ADV_Utils.formatNumber('4321', 0);
			CRAN_VEC_ADV_Utils.formatNumber('-1234564', 0);
			CRAN_VEC_ADV_Utils.formatNumber('123456.99', 2);
			CRAN_VEC_ADV_Utils.formatNumber('-12345678.9', 2);
			CRAN_VEC_ADV_Utils.formatNumber('-0.1', 2);
		} catch (Exception e) {
		}
	}

	@isTest
	static void CRAN_VEC_ADV_Utils_getAllErrors_Test() {
		List<CRAN_VEC_ADV_ProcessSTError_CLS> errors = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
		List<CRAN_VEC_ADV_ProcessSTError_CLS> errorsTwo = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
		CRAN_VEC_ADV_ProcessSTError_CLS error = new CRAN_VEC_ADV_ProcessSTError_CLS();
		errors.add(error);
		errorsTwo.add(error);
		errorsTwo.add(error);
		CRAN_VEC_ADV_Utils.getAllErrorsService(errors);
		CRAN_VEC_ADV_Utils.getAllErrorsService(errorsTwo);
	}

	@isTest
	static void CRAN_VEC_ADV_Utils_RelatedBpsFr_Test() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFctory = new CRAN_VEC_ADV_TestDataFactory_TST();
		Contact c = dataFctory.createIndividualContact();
		CRAN_VEC_ADV_Utils.getRelatedBpsFromContactIDConvert(c.Id);
	}

	@isTest
	static void saveAndDeleteContentDocumentTest() {
		CRAN_VEC_ADV_Utils.saveContentVersion('JVBERi0xLjQKJeLjz9MKMyAwIG9iaiA8PC9MZW5ndGggNDQvRmlsdGVyL0ZsYXRlRGVjb2RlPj5zdHJlYW0KeNor5DJQMFDI5TK1NNUzMjcDsnPgbAsTQz0LS6CAAYKZwRWukMcFACXdCs4KZW5kc3R','test');
		CRAN_VEC_ADV_Utils.deleteContentDocument('test');
	}

	@isTest
	static void checkOrderManualConfirmTest_nullResponse() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFctory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFctory.createOrdersManualConfirm();
		System.assert(!CRAN_VEC_ADV_Utils.checkOrderManualConfirm('','',''));
	}

	@isTest
	static void checkOrderManualConfirmTest_STEX_FALSE() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFctory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFctory.createOrdersManualConfirm();
		System.assert(!CRAN_VEC_ADV_Utils.checkOrderManualConfirm('STEX','',''));
	}
	@isTest
	static void checkOrderManualConfirmTest_FOREX_TRUE() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFctory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFctory.createOrdersManualConfirm();
		System.assert(CRAN_VEC_ADV_Utils.checkOrderManualConfirm('FXTR','',''));
	}
	@isTest
	static void checkOrderManualConfirmTest_STEX_TRUE() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFctory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFctory.createOrdersManualConfirm();
		System.assert(CRAN_VEC_ADV_Utils.checkOrderManualConfirm('STEX','','504783'));
	}

	@isTest
	static void checkOrderManualConfirmTest_STEX_INSTR() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFctory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFctory.createOrdersManualConfirmInstr();
		System.assert(CRAN_VEC_ADV_Utils.checkOrderManualConfirm('STEX','7789',''));
	}

	@isTest
	static void checkOrderManualConfirmTest_STEX_ALL() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFctory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFctory.createOrdersManualConfirmStex();
		System.assert(CRAN_VEC_ADV_Utils.checkOrderManualConfirm('STEX','',''));
	}

	@isTest
	static void checkOrderManualConfirmTest_STEX_FALSE_ALL() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFctory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFctory.createOrdersManualConfirm8034();
		System.assert(!CRAN_VEC_ADV_Utils.checkOrderManualConfirm('STEX','8034','504783'));
	}
	@isTest
	static void checkOrderManualConfirmTest_STEX_TRUE_ALL() {
		CRAN_VEC_ADV_TestDataFactory_TST dataFctory = new CRAN_VEC_ADV_TestDataFactory_TST();
		dataFctory.createOrdersManualConfirm();
		System.assert(CRAN_VEC_ADV_Utils.checkOrderManualConfirm('STEX','8035','504783'));
	}
}