/**
 * CRAN_VEC_ADV_RenovateForm_AUC  Renovate action button class
 *
 * Fecha Edicion: 23/08/2017 Añadido correcion para no generar objetos CUSTOMFORM Response si al renovar la respuesta devuelve un ID externo ya existente, en este caso se reutiliza
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.1
 *
*/
public with sharing class CRAN_VEC_ADV_RenovateForm_AUC {

    @AuraEnabled
    public static String initApex(String accountId){
        Contact c = retrieveIdContact(accountId);
        List<Account> lstBPs = getBPs(c.Id);
        SuccessInitResponse responseSuccess = new SuccessInitResponse(c,lstBPs);
        return JSON.serialize(responseSuccess);
    }

    @AuraEnabled
    public static String recuperarCuestionariosRespond(String bpId){

        try{
            // llamada al servicio recuperarCuestionarios
            CRAN_VEC_ADV_ProcessBPCustomFormRQ_CLS rq = new CRAN_VEC_ADV_ProcessBPCustomFormRQ_CLS();

            ////////////// ENTRADA PARAMETROS /////////////
            rq.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));

            CRAN_VEC_ADV_Obj_CLS obj = new CRAN_VEC_ADV_Obj_CLS();        
            obj.setAvqId(CRAN_VEC_ADV_Utils.getIdAvaloq(bpId));  

            List<CRAN_VEC_ADV_Obj_CLS> objList = new List<CRAN_VEC_ADV_Obj_CLS>(); 
            objList.add(obj);

            CRAN_VEC_ADV_ObjList_CLS objListF = new CRAN_VEC_ADV_ObjList_CLS();
            objListF.setObjType(CRAN_VEC_ADV_Constants_CLS.BP);
            objListF.setObj(objList);

            List<CRAN_VEC_ADV_ObjList_CLS> temp= new List<CRAN_VEC_ADV_ObjList_CLS>();
            temp.add(objListF);

            rq.setObjList(temp);
            rq.setQuestType(CRAN_VEC_ADV_Constants_CLS.ID_TEMPLATE);
            ////////////// FIN ENTRADA PARAMETROS /////////////

            String jsonRequest = JSON.serialize(rq);

            //POST CON ENCRIPTADO
            //CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_RECUPERAR_CUESTIONARIOS,CRAN_VEC_ADV_Utils.getBUAvaloq(bpId),jsonRequest);
            
            //GET SIN ENCRIPTAR AVALOQ
            CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_RECUPERAR_CUESTIONARIOS,CRAN_VEC_ADV_Utils.getBUAvaloq(bpId),jsonRequest);
            
            CRAN_VEC_ADV_ProcessBPCustomFormRS_CLS results = (CRAN_VEC_ADV_ProcessBPCustomFormRS_CLS)JSON.deserialize(restClient.responseBody, CRAN_VEC_ADV_ProcessBPCustomFormRS_CLS.class);


            if(results == null){
                return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_CF_MSG_NOFORMS));   

            }

            if(results.getErrors() != null){
                return JSON.serialize(new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(results.getErrors())));   

            }


            if(results.getObjList()==null){
                return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_CF_MSG_NOFORMS));
            }

            return restClient.responseBody;

        }catch(Exception e){
            return JSON.serialize(new ErrorResponse(e.getMessage()));
        }    
    }


    @AuraEnabled
    public static String crearOrdenModificacionCuestionarioRespond(String mybpIdAvaloq, String myIdAccount,String contactId, String formValueSelected){
        
        try{
                System.debug('contactId '+contactId);

                List<Account> lstAccBp = [SELECT Id,CRAN_VEC_ADV_T_BPId__c FROM Account WHERE CRAN_VEC_ADV_T_BPId__c = :mybpIdAvaloq];
                List<Contact> myContact = [SELECT Id,CRAN_VEC_ADV_T_PersonId__c,CRAN_VEC_ADV_P_PersonType__c  FROM Contact WHERE Id = :contactId];
                
                CRAN_VEC_ADV_RenewCustomFormRQ_CLS rq = new CRAN_VEC_ADV_RenewCustomFormRQ_CLS();

                ////////////// ENTRADA PARAMETROS /////////////
                rq.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));

                CRAN_VEC_ADV_Obj_CLS objBp = new CRAN_VEC_ADV_Obj_CLS();
                objBp.setAvqId(CRAN_VEC_ADV_Utils.getIdAvaloq(mybpIdAvaloq));

                CRAN_VEC_ADV_Obj_CLS objQuest = new CRAN_VEC_ADV_Obj_CLS();
                objQuest.setAvqId(formValueSelected);

                CRAN_VEC_ADV_ObjList_CLS objListBp = new CRAN_VEC_ADV_ObjList_CLS();
                objListBp.setObjType(CRAN_VEC_ADV_Constants_CLS.BP);
                List<CRAN_VEC_ADV_Obj_CLS> obj = new List<CRAN_VEC_ADV_Obj_CLS>();
                obj.add(objBp);
                objListBp.setObj(obj);
                    
                CRAN_VEC_ADV_ObjList_CLS objListQuest = new CRAN_VEC_ADV_ObjList_CLS();
                objListQuest.setObjType(CRAN_VEC_ADV_Constants_CLS.QUEST);
                List<CRAN_VEC_ADV_Obj_CLS> obj1 = new List<CRAN_VEC_ADV_Obj_CLS>();
                obj1.add(objQuest);
                objListQuest.setObj(obj1);

                CRAN_VEC_ADV_Obj_CLS objPerson = new CRAN_VEC_ADV_Obj_CLS();
                objPerson.setAvqId(CRAN_VEC_ADV_Utils.getIdAvaloq(myContact[0].CRAN_VEC_ADV_T_PersonId__c));

                CRAN_VEC_ADV_ObjList_CLS objListPerson = new CRAN_VEC_ADV_ObjList_CLS();
                objListPerson.setObjType(CRAN_VEC_ADV_Constants_CLS.PERSON);
                List<CRAN_VEC_ADV_Obj_CLS> objPer = new List<CRAN_VEC_ADV_Obj_CLS>();
                objPer.add(objPerson);
                objListPerson.setObj(objPer);



                List<CRAN_VEC_ADV_ObjList_CLS> objList = new List<CRAN_VEC_ADV_ObjList_CLS>(); 
                //objList.add(objListBp);
                objList.add(objListPerson);
                objList.add(objListQuest);
                rq.setObjList(objList);
                ////////////// FIN ENTRADA PARAMETROS /////////////

                String jsonRequest = JSON.serialize(rq);
                CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_CREAR_ORDER_MODIFICACION,CRAN_VEC_ADV_Utils.getBUAvaloq(mybpIdAvaloq),jsonRequest);
                

                CRAN_VEC_ADV_RenewCustomFormRS_CLS rs = (CRAN_VEC_ADV_RenewCustomFormRS_CLS)JSON.deserialize(restClient.responseBody, CRAN_VEC_ADV_RenewCustomFormRS_CLS.class);


                //GESTION ERRORES
                if(rs.getErrors()==null && rs.getOrder()==null){
                    return JSON.serialize(new ErrorResponse('No existen datos'));
                }

                if(rs.getErrors() != null && rs.getOrder()!=null){
                    return JSON.serialize(new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(rs.getErrors())));   
                }

                if(rs.getErrors() != null && rs.getOrder()==null){
                    return JSON.serialize(new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(rs.getErrors())));   
                }

                //FIN GESTION ERRORES

                if(rs!=null && rs.getErrors()==null && rs.getOrder()!=null){

                    String avaqExtId = CRAN_VEC_ADV_Utils.getBUAvaloq(mybpIdAvaloq) + '_' +rs.getOrder().getOrderNr();


                    List<CRAN_VEC_ADV_CustomForm__c> lstCustomForms = [SELECT CRAN_VEC_ADV_B_Enable__c,Id,Name,CRAN_VEC_ADV_N_Version__c,CRAN_VEC_ADV_T_Metadata_Types_ID__c 
                                                                    FROM CRAN_VEC_ADV_CustomForm__c
                                                                    WHERE CRAN_VEC_ADV_B_Enable__c=true and CRAN_VEC_ADV_P_PersonType__c=:myContact[0].CRAN_VEC_ADV_P_PersonType__c];

                    //Antes de crear un nuevo objeto de respuesta de formulario comprobamos que el id externo existe para no crear duplicados en Salesforce                                             
                    List<CRAN_VEC_ADV_CustomForm_Response__c> testResList = [SELECT Id,CRAN_VEC_ADV_MD_CustomForm__c 
                                                                            FROM CRAN_VEC_ADV_CustomForm_Response__c
                                                                            WHERE CRAN_VEC_ADV_T_Avaloq_ID__c =:avaqExtId];

                    CRAN_VEC_ADV_CustomForm_Response__c pSuitableTestRespond = new CRAN_VEC_ADV_CustomForm_Response__c();

                    if(!testResList.isEmpty()){

                        pSuitableTestRespond = testResList[0];
                        pSuitableTestRespond.CRAN_VEC_ADV_P_Acceptance_Status__c = 'On hold';
                        pSuitableTestRespond.CRAN_VEC_ADV_DT_StartDate__c = Datetime.now();
                        pSuitableTestRespond.CRAN_VEC_ADV_DT_Sent_Date__c = null;
                        pSuitableTestRespond.CRAN_VEC_ADV_P_Profile__c = null;
                        pSuitableTestRespond.Name = lstCustomForms[0].Name + ' - ' + Datetime.now().format(CRAN_VEC_ADV_Constants_CLS.DATE_FORMAT);
                        CRAN_VEC_ADV_Utils.updateSO(pSuitableTestRespond);
                        //Eliminar respuestas del formulario seleccionado para dejarlo limpio y volver a cargar la plantilla correspondiente
                        List<CRAN_VEC_ADV_CustomForm_Answer__c> lstAnswers = [SELECT ID FROM CRAN_VEC_ADV_CustomForm_Answer__c WHERE CRAN_VEC_ADV_MD_CustomFormResponse__c = :pSuitableTestRespond.Id];
                        CRAN_VEC_ADV_Utils.deleteSOs(lstAnswers);

                    }else{

                        pSuitableTestRespond.Name = lstCustomForms[0].Name + ' - ' + Datetime.now().format(CRAN_VEC_ADV_Constants_CLS.DATE_FORMAT);
                        pSuitableTestRespond.CRAN_VEC_ADV_MD_CustomForm__c = lstCustomForms[0].Id;

                        System.debug(contactId+' ' + mybpIdAvaloq+ ' ' + rs.getOrder().getOrderNr());
                        pSuitableTestRespond.CRAN_VEC_ADV_L_Contact__c = contactId;
                        pSuitableTestRespond.CRAN_VEC_ADV_L_Business_Partner__c = lstAccBp[0].Id;
                        pSuitableTestRespond.CRAN_VEC_ADV_DT_StartDate__c = Datetime.now();

                        pSuitableTestRespond.CRAN_VEC_ADV_T_Avaloq_ID__c = avaqExtId;
                        pSuitableTestRespond.CRAN_VEC_ADV_T_Avaloq_External_Id__c = rs.getOrder().getOrderNr();
                        pSuitableTestRespond.CRAN_VEC_ADV_T_Bu_Id__c = CRAN_VEC_ADV_Utils.getBUAvaloq(mybpIdAvaloq);

                        CRAN_VEC_ADV_Utils.insertSO(pSuitableTestRespond);
                    }


                    //RECUPERA ESTRUCTURA DEL TEMPLATE
                    List<CRAN_VEC_ADV_CustomForm_Section__c> lstSuitableAnswer = [SELECT Id,Name,CRAN_VEC_ADV_N_Order__c,CRAN_VEC_ADV_MD_CustomForm__c,
                                                (SELECT CRAN_VEC_ADV_P_AnswerType__c,Id,Name,CRAN_VEC_ADV_N_Order__c,CRAN_VEC_ADV_MD_Section__c 
                                                    FROM CRAN_VEC_ADV_Questions__r
                                                    WHERE  CRAN_VEC_ADV_P_AnswerType__c != 'Row' AND CRAN_VEC_ADV_P_AnswerType__c != 'Column'
                                                    ORDER BY CRAN_VEC_ADV_N_Order__c) 
                                            FROM CRAN_VEC_ADV_CustomForm_Section__c 
                                            WHERE CRAN_VEC_ADV_MD_CustomForm__c= :pSuitableTestRespond.CRAN_VEC_ADV_MD_CustomForm__c
                                            ORDER BY CRAN_VEC_ADV_N_Order__c];
                    //CREAMOS NUEVO FORMULARIO
                    List<CRAN_VEC_ADV_CustomForm_Answer__c> lstAnswers = new List<CRAN_VEC_ADV_CustomForm_Answer__c>();
                    for(CRAN_VEC_ADV_CustomForm_Section__c section: lstSuitableAnswer){
                         for(CRAN_VEC_ADV_CustomForm_Question__c q: section.CRAN_VEC_ADV_Questions__r){
                            CRAN_VEC_ADV_CustomForm_Answer__c emptyAnswer = new CRAN_VEC_ADV_CustomForm_Answer__c();
                            emptyAnswer.CRAN_VEC_ADV_MD_Question__c = q.Id;
                            emptyAnswer.CRAN_VEC_ADV_MD_Question__r = q;
                            //Asignar a Answer el id del formulario al que pertenece
                            emptyAnswer.CRAN_VEC_ADV_MD_CustomFormResponse__c = pSuitableTestRespond.Id;
                            //CRAN_VEC_ADV_CustomForm_Wrapper answerW = new CRAN_VEC_ADV_CustomForm_Wrapper(q,emptyAnswer);
                            lstAnswers.add(emptyAnswer);
                        }
                    }
                    //INSERT ANSWERS NUEVAS AL FORMULARIO
                    CRAN_VEC_ADV_Utils.insertSOs(lstAnswers);


                    //devuelvo JSON con la respuesta del servicio y el id del formulario creado
                    return JSON.serialize(new ResultServices(restClient.responseBody,pSuitableTestRespond.Id));
                }

                //FIN CREAR NUEVO CUESTIONARIO
                return JSON.serialize(new ResultServices(restClient.responseBody,null));

        }catch(Exception e){
            return JSON.serialize(new ErrorResponse(e.getMessage()));
        } 

    }

    private static List<Account> getBPs(String contactId){
        try{

            List<FinServ__FinancialAccountRole__c> lstFAR = CRAN_VEC_ADV_Utils.getRelatedBpsFromContactIDRenovate(contactId);

            List<Account> lstAccounts = new List<Account>();
            Map<String,Account> mapAccounts = new  Map<String,Account>();

            lstAccounts.add(new Account());

            for(FinServ__FinancialAccountRole__c far : lstFAR){
                mapAccounts.put(far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Id, new Account(Id=far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Id,AccountNumber=far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_T_BPId__c,Name=far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.AccountNumber+' - '+far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Name));
            }

             for(Account accountTemp : mapAccounts.values()){
                lstAccounts.add(accountTemp);
            }

            return lstAccounts;
        }catch (Exception e){
            return null;
        }
    }


    private static Contact retrieveIdContact(String accountId){
        try{
            Contact myContact = [SELECT Id,CRAN_VEC_ADV_P_PersonType__c FROM Contact WHERE AccountId = :accountId];
            return myContact;
        }catch (Exception e){
            return null;
        }
    }

    class ResultServices{
        public String solService;
        public String idForm;

        public ResultServices(String solService, String idForm){
            this.solService = solService;
            this.idForm = idForm;
            
        }
    }

    /*--------------------------*/
    /*     Classes Wrapper      */
    /*     ---------------      */
    /*     Para responses       */
    /*--------------------------*/

    class SuccessInitResponse{
        public Boolean success = true;
        public List<Account> bps;
        public Contact contact;

        public SuccessInitResponse(Contact c,List<Account> bps){
            this.success = true;
            this.contact = c;
            this.bps = bps;
        }
    } 

    @TestVisible
    class ErrorResponse{
        public Boolean success = false;
        public String messageError;

        public ErrorResponse(String messageError){
            this.success = false;
            this.messageError = messageError;
            
        }
    }

}