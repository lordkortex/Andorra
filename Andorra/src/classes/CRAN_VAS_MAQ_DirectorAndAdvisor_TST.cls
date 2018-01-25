@isTest
private class CRAN_VAS_MAQ_DirectorAndAdvisor_TST {
    @isTest static void getSobjectLabel() {
        
        User advisor = CRAN_VAS_KER_TestDataFactory_TST.createAdvisor(null);      
        
        system.runAs(advisor) {     
            List<String> response = 
                (List<String>)JSON.deserialize(CRAN_VAS_MAQ_DirectorAndAdvisor_AUC.getSobjectLabel(UserInfo.getUserId()), List<String>.class);
            system.assert(response[0] == 'Users');
            system.assert(response[1] == 'Testing');
            system.assert(response[2] == 'User');
        }
        
        
    }
}