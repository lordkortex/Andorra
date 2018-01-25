public class CRAN_VEC_ADV_customSettingUtil_CLS {
	public static void createAvaloqCustomSetting(){
        CRAN_VEC_ADV_AvaloqSettings__c aCS = new CRAN_VEC_ADV_AvaloqSettings__c();
        aCS.CRAN_VEC_ADV_T_AlgorithmName__c = 'AES128';
        aCS.CRAN_VEC_ADV_DatapowerEncrypted__c = 'https://e-credit.dev.creditandorragroup.com/AvaloqServiciosSF/lanzarServicio/';
        aCS.CRAN_VEC_ADV_T_PrivateKey__c = '1234567890123456';
        aCS.CRAN_VEC_ADV_T_TimeOut__c = 30000.0;
        aCS.CRAN_VEC_ADV_B_Debug__c = true;
        aCS.CRAN_VEC_ADV_B_MockServices__c = true;
        aCS.CRAN_VEC_ADV_T_Enviroment__c = 'DEV';
        aCS.CRAN_VEC_ADV_T_CodAppOrigin__c = 'FSC';
        aCS.SetupOwnerId = UserInfo.getOrganizationId();
        insert aCS;
    }

    public static void createPortfolioCustomSetting(){
        CRAN_VEC_ADV_Portfolio__c pCS = new CRAN_VEC_ADV_Portfolio__c();

        List<Report> lstReports = [SELECT Id,DeveloperName FROM Report WHERE DeveloperName = 'CRAN_VEC_ADV_PF_Business_Partner'];
        if(lstReports.size()>0){
            pCS.CRAN_VEC_ADV_ReportId_BP__c = lstReports[0].Id; 
        }

        lstReports = [SELECT Id,DeveloperName FROM Report WHERE DeveloperName = 'CRAN_VEC_ADV_PF_Financial_Account'];
        if(lstReports.size()>0){
            pCS.CRAN_VEC_ADV_ReportId_FA__c = lstReports[0].Id;
        }
        lstReports = [SELECT Id,DeveloperName FROM Report WHERE DeveloperName = 'CRAN_VEC_ADV_PF_Person'];
        if(lstReports.size()>0){
            pCS.CRAN_VEC_ADV_ReportId_Person__c = lstReports[0].Id;
        }

        lstReports = [SELECT Id,DeveloperName FROM Report WHERE DeveloperName = 'CRAN_VEC_ADV_PF_Business_Partner_Chart'];
        if(lstReports.size()>0){
            pCS.CRAN_VEC_ADV_ChartReportId_BP__c = lstReports[0].Id;
        }

        lstReports = [SELECT Id,DeveloperName FROM Report WHERE DeveloperName = 'CRAN_VEC_ADV_PF_Financial_Account_Chart'];
        if(lstReports.size()>0){
            pCS.CRAN_VEC_ADV_ChartReportId_FA__c = lstReports[0].Id;
        }
        lstReports = [SELECT Id,DeveloperName FROM Report WHERE DeveloperName = 'CRAN_VEC_ADV_PF_Person_Chart'];
        if(lstReports.size()>0){
            pCS.CRAN_VEC_ADV_ChartReportId_Person__c = lstReports[0].Id;
        }
		lstReports = [SELECT Id,DeveloperName FROM Report WHERE DeveloperName = 'CRAS_ICA_ASS_Insurance_Portfolio_Person_Chart_Report'];
        if(lstReports.size()>0){
            pCS.CRAS_ICA_ASS_ChartReportId_Person__c = lstReports[0].Id;
        }
		lstReports = [SELECT Id,DeveloperName FROM Report WHERE DeveloperName = 'CRAS_ICA_ASS_Insurance_Portfolio_Person_Report'];
        if(lstReports.size()>0){
            pCS.CRAS_ICA_ASS_ReportId_Person__c = lstReports[0].Id;
        }
        pCS.CRAN_VEC_ADV_ChartSize__c = 'large';
        pCS.CRAN_VEC_ADV_fieldChartBP__c = 'Account.Id';
        pCS.CRAN_VEC_ADV_fieldChartFA__c = 'FinServ__FinancialAccount__c.Id';
        pCS.CRAN_VEC_ADV_fieldChartPerson__c = 'Account.Id';
        pCS.CRAS_ICA_ASS_fieldChartPerson__c = 'FinServ__FinancialAccountRole__c.FinServ__RelatedContact__c.Id';
		pCS.CRAN_VEC_ADV_HrefTarget__c = '_blank';
        pCS.CRAN_VEC_ADV_AutoRedirect__c = false;
        pCS.Name = 'Default';
        pCS.SetupOwnerId = UserInfo.getOrganizationId();

        insert pCS;
    }
}