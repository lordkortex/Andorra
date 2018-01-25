/**
 * 
 * 
 * */
@isTest
public class CRAN_VAS_KER_RecordTypeUtil_TST {
    
    /**
     * Test the checkSharing (private method) method through the method getRecTypesByDevName.
     * */    
    @isTest    
    static void testCheckSharing() {
        
        UserRole 	userRole 		= CRAN_VAS_KER_TestDataFactory_TST.createUserRole('Director Oficina Escaldes', null);
        User 		officeDirector 	= CRAN_VAS_KER_TestDataFactory_TST.createUser(userRole.Id, 'Banking Office Director', 'Office Director User', null);
        
        System.runAs(officeDirector) {
        	Map<String,Id> recTypes = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypesByDevName('Opportunity',true); 
            System.assert(recTypes.get('CRAN_VAS_MAQ_Venta') != null);
 		}        
	}
    
    /**
     * Test the getRecTypeId method with enforceSharing
     * */
    @isTest
    static void testGetRecTypeIdEnforceSharing() {
        
        UserRole 	userRole 		= CRAN_VAS_KER_TestDataFactory_TST.createUserRole('Director Oficina Escaldes', null);        
        User 		officeDirector 	= CRAN_VAS_KER_TestDataFactory_TST.createUser(userRole.Id, 'Banking Office Director', 'Office Director User', null);
        
        System.runAs(officeDirector) {
			System.assert(CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity','CRAN_VAS_MAQ_Venta', true) != null);
		}
    }
    
     /**
     * Test the getRecTypeId method without enforceSharing through the getRecTypeId(object, devname) method
     * */
    @isTest
    static void testGetRecTypeId() {
        
        UserRole 	userRole 		= CRAN_VAS_KER_TestDataFactory_TST.createUserRole('Director Oficina Escaldes', null);        
        User 		officeDirector 	= CRAN_VAS_KER_TestDataFactory_TST.createUser(userRole.Id, 'Director', 'Office Director User', null);
        
        System.runAs(officeDirector) {
			System.assert(CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity','CRAN_VAS_MAQ_Venta') != null);
		}
    }
    
    /**
     * Test the getRecTypesByName method with enforceSharing
     * */
    @isTest
    static void testGetRecTypesByNameEnforceSharing() {

        UserRole 	userRole 		= CRAN_VAS_KER_TestDataFactory_TST.createUserRole('Director Oficina Escaldes', null);        
        User		officeDirector 	= CRAN_VAS_KER_TestDataFactory_TST.createUser(userRole.Id, 'Director', 'Office Director User', null);
        
        System.runAs(officeDirector) {
			System.assert(CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypesByName('Opportunity',true) != null);
		}
    }
    
     /**
     * Test the getRecTypesByName method without enforceSharing
     * */
    @isTest
    static void testGetRecTypesByName() {

        UserRole 	userRole 		= CRAN_VAS_KER_TestDataFactory_TST.createUserRole('Director Oficina Escaldes', null);        
        User 		officeDirector 	= CRAN_VAS_KER_TestDataFactory_TST.createUser(userRole.Id, 'Director', 'Office Director User', null);
        
        System.runAs(officeDirector) {
			System.assert(CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypesByName('Opportunity') != null);
		}
    }
    
    /**
     * Test the getRecTypesByName method without enforceSharing
     * */
    @isTest
    static void testGetRecTypesByDevName() {

        UserRole 	userRole 		= CRAN_VAS_KER_TestDataFactory_TST.createUserRole('Director Oficina Escaldes', null);        
        User 		officeDirector 	= CRAN_VAS_KER_TestDataFactory_TST.createUser(userRole.Id, 'Director', 'Office Director User', null);
        
        System.runAs(officeDirector) {
			System.assert(CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypesByDevName('Opportunity') != null);
		}
    }
    
    @isTest
    static void testSharingVisibilityAndInvalidValues() {     
        
        update new User ( Id = UserInfo.getUserId(), LanguageLocaleKey='en_US' );
        User readOnlyUser;
        
        System.runAs(new User( Id = UserInfo.getUserId())) {    
            System.assert(CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Account', 'Master') != null);
            
            readOnlyUser = CRAN_VAS_KER_TestDataFactory_TST.createUser(null, 'Read Only' , null, null);
            
            System.assert(CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', 'InvalidLabel') == null);
        }
        
        System.runAs(readOnlyUser) {
            System.assert(CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', 'CRAN_VAS_MAQ_Venta', true) == null);
            System.assert(CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypesByDevName('Opportunity', true) == null); 
        }
        
       
    }    
    
}