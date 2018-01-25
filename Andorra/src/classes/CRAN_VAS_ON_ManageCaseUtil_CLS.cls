/**
* VASS
* @author           Raul Mora raulalberto.mora@vass.es
* Project:          Credit Andorra
* Description:      Clase que contiene la logica para la creación del caso.
*
* Changes (Version)
* -------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0     22-01-2018     Griselda Diaz       Class definition. 
*********************************************************************************************************/
public class CRAN_VAS_ON_ManageCaseUtil_CLS{

	/**
	* @Method:      createCase
	* @Parameters:  ID
	* @Description: Method that will create the case based on the given parameters.
	*/
	public static Case createCase(ID idContact) {
		return createCase(idContact, null);
	}
	
	/**
	* @Method:      createCase
	* @Paramerers:  ID
	* @Description: Method that will create the case based on the obtained parameters.
	*/
	public static Case createCase(ID idLead, Id idSecurity) {
		Case objCase = new Case();
		Map<String, Id> mapRecordType = CRAN_VAS_ON_ManageObjectUtil_CLS.getMapRecordTypes('Case');

		try {
			//Map field to create case.
			objCase.Lead__c = idLead;
			objCase.Stage__c =  Label.CRAN_VAS_ON_Create_Case;
			objCase.Origin =
					'Onboarding'; // (2018-01-05) DJG MAO-182: Establecer como ORIGEN del nuevo CASE el proceso de ONBOARDING 'Web';
			objCase.Subject = 'Cliente onboarding';
			objCase.Description = 'Nuevo cliente generado desde onboarding online.';
			objCase.Status = 'New';
			//objCase.RecordTypeId = mapRecordType.get('Onboarding');
			
			insert objCase;
		} 
        catch (exception e) {
			System.debug('\n create Case error @@@ \n' + e);
			CRAN_VAS_ON_EventLoggerBase_CLS.getInstance().commitLog(e); // Logs the Exception in EventLogger__c custom object
			//AnswerUtils_cls.crearObjetoError('NewUser_createCase', e.getmessage());
			throw new CRAN_VAS_ON_Exception(500, e.getMessage());
		}

		return objCase;
	}
    
    /**
	* @Method:      updateCaseStage
	* @Paramerers:  ID, String, String
	* @Return:      Date
	* @Description: Method that will obtain the stage related to the obtained action and update the case stage.
	*/
	public static void updateCaseStage(ID idCase) {
	    //Custom setting to obtain the case stage name that needs to be updated to.
		//Case_Stage_Action__c objCaseSA = Case_Stage_Action__c.getValues(strAction);
		//Map to store the field API name and the value to assign.
		//Set the stage value based on the custom setting.*/

        try {
            Case objCase; 
            // Get the metadata related with the current stage of the case (idCase)
            Stage_Flow__mdt recoverMeta = getMapStages(idCase);            
            map<id, map<String, String>> mpFieldValueMap = new map<Id, map<String, String>>{ idCase => new Map<String, String>{'Stage__c'=>recoverMeta.Next_Stage__c} };
            CRAN_VAS_ON_ManageObjectUtil_CLS.updateObjectList ( mpFieldValueMap, 'Case' );
        }
        catch(Exception e){
            throw new CRAN_VAS_ON_Exception(500,'Error update the stage');
        }
    }
		
    public static Stage_Flow__mdt getMapStages( ID idCase ) { 
		string casestage = [Select Stage__c from Case where id = :idCase].Stage__c;       
        //Map to store the field API name and the value to assign.
		map<String, String> mpFieldValueCase = new map<String, String>();
		
		list<Stage_Flow__mdt> lstStages = new list<Stage_Flow__mdt>(
				[ SELECT Id, Label, ActionName__c, Current_Stage__c, Next_Stage__c, Prev_Stage__c FROM Stage_Flow__mdt  WHERE Current_Stage__c = :casestage ]);
		
        Stage_Flow__mdt first = (Stage_Flow__mdt) lstStages.get(0);
        
		return first;
	}
}