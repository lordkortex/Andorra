public with sharing class CRAN_VEC_ADV_CustomForm_CTR {

    //CONTANTS FOR AVALOQ ANSWER TYPES
    static final String ALVALOQ_NUMBER = 'number';
    static final String ALVALOQ_TEXT = 'number';
    static final String ALVALOQ_PICKLIST = 'code_table';
    static final String ALVALOQ_MULTIPICKLIST = 'code_table';
    static final String AVALOQ_SPECIALQUESTION = 'mdb$mifid_dflt$g2_q1';
    static final String AVALOQ_SPECIALQUESTION_ROW = 'mdb$mifid_dflt$g2_q1_r4';
    static final String SPECIALQUESTION_YES = 'mdb$mifid_dflt$answer_yes';
    static final String MATRIX_TYPE = 'Matrix';
    static final String ROW_TYPE = 'Row';
    static final String COLUMN_TYPE = 'Column';
    static final String PICKLIST_TYPE = 'Picklist';
    static final String MULTIPICKLIST_TYPE = 'Multipicklist';
    static final String NUMBER_TYPE = 'Number';
    static final String TEXT_TYPE = 'Text';
    static final String EMPTY_ANSWER_PICK = '$0$';
    static final String ACCEPTANCE_STATUS_DONE = 'Done';
    static final String BODY_NULL_ERRORMSG = 'IMPOSIBLE PERFORM THE REQUEST';

    static final Boolean MOCKSERVICES = CRAN_VEC_ADV_AvaloqSettings__c.getInstance().CRAN_VEC_ADV_B_MockServices__c;

    public CRAN_VEC_ADV_CustomForm_Response__c pSuitableTestRespond{get; private set;}

    public List<CRAN_VEC_ADV_Section_Wrapper> lstSectionW {get;private set;}
    public List<SelectOption> lstSelectOption{get;private set;}
    public CRAN_VEC_ADV_CustomForm_Wrapper actualQuestion{get;set;}
    public Integer iSection{get; set;}
    public Integer iQuestion{get; set;}
    private Boolean formCompleted{get; set;}
    public String perfilPage{get; set;}
    public String nameContact{get; private set;}
    public String nameBP{get; private set;}
    public String signingUrl{get; set;}
    public Contact relatedContact {get;private set;}
    
    public List<CRAN_VEC_ADV_MatrixRow> matrixAnswers{get; set;}
    private String customMetadata {get;set;}
    public String formId{get;set;}
    public Boolean viewMode{get;private set;}

    private String personType;

    //public String idPerson{get;private set;}
    public String action{get;private set;}
    
    public List<String> multiPickValue{get;set;}
    public String errorMessages{get;set;}
    public String warningMessages{get;set;}
    public Boolean displayError{get;set;}
    public Boolean displayAlert{get;set;}
    public Boolean displayOk{get;set;}
    public Boolean verificateOk{get;set;}
    public Boolean signOk{get;set;}
    public Boolean signNext{get;set;}
    public Boolean sendToDocuSign{get;set;}


    
    // Unique label corresponding to the continuation
    public String requestLabel;
    public String requestLabelVerification;
    
    // Result of callout
    //public String result {get;set;}
   
    public CRAN_VEC_ADV_CustomForm_CTR() {
        formId = ApexPages.currentPage().getParameters().get('formId');
        action  = ApexPages.currentPage().getParameters().get('action');
        if('view'.equals(action)){
            viewMode = true;
        }
    }

    public void onload(){
        iSection = -1;
        iQuestion = -1;
        verificateOk = false;
        signOk = false;
        signNext = false;
        sendToDocuSign = false;
        lstSelectOption = new List<SelectOption>();
        //Metodo onload para guardar datos del formulario desde visual force

        pSuitableTestRespond = [SELECT  Id,
                                        Name,
                                        CreatedDate,
                                        CRAN_VEC_ADV_DT_Sent_Date__c,
                                        CRAN_VEC_ADV_P_Acceptance_Status__c,
                                        CRAN_VEC_ADV_T_Document_URL__c,
                                        CRAN_VEC_ADV_T_FinancialAccount__c,
                                        tolabel(CRAN_VEC_ADV_P_Profile__c),
                                        CRAN_VEC_ADV_L_Business_Partner__c,
                                		CRAN_VEC_ADV_T_Bu_Id__c,
                                        CRAN_VEC_ADV_L_Business_Partner__r.Name,
                                        CRAN_VEC_ADV_L_Business_Partner__r.AccountNumber,
                                        CRAN_VEC_ADV_MD_CustomForm__c,
                                        CRAN_VEC_ADV_MD_CustomForm__r.CRAN_VEC_ADV_N_Version__c,
                                        CRAN_VEC_ADV_L_Contact__c,
                                        CRAN_VEC_ADV_L_Contact__r.Name,
                                		CRAN_VEC_ADV_L_Contact__r.AccountId,
                                        CRAN_VEC_ADV_T_Avaloq_ID__c
                                FROM CRAN_VEC_ADV_CustomForm_Response__c 
                                WHERE Id = :formId];
        nameContact = pSuitableTestRespond.CRAN_VEC_ADV_L_Contact__r.Name;
        relatedContact = pSuitableTestRespond.CRAN_VEC_ADV_L_Contact__r;
        nameBP = pSuitableTestRespond.CRAN_VEC_ADV_L_Business_Partner__r.AccountNumber +' - '+ pSuitableTestRespond.CRAN_VEC_ADV_L_Business_Partner__r.Name;

        perfilPage = pSuitableTestRespond.CRAN_VEC_ADV_P_Profile__c;
        List<CRAN_VEC_ADV_CustomForm_Section__c> lstSuitableAnswer;
        List<CRAN_VEC_ADV_CustomForm_Response__c> lstSuitableTestRespond;
        lstSectionW = new List<CRAN_VEC_ADV_Section_Wrapper>();

        List<CRAN_VEC_ADV_CustomForm__c> auxLstSuitability_Test = [SELECT CRAN_VEC_ADV_B_Enable__c,Id,Name,CRAN_VEC_ADV_N_Version__c,CRAN_VEC_ADV_T_Metadata_Types_ID__c,CRAN_VEC_ADV_P_PersonType__c
                                                           FROM CRAN_VEC_ADV_CustomForm__c
                                                            WHERE Id= :pSuitableTestRespond.CRAN_VEC_ADV_MD_CustomForm__c];
        CRAN_VEC_ADV_CustomForm__c pSuitableTest  = auxLstSuitability_Test[0];
        
        personType = pSuitableTest.CRAN_VEC_ADV_P_PersonType__c;
        customMetadata = pSuitableTest.CRAN_VEC_ADV_T_Metadata_Types_ID__c + '__mdt';

        if(auxLstSuitability_Test.size()==0){
            displayError = true;
            viewMode = true;
            errorMessages = Label.CRAN_VEC_ADV_CF_MSG_TEMPLATEALERT;
        }else{
            lstSuitableAnswer = [SELECT Id,Name,CRAN_VEC_ADV_N_Order__c,CRAN_VEC_ADV_MD_CustomForm__c,
                                    (SELECT CRAN_VEC_ADV_P_AnswerType__c,Id,Name,CRAN_VEC_ADV_N_Order__c,CRAN_VEC_ADV_MD_Section__c,CRAN_VEC_ADV_T_Id_Avaloq__c 
                                        FROM CRAN_VEC_ADV_Questions__r
                                        WHERE  CRAN_VEC_ADV_P_AnswerType__c != :ROW_TYPE AND CRAN_VEC_ADV_P_AnswerType__c != :COLUMN_TYPE
                                        ORDER BY CRAN_VEC_ADV_N_Order__c) 
                                FROM CRAN_VEC_ADV_CustomForm_Section__c 
                                WHERE CRAN_VEC_ADV_MD_CustomForm__c= :pSuitableTest.Id
                                ORDER BY CRAN_VEC_ADV_N_Order__c];

            lstSuitableTestRespond =    [SELECT    Id,
                                                Name,
                                                CreatedDate,
                                                CRAN_VEC_ADV_DT_Sent_Date__c,
                                                CRAN_VEC_ADV_P_Acceptance_Status__c,
                                                CRAN_VEC_ADV_T_Document_URL__c,
                                                CRAN_VEC_ADV_T_FinancialAccount__c,
                                    			CRAN_VEC_ADV_T_Bu_Id__c,
                                                CRAN_VEC_ADV_L_Business_Partner__c,
                                                CRAN_VEC_ADV_L_Business_Partner__r.Name,
                                                CRAN_VEC_ADV_L_Business_Partner__r.AccountNumber,
                                                CRAN_VEC_ADV_MD_CustomForm__c,
                                                CRAN_VEC_ADV_MD_CustomForm__r.CRAN_VEC_ADV_N_Version__c,
                                                CRAN_VEC_ADV_L_Contact__c,
                                                CRAN_VEC_ADV_L_Contact__r.Name,
                                                CRAN_VEC_ADV_T_Avaloq_ID__c,
                                                (SELECT CRAN_VEC_ADV_B_Answered__c,
                                                        CRAN_VEC_ADV_T_Answer__c,
                                                        Id,
                                                        Name,
                                                        CRAN_VEC_ADV_MD_Question__c,
                                                        CRAN_VEC_ADV_MD_CustomFormResponse__c 
                                                FROM CRAN_VEC_ADV_Answers__r) 
                                        FROM CRAN_VEC_ADV_CustomForm_Response__c 
                                        WHERE Id = :formId 
                                        ORDER BY CRAN_VEC_ADV_DT_StartDate__c DESC];
            nameContact = pSuitableTestRespond.CRAN_VEC_ADV_L_Contact__r.Name;
            nameBP = pSuitableTestRespond.CRAN_VEC_ADV_L_Business_Partner__r.AccountNumber +' - '+ pSuitableTestRespond.CRAN_VEC_ADV_L_Business_Partner__r.Name;

            if(lstSuitableAnswer.size()>0){
                pSuitableTestRespond = lstSuitableTestRespond[0];
                for(CRAN_VEC_ADV_CustomForm_Section__c section: lstSuitableAnswer){
                    CRAN_VEC_ADV_Section_Wrapper sectionW = new CRAN_VEC_ADV_Section_Wrapper();
                    sectionW.nameSection = section.name;
                    for(CRAN_VEC_ADV_CustomForm_Question__c q: section.CRAN_VEC_ADV_Questions__r){
                        for(CRAN_VEC_ADV_CustomForm_Answer__c answer : pSuitableTestRespond.CRAN_VEC_ADV_Answers__r){
                            if(answer.CRAN_VEC_ADV_MD_Question__c == q.Id){
                                answer.CRAN_VEC_ADV_MD_Question__r = q;
                                CRAN_VEC_ADV_CustomForm_Wrapper answerW = new CRAN_VEC_ADV_CustomForm_Wrapper(q,answer);
                                sectionW.questions.add(answerW);
                                }
                            }
                    }
                    lstSectionW.add(sectionW);
                }
            }
            //Comprobamos refrescos de pantalla al tener un formulario completado
            if(pSuitableTestRespond.CRAN_VEC_ADV_P_Acceptance_Status__c.equals(ACCEPTANCE_STATUS_DONE)){
                    viewMode = true;
                    verificateOk = true;
                    displayOk = true;
                    signOk = true;
            } else if(pSuitableTestRespond.CRAN_VEC_ADV_P_Acceptance_Status__c.equals(CRAN_VEC_ADV_Constants_CLS.SIGNED)){
                signOk = true;
                displayOk = true;
                viewMode = true;
                verificateOk = false;
                signNext = true;    
                sendToDocuSign = true;
            } 
        }
    }

    public void selectActualQuestion(){
        if(iSection!=-1 && iQuestion!=-1){
            saveLastQuestion(true);
            actualQuestion = lstSectionW[iSection].questions[iQuestion];
            if(actualQuestion.answer.CRAN_VEC_ADV_MD_Question__r.CRAN_VEC_ADV_P_AnswerType__c==PICKLIST_TYPE){
                updatePickListOptions(actualQuestion.question.Name);
            }
            else if(actualQuestion.answer.CRAN_VEC_ADV_MD_Question__r.CRAN_VEC_ADV_P_AnswerType__c==MULTIPICKLIST_TYPE){
                updateMultiPickListOptions(actualQuestion);
            }
            else if(actualQuestion.answer.CRAN_VEC_ADV_MD_Question__r.CRAN_VEC_ADV_P_AnswerType__c==MATRIX_TYPE){
                updateAnswerTable(actualQuestion);
            }
        }
    }

    public void saveLastQuestion(Boolean commitActualQuestion){
        if(actualQuestion!=null){
            //Answered null por defecto
            actualQuestion.answer.CRAN_VEC_ADV_B_Answered__c = false;
            if(commitActualQuestion){
                CRAN_VEC_ADV_Utils.upsertSO(actualQuestion.answer);
            }
        }
       
        if(actualQuestion!=null && String.isNotBlank(actualQuestion.answer.CRAN_VEC_ADV_T_Answer__c) || actualQuestion!=null && actualQuestion.answer.CRAN_VEC_ADV_MD_Question__r.CRAN_VEC_ADV_P_AnswerType__c==MATRIX_TYPE || actualQuestion!=null && actualQuestion.answer.CRAN_VEC_ADV_MD_Question__r.CRAN_VEC_ADV_P_AnswerType__c==MULTIPICKLIST_TYPE && multiPickValue!=null && multiPickValue.size() > 0)
        {
            actualQuestion.answer.CRAN_VEC_ADV_B_Answered__c = true;
            if(actualQuestion.answer.CRAN_VEC_ADV_MD_Question__r.CRAN_VEC_ADV_P_AnswerType__c==MATRIX_TYPE){
                //For Matrix type check answer list
                actualQuestion.answer.CRAN_VEC_ADV_B_Answered__c = true;
                //Serialize child answers map matrixclass to serialize class
                    List<CRAN_VEC_ADV_MatrixRow_Serialize> serializeMatrix = new List<CRAN_VEC_ADV_MatrixRow_Serialize>();
                    for(CRAN_VEC_ADV_MatrixRow row : matrixAnswers){
                        List<CRAN_VEC_ADV_MatrixColumn_Serialize> serializeColumns = new List<CRAN_VEC_ADV_MatrixColumn_Serialize>();
                        for(CRAN_VEC_ADV_MatrixColumn column : row.columnList){
                            if(column.question.CRAN_VEC_ADV_P_Child_Type__c == PICKLIST_TYPE){
                                if(column.answer.CRAN_VEC_ADV_T_Answer__c == EMPTY_ANSWER_PICK){
                                    actualQuestion.answer.CRAN_VEC_ADV_B_Answered__c = false;
                                }
                            }
                            CRAN_VEC_ADV_MatrixColumn_Serialize columnSerialize = new CRAN_VEC_ADV_MatrixColumn_Serialize(column.answer,column.question);
                            serializeColumns.add(columnSerialize);
                        }
                        CRAN_VEC_ADV_MatrixRow_Serialize rowSerialize = new CRAN_VEC_ADV_MatrixRow_Serialize(serializeColumns,row.questionText, row.idAvaloq);
                        serializeMatrix.add(rowSerialize);
                    }
                    String jsonString = JSON.serialize(serializeMatrix);
                    actualQuestion.answer.CRAN_VEC_ADV_T_Answer__c = jsonString;
            }
            //Upsert to save answer text
            if(actualQuestion.answer.CRAN_VEC_ADV_MD_Question__r.CRAN_VEC_ADV_P_AnswerType__c==MULTIPICKLIST_TYPE){
                actualQuestion.answer.CRAN_VEC_ADV_T_Answer__c = String.join(multiPickValue,',');
            }
            if(commitActualQuestion){
                CRAN_VEC_ADV_Utils.upsertSO(actualQuestion.answer);
            }
        } 
    }

    private void updatePickListOptions(String fieldPickList)
    {
        fieldPickList = fieldPickList + '__C';
        lstSelectOption = new List<SelectOption>();
        Map<String, Schema.SobjectField> FsMap = Schema.getGlobalDescribe().get(customMetadata).getDescribe().fields.getMap();
        List<Schema.PicklistEntry> ple = FsMap.get(fieldPickList).getDescribe().getPicklistValues();
        for(Schema.PicklistEntry p : ple)
            lstSelectOption.add(new SelectOption(p.getValue(), p.getLabel()));        
    }

    private void updateMultiPickListOptions(CRAN_VEC_ADV_CustomForm_Wrapper actualQuestion)
    {
        multiPickValue = new List<String>();
        String fieldPickList = actualQuestion.question.Name;
        fieldPickList = fieldPickList + '__C';
        lstSelectOption = new List<SelectOption>();
        Map<String, Schema.SobjectField> FsMap = Schema.getGlobalDescribe().get(customMetadata).getDescribe().fields.getMap();
        List<Schema.PicklistEntry> ple = FsMap.get(fieldPickList).getDescribe().getPicklistValues();
        for(Schema.PicklistEntry p : ple)
            lstSelectOption.add(new SelectOption(p.getValue(), p.getLabel()));        
        //Repaint last selected Answer
        if(actualQuestion.answer.CRAN_VEC_ADV_T_Answer__c != null){
            multiPickValue = actualQuestion.answer.CRAN_VEC_ADV_T_Answer__c.split(',');
        }

    }

    public void isFormCompleted()
    {
        //Save actual question answer wrapper
        selectActualQuestion();
        //Check all questions
        checkFormCompleted();
    }


    public Object calculateProfile() {
        if(formCompleted){
            if(MOCKSERVICES){
                CRAN_VEC_ADV_ProcessSTResponse_CLS response = (CRAN_VEC_ADV_ProcessSTResponse_CLS)JSON.deserialize(CRAN_VEC_ADV_Utils.getMockBody(CRAN_VEC_ADV_Constants_CLS.SERVICE_CALCULAR),CRAN_VEC_ADV_ProcessSTResponse_CLS.class);
                viewMode = false;
                displayOk = true;
                signOk = true;
                pSuitableTestRespond.CRAN_VEC_ADV_P_Profile__c = response.getProfileType();
                //TRANSLATE PROFILE RESULT LABEL
                perfilPage = getLabelFromValue(pSuitableTestRespond.CRAN_VEC_ADV_P_Profile__c);
                
                CRAN_VEC_ADV_Utils.updateSO(pSuitableTestRespond);

            }else{
                //Continuation cant save controller status
                multiPickValue = null;
                // Create Request            
                CRAN_VEC_ADV_ProcessSTRequest_CLS rq = new CRAN_VEC_ADV_ProcessSTRequest_CLS();
                CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
                order.setOrderNr(CRAN_VEC_ADV_Utils.getIdAvaloq(pSuitableTestRespond.CRAN_VEC_ADV_T_Avaloq_ID__c));
                rq.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));
                List<CRAN_VEC_ADV_ProcessSTQuestion_CLS> questionList = createRequest(lstSectionW); 
                rq.setQuestionary(questionList);
                rq.setOrder(order);
                String jsonRequest = JSON.serialize(rq);
                
                // Create continuation with a timeout
                Continuation con = new Continuation(120);
                // Set callback method
                con.continuationMethod='processCalculate';

                CRAN_VEC_ADV_AvaloqServiceRequest avRq = new CRAN_VEC_ADV_AvaloqServiceRequest(CRAN_VEC_ADV_Constants_CLS.SERVICE_CALCULAR,CRAN_VEC_ADV_Utils.getBUAvaloq(pSuitableTestRespond.CRAN_VEC_ADV_T_Bu_Id__c),jsonRequest);
                HttpRequest req = avRq.avaloqRequest;
                // Add callout request to continuation
                requestLabel = con.addHttpRequest(req);
                // Return the continuation
                return con;
            }
        }
        return null;
    }

    // Callback method 
    public Object processCalculate() {
        String perfilId;
        HttpResponse responseBody = Continuation.getResponse(this.requestLabel);
        Boolean isOk = false;
        try{

            pSuitableTestRespond = [SELECT  Id,
                                            Name,
                                            CreatedDate,
                                            CRAN_VEC_ADV_DT_Sent_Date__c,
                                            CRAN_VEC_ADV_P_Acceptance_Status__c,
                                            CRAN_VEC_ADV_T_Document_URL__c,
                                            CRAN_VEC_ADV_T_FinancialAccount__c,
                                    		CRAN_VEC_ADV_T_Bu_Id__c,
                                            CRAN_VEC_ADV_L_Business_Partner__c,
                                            CRAN_VEC_ADV_L_Business_Partner__r.Name,
                                            CRAN_VEC_ADV_L_Business_Partner__r.AccountNumber,
                                            CRAN_VEC_ADV_P_Profile__c,
                                            CRAN_VEC_ADV_MD_CustomForm__c,
                                            CRAN_VEC_ADV_MD_CustomForm__r.CRAN_VEC_ADV_N_Version__c,
                                            CRAN_VEC_ADV_L_Contact__c,
                                            CRAN_VEC_ADV_L_Contact__r.Name,
                                    		CRAN_VEC_ADV_L_Contact__r.AccountId,
                                            CRAN_VEC_ADV_T_Avaloq_ID__c
                                    FROM CRAN_VEC_ADV_CustomForm_Response__c 
                                    WHERE Id = :formId];
            nameContact = pSuitableTestRespond.CRAN_VEC_ADV_L_Contact__r.Name;
            nameBP = pSuitableTestRespond.CRAN_VEC_ADV_L_Business_Partner__r.AccountNumber +' - '+ pSuitableTestRespond.CRAN_VEC_ADV_L_Business_Partner__r.Name;

            if(String.isNotBlank(responseBody.getBody())){
                //Recuperar datos response
                CRAN_VEC_ADV_AvaloqServiceResponse avRs = new CRAN_VEC_ADV_AvaloqServiceResponse(responseBody.getBody());
                if(String.isNotBlank(avRs.content)){
                    CRAN_VEC_ADV_ProcessSTResponse_CLS response = (CRAN_VEC_ADV_ProcessSTResponse_CLS)JSON.deserialize(avRs.content,CRAN_VEC_ADV_ProcessSTResponse_CLS.class);
                    if(String.isNotBlank(response.getProfileType())){
                         perfilId = response.getProfileType();
                         viewMode = false;
                         displayOk = true;
                         isOk = true;
                         signOk = true;
                    }else if(response.getErrors() != null && response.getErrors().size() > 0){
                        //Error check
                        viewMode = false;
                        displayError = true;
                        signOk = false;
                        signNext = false;
                        for(CRAN_VEC_ADV_ProcessSTError_CLS error : response.getErrors()){
                            if(errorMessages == ''){
                                 errorMessages = error.getDesc();
                            }else{
                                 errorMessages = errorMessages + ',' +error.getDesc();
                            }
                        }
                    }
                }else{
                    //Body null
                    viewMode = false;
                    signOk = false;
                    displayError = true;
                    errorMessages = BODY_NULL_ERRORMSG;
                    signNext = false;
                }
            }else{
                //Body null
                viewMode = false;
                signOk = false;
                displayError = true;
                errorMessages = BODY_NULL_ERRORMSG;
                signNext = false;
            }

            if(isOk){
                pSuitableTestRespond.CRAN_VEC_ADV_P_Profile__c = perfilId;
                //TRANSLATE PROFILE RESULT LABEL
                perfilPage = getLabelFromValue(pSuitableTestRespond.CRAN_VEC_ADV_P_Profile__c);
                CRAN_VEC_ADV_Utils.updateSO(pSuitableTestRespond);
            }
        }catch(Exception e){
            viewMode = false;
            signOk = false;
            displayError = true;
            errorMessages = BODY_NULL_ERRORMSG;
            signNext = false;
            return null;
        }
        // Return null to re-render the original Visualforce page
        return null;
    }
    
	public void getSignUrl() {
      if (formId != null) {
           try {
               CRAN_VAS_KER_ISignatureHandler handler = CRAN_VAS_KER_SignatureHandlerFactory.createSignatureHandler(formId);
               signingUrl = handler.getSignatureUrl(formId);
               signOk = true;
               displayOk = true;
               viewMode = true;
               verificateOk = false;
               signNext = true;    
               sendToDocuSign = true;
           } catch (Exception ex) {
               signOk = true;
               verificateOk = false;
               viewMode = true;
               displayOk = false;
               displayError = true;
               signNext = false;
               errorMessages = ex.getMessage();
           }
       } else {
           throw new CRAN_VAS_KER_SignatureException(System.Label.CRAN_VAS_KER_SignatureExceptionDSInPersonSignURL);
       }
    }

    private void checkFormCompleted(){
        errorMessages = '';
        warningMessages = '';
        formCompleted = true;
        displayAlert = false;
        displayError = false;
        displayOk = false;
        for(CRAN_VEC_ADV_Section_Wrapper section : lstSectionW){
            for(CRAN_VEC_ADV_CustomForm_Wrapper question : section.questions){
                if(!question.answer.CRAN_VEC_ADV_B_Answered__c){
                    formCompleted = false;
                    displayAlert = true;
                    warningMessages = question.question.Name;
                    return;
                }
            }
        }
    }

    //Generate content for SF_CALC_PROF_REQ 
    private static List<CRAN_VEC_ADV_ProcessSTQuestion_CLS> createRequest (List<CRAN_VEC_ADV_Section_Wrapper> lstSectionW){
        List<CRAN_VEC_ADV_ProcessSTQuestion_CLS> questionList = new List<CRAN_VEC_ADV_ProcessSTQuestion_CLS>(); 
        for (CRAN_VEC_ADV_Section_Wrapper section : lstSectionW){
            for (CRAN_VEC_ADV_CustomForm_Wrapper questionW : section.questions){
                //ONLY SEND QUESTIONS ANSWERED
                if(questionW.answer.CRAN_VEC_ADV_B_Answered__c){
                     CRAN_VEC_ADV_ProcessSTQuestion_CLS question = new CRAN_VEC_ADV_ProcessSTQuestion_CLS();
                    //QUESTION ANSWER TYPE TEXT
                    if(questionW.question.CRAN_VEC_ADV_P_AnswerType__c == TEXT_TYPE){
                        //TEMP TYPE
                        List<CRAN_VEC_ADV_ProcessSTAnswerList_CLS> answers = new List<CRAN_VEC_ADV_ProcessSTAnswerList_CLS>();
                        CRAN_VEC_ADV_ProcessSTAnswerList_CLS answer = new CRAN_VEC_ADV_ProcessSTAnswerList_CLS();
                        
                        List<CRAN_VEC_ADV_ProcessSTAnswer_CLS> answerList = new List<CRAN_VEC_ADV_ProcessSTAnswer_CLS>();
                        answerList.add(new CRAN_VEC_ADV_ProcessSTAnswer_CLS(questionW.answer.CRAN_VEC_ADV_T_Answer__c,ALVALOQ_TEXT));
                        
                        answer.setAnswers(answerList);
                        answers.add(answer);
                        question.setAnswers(answers);
                        question.setId(questionW.question.CRAN_VEC_ADV_T_Id_Avaloq__c);
                        questionList.add(question);
                    }
                    //QUESTION ANSWER TYPE NUMBER
                    if(questionW.question.CRAN_VEC_ADV_P_AnswerType__c == NUMBER_TYPE){
                        List<CRAN_VEC_ADV_ProcessSTAnswerList_CLS> answers = new List<CRAN_VEC_ADV_ProcessSTAnswerList_CLS>();
                        CRAN_VEC_ADV_ProcessSTAnswerList_CLS answer = new CRAN_VEC_ADV_ProcessSTAnswerList_CLS();

                        List<CRAN_VEC_ADV_ProcessSTAnswer_CLS> answerList = new List<CRAN_VEC_ADV_ProcessSTAnswer_CLS>();
                        //PROCESS NUMBER, AVALOQ ONLY ACCEPT "." AS DECIMAL MARK
                        //ReplaceAll(',','');
                        String numberReplace = questionW.answer.CRAN_VEC_ADV_T_Answer__c;
                        String decimalReplace = numberReplace.replace('.','');
                        answerList.add(new CRAN_VEC_ADV_ProcessSTAnswer_CLS(decimalReplace.replace(',','.'),ALVALOQ_NUMBER));
                        
                        answer.setAnswers(answerList);
                        answers.add(answer);

                        question.setId(questionW.question.CRAN_VEC_ADV_T_Id_Avaloq__c);
                        question.setAnswers(answers);
                        questionList.add(question);
                    }
                    //QUESTION ANSWER TYPE PICKLIST
                    else if(questionW.question.CRAN_VEC_ADV_P_AnswerType__c == PICKLIST_TYPE){
                        if(EMPTY_ANSWER_PICK.equals(questionW.answer.CRAN_VEC_ADV_T_Answer__c)){
                             //List<CRAN_VEC_ADV_ProcessSTAnswerList_CLS> answers = new List<CRAN_VEC_ADV_ProcessSTAnswerList_CLS>();
                            //CRAN_VEC_ADV_ProcessSTAnswerList_CLS answer = new CRAN_VEC_ADV_ProcessSTAnswerList_CLS();

                            //List<CRAN_VEC_ADV_ProcessSTAnswer_CLS> answerList = new List<CRAN_VEC_ADV_ProcessSTAnswer_CLS>();
                            //answerList.add(new CRAN_VEC_ADV_ProcessSTAnswer_CLS('',ALVALOQ_PICKLIST));
                            //
                            // answer.setAnswers(answerList);
                            // answers.add(answer);
                            //
                            //question.setAnswers(answers);
                            //question.setId(questionW.question.CRAN_VEC_ADV_T_Id_Avaloq__c);
                            //questionList.add(question);
                        }else{
                            List<CRAN_VEC_ADV_ProcessSTAnswerList_CLS> answers = new List<CRAN_VEC_ADV_ProcessSTAnswerList_CLS>();
                            CRAN_VEC_ADV_ProcessSTAnswerList_CLS answer = new CRAN_VEC_ADV_ProcessSTAnswerList_CLS();

                            List<CRAN_VEC_ADV_ProcessSTAnswer_CLS> answerList = new List<CRAN_VEC_ADV_ProcessSTAnswer_CLS>();
                            answerList.add(new CRAN_VEC_ADV_ProcessSTAnswer_CLS(questionW.answer.CRAN_VEC_ADV_T_Answer__c,ALVALOQ_PICKLIST));
                            
                            answer.setAnswers(answerList);
                            answers.add(answer);

                            question.setAnswers(answers);
                            question.setId(questionW.question.CRAN_VEC_ADV_T_Id_Avaloq__c);
                            questionList.add(question);
                        }
                    }
                    //QUESTION ANSWER TYPE MULTIPICKLIST
                    else if(questionW.question.CRAN_VEC_ADV_P_AnswerType__c == MULTIPICKLIST_TYPE){
                        if(String.isNotBlank(questionW.answer.CRAN_VEC_ADV_T_Answer__c)){
                            List<CRAN_VEC_ADV_ProcessSTAnswerList_CLS> answers = new List<CRAN_VEC_ADV_ProcessSTAnswerList_CLS>();
                            CRAN_VEC_ADV_ProcessSTAnswerList_CLS answerl = new CRAN_VEC_ADV_ProcessSTAnswerList_CLS();

                            List<CRAN_VEC_ADV_ProcessSTAnswer_CLS> answerList = new List<CRAN_VEC_ADV_ProcessSTAnswer_CLS>();
                            //ITERATE ANSWERS
                            List<String> multiValue = new List<String>();
                            multiValue = questionW.answer.CRAN_VEC_ADV_T_Answer__c.split(',');
                            for(String value : multiValue){
                                CRAN_VEC_ADV_ProcessSTAnswer_CLS answer = new CRAN_VEC_ADV_ProcessSTAnswer_CLS(value,ALVALOQ_MULTIPICKLIST);
                                answerList.add(answer);
                            }

                            answerl.setAnswers(answerList);
                            answers.add(answerl);
                            question.setAnswers(answers);
                        }
                        question.setId(questionW.question.CRAN_VEC_ADV_T_Id_Avaloq__c);
                        questionList.add(question);
                    }
                    //QUESTION ANSWER TYPE MATRIX
                    //
                    else if(questionW.question.CRAN_VEC_ADV_P_AnswerType__c == MATRIX_TYPE){
                        //deserialize matrix rows
                        if(AVALOQ_SPECIALQUESTION.equals(questionW.question.CRAN_VEC_ADV_T_Id_Avaloq__c)){
                            //ESPECIAL QUESTION ITS A MULTISELECT NOT A MATRIX
                            List<CRAN_VEC_ADV_ProcessSTAnswerList_CLS> answers = new List<CRAN_VEC_ADV_ProcessSTAnswerList_CLS>();
                            CRAN_VEC_ADV_ProcessSTAnswerList_CLS answerl = new CRAN_VEC_ADV_ProcessSTAnswerList_CLS();
                            List<CRAN_VEC_ADV_MatrixRow_Serialize> matrixDeserializeRows = (List<CRAN_VEC_ADV_MatrixRow_Serialize>)JSON.deserializeStrict(questionW.answer.CRAN_VEC_ADV_T_Answer__c, List<CRAN_VEC_ADV_MatrixRow_Serialize>.class);
                            List<CRAN_VEC_ADV_ProcessSTAnswer_CLS> answerList = new List<CRAN_VEC_ADV_ProcessSTAnswer_CLS>();
                            for(CRAN_VEC_ADV_MatrixRow_Serialize deserializeRow : matrixDeserializeRows){
                                for(CRAN_VEC_ADV_MatrixColumn_Serialize deserializeColumn : deserializeRow.columnList){
                                    /*if(deserializeColumn.question.CRAN_VEC_ADV_P_Child_Type__c == NUMBER_TYPE && String.isNotBlank(deserializeColumn.answer.CRAN_VEC_ADV_T_Answer__c)){
                                        CRAN_VEC_ADV_ProcessSTAnswer_CLS answer = new CRAN_VEC_ADV_ProcessSTAnswer_CLS(deserializeColumn.answer.CRAN_VEC_ADV_T_Answer__c,ALVALOQ_NUMBER);
                                        answerList.add(answer);
                                    }else if(deserializeColumn.question.CRAN_VEC_ADV_P_Child_Type__c == TEXT_TYPE && String.isNotBlank(deserializeColumn.answer.CRAN_VEC_ADV_T_Answer__c)){
                                        CRAN_VEC_ADV_ProcessSTAnswer_CLS answer = new CRAN_VEC_ADV_ProcessSTAnswer_CLS(deserializeColumn.answer.CRAN_VEC_ADV_T_Answer__c,ALVALOQ_PICKLIST);
                                        answerList.add(answer);
                                    }else */
                                    if(deserializeColumn.question.CRAN_VEC_ADV_P_Child_Type__c == PICKLIST_TYPE && SPECIALQUESTION_YES.equals(deserializeColumn.answer.CRAN_VEC_ADV_T_Answer__c)){
                                        if(AVALOQ_SPECIALQUESTION_ROW.equals(deserializeRow.idAvaloq)){
                                            CRAN_VEC_ADV_ProcessSTAnswer_CLS answer = new CRAN_VEC_ADV_ProcessSTAnswer_CLS(deserializeRow.idAvaloq,ALVALOQ_PICKLIST,getSpecialMatrixRs(matrixDeserializeRows));
                                            answerList.add(answer);
                                        }else{
                                            CRAN_VEC_ADV_ProcessSTAnswer_CLS answer = new CRAN_VEC_ADV_ProcessSTAnswer_CLS(deserializeRow.idAvaloq,ALVALOQ_PICKLIST);
                                            answerList.add(answer);
                                        }
                                    }
                                }
                            }
                            answerl.setAnswers(answerList);
                            answers.add(answerl);
                            question.setAnswers(answers);
                        }else{
                            List<CRAN_VEC_ADV_ProcessSTAnswerList_CLS> answers = new List<CRAN_VEC_ADV_ProcessSTAnswerList_CLS>();
                            CRAN_VEC_ADV_ProcessSTAnswerList_CLS answerl = new CRAN_VEC_ADV_ProcessSTAnswerList_CLS();

                            List<CRAN_VEC_ADV_MatrixRow_Serialize> matrixDeserializeRows = (List<CRAN_VEC_ADV_MatrixRow_Serialize>)JSON.deserializeStrict(questionW.answer.CRAN_VEC_ADV_T_Answer__c, List<CRAN_VEC_ADV_MatrixRow_Serialize>.class);
                            List<CRAN_VEC_ADV_ProcessSTMatrixAnswer_CLS> matrixAnswerList = new List<CRAN_VEC_ADV_ProcessSTMatrixAnswer_CLS>();
                        
                            for(CRAN_VEC_ADV_MatrixRow_Serialize deserializeRow : matrixDeserializeRows){
                             List<CRAN_VEC_ADV_ProcessSTSection_CLS> sections = new List<CRAN_VEC_ADV_ProcessSTSection_CLS>();
                                for(CRAN_VEC_ADV_MatrixColumn_Serialize deserializeColumn : deserializeRow.columnList){
                                    if(deserializeColumn.question.CRAN_VEC_ADV_P_Child_Type__c == NUMBER_TYPE){
                                        CRAN_VEC_ADV_ProcessSTSection_CLS deserializeSection = new CRAN_VEC_ADV_ProcessSTSection_CLS(deserializeColumn.question.CRAN_VEC_ADV_T_Id_Avaloq__c,ALVALOQ_NUMBER,deserializeColumn.answer.CRAN_VEC_ADV_T_Answer__c);
                                        sections.add(deserializeSection);
                                    }else if(deserializeColumn.question.CRAN_VEC_ADV_P_Child_Type__c == PICKLIST_TYPE){

                                        if(EMPTY_ANSWER_PICK.equals(deserializeColumn.answer.CRAN_VEC_ADV_T_Answer__c)){
                                            //EMPTY ANSWERS
                                            //CRAN_VEC_ADV_ProcessSTSection_CLS deserializeSection = new CRAN_VEC_ADV_ProcessSTSection_CLS(deserializeColumn.question.CRAN_VEC_ADV_T_Id_Avaloq__c,ALVALOQ_PICKLIST,'');
                                            //sections.add(deserializeSection);
                                            //sections = null;
                                        }else{
                                            CRAN_VEC_ADV_ProcessSTSection_CLS deserializeSection = new CRAN_VEC_ADV_ProcessSTSection_CLS(deserializeColumn.question.CRAN_VEC_ADV_T_Id_Avaloq__c,ALVALOQ_PICKLIST,deserializeColumn.answer.CRAN_VEC_ADV_T_Answer__c);
                                            sections.add(deserializeSection);
                                        }
                                    }
                                }
                                //ONLY INSERT ROW ELEMENT WHEN COLUMN NOT EMPTY
                                if(sections != null && sections.size() > 0){
                                    CRAN_VEC_ADV_ProcessSTMatrixAnswer_CLS matrixAnswer = new CRAN_VEC_ADV_ProcessSTMatrixAnswer_CLS(deserializeRow.idAvaloq,sections);
                                    matrixAnswerList.add(matrixAnswer);
                                }
                            }
                            answerl.setMatrixAnswers(matrixAnswerList);
                            answers.add(answerl);
                            question.setAnswers(answers);
                        }
                        question.setId(questionW.question.CRAN_VEC_ADV_T_Id_Avaloq__c);
                        questionList.add(question);
                    }
                }    
            }
        }
        return questionList;
    }

    public void updateAnswerTable(CRAN_VEC_ADV_CustomForm_Wrapper actualQuestion){
        //Recuperamos la lista de preguntas hijas de la pregunta Matrix y generamos un modelo para su representacion visual
        matrixAnswers = new List<CRAN_VEC_ADV_MatrixRow>();
        List<CRAN_VEC_ADV_CustomForm_Question__c> rowQuestions = new List<CRAN_VEC_ADV_CustomForm_Question__c>();
        rowQuestions = [SELECT CRAN_VEC_ADV_P_AnswerType__c,CRAN_VEC_ADV_P_Child_Type__c,Id,Name,CRAN_VEC_ADV_L_Question_Father__c,CRAN_VEC_ADV_N_Order__c,CRAN_VEC_ADV_MD_Section__c,CRAN_VEC_ADV_T_Id_Avaloq__c 
                                        FROM CRAN_VEC_ADV_CustomForm_Question__c
                                        WHERE  CRAN_VEC_ADV_P_AnswerType__c = :ROW_TYPE AND CRAN_VEC_ADV_L_Question_Father__r.Id = :actualQuestion.question.Id
                                        ORDER BY CRAN_VEC_ADV_N_Order__c];

        List<CRAN_VEC_ADV_CustomForm_Question__c> columnQuestions = new List<CRAN_VEC_ADV_CustomForm_Question__c>();

        columnQuestions = [SELECT CRAN_VEC_ADV_P_AnswerType__c,CRAN_VEC_ADV_P_Child_Type__c,Id,Name,CRAN_VEC_ADV_L_Question_Father__c,CRAN_VEC_ADV_N_Order__c,CRAN_VEC_ADV_MD_Section__c,CRAN_VEC_ADV_T_Id_Avaloq__c 
                                        FROM CRAN_VEC_ADV_CustomForm_Question__c
                                        WHERE  CRAN_VEC_ADV_P_AnswerType__c = :COLUMN_TYPE AND CRAN_VEC_ADV_L_Question_Father__r.Id = :actualQuestion.question.Id
                                        ORDER BY CRAN_VEC_ADV_N_Order__c];
                                   
        //Add Row list
        for(CRAN_VEC_ADV_CustomForm_Question__c question : rowQuestions){
            //Add column list
             List<CRAN_VEC_ADV_MatrixColumn> columnList = new List<CRAN_VEC_ADV_MatrixColumn>();
            for(CRAN_VEC_ADV_CustomForm_Question__c columnQuestion : columnQuestions){
                CRAN_VEC_ADV_CustomForm_Answer__c emptyAnswer = new CRAN_VEC_ADV_CustomForm_Answer__c();
                emptyAnswer.CRAN_VEC_ADV_MD_Question__c = columnQuestion.Id;
                emptyAnswer.CRAN_VEC_ADV_MD_Question__r = columnQuestion;
                CRAN_VEC_ADV_MatrixColumn column = new CRAN_VEC_ADV_MatrixColumn(columnQuestion.Name, emptyAnswer, columnQuestion, customMetadata, columnQuestion.CRAN_VEC_ADV_T_Id_Avaloq__c);
                columnList.add(column);
            }
            CRAN_VEC_ADV_MatrixRow row = new CRAN_VEC_ADV_MatrixRow(columnList, question.Name, '', question.CRAN_VEC_ADV_T_Id_Avaloq__c);
            matrixAnswers.add(row);
        }

        //Comprobar datos
        if(actualQuestion.answer.CRAN_VEC_ADV_T_Answer__c!=null){
              List<CRAN_VEC_ADV_MatrixRow_Serialize> matrixDeserializeRows = (List<CRAN_VEC_ADV_MatrixRow_Serialize>)JSON.deserializeStrict(actualQuestion.answer.CRAN_VEC_ADV_T_Answer__c, List<CRAN_VEC_ADV_MatrixRow_Serialize>.class);
            for(Integer r = 0;r < matrixDeserializeRows.size();r++){
                for(Integer c = 0;c < matrixDeserializeRows[r].columnList.size();c++){
                    if(matrixDeserializeRows[r].columnList[c].answer != null){
                         matrixAnswers[r].columnList[c].answer = matrixDeserializeRows[r].columnList[c].answer;
                    }
                }
            }
        }
    }


    public Object verificateFormComplete(){
        //Create Request
        //Continuation cant save controller status
        multiPickValue = null;
        CRAN_VEC_ADV_VerifyCustomFormRQ_CLS rq = new CRAN_VEC_ADV_VerifyCustomFormRQ_CLS();
        ///////////// PARAMETROS DE ENTRADA /////////////////
        rq.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));

        CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
        order.setOrderNr(CRAN_VEC_ADV_Utils.getIdAvaloq(pSuitableTestRespond.CRAN_VEC_ADV_T_Avaloq_ID__c));
        order.setIsNew(false);
        rq.setOrder(order);
        ///////////// FIN PARAMETROS DE ENTRADA /////////////////

        String jsonRequest = JSON.serialize(rq);
        CRAN_VEC_ADV_AvaloqSettings__c cs = CRAN_VEC_ADV_AvaloqSettings__c.getInstance();

        if(MOCKSERVICES){
            CRAN_VEC_ADV_VerifyCustomFormRS_CLS response = (CRAN_VEC_ADV_VerifyCustomFormRS_CLS)JSON.deserialize(CRAN_VEC_ADV_Utils.getMockBody(CRAN_VEC_ADV_Constants_CLS.SERVICE_VERIFICAR),CRAN_VEC_ADV_VerifyCustomFormRS_CLS.class);
            verificateOk = true;
            viewMode = true;
            pSuitableTestRespond = [SELECT  Id,
                                                Name,
                                                CreatedDate,
                                                CRAN_VEC_ADV_DT_Sent_Date__c,
                                                CRAN_VEC_ADV_P_Acceptance_Status__c,
                                                CRAN_VEC_ADV_T_Document_URL__c,
                                                CRAN_VEC_ADV_T_FinancialAccount__c,
                                    			CRAN_VEC_ADV_T_Bu_Id__c,
                                                CRAN_VEC_ADV_L_Business_Partner__c,
                                                CRAN_VEC_ADV_L_Business_Partner__r.Name,
                                                CRAN_VEC_ADV_L_Business_Partner__r.AccountNumber,
                                                CRAN_VEC_ADV_MD_CustomForm__c,
                                                CRAN_VEC_ADV_MD_CustomForm__r.CRAN_VEC_ADV_N_Version__c,
                                                CRAN_VEC_ADV_L_Contact__c,
                                                CRAN_VEC_ADV_P_Profile__c,
                                                CRAN_VEC_ADV_T_Avaloq_ID__c,
                                                CRAN_VEC_ADV_L_Contact__r.Name,
                                    			CRAN_VEC_ADV_L_Contact__r.AccountId
                                        FROM CRAN_VEC_ADV_CustomForm_Response__c 
                                        WHERE Id = :formId];
            nameContact = pSuitableTestRespond.CRAN_VEC_ADV_L_Contact__r.Name;
            nameBP = pSuitableTestRespond.CRAN_VEC_ADV_L_Business_Partner__r.AccountNumber +' - '+ pSuitableTestRespond.CRAN_VEC_ADV_L_Business_Partner__r.Name;
            pSuitableTestRespond.CRAN_VEC_ADV_P_Acceptance_Status__c = ACCEPTANCE_STATUS_DONE;
            pSuitableTestRespond.CRAN_VEC_ADV_DT_Sent_Date__c = Datetime.now();
            CRAN_VEC_ADV_Utils.updateSO(pSuitableTestRespond);

            Account accbp = pSuitableTestRespond.CRAN_VEC_ADV_L_Business_Partner__r;
            accbp.CRAN_VEC_ADV_P_RiskProfile__c = getProfileFromAvaloqID(pSuitableTestRespond.CRAN_VEC_ADV_P_Profile__c);
            CRAN_VEC_ADV_Utils.updateSO(accbp);

            return null;


        }else{
            // Create continuation with a timeout
            Continuation con = new Continuation(120);
            // Set callback method
            con.continuationMethod='responseVerificate';
            // Create callout request
            CRAN_VEC_ADV_AvaloqServiceRequest avRq = new CRAN_VEC_ADV_AvaloqServiceRequest(CRAN_VEC_ADV_Constants_CLS.SERVICE_VERIFICAR,getBUFromBP(),jsonRequest);
            HttpRequest req = avRq.avaloqRequest;
            // Add callout request to continuation
            requestLabelVerification = con.addHttpRequest(req);
            // Return the continuation
            return con;
        }
        
    }

    // Callback method 
    public Object responseVerificate() {
        HttpResponse responseBody = Continuation.getResponse(this.requestLabelVerification);
        Boolean isOk = false;
        try{
            //Update pSuitableTestRespond variable for continuation
            pSuitableTestRespond = [SELECT      Id,
                                                Name,
                                                CreatedDate,
                                                CRAN_VEC_ADV_P_Profile__c,
                                                CRAN_VEC_ADV_DT_Sent_Date__c,
                                                CRAN_VEC_ADV_P_Acceptance_Status__c,
                                                CRAN_VEC_ADV_T_Document_URL__c,
                                                CRAN_VEC_ADV_T_FinancialAccount__c,
                                    			CRAN_VEC_ADV_T_Bu_Id__c,
                                                CRAN_VEC_ADV_L_Business_Partner__c,
                                                CRAN_VEC_ADV_L_Business_Partner__r.Name,
                                                CRAN_VEC_ADV_L_Business_Partner__r.AccountNumber,
                                                CRAN_VEC_ADV_L_Business_Partner__r.CRAN_VEC_ADV_P_RiskProfile__c,
                                                CRAN_VEC_ADV_MD_CustomForm__c,
                                                CRAN_VEC_ADV_MD_CustomForm__r.CRAN_VEC_ADV_N_Version__c,
                                                CRAN_VEC_ADV_L_Contact__c,
                                                CRAN_VEC_ADV_T_Avaloq_ID__c,
                                                CRAN_VEC_ADV_L_Contact__r.Name,
                                    			CRAN_VEC_ADV_L_Contact__r.AccountId
                                        FROM CRAN_VEC_ADV_CustomForm_Response__c 
                                        WHERE Id = :formId];

            nameContact = pSuitableTestRespond.CRAN_VEC_ADV_L_Contact__r.Name;
            nameBP = pSuitableTestRespond.CRAN_VEC_ADV_L_Business_Partner__r.AccountNumber +' - '+ pSuitableTestRespond.CRAN_VEC_ADV_L_Business_Partner__r.Name;

            if(String.isNotBlank(responseBody.getBody())){
                    CRAN_VEC_ADV_AvaloqServiceResponse avRs = new CRAN_VEC_ADV_AvaloqServiceResponse(responseBody.getBody());
                    //Recuperar datos response
                    CRAN_VEC_ADV_VerifyCustomFormRS_CLS response = (CRAN_VEC_ADV_VerifyCustomFormRS_CLS)JSON.deserialize(avRs.content,CRAN_VEC_ADV_VerifyCustomFormRS_CLS.class);

                    if(response.getErrors() == null){
                        verificateOk = true;
                        viewMode = true;
                        displayOk = true;
                        //Save BP riskProfile
                        Account accbp = pSuitableTestRespond.CRAN_VEC_ADV_L_Business_Partner__r;
                        System.debug('*********** '+pSuitableTestRespond.CRAN_VEC_ADV_P_Profile__c);
                        System.debug('/////// '+getProfileFromAvaloqID(pSuitableTestRespond.CRAN_VEC_ADV_P_Profile__c));
                        accbp.CRAN_VEC_ADV_P_RiskProfile__c = getProfileFromAvaloqID(pSuitableTestRespond.CRAN_VEC_ADV_P_Profile__c);
                        CRAN_VEC_ADV_Utils.updateSO(accbp);

                        //Save test response
                        pSuitableTestRespond.CRAN_VEC_ADV_P_Acceptance_Status__c = ACCEPTANCE_STATUS_DONE;
                        pSuitableTestRespond.CRAN_VEC_ADV_DT_Sent_Date__c = Datetime.now();
                        CRAN_VEC_ADV_Utils.updateSO(pSuitableTestRespond);

                    }else {
                        //Error check
                        displayOk = false;
                        verificateOk = false;
                        signOk = false;
                        viewMode = false;
                        displayError = true;
                        for(CRAN_VEC_ADV_ProcessSTError_CLS error : response.getErrors()){
                            if(errorMessages == ''){
                                 errorMessages = error.getDesc();
                            }else{
                                 errorMessages = errorMessages + ',' +error.getDesc();
                            }
                        }
                    }
            }else{
                //Body null
                verificateOk = false;
                displayOk = false;
                signOk = false;
                viewMode = false;
                displayError = true;
                errorMessages = BODY_NULL_ERRORMSG;
                
            }
         }catch(Exception e){
            displayOk = false;
            verificateOk = false;
            signOk = false;
            viewMode = false;
            displayError = true;
            errorMessages = BODY_NULL_ERRORMSG;
            return null;
        }
        return null;
    }

    private String getLabelFromValue(String code){
        List<Schema.PicklistEntry> picklistValues = 
        CRAN_VEC_ADV_CustomForm_Response__c.CRAN_VEC_ADV_P_Profile__c.getDescribe().getPicklistValues();
        for (Schema.PicklistEntry pe: picklistValues) {
            if(code == pe.getValue())
            {
                return pe.getLabel();
            }
        }
        return null;
    }

    private String getBUFromBP(){
        return CRAN_VEC_ADV_Utils.getBUAvaloq(pSuitableTestRespond.CRAN_VEC_ADV_T_Bu_Id__c);
    }

    private String getProfileFromAvaloqID(String AvaId){
        return CRAN_VEC_ADV_Constants_CLS.ADVID_AVALOQ_MAP.get(AvaId);
    }


    public void signProfile() {
        getSignUrl();
    }

    private static String getSpecialMatrixRs(List<CRAN_VEC_ADV_MatrixRow_Serialize> rowList){
        for(CRAN_VEC_ADV_MatrixRow_Serialize deserializeRow : rowList){
            for(CRAN_VEC_ADV_MatrixColumn_Serialize deserializeColumn : deserializeRow.columnList){
                if(deserializeColumn.question.CRAN_VEC_ADV_P_Child_Type__c == NUMBER_TYPE && String.isNotBlank(deserializeColumn.answer.CRAN_VEC_ADV_T_Answer__c)){
                    return deserializeColumn.answer.CRAN_VEC_ADV_T_Answer__c;
                }else if(deserializeColumn.question.CRAN_VEC_ADV_P_Child_Type__c == TEXT_TYPE && String.isNotBlank(deserializeColumn.answer.CRAN_VEC_ADV_T_Answer__c)){
                    return  deserializeColumn.answer.CRAN_VEC_ADV_T_Answer__c;
                }
            }
        }
        return '';
    }
    
    @RemoteAction
    public static Map<String, String> getMobilePhoneInfo(Id id) {
        return CRAN_VAS_KER_SignatureUtils.getMobilePhoneInfo(id);
    }

}