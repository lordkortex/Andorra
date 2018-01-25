@isTest
private class CRAN_VAS_KER_SchemaHelper_TST {

    @isTest static void getSObjectInfo() {
        
        update new User ( Id = UserInfo.getUserId(), LanguageLocaleKey='en_US' );
        
        System.runAs(new User( Id = UserInfo.getUserId())) {    
            Account acc = new Account(Name = 'Name');
            insert acc;
            
            system.assert(CRAN_VAS_KER_SchemaHelper_CLS.getRecordNameById(acc.Id) == 'Name');
            system.assert(CRAN_VAS_KER_SchemaHelper_CLS.getSObjectApiName(acc.Id) == 'Account');
            system.assert(CRAN_VAS_KER_SchemaHelper_CLS.getSObjectLabelById(acc.Id) == 'Account');
            system.assert(CRAN_VAS_KER_SchemaHelper_CLS.getSObjectLabelPluralById(acc.Id) == 'Accounts');
            system.assert(CRAN_VAS_KER_SchemaHelper_CLS.getRecordNameById('0019E000009PZbAQAW') == ''); 
            
        }
        
    }
    
}