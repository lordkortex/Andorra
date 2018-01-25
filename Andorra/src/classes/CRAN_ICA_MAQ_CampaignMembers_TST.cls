@isTest
public class CRAN_ICA_MAQ_CampaignMembers_TST {

    
    @testSetup
	static void loadTestData() {
      
        String idRecordAccountBP = CRAS_ICA_ASS_CustomSettingsUtil_CLS.getObjectRecordTypeId(Account.SObjectType,'CRAN_VEC_ADV_Business_Partner');	

        Account acc = new Account();
        acc.Name = 'Test account BP';
        acc.RecordTypeId = idRecordAccountBP;
        insert acc;

        Account accCont = new Account();
        accCont.Name = 'Test account contact';
        insert accCont;
        
        Contact con = new Contact();
        con.LastName = 'Test contact';
        con.AccountId = accCont.Id;
        insert con;
        
        FinServ__FinancialAccount__c finAcc = new FinServ__FinancialAccount__c();
        finAcc.Name = 'Test fa';
        finAcc.FinServ__PrimaryOwner__c = acc.Id;
        insert finAcc;
        
        
        FinServ__FinancialAccountRole__c far = new FinServ__FinancialAccountRole__c();
        far.FinServ__RelatedAccount__c = acc.Id;
        far.FinServ__RelatedContact__c = con.Id;
        far.FinServ__FinancialAccount__c =   finAcc.Id;
        far.FinServ__Role__c = 'Beneficiary';
        insert far;
        
        String idRecordTypeCampana = CRAS_ICA_ASS_CustomSettingsUtil_CLS.getObjectRecordTypeId(Campaign.SObjectType,'CRAN_VAS_MAQ_MarquetingRecordType');	

        Campaign c = new Campaign(); 
        c.Name = 'Test Campaign';
        c.RecordTypeId = idRecordTypeCampana; 
		insert c;
        
        CampaignMember  cm = new CampaignMember();
        cm.ContactId= con.Id;
        cm.Status='Opt-In'; 
        cm.CampaignId = c.Id;
        cm.CRAN_VAS_MAQ_L_GestorMiembroCampana__c =  UserInfo.getUserId();
        insert cm;

        
    }    
    
    /*
    @isTest  
    static void getData_AuraController(){
    	//Testeamos el aura controller que llama a un Webservice.  
        
        try{
 
          Campaign camp = [select name,id from campaign];
        
          String body = '[{"name":"00080140 00080140"}]';
        
		  Map<String, String> headerMap = new Map<String, String>{'Content-Type' => 'application/json'};	
        
		  Test.startTest(); 
          Test.setMock(HttpCalloutMock.class, new CRAN_VAS_KER_SingleRequestMock(200, 'Success', body, headerMap));
		  String records = CRAN_ICA_MAQ_CampaignMembers_AUC.getRecords(camp.Id);   
          Test.stopTest();  
          System.assert(records != null && records.length() > 0); 

        }
        catch( System.CalloutException  e){
            System.debug('Exception:' + e.getMessage());
            System.assert(false);
        } 
        
    }    
    
   
    @isTest 
	static void getDataCSV_BackEnd() {
    	//Testeamos las clases que estan detras del WS
           
        Campaign camp = [select id from campaign];

        List<CRAN_ICA_KER_CampaignMembers_DTO> lCampingMembers = CRAN_ICA_KER_CampaignMembers_CTR.getCampaignMembers(camp.id);

        System.assert(lCampingMembers != null && !lCampingMembers.isEmpty());
    }    
    
    
    @isTest 
	static void getData_WS() {
    
        //Test.startTest(); //CRAS_ICA_ASS_sntRestYear_WSR.getSntByMarket(); //CRAS_ICA_ASS_CleanInsuranceData_Job    
        List<CRAN_ICA_KER_CampaignMembers_DTO> lDTO = CRAN_ICA_KER_campaignMembersRest_WSR.getCampaignSales();
        System.assert(lDTO != null);
        //Test.stopTest();  
     }*/
     
    
    @isTest 
	static void get_AUC_Batch() {
    	

       //Testeamos las clases AUC y Batch que se ejecuta
           
        Campaign camp = [select name,id from campaign];
 
        if(camp != null)
        {
        	String records = CRAN_ICA_MAQ_CampaignMembers_AUC.getRecords(camp.Id  , UserInfo.getUserId() );
        
        	System.assert(records == '');
        }
        
    }  
    
}