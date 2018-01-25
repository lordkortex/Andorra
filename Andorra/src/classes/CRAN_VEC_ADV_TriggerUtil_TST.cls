@isTest
private class CRAN_VEC_ADV_TriggerUtil_TST {
    @isTest 
    static void CRAN_VEC_ADV_TriggerUtil_test_Two_Enable() {
        Test.startTest();
        CRAN_VEC_ADV_CustomForm__c temp1 = new CRAN_VEC_ADV_CustomForm__c();
	        temp1.CRAN_VEC_ADV_B_Enable__c = true;
	        temp1.CRAN_VEC_ADV_N_Version__c = 1;
	        temp1.CRAN_VEC_ADV_P_PersonType__c = '120';
	        temp1.CRAN_VEC_ADV_P_Type__c = 'mdb$mifid';
	        temp1.CRAN_VEC_ADV_T_Metadata_Types_ID__c = 'CRAN_VEC_ADV_CF_SUIV2PF';
	    insert temp1;

		CRAN_VEC_ADV_CustomForm__c temp2 = new CRAN_VEC_ADV_CustomForm__c();
	        temp2.CRAN_VEC_ADV_B_Enable__c = true;
	        temp2.CRAN_VEC_ADV_N_Version__c = 1;
	        temp2.CRAN_VEC_ADV_P_PersonType__c = '120';
	        temp2.CRAN_VEC_ADV_P_Type__c = 'mdb$mifid';
	        temp2.CRAN_VEC_ADV_T_Metadata_Types_ID__c = 'CRAN_VEC_ADV_CF_SUIV2PJ';
	    
	    try{
			insert temp2;
		} catch(DMLException e){
            System.debug('CRAN_VEC_ADV_TriggerUtil_test_Two_Enable '+e.getMessage());
        }

		Test.stopTest();

    }

    @isTest 
    static void CRAN_VEC_ADV_TriggerUtil_test_Enable_Disable() {
        Test.startTest();
        CRAN_VEC_ADV_CustomForm__c temp1 = new CRAN_VEC_ADV_CustomForm__c();
	        temp1.CRAN_VEC_ADV_B_Enable__c = true;
	        temp1.CRAN_VEC_ADV_N_Version__c = 1;
	        temp1.CRAN_VEC_ADV_P_PersonType__c = '120';
	        temp1.CRAN_VEC_ADV_P_Type__c = 'mdb$mifid';
	        temp1.CRAN_VEC_ADV_T_Metadata_Types_ID__c = 'CRAN_VEC_ADV_CF_SUIV2PF';
	    insert temp1;

		CRAN_VEC_ADV_CustomForm__c temp2 = new CRAN_VEC_ADV_CustomForm__c();
	        temp2.CRAN_VEC_ADV_B_Enable__c = false;
	        temp2.CRAN_VEC_ADV_N_Version__c = 1;
	        temp2.CRAN_VEC_ADV_P_PersonType__c = '120';
	        temp2.CRAN_VEC_ADV_P_Type__c = 'mdb$mifid';
	        temp2.CRAN_VEC_ADV_T_Metadata_Types_ID__c = 'CRAN_VEC_ADV_CF_SUIV2PJ';
	    insert temp2;

	    temp2.CRAN_VEC_ADV_B_Enable__c = true;
	    try{
	    	update temp2;
	    }catch(DMLException e){
            System.debug('CRAN_VEC_ADV_TriggerUtil_test_Enable_Disable '+e.getMessage());
        }

		Test.stopTest();

    }

    @isTest 
    static void CRAN_VEC_ADV_TriggerUtil_test_DeleteEnable() {
        Test.startTest();
        CRAN_VEC_ADV_CustomForm__c temp1 = new CRAN_VEC_ADV_CustomForm__c();
	        temp1.CRAN_VEC_ADV_B_Enable__c = true;
	        temp1.CRAN_VEC_ADV_N_Version__c = 1;
	        temp1.CRAN_VEC_ADV_P_PersonType__c = '120';
	        temp1.CRAN_VEC_ADV_P_Type__c = 'mdb$mifid';
	        temp1.CRAN_VEC_ADV_T_Metadata_Types_ID__c = 'CRAN_VEC_ADV_CF_SUIV2PF';
	    
	    insert temp1;
	    
	    try{
	    	delete temp1;
	    }catch(DMLException e){
	    	System.debug('CRAN_VEC_ADV_TriggerUtil_test_DeleteEnable '+e.getMessage());
	    }

		Test.stopTest();

    }

    @isTest 
    static void CRAN_VEC_ADV_TriggerUtil_test_DeleteDisable() {
        Test.startTest();
        CRAN_VEC_ADV_CustomForm__c temp1 = new CRAN_VEC_ADV_CustomForm__c();
	        temp1.CRAN_VEC_ADV_B_Enable__c = false;
	        temp1.CRAN_VEC_ADV_N_Version__c = 1;
	        temp1.CRAN_VEC_ADV_P_PersonType__c = '120';
	        temp1.CRAN_VEC_ADV_P_Type__c = 'mdb$mifid';
	        temp1.CRAN_VEC_ADV_T_Metadata_Types_ID__c = 'CRAN_VEC_ADV_CF_SUIV2PF';
	    
	    insert temp1;
	    delete temp1;

		Test.stopTest();

    }
}