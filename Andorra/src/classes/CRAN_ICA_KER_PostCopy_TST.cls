@isTest
public class CRAN_ICA_KER_PostCopy_TST {

    @isTest  
    static void testPostcopy()
    {
        CRAN_ICA_KER_PostCopy_CLS apexclass = new CRAN_ICA_KER_PostCopy_CLS();
        Test.testSandboxPostCopyScript(apexclass, UserInfo.getOrganizationId(), UserInfo.getOrganizationId(), 'sandbox');

        List<FinServ__FinancialAccountRole__c> relLst = [SELECT id FROM FinServ__FinancialAccountRole__c];
        System.assert(relLst.Size() > 0);
    }
}