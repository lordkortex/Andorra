/**
 * CRAN_VEC_ADV_RestClient_CLS generic Rest client manager
 *
 * Fecha: 18/01/2017
 * @author  Iñaki Hernando  (Cloud Coachers)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_CloneCustomForm_AUC {

	/**
    * 
    * Método encargado de clonar los formularios.
    *
    * @param  ID customFormId - Id del formulario a clonar.
    * 
    * @return Object - SuccessCloneCustomForm si todo va bien y ErrorCloneCustomForm si va mal.
    *
    */	
	@AuraEnabled
	public static Object cloneCustomForm(ID customFormId) {
		try{

			CRAN_VEC_ADV_CustomForm__c oldCF;
			CRAN_VEC_ADV_CustomForm__c newCF;

			List<CRAN_VEC_ADV_CustomForm_Section__c> lstOldSections;
			List<CRAN_VEC_ADV_CustomForm_Section__c> lstNewSections;

			List<CRAN_VEC_ADV_CustomForm_Question__c> lstOldQuestions;
			List<CRAN_VEC_ADV_CustomForm_Question__c> lstNewQuestions;

			List<CRAN_VEC_ADV_CustomForm_Question__c> lstOldQuestions2;
			List<CRAN_VEC_ADV_CustomForm_Question__c> lstNewQuestions2;

			Map<ID,ID> mapIdsSections = new Map<ID,ID>();
			Map<ID,ID> mapIdsQuestions = new Map<ID,ID>();

			//CLONE CRAN_VEC_ADV_CustomForm__c cf
			String soql = CRAN_VEC_ADV_Utils.getCreatableFieldsSOQL('CRAN_VEC_ADV_CustomForm__c','Id=:customFormId');
			oldCF = Database.Query(soql);
			newCF = oldCF.clone(false, true, false, false);

			newCF.Name = oldCF.Name + ' (CLONE)'; 		
			newCF.CRAN_VEC_ADV_B_Enable__c = false;
			insert newCF;

			//CLONE CRAN_VEC_ADV_CustomForm_Section__c
			soql = CRAN_VEC_ADV_Utils.getCreatableFieldsSOQL('CRAN_VEC_ADV_CustomForm_Section__c','CRAN_VEC_ADV_MD_CustomForm__c=:customFormId');
			lstOldSections = Database.Query(soql);
			
			lstNewSections = lstOldSections.deepClone();
			for(Integer i = 0 ; i<lstNewSections.size() ; i++){
				//lstNewSections[i].Name = lstNewSections[i].Name + '(CLONE)';
				lstNewSections[i].CRAN_VEC_ADV_MD_CustomForm__c = newCF.Id;
			}

			insert lstNewSections;
			
			for(Integer i = 0 ; i<lstNewSections.size() ; i++){
				mapIdsSections.put(lstOldSections[i].Id,lstNewSections[i].Id);
			}

			//CLONE CRAN_VEC_ADV_CustomForm_Question__c
			soql = CRAN_VEC_ADV_Utils.getCreatableFieldsSOQL('CRAN_VEC_ADV_CustomForm_Question__c','CRAN_VEC_ADV_L_Question_Father__c = null AND CRAN_VEC_ADV_MD_Section__c IN :lstOldSections');
			System.debug('### EJECUTA: ' + soql);
			lstOldQuestions = Database.Query(soql);
			lstNewQuestions = lstOldQuestions.deepClone();
			for(Integer i = 0 ; i<lstNewQuestions.size() ; i++){
				//lstNewQuestions[i].Name = lstNewQuestions[i].Name + '(CLONE)';
				lstNewQuestions[i].CRAN_VEC_ADV_MD_Section__c = mapIdsSections.get(lstOldQuestions[i].CRAN_VEC_ADV_MD_Section__c);
			}

			System.debug('before insert lstNewQuestions: ' + lstNewQuestions);
			insert lstNewQuestions;
			System.debug('after insert lstNewQuestions: ' + lstNewQuestions);

			for(Integer i = 0 ; i<lstNewQuestions.size() ; i++){
				mapIdsQuestions.put(lstOldQuestions[i].Id,lstNewQuestions[i].Id);
			}		

			System.debug('lstOldQuestions2: ' + lstOldQuestions2);
			soql = CRAN_VEC_ADV_Utils.getCreatableFieldsSOQL('CRAN_VEC_ADV_CustomForm_Question__c','CRAN_VEC_ADV_L_Question_Father__c IN :lstOldQuestions AND CRAN_VEC_ADV_MD_Section__c IN :lstOldSections');
			System.debug('### EJECUTA: ' + soql);
			lstOldQuestions2 = Database.Query(soql);
			/*lstOldQuestions2 = [	SELECT Id, Name 
								FROM CRAN_VEC_ADV_CustomForm_Question__c 
								WHERE CRAN_VEC_ADV_L_Question_Father__c IN :lstOldQuestions2 
									AND CRAN_VEC_ADV_MD_Section__c IN :lstNewSections];
			*/
			lstNewQuestions2 = lstOldQuestions2.deepClone();
			for(Integer i = 0 ; i<lstNewQuestions2.size() ; i++){
				//lstNewQuestions2[i].Name = lstNewQuestions2[i].Name + '(CLONE)';
				lstNewQuestions2[i].CRAN_VEC_ADV_MD_Section__c = mapIdsSections.get(lstOldQuestions2[i].CRAN_VEC_ADV_MD_Section__c);
				lstNewQuestions2[i].CRAN_VEC_ADV_L_Question_Father__c = mapIdsQuestions.get(lstOldQuestions2[i].CRAN_VEC_ADV_L_Question_Father__c);
			}

			insert lstNewQuestions2;
			return new SuccessCloneCustomForm(newCF.Id);
		}catch (Exception e){
			return new ErrorCloneCustomForm(e.getMessage());
		}
	}

	/*--------------------------*/
    /*     Classes Wrapper      */
    /*     ---------------      */
    /*     Para responses       */
    /*--------------------------*/

    class SuccessCloneCustomForm{
        @AuraEnabled public Boolean success = true;
        @AuraEnabled public ID id;
        
        public SuccessCloneCustomForm(ID id){
            this.success = true;
            this.id = id;
        }
    } 

    @TestVisible
    class ErrorCloneCustomForm{
    	@AuraEnabled public Boolean success = false;
    	@AuraEnabled public String messageError;

    	public ErrorCloneCustomForm(String messageError){
    		this.success = false;
    		this.messageError = messageError;
    	}
    }
}