@isTest
public class CRAN_VAS_ADV_PageHeader_TST {
    
    public static final String FIELDNAMES_WITHOUT_RT='{"NONE":[{"iconName":"user","iconCategory":"standard","fieldName":"CRAN_VEC_ADV_F_Person_Number__c"},{"iconName":"call","iconCategory":"standard","fieldName":"CRAN_VEC_ADV_F_HeaderContact1__c"},{"iconName":"","iconCategory":"","fieldName":"CRAN_VEC_ADV_F_HeaderContact2__c"},{"iconName":"","iconCategory":"","fieldName":"CRAN_VEC_ADV_B_BigCliUnit__c"},{"iconName":"","iconCategory":"","fieldName":"CRAS_ICA_ASS_F_RRestri__c"}]}';
    public static final String FIELDNAMES_BY_RT='{"CRAN_VEC_ADV_Individual":[{"iconName":"user","iconCategory":"standard","fieldName":"CRAN_VEC_ADV_F_Person_Number__c"},{"iconName":"call","iconCategory":"standard","fieldName":"CRAN_VEC_ADV_F_HeaderContact1__c"},{"iconName":"","iconCategory":"","fieldName":"CRAN_VEC_ADV_F_HeaderContact2__c"},{"iconName":"","iconCategory":"","fieldName":"CRAN_VEC_ADV_B_BigCliUnit__c"},{"iconName":"","iconCategory":"","fieldName":"CRAS_ICA_ASS_F_RRestri__c"}],"CRAN_VEC_ADV_Business":[{"iconName":"user","iconCategory":"standard","fieldName":"CRAN_VEC_ADV_F_Person_Number__c"},{"iconName":"call","iconCategory":"standard","fieldName":"CRAN_VEC_ADV_F_HeaderContact1__c"},{"iconName":"","iconCategory":"","fieldName":"CRAN_VEC_ADV_F_HeaderContact2__c"},{"iconName":"","iconCategory":"","fieldName":"CRAN_VEC_ADV_B_BigCliUnit__c"}],"CRAN_VEC_ADV_Business_Partner":[{"iconName":"custom32","iconCategory":"custom","fieldName":"CRAN_VEC_ADV_P_Branch__c"},{"iconName":"custom57","iconCategory":"custom","fieldName":"FinServ__ClientCategory__c"}]}';
    public static final String INVALID_CRUD_FLS='{"CRAN_VEC_ADV_Business_Partner":[{"iconName":"","iconCategory":"","fieldName":"TEST"}]}';
    public static final String ONEFIELDNAME_RS='{"CRAN_VEC_ADV_Individual":[{"iconName":"","iconCategory":"","fieldName":"FinServ__PrimaryContact__r.CRAN_VEC_ADV_P_IsPEP__c"}]}';
    public static final String ONEFIELDNAME_CURRENCY='{"CRAN_VEC_ADV_Individual":[{"iconName":"","iconCategory":"","fieldName":"Cash_and_Money_BP__c"}]}';
    public static final String ONEFIELDNAME_PICKLIST='{"CRAN_VEC_ADV_Individual":[{"iconName":"","iconCategory":"","fieldName":"CRAN_VEC_ADV_P_CliNature__c"}]}';
    
    @testSetup 
    static void loadTestData() {
        CRAN_VAS_KER_TestDataFactory_TST dataFactory = new CRAN_VAS_KER_TestDataFactory_TST();
        
        Account accIndividual = CRAN_VAS_KER_TestDataFactory_TST.createFsIndividualAccount();
        Account accBusiness = dataFactory.createBusinessAccount();
        Account accBusinessPartner = CRAN_VAS_KER_TestDataFactory_TST.createBPAccounts().get(0);
    }
    
    @isTest static void testGetRecordTypeById() {       	
        
        List<Account> accs = [SELECT Id FROM Account LIMIT 3];
        
        system.assertEquals(accs.size(),3);    
        
        Set <String> recordTypes = new Set<String>();
        recordTypes.add(CRAN_VAS_KER_TestDataFactory_TST.Account_IndividualCA_Name);
        recordTypes.add(CRAN_VAS_KER_TestDataFactory_TST.Account_BusinessCA_Name);
        recordTypes.add(CRAN_VAS_KER_TestDataFactory_TST.Account_BusinessPartner_Name);
        
        for (Account acc:accs){
            String recordType = CRAN_VAS_ADV_PageHeader_AUC.getRecordTypeById(acc.Id);
            System.assert(recordType != null); 
            System.assert(recordTypes.contains(recordType));
        }
        
    }
    
    
    @isTest static void testGetPH_WithoutRT() {   
        
        // Get Account
        Account acc = [SELECT Id, RecordType.DeveloperName FROM Account LIMIT 1];
        system.assert(acc != null);              
        
        String result = CRAN_VAS_ADV_PageHeader_AUC.getRecordById(String.valueOf(acc.Id), acc.RecordType.DeveloperName, FIELDNAMES_WITHOUT_RT);
        System.assert(result.contains('value') && result.contains('label') && result.contains('iconName') && result.contains('iconCategory')
                      && result.contains('fieldType') && result.contains('fieldName'));            
    }
    
