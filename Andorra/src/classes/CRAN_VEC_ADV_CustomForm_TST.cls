@isTest
private class CRAN_VEC_ADV_CustomForm_TST {

	
    @isTest
    static void CRAN_VEC_ADV_CustomForm_Test_TST() {    
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
        Contact c = dataFactory.createIndividualContactWithTwoBps();
        CRAN_VEC_ADV_CustomForm__c cf= dataFactory.create_CustomForm_TemplatePF();
        CRAN_VEC_ADV_CustomForm_Response__c cfr = dataFactory.addCustomFormResponse(cf.Id,c.Id);
        dataFactory.createAvaloqSetting();

		//TEST NEW
		PageReference pageRef = Page.CRAN_VEC_ADV_CustomForm;
        pageRef.getParameters().put('formId', String.valueOf(cfr.Id));
        
        Test.setCurrentPage(pageRef);
        CRAN_VEC_ADV_CustomForm_CTR newCFController = new CRAN_VEC_ADV_CustomForm_CTR();

        newCFController.onload();
        //Recorrer las secciones y questions seleccionando y asignando un valor a Answers
        //SELECT NUMBER
    	newCFController.iSection=0;
    	newCFController.iQuestion = 0;  
    	newCFController.selectActualQuestion();
        newCFController.actualQuestion.answer.CRAN_VEC_ADV_T_Answer__c = 'EMPTY';
        //SELECT PICKLIST
        newCFController.iSection=0;
        newCFController.iQuestion = 1;  
        newCFController.selectActualQuestion();
        newCFController.actualQuestion.answer.CRAN_VEC_ADV_T_Answer__c = 'EMPTY';
        //SELECT MULTIPICKLIST
    	newCFController.iSection=0;
    	newCFController.iQuestion = 2; 
    	newCFController.selectActualQuestion();
        newCFController.multiPickValue.add('Value001');
        newCFController.multiPickValue.add('Value002');
        //SELECT MATRIX
        newCFController.iSection=0;
        newCFController.iQuestion = 3;
        newCFController.selectActualQuestion();

        //REPAINT METHODS MATRIX
        newCFController.iSection=0;
        newCFController.iQuestion = 3;  
        newCFController.selectActualQuestion();
        //REPAINT METHODS MULTIPICKLIST
        newCFController.iSection=0;
        newCFController.iQuestion = 2;  
        newCFController.selectActualQuestion();

        newCFController.requestLabel = 'calculateResponse';

        newCFController.getSignUrl();

        //MARCAR COMO RESPONDIDAS
        for(CRAN_VEC_ADV_Section_Wrapper section : newCFController.lstSectionW){
            for(CRAN_VEC_ADV_CustomForm_Wrapper question : section.questions){
                question.answer.CRAN_VEC_ADV_B_Answered__c = true;
            }
        }

        Map<String,String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        String responseJson = CRAN_VEC_ADV_Utils.getMockBody(CRAN_VEC_ADV_Constants_CLS.SERVICE_CALCULAR);
        newCFController.isFormCompleted();

        Test.startTest();
        
        //Calculate Profile
        HttpResponse res = CRAN_VEC_ADV_AvaloqMockWS_TST.getCalculateProfileUnencrypted();
        System.debug('RES: ' + res);
        System.debug('RES.Body: ' + res.getBody());


        //MOCK CONTIN
        Continuation conti = (Continuation)newCFController.calculateProfile();
        Test.setContinuationResponse(newCFController.requestLabel, res);
        Object result = Test.invokeContinuationMethod(newCFController, conti);

        //Verificate Form Complete
        HttpResponse res2 = CRAN_VEC_ADV_AvaloqMockWS_TST.getVerificateFormComplete();
        System.debug('res2: ' + res2);
        Continuation conti2 = (Continuation)newCFController.verificateFormComplete();
        Test.setContinuationResponse(newCFController.requestLabelVerification, res2);
        Object result2 = Test.invokeContinuationMethod(newCFController, conti2);

        Test.stopTest();
	}


    @isTest
    static void CRAN_VEC_ADV_CustomForm_Test2_TST() {    
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
        Contact c = dataFactory.createIndividualContactWithTwoBps();
        CRAN_VEC_ADV_CustomForm__c cf= dataFactory.create_CustomForm_TemplatePF();
        CRAN_VEC_ADV_CustomForm_Response__c cfr = dataFactory.addCustomFormResponse(cf.Id,c.Id);
        cfr.CRAN_VEC_ADV_P_Acceptance_Status__c = 'Done';
        update cfr;
        dataFactory.createAvaloqSetting();

        //TEST NEW
        PageReference pageRef = Page.CRAN_VEC_ADV_CustomForm;
        pageRef.getParameters().put('formId', String.valueOf(cfr.Id));
        
        Test.setCurrentPage(pageRef);
        CRAN_VEC_ADV_CustomForm_CTR newCFController = new CRAN_VEC_ADV_CustomForm_CTR();

        newCFController.onload();

    }


