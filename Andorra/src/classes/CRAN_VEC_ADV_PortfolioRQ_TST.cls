@isTest
private class CRAN_VEC_ADV_PortfolioRQ_TST {
	
	@isTest 
	static void CRAN_VEC_ADV_PortfolioRQ_TST() {
		System.debug('CRAN_VEC_ADV_PortfolioRQ_TST_testmethod_001');
		String prueba = '{\"dateTo\":\"11/12/2016\",\"objList\":[{\"objType\":\"bp\",\"obj\":{\"avqId\":817926}}]}';
        
		//CRAN_VEC_ADV_PortfolioRQ_CLS response = (CRAN_VEC_ADV_PortfolioRQ_CLS)JSON.deserialize(prueba, CRAN_VEC_ADV_PortfolioRQ_CLS.class);

		//System.debug(response);
		


        /*CRAN_VEC_ADV_PortfolioRQ_CLS rq = new CRAN_VEC_ADV_PortfolioRQ_CLS();
            rq.setTemplate(personType);
            rq.setContactId(idPerson);
            rq.setBpId(pSuitableTestRespond.CRAN_VEC_ADV_L_Business_Partner__c);*/


            /*rq.setTemplate(personType);
            rq.setContactId(idPerson);
            rq.setBpId(pSuitableTestRespond.CRAN_VEC_ADV_L_Business_Partner__c);
            //rq.setStartDate(pSuitableTestRespond.CreatedDate.format('yyyy-MM-dd'));
            rq.setLanguage(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));
            List<CRAN_VEC_ADV_ProcessSTQuestion_CLS> questionList = createRequest(lstSectionW); 
            rq.setQuestion(questionList);
            String jsonRequest = JSON.serialize(rq);
            System.debug('JSON --> SF_CALC_PROF_REQ: '+jsonRequest);
            CRAN_VEC_ADV_AvaloqSettings__c cs = CRAN_VEC_ADV_AvaloqSettings__c.getInstance();
            // Create continuation with a timeout
            Continuation con = new Continuation(120);
            // Set callback method
            con.continuationMethod='processResponse';
            // Create callout request
            CRAN_VEC_ADV_AvaloqServiceRequest avRq = new CRAN_VEC_ADV_AvaloqServiceRequest('calculateProfile',jsonRequest);
            HttpRequest req = avRq.avaloqRequest;
            // Add callout request to continuation
            requestLabel = con.addHttpRequest(req);
            // Return the continuation
            return con;*/


	}

}