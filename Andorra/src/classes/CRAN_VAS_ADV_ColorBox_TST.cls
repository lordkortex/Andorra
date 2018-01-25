@isTest
public class CRAN_VAS_ADV_ColorBox_TST {
    public static final String ONE_FIELDNAME_BOOLEAN = 'CRAN_VEC_ADV_B_BigCliUnit__c';
    public static final String ONE_FIELDNAME_DATE = 'CRAN_VEC_ADV_D_Close__c';
    public static final String FIELDNAMES_ACC = 'Cash_and_Money_BP__c,Loans_BP__c,Credit_Card_BP__c';
	public static final String FIELDNAMES_ACC_WITH_RS = 'Owner.Name, FinServ__PrimaryContact__r.CRAN_VEC_ADV_P_MIFIDCLASS__c,FinServ__PrimaryContact__r.CRAN_VEC_ADV_P_IsPEP__c';
    public static final String INVALID_FIELDNAMES = 'ABCDEFG';
    
    
    @testSetup 
	static void loadTestData() {
        CRAN_VAS_KER_TestDataFactory_TST dataFactory = new CRAN_VAS_KER_TestDataFactory_TST();
		      
        Account accIndividual = CRAN_VAS_KER_TestDataFactory_TST.createFsIndividualAccount();        
	}
    
    
    @isTest static void testColorBoxData() {       	
        try{
          // Get account
          Account acc = [SELECT Id FROM Account LIMIT 1]; 		   
          system.assert(acc != null);    
          
          Map<String,Object> result = CRAN_VAS_ADV_ColorBox_AUC.getObjectInfo(acc.Id, FIELDNAMES_ACC);  

          System.assert(result != null);
          System.assertEquals(result.size(),4);          
          System.assert(result.keySet().contains(CRAN_VAS_ADV_ColorBox_AUC.CURRENCY_ISO_CODE));  
            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        }
    }
    
    @isTest static void testColorBoxData_WithRelationship() {       	
        try{
          // Get account
          Account acc = [SELECT Id FROM Account LIMIT 1]; 		   
          system.assert(acc != null);    
          
          Map<String,Object> result = CRAN_VAS_ADV_ColorBox_AUC.getObjectInfo(acc.Id, FIELDNAMES_ACC_WITH_RS);  
          System.assert(result != null);
          System.assertEquals(result.size(),2);
          System.assert(result.keySet().contains(CRAN_VAS_ADV_ColorBox_AUC.CURRENCY_ISO_CODE));  
            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        }
    }
    
    @isTest static void testColorBoxData_OneField_Boolean() {       	
        try{
          // Get account
          Account acc = [SELECT Id FROM Account LIMIT 1]; 		   
          system.assert(acc != null);    
          
          Map<String,Object> result = CRAN_VAS_ADV_ColorBox_AUC.getObjectInfo(acc.Id, ONE_FIELDNAME_BOOLEAN);  
          System.assert(result != null);
          System.assertEquals(result.size(),2);
          System.assert(result.keySet().contains(CRAN_VAS_ADV_ColorBox_AUC.CURRENCY_ISO_CODE));  
            
          String firstValue = String.valueOf(result.get((new List<String>(result.keySet()))[0]));
          System.assert((firstValue == Label.CRAN_VAS_ADV_CF_LBL_Yes) ||  (firstValue == Label.CRAN_VAS_ADV_CF_LBL_No ) )  ;
            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        }
    }
    
     @isTest static void testColorBoxData_OneField_Date() {       	
        try{
          // Get account
          Account acc = [SELECT Id FROM Account LIMIT 1]; 		   
          system.assert(acc != null);    
          
          Map<String,Object> result = CRAN_VAS_ADV_ColorBox_AUC.getObjectInfo(acc.Id, ONE_FIELDNAME_DATE);  
            
          System.assert(result != null);
          System.assertEquals(result.size(),2);
          System.assert(result.keySet().contains(CRAN_VAS_ADV_ColorBox_AUC.CURRENCY_ISO_CODE));  
            
        } catch (Exception ex) { 
            System.debug('Exception:'+ex.getMessage());
            system.assert(false);
        }
    }
    
    @isTest static void test_Invalid_FieldDames() {       	
        boolean exceptionThrown = false;
        try{
          // Get account
          Account acc = [SELECT Id FROM Account LIMIT 1]; 		   
          system.assert(acc != null);    
          CRAN_VAS_ADV_ColorBox_AUC.getObjectInfo(acc.Id, INVALID_FIELDNAMES);          
        } catch (Exception ex) { 
            exceptionThrown = true;
        }
        
        System.assertEquals(exceptionThrown, true);
    }
}