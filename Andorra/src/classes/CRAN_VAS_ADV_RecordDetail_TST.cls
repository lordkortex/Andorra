@isTest
public class CRAN_VAS_ADV_RecordDetail_TST {

    @testSetup 
	static void loadTestData() {
        CRAN_VAS_KER_TestDataFactory_TST dataFactory = new CRAN_VAS_KER_TestDataFactory_TST();
		dataFactory.createBusinessAccount();
	}
    
    @isTest static void testGetAccountRecordById() {       	
        try{
          // Get the first test account by using a SOQL query
          Account acc = [SELECT Id,CRAN_VEC_ADV_L_Advisor__r.Name,CRAN_VEC_ADV_B_ContractSigned__c,CRAN_VEC_ADV_D_SignDate__c FROM Account LIMIT 1];
 
          Account myAcc = CRAN_VAS_ADV_RecordDetail_AUC.getRecordById(acc.Id);
          system.assert(myAcc != null); 
            
          //Check Id  
          system.assert(myAcc.Id != null);    
          system.assertEquals(myAcc.Id, acc.Id); 
            
   		  //Check other fields   		           
          system.assertEquals(myAcc.CRAN_VEC_ADV_B_ContractSigned__c, acc.CRAN_VEC_ADV_B_ContractSigned__c); 
          system.assertEquals(myAcc.CRAN_VEC_ADV_D_SignDate__c, acc.CRAN_VEC_ADV_D_SignDate__c); 
          system.assertEquals(myAcc.CRAN_VEC_ADV_L_Advisor__r.Name, acc.CRAN_VEC_ADV_L_Advisor__r.Name); 
        } catch (Exception ex) { 
            System.debug('Exception (CRAN_VAS_ADV_RecordDetail_TST):'+ex.getMessage());
            system.assert(false);
        }
    }
}