    @isTest static void testGetPH_ByRT_Individual() {   
        
        String recordTypeName = CRAN_VAS_KER_TestDataFactory_TST.Account_IndividualCA_Name;
        
        // Get Account with Individual Record Type 
        Account acc = [SELECT Id FROM Account WHERE RecordType.DeveloperName =:recordTypeName LIMIT 1];
        system.assert(acc != null);              
        
        String result = CRAN_VAS_ADV_PageHeader_AUC.getRecordById(String.valueOf(acc.Id), recordTypeName, FIELDNAMES_BY_RT);
        
        System.assert(result.contains('value') && result.contains('label') && result.contains('iconName') && result.contains('iconCategory')
                      && result.contains('fieldType') && result.contains('fieldName'));  
    }
    
    @isTest static void testGetPH_ByRT_Business() {   
        
        String recordTypeName = CRAN_VAS_KER_TestDataFactory_TST.Account_BusinessCA_Name;
        
        // Get Account with Business Record Type 
        Account acc = [SELECT Id FROM Account WHERE RecordType.DeveloperName =:recordTypeName LIMIT 1];
        system.assert(acc != null);              
        
        String result = CRAN_VAS_ADV_PageHeader_AUC.getRecordById(String.valueOf(acc.Id), recordTypeName, FIELDNAMES_BY_RT);
        
        System.assert(result.contains('value') && result.contains('label') && result.contains('iconName') && result.contains('iconCategory')
                      && result.contains('fieldType') && result.contains('fieldName'));  
        
    }
    
    @isTest static void testGetPH_ByRT_BusinessPartner() {   
        
        String recordTypeName = CRAN_VAS_KER_TestDataFactory_TST.Account_BusinessPartner_Name;
        
        // Get Account with Business Partner Record Type 
        Account acc = [SELECT Id FROM Account WHERE RecordType.DeveloperName =:recordTypeName LIMIT 1];
        system.assert(acc != null);              
        
        String result = CRAN_VAS_ADV_PageHeader_AUC.getRecordById(String.valueOf(acc.Id), recordTypeName, FIELDNAMES_BY_RT);
        
        System.assert(result.contains('value') && result.contains('label') && result.contains('iconName') && result.contains('iconCategory')
                      && result.contains('fieldType') && result.contains('fieldName'));  
    }
    
    @isTest static void testGetPH_WithRelationship() {   
        String recordTypeName = CRAN_VAS_KER_TestDataFactory_TST.Account_IndividualCA_Name;
        
        // Get Account with Individual Record Type 
        Account acc = [SELECT Id FROM Account WHERE RecordType.DeveloperName =:recordTypeName LIMIT 1];
        system.assert(acc != null);              
        
        String result = CRAN_VAS_ADV_PageHeader_AUC.getRecordById(String.valueOf(acc.Id), recordTypeName, ONEFIELDNAME_RS);
        
        System.assert(result.contains('value') && result.contains('label') && result.contains('iconName') && result.contains('iconCategory')
                      && result.contains('fieldType') && result.contains('fieldName'));  
        
    }
    
    @isTest static void testGetPH_Currency_Picklist_Types() {   
        
        String recordTypeName = CRAN_VAS_KER_TestDataFactory_TST.Account_IndividualCA_Name;
        
        // Get Account with Individual Record Type 
        Account acc = [SELECT Id FROM Account WHERE RecordType.DeveloperName =:recordTypeName LIMIT 1];
        system.assert(acc != null);              
        
        String resultPicklist = CRAN_VAS_ADV_PageHeader_AUC.getRecordById(String.valueOf(acc.Id), recordTypeName, ONEFIELDNAME_PICKLIST);
        System.assert(resultPicklist.contains('value') && resultPicklist.contains('label') && resultPicklist.contains('iconName') && resultPicklist.contains('iconCategory')
                      && resultPicklist.contains('fieldType') && resultPicklist.contains('fieldName'));  
        
        String resultCurrency = CRAN_VAS_ADV_PageHeader_AUC.getRecordById(String.valueOf(acc.Id), recordTypeName, ONEFIELDNAME_CURRENCY);
        System.assert(resultCurrency.contains('value') && resultCurrency.contains('label') && resultCurrency.contains('iconName') && resultCurrency.contains('iconCategory')
                      && resultCurrency.contains('fieldType') && resultCurrency.contains('fieldName'));  
        
    }
    
    @isTest static void test_InvalidCRUD_FLS() {   
        
        update new User ( Id = UserInfo.getUserId(), LanguageLocaleKey='en_US' );
        User readOnlyUser;
        String recordTypeName;
        Account acc;
        
        System.runAs(new User( Id = UserInfo.getUserId())) {
            
            recordTypeName = CRAN_VAS_KER_TestDataFactory_TST.Account_BusinessPartner_Name;
            
            // Get Account with Business Partner Record Type 
            acc = [SELECT Id FROM Account WHERE RecordType.DeveloperName =:recordTypeName LIMIT 1];
            System.assert(acc != null);              
            
            readOnlyUser = CRAN_VAS_KER_TestDataFactory_TST.createUser(null, 'Read Only' , null, null);
        }
        
        System.runAs(readOnlyUser) {   
            String result = CRAN_VAS_ADV_PageHeader_AUC.getRecordById(String.valueOf(acc.Id), recordTypeName, INVALID_CRUD_FLS);
        }            
        
    }
}