    @isTest
    static void MockServiceTest() {
        CRAN_VEC_ADV_TestDataFactory_TST dataFactory = new CRAN_VEC_ADV_TestDataFactory_TST();
        Contact c = dataFactory.createIndividualContactWithTwoBps();
        Account bp = [SELECT ID FROM ACCOUNT WHERE CRAN_VEC_ADV_T_BPId__c = '9_9000001' LIMIT 1];
        CRAN_VEC_ADV_CustomForm__c cf= dataFactory.create_CustomForm_TemplatePF();
        CRAN_VEC_ADV_CustomForm_Response__c cfr = dataFactory.addCustomFormResponse(cf.Id,c.Id);
        cfr.CRAN_VEC_ADV_L_Business_Partner__c = bp.Id;
        update cfr;
        
        dataFactory.createAvaloqSettingMockTrue();
        
        PageReference pageRef = Page.CRAN_VEC_ADV_CustomForm;
        pageRef.getParameters().put('formId', String.valueOf(cfr.Id));
        
        Test.setCurrentPage(pageRef);
        CRAN_VEC_ADV_CustomForm_CTR newCFController = new CRAN_VEC_ADV_CustomForm_CTR();

        newCFController.onload();
        //Recorrer las secciones y questions seleccionando y asignando un valor a Answers
        //SELECT NUMBER
        newCFController.iSection=0;
        newCFController.iQuestion = 0;  
        newCFController.selectActualQuestion();
        newCFController.actualQuestion.answer.CRAN_VEC_ADV_T_Answer__c = 'EMPTY';
        //SELECT PICKLIST
        newCFController.iSection=0;
        newCFController.iQuestion = 1;  
        newCFController.selectActualQuestion();
        newCFController.actualQuestion.answer.CRAN_VEC_ADV_T_Answer__c = 'EMPTY';
        //SELECT MULTIPICKLIST
        newCFController.iSection=0;
        newCFController.iQuestion = 2; 
        newCFController.selectActualQuestion();
        newCFController.multiPickValue.add('Value001');
        newCFController.multiPickValue.add('Value002');
        //SELECT MATRIX
        newCFController.iSection=0;
        newCFController.iQuestion = 3;
        newCFController.selectActualQuestion();

        //REPAINT METHODS MATRIX
        newCFController.iSection=0;
        newCFController.iQuestion = 3;  
        newCFController.selectActualQuestion();
        //REPAINT METHODS MULTIPICKLIST
        newCFController.iSection=0;
        newCFController.iQuestion = 2;  
        newCFController.selectActualQuestion();

        newCFController.requestLabel = 'calculateResponse';

        //MARCAR COMO RESPONDIDAS
        for(CRAN_VEC_ADV_Section_Wrapper section : newCFController.lstSectionW){
            for(CRAN_VEC_ADV_CustomForm_Wrapper question : section.questions){
                question.answer.CRAN_VEC_ADV_B_Answered__c = true;
            }
        }

        Map<String,String> headers = new Map<String,String>();
        headers.put('Content-Type', 'application/json');
        String responseJson = CRAN_VEC_ADV_Utils.getMockBody(CRAN_VEC_ADV_Constants_CLS.SERVICE_CALCULAR);
        newCFController.isFormCompleted();

        Test.startTest();
        
        //Calculate Profile
        HttpResponse res = CRAN_VEC_ADV_AvaloqMockWS_TST.getCalculateProfileUnencrypted();
        System.debug('RES: ' + res);
        System.debug('RES.Body: ' + res.getBody());
        
        //MOCK CONTIN
        newCFController.calculateProfile();

        //Verificate Form Complete
        newCFController.verificateFormComplete();
        Test.stopTest();
        
    }

    @isTest
    static void CRAN_VEC_ADV_testmethod_TestRestModel() {
        List<CRAN_VEC_ADV_ProcessSTError_CLS> errorList = new List<CRAN_VEC_ADV_ProcessSTError_CLS>();
        CRAN_VEC_ADV_ProcessSTError_CLS error = new CRAN_VEC_ADV_ProcessSTError_CLS();
        error.setCode('001');
        error.setDesc('ERROR CODE');
        error.getCode();
        error.getDesc();
        errorList.add(error);

        CRAN_VEC_ADV_ProcessSTQuestion_CLS question = new CRAN_VEC_ADV_ProcessSTQuestion_CLS();
        
        question.setId('00001');
        question.getId();

        CRAN_VEC_ADV_ProcessSTRequest_CLS rq = new CRAN_VEC_ADV_ProcessSTRequest_CLS();
        List<CRAN_VEC_ADV_ProcessSTQuestion_CLS> questionList = new List<CRAN_VEC_ADV_ProcessSTQuestion_CLS>();
        questionList.add(question);
        rq.setLang('languageTest');
        rq.setQuestionary(questionList);
        rq.getOrder();

        rq.getLang();
        rq.getQuestionary();

        CRAN_VEC_ADV_ProcessSTResponse_CLS rs = new CRAN_VEC_ADV_ProcessSTResponse_CLS();

        rs.setErrors(errorList);
        rs.setProfileText('profile');
        rs.getProfileText();
        rs.setProfileType('type');
        rs.getProfileType();        
        rs.setQuestion(questionList);
        rs.getQuestion();
        rs.getErrors();
    }
}