/**
 * Esta clase proporciona los servicios necesarios de Apex para la pagina de nuevo de AURA.
 *
 * Fecha: 19/11/2016
 * @author  Cloud Coachers (Iñaki Hernando Urcullu - inakihu@gmail.com)
 * @version 1.1
 *
*/

public with sharing class CRAN_VEC_ADV_newForm_AUC {
	
	@AuraEnabled
    public static String initApex(String accountId){
        try{
            Contact c = retrieveIdContact(accountId);
            List<Option> lstOptions = getFormTypes(c.CRAN_VEC_ADV_P_PersonType__c);
            List<Account> lstBPs = getBPs(c.Id);
            List<Account> lstBPsConvert = getBPsConvert(c.Id);
    
            System.debug('lstBPs '+lstBPs);
            System.debug('lstBPsConvert '+lstBPsConvert);
        
            SuccessInitResponse responseSuccess = new SuccessInitResponse(lstOptions,c,lstBPs,lstBPsConvert);
            System.debug('responseSuccess '+responseSuccess);
            return JSON.serialize(responseSuccess);
        }catch(Exception e){
             return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_CF_MSG_NO_BP));
        }
    }


    @AuraEnabled
    public static String callApexAvaloqNewForm(String bpId,String contactId,String formTemplateId,Boolean changedToAdv){
        try{
            Account accBP = [SELECT Id,CRAN_VEC_ADV_T_BPId__c,CRAN_VEC_ADV_B_AdvAccount__c FROM Account WHERE Id=:bpId];
            Contact personId = [SELECT Id,CRAN_VEC_ADV_T_PersonId__c FROM Contact WHERE Id=:contactId];
            CRAN_VEC_ADV_CustomForm__c cf = [Select Id,Name,CRAN_VEC_ADV_N_Version__c,CRAN_VEC_ADV_P_Type__c FROM CRAN_VEC_ADV_CustomForm__c WHERE ID=:formTemplateId];
            //Llama al servicio para crear Formulario en Avaloq
            CRAN_VEC_ADV_NewCustomFormRQ_CLS rq = new CRAN_VEC_ADV_NewCustomFormRQ_CLS();

            ////////// ENTRADA PARAMETROS ////////////
                rq.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));

                rq.setQuestType(cf.CRAN_VEC_ADV_P_Type__c);
                /////////////////////////////////////////
                CRAN_VEC_ADV_Obj_CLS objPerson = new CRAN_VEC_ADV_Obj_CLS();
                objPerson.setAvqId(CRAN_VEC_ADV_Utils.getIdAvaloq(personId.CRAN_VEC_ADV_T_PersonId__c));

                CRAN_VEC_ADV_Obj_CLS objBp = new CRAN_VEC_ADV_Obj_CLS();
                objBp.setAvqId(CRAN_VEC_ADV_Utils.getIdAvaloq(accBP.CRAN_VEC_ADV_T_BPId__c));
                /////////////////////////////////////////
                CRAN_VEC_ADV_ObjList_CLS objListPerson = new CRAN_VEC_ADV_ObjList_CLS();
                    objListPerson.setObjType(CRAN_VEC_ADV_Constants_CLS.PERSON);
                    List<CRAN_VEC_ADV_Obj_CLS> x = new List<CRAN_VEC_ADV_Obj_CLS>();
                    x.add(objPerson);
                    objListPerson.setObj(x);

                CRAN_VEC_ADV_ObjList_CLS objListBp = new CRAN_VEC_ADV_ObjList_CLS();
                    objListBp.setObjType(CRAN_VEC_ADV_Constants_CLS.BP);
                    List<CRAN_VEC_ADV_Obj_CLS> y = new List<CRAN_VEC_ADV_Obj_CLS>();
                    y.add(objBp);
                    objListBp.setObj(y);
                ///////////////////////////
                List<CRAN_VEC_ADV_ObjList_CLS> objList = new List<CRAN_VEC_ADV_ObjList_CLS>();
                objList.add(objListPerson);
                objList.add(objListBp);
                rq.setObjList(objList);
                System.debug('-->ChangedToAdv: '+ changedToAdv);
                rq.setIsAdvBp(changedToAdv);
            ////////// FIN ENTRADA PARAMETROS ////////////

            

            CRAN_VEC_ADV_CustomForm_Response__c pSuitableTestRespond = new CRAN_VEC_ADV_CustomForm_Response__c();

            String jsonRequest = JSON.serialize(rq);

            //POST REQUEST
            CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_CREAR_NUEVO,CRAN_VEC_ADV_Utils.getBUAvaloq(accBP.CRAN_VEC_ADV_T_BPId__c),jsonRequest);
            System.debug('restClient.responseBody'+restClient.responseBody);
            CRAN_VEC_ADV_NewCustomFormRS_CLS results = (CRAN_VEC_ADV_NewCustomFormRS_CLS)JSON.deserialize(restClient.responseBody, CRAN_VEC_ADV_NewCustomFormRS_CLS.class);
            
            if(results.getErrors()!=null && results.getErrors().size()>0){
                return JSON.serialize(new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(results.getErrors())));
            }else{
                String soql = CRAN_VEC_ADV_Utils.getCreatableFieldsSOQL('Account','Id=\'' + bpId +'\'');
                Account bpOrigen = (Account)Database.query(soql);
                Account bpNuevo;
                //changedToAdv Nuevo tag que define si el BP recibido se modifica a advisory (true) o no (false) se clona
                if(!changedToAdv){
                    bpNuevo = bpOrigen.clone(false, true);
                }

                if(results.getOrder()!=null){
                    pSuitableTestRespond.CRAN_VEC_ADV_T_Avaloq_ID__c = CRAN_VEC_ADV_Utils.getBUAvaloq(accBP.CRAN_VEC_ADV_T_BPId__c) + '_' +results.getOrder().getOrderNr();
                    pSuitableTestRespond.CRAN_VEC_ADV_T_Avaloq_External_Id__c = results.getOrder().getOrderNr();
                    pSuitableTestRespond.CRAN_VEC_ADV_T_Bu_Id__c = CRAN_VEC_ADV_Utils.getBUAvaloq(accBP.CRAN_VEC_ADV_T_BPId__c);
                    if(!changedToAdv){
                        bpNuevo.CRAN_VEC_ADV_T_BPId__c = CRAN_VEC_ADV_Utils.getBUAvaloq(accBP.CRAN_VEC_ADV_T_BPId__c) + '_' + results.getObjList()[0].getObj()[0].getAvqId();
                        bpNuevo.CRAN_VEC_ADV_B_AdvAccount__c = true;

                        System.debug('keylist'+results.getObjList()[0].getObj()[0]);
                        if(results.getObjList()[0].getObj()[0].getKeyList()!=null){
                            CRAN_VEC_ADV_keyList_CLS myKeyList = results.getObjList()[0].getObj()[0].getKeyList()[0];
                            if(myKeyList!=null && myKeyList.getvalue()!=null && myKeyList.getvalue()!='')
                                bpNuevo.CRAN_VEC_ADV_N_Number__c  = myKeyList.getvalue();
                                bpNuevo.AccountNumber  = myKeyList.getvalue();
                        }

                        CRAN_VEC_ADV_Utils.insertSO(bpNuevo);
                        pSuitableTestRespond.CRAN_VEC_ADV_L_Business_Partner__c = bpNuevo.Id;
                    } else{
                        bpOrigen.CRAN_VEC_ADV_B_AdvAccount__c = true;
                        CRAN_VEC_ADV_Utils.updateSO(bpOrigen);
                        pSuitableTestRespond.CRAN_VEC_ADV_L_Business_Partner__c = bpOrigen.Id;
                    }
                }
                pSuitableTestRespond.Name = cf.Name + ' - ' + Datetime.now().format(CRAN_VEC_ADV_Constants_CLS.DATE_FORMAT);
                pSuitableTestRespond.CRAN_VEC_ADV_MD_CustomForm__c = formTemplateId;
                pSuitableTestRespond.CRAN_VEC_ADV_L_Contact__c = contactId;
                pSuitableTestRespond.CRAN_VEC_ADV_B_ChangedToADV__c = changedToAdv;
                pSuitableTestRespond.CRAN_VEC_ADV_DT_StartDate__c = Datetime.now();
                CRAN_VEC_ADV_Utils.insertSO(pSuitableTestRespond);

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
                        CRAN_VEC_ADV_CustomForm_Wrapper answerW = new CRAN_VEC_ADV_CustomForm_Wrapper(q,emptyAnswer);
                        lstAnswers.add(emptyAnswer);
                    }
                }
                //INSERT ANSWERS NUEVAS AL FORMULARIO
                CRAN_VEC_ADV_Utils.insertSOs(lstAnswers);  

                if(!changedToAdv){
                    return JSON.serialize(new SuccessResponse(pSuitableTestRespond.Id,bpNuevo.Id));
                } else{
                    return JSON.serialize(new SuccessResponse(pSuitableTestRespond.Id,bpOrigen.Id));
                }
            }
        }catch(Exception e){
            return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_CF_MSG_NO_BP));
        }
        
    }

    /*--------------------------*/
    /*     MÉTODOS PRIVADOS     */
    /*--------------------------*/

    /**
    * Recupera los Business Partner del contacto.
    *
    * @param String contactId - Id del Contact del que se quiere consultar los BPs
    *
    * @return Contact - Contacto con el resultado.
    */

    private static List<Account> getBPs(String contactId){
        try{
            List<FinServ__FinancialAccountRole__c> lstFAR = CRAN_VEC_ADV_Utils.getRelatedBpsFromContactID(contactId);
            
            List<Account> lstAccounts = new List<Account>();
            Map<String,Account> mapAccounts = new  Map<String,Account>();

            //remove Accounts duplicates 
            for(FinServ__FinancialAccountRole__c far : lstFAR){
                mapAccounts.put(far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Id, new Account(Id=far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Id,Name=far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.AccountNumber +' - '+ far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Name));
            }

            for(Account accountTemp : mapAccounts.values()){
                lstAccounts.add(accountTemp);
            }

            return lstAccounts;
        }catch (Exception e){
            return null;
        }
    }
    

    private static List<Account> getBPsConvert(String contactId){
        try{
            List<FinServ__FinancialAccountRole__c> lstFAR = CRAN_VEC_ADV_Utils.getRelatedBpsFromContactID(contactId);

            List<Account> lstAccounts = new List<Account>();
            Map<String,Account> mapAccounts = new  Map<String,Account>();

            //remove Accounts duplicates 
            for(FinServ__FinancialAccountRole__c far : lstFAR){
                mapAccounts.put(far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Id, new Account(Id=far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Id,Name=far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.AccountNumber+' - '+far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Name));
            }

            for(Account accountTemp : mapAccounts.values()){
                lstAccounts.add(accountTemp);
            }

            return lstAccounts;
        }catch (Exception e){
            return null;
        }
    }
    /**
    * Recupera el Contact a partir del id de Account
    *
    * @param String accountId - Id del account que recibe el component 
    *
    * @return Contact - Contacto con el resultado.
    */
    private static Contact retrieveIdContact(String accountId){
        try{
            Contact myContact = [SELECT Id,CRAN_VEC_ADV_P_PersonType__c FROM Contact WHERE AccountId = :accountId];
            return myContact;
        }catch (Exception e){
            return null;
        }
    }
    

    /**
    * Recupera los opciones disponibles para el desplegable.
    *
    * @param strDatetime - 
    *
    * @return initialization vector para la encriptación
    */
	private static List<Option> getFormTypes(String personType){
        List<Option> lstOptions = new List<Option>();
        List<CRAN_VEC_ADV_CustomForm__c> lstCustomForms = [SELECT CRAN_VEC_ADV_B_Enable__c,Id,Name,CRAN_VEC_ADV_N_Version__c,CRAN_VEC_ADV_T_Metadata_Types_ID__c 
														FROM CRAN_VEC_ADV_CustomForm__c
														WHERE CRAN_VEC_ADV_B_Enable__c=true and CRAN_VEC_ADV_P_PersonType__c=:personType];
                                              
        for(CRAN_VEC_ADV_CustomForm__c customForm : lstCustomForms){
            lstOptions.add(new Option(customForm.Id, customForm.Name));
        }
        return lstOptions;
    }

    /*--------------------------*/
    /*     Classes Wrapper      */
    /*     ---------------      */
    /*     Para responses       */
    /*--------------------------*/

    class Option{
    	public String label;
    	public String value;

    	public Option(String value, String label){
    		this.value = value;
    		this.label = label;
    		
    	}
    }

    class SuccessResponse{
    	public Boolean success = true;
    	public String responseId;
        public String bpId;

    	public SuccessResponse(String responseId,String bpId){
    		this.success = true;
    		this.responseId = responseId;
            this.bpId = bpId;
    		
    	}
    }

    class SuccessInitResponse{
        @AuraEnabled
        public Boolean success = true;
        public List<Option> options;
        public List<Account> bps;
        public List<Account> bpsConvert;
        public Contact contact;

        public SuccessInitResponse(List<Option> lstOptions,Contact c,List<Account> bps,List<Account> bpsConvert){
            this.success = true;
            this.options = lstOptions;
            this.contact = c;
            this.bps = bps;
            this.bpsConvert = bpsConvert;
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