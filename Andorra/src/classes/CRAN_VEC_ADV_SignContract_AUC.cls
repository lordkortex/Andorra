public with sharing class CRAN_VEC_ADV_SignContract_AUC {
	@AuraEnabled
	public static Object queryAccountApex(String recordId){
		try{
            Account account = [SELECT Id,CRAN_VEC_ADV_T_BPId__c,CRAN_VEC_ADV_D_SignDate__c,CRAN_VEC_ADV_B_ContractSigned__c, CRAN_VEC_ADV_P_Bunit__c FROM Account where Id=:recordId];
            if(account.CRAN_VEC_ADV_D_SignDate__c==null)
                account.CRAN_VEC_ADV_D_SignDate__c = Date.today();
			return new SuccessResponse(account);
		}catch (Exception e){
			return new ErrorResponse(e);
		}
	}

	@AuraEnabled
	public static Object signContractApex(Account account){
		try{
            //llamada servicio SfSignContrReq
            CRAN_VEC_ADV_SignContractRQ rqSign = new CRAN_VEC_ADV_SignContractRQ();
            CRAN_VEC_ADV_Obj_CLS objBp = new CRAN_VEC_ADV_Obj_CLS();
            objBp.setAvqId(CRAN_VEC_ADV_Utils.getIdAvaloq(account.CRAN_VEC_ADV_T_BPId__c));

            rqSign.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));
            Datetime singDate = account.CRAN_VEC_ADV_D_SignDate__c;
            rqSign.setSigntDate(singDate.format(CRAN_VEC_ADV_Constants_CLS.DATE_FORMAT));

            CRAN_VEC_ADV_ObjList_CLS objListBp = new CRAN_VEC_ADV_ObjList_CLS();
            objListBp.setObjType('bp');
            List<CRAN_VEC_ADV_Obj_CLS> y = new List<CRAN_VEC_ADV_Obj_CLS>();
            y.add(objBp);
            objListBp.setObj(y);

            rqSign.setObjList(objListBp);

            CRAN_VEC_ADV_SignContractKeyValue keyValue = new CRAN_VEC_ADV_SignContractKeyValue();
            keyValue.setValue('AF');
            keyValue.setKeyType('symbol');
            rqSign.setKeyValue(keyValue);

            String jsonRequest = JSON.serialize(rqSign);
            System.debug('request sing:'+jsonRequest);
            System.debug('Bunit: '+ account.CRAN_VEC_ADV_P_Bunit__c);
            CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_FIRMA_CONTRATO,CRAN_VEC_ADV_Utils.getBUAvaloq(account.CRAN_VEC_ADV_T_BPId__c),jsonRequest);
            System.debug('restClient: '+ restClient);
            CRAN_VEC_ADV_SignContractRS results = (CRAN_VEC_ADV_SignContractRS)JSON.deserialize(restClient.responseBody, CRAN_VEC_ADV_SignContractRS.class);
            System.debug('result sing: '+results);
            if(results.getErrors()!=null && results.getErrors().size()>0){
                System.debug('errors :'+JSON.serialize(new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(results.getErrors()))));
                return new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(results.getErrors()));
            }else{
                account.CRAN_VEC_ADV_B_ContractSigned__c=true;
                upsert account;
                return new SuccessResponse(account);
            }
		}catch (Exception e){
            System.debug('Exception:'+e);
			return new ErrorResponse(e);
		}
	}

	/*--------------------------*/
    /*     Classes Wrapper      */
    /*     ---------------      */
    /*     Para responses       */
    /*--------------------------*/

    @TestVisible
    class SuccessResponse{

        @AuraEnabled public Boolean success{get;set;}
        @AuraEnabled public Account account{get;set;}

        public SuccessResponse(Account account){
            this.success = true;
            this.account = account;
        }
    }

    @TestVisible
    class ErrorResponse{
        @AuraEnabled public Boolean success{get;set;}
        @AuraEnabled public Integer lineNumber{get;set;}
        @AuraEnabled public String messageError{get;set;}
        @AuraEnabled public String typeError{get;set;}
        @AuraEnabled public String stackTrace{get;set;}
        
        public ErrorResponse(Exception e){
    		this.success = false;
            this.lineNumber = e.getLineNumber();
            this.typeError = e.getTypeName();
    		this.messageError = e.getMessage();
            this.stackTrace = e.getStackTraceString();
    	}

        public ErrorResponse(String e){
            this.success = false;
            this.messageError = e;
        }
    }

}