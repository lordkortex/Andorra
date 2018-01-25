@isTest
private class CRAN_VAS_KER_RoleUtils_TST {

    @isTest static void testRoleAndSubordinates() {

        User 	director 	= CRAN_VAS_KER_TestDataFactory_TST.createDirector();
        User	advisor 	= CRAN_VAS_KER_TestDataFactory_TST.createAdvisor(director.UserRoleId);

        System.runAs(director) {
            
            Set<Id> roles = CRAN_VAS_KER_RoleUtils_CLS.getRoleSubordinateUsers(UserInfo.getUserId());

            system.assert(roles.contains(advisor.Id));
            
            roles = CRAN_VAS_KER_RoleUtils_CLS.getRoleSubordinateUsersFromCurrentUser();

            system.assert(roles.contains(advisor.Id));
        }
    }
}