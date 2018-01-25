/**
 * CRAN_VEC_ADV_CustomForm Trigger Util Class
 *
 * Fecha: 29/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

public class CRAN_VEC_ADV_CustomFormTriggerUtil {
	
	public static void cargarRelaciones(Map<Id,CRAN_VEC_ADV_CustomForm__c> mapOld, List<CRAN_VEC_ADV_CustomForm__c> listNew, String operacion){

		List<CRAN_VEC_ADV_CustomForm__c> templateActive = [SELECT ID, NAME, CRAN_VEC_ADV_B_Enable__c, CRAN_VEC_ADV_P_PersonType__c, CRAN_VEC_ADV_P_Type__c FROM CRAN_VEC_ADV_CustomForm__c WHERE CRAN_VEC_ADV_B_Enable__c = true];

		if(operacion.equals('Insert'))
		{
			for(CRAN_VEC_ADV_CustomForm__c newTemplate : listNew){
				//ONLY CHECK ENABLED TEMPLATES
				if(newTemplate.CRAN_VEC_ADV_B_Enable__c && templateActive.size() > 0){
					if(searchTemplateByType(newTemplate, templateActive)){
						newTemplate.addError(Label.CRAN_VEC_ADV_CF_TRIGGER_FAIL);
					}
				}
			}
		}
		if(operacion.equals('Update'))
		{
			for(CRAN_VEC_ADV_CustomForm__c newTemplate : listNew){
				//ONLY CHECK ENABLED TEMPLATES
				if(newTemplate.CRAN_VEC_ADV_B_Enable__c && templateActive.size() > 0){
					//ONLY IF OLD ENABLED CHANGE
					if(!mapOld.get(newTemplate.Id).CRAN_VEC_ADV_B_Enable__c){
						if(searchTemplateByType(newTemplate, templateActive)){
							newTemplate.addError(Label.CRAN_VEC_ADV_CF_TRIGGER_FAIL);
						}
					}
				}
			}
		}
	}

	private static Boolean searchTemplateByType(CRAN_VEC_ADV_CustomForm__c checkTemplate, List<CRAN_VEC_ADV_CustomForm__c> templateActive){
		for(CRAN_VEC_ADV_CustomForm__c template : templateActive){
			//CHECK NOT ARE THE SAME TEMPLATE FOR UPDATES
			if(template.Id != checkTemplate.Id &&
				template.CRAN_VEC_ADV_P_PersonType__c == checkTemplate.CRAN_VEC_ADV_P_PersonType__c && 
				template.CRAN_VEC_ADV_P_Type__c == checkTemplate.CRAN_VEC_ADV_P_Type__c){
				return true;
			}
		}
		return false;
	}

	public static void deleteFormResponses(Map<Id,CRAN_VEC_ADV_CustomForm__c> listOld, List<CRAN_VEC_ADV_CustomForm__c> listNew){		
		System.debug('deleteFormResponses');
		for (String keyMap : listOld.keySet()){
			System.debug('entra bucle');
			CRAN_VEC_ADV_CustomForm__c element = listOld.get(keyMap);	
			System.debug('element '+element);
			System.debug('keyMap '+keyMap);

			CRAN_VEC_ADV_BatchDeleteCFResponse_CLS batchDelete = new CRAN_VEC_ADV_BatchDeleteCFResponse_CLS(keyMap);
			ID batchprocessid = Database.executeBatch(batchDelete,200);
			System.debug('IdBatch '+batchprocessid);
		}
	}


	public static void checkDelete(Map<Id,CRAN_VEC_ADV_CustomForm__c> mapOld, List<CRAN_VEC_ADV_CustomForm__c> listNew, String operacion){
		for (Id keyMap : mapOld.keySet()){
			CRAN_VEC_ADV_CustomForm__c element = mapOld.get(keyMap);
			System.debug('entra en check');
			if(element.CRAN_VEC_ADV_B_Enable__c==true) 
				element.addError(Label.CRAN_VEC_ADV_CF_TRIGGER_FAIL_DELETE);
		}
	}






	
}