/**
 * CRAN_VAS_KER_OppTriggerHandler_CLS Opportunity Trigger Handler Test Class
 * Fecha: Marzo 2017
 * @author VASS
 * @version 1.0
*/
@isTest
public class CRAN_VAS_KER_OppTriggerHandler_TST {
	
    /*
     * Initialize Data Factory
     */
    @testSetup
    static void testSetup() {

        //List<Contact> contacts = CRAN_VAS_KER_TestDataFactory_TST.createIndividualContact();
        //Contact contact = [SELECT Id, Account.FinServ__PrimaryContact__c, AccountId FROM Contact WHERE Id =: contacts[1].Id ];
   	
        Account acc = CRAN_VAS_KER_TestDataFactory_TST.createFsIndividualAccount();
            
        
        Account bp = CRAN_VAS_KER_TestDataFactory_TST.createBPAccounts()[1];
        List<Campaign> listCampaigns = CRAN_VAS_KER_TestDataFactory_TST.createSistematicaMarketingCampaigns();
        Campaign sistCampaign = listCampaigns.get(1);
        Campaign maqCampaign = listCampaigns.get(0);
        String name = 'Test sistematica goal';
        Opportunity objSist = CRAN_VAS_KER_TestDataFactory_TST.createSistematicaGoal(name, sistCampaign.Id,bp.Id,acc.Id,false);
		name = 'Test sistematica goal 2';
        Opportunity objSist2 = CRAN_VAS_KER_TestDataFactory_TST.createSistematicaGoal(name, sistCampaign.Id,bp.Id,acc.Id,false);
        name = 'Test sistematica sale';
        Opportunity sistSale = CRAN_VAS_KER_TestDataFactory_TST.createSistematicaSale(name, sistCampaign.Id,bp.Id,acc.Id,objSist.Id,false);
        name = 'Test sistematica sale bis';
        Opportunity sistSale2 = CRAN_VAS_KER_TestDataFactory_TST.createSistematicaSale(name, sistCampaign.Id,bp.Id,acc.Id,objSist.Id,false);
        name ='Test marketing goal';
        Opportunity objMaq = CRAN_VAS_KER_TestDataFactory_TST.createMarketingGoal(name, maqCampaign.Id,acc.Id,false);
        name ='Test personal goal';
        Opportunity objPers = CRAN_VAS_KER_TestDataFactory_TST.createMarketingGoal(name, null,acc.Id,false);
        name = 'Test marketing department goal';
        Opportunity objMaqDpt = CRAN_VAS_KER_TestDataFactory_TST.createMarketingDepartmentGoal(name, maqCampaign.Id,acc.Id,false);
        name = 'Test marketing sale';
        Opportunity maqSale = CRAN_VAS_KER_TestDataFactory_TST.createSistematicaSale(name, maqCampaign.Id,bp.Id,acc.Id,objMaq.Id,false);
        
        List<Opportunity> salesAndGoals = new List<Opportunity>();
        
        salesAndGoals.add(objSist);
        salesAndGoals.add(objSist2);
        salesAndGoals.add(objMaq);
        salesAndGoals.add(objPers);
        salesAndGoals.add(objMaqDpt);
        
        salesAndGoals.add(sistSale);
        salesAndGoals.add(sistSale2);
        salesAndGoals.add(maqSale);
        
        insert salesAndGoals;
        
        sistSale2.CRAN_VAS_MAQ_T_IdOperacionComercial__c='234124';
        sistSale2.StageName = 'Closed Won';       
                              
        update sistSale2;
        //Add campaignMember
        //String cmStatus = CRAN_VAS_KER_Constants_CLS.CAMPAIGNMEMBER_STATUS_WORKED;
        //CampaignMember cm = CRAN_VAS_KER_TestDataFactory_TST.addCampaignMemberToCampaign(maqCampaign.Id, acc.FinServ__PrimaryContact__c, maqSale, cmStatus);
        CRAN_VAS_KER_TestDataFactory_TST.updateUserDepartment(UserInfo.getUserId());
		
        CRAN_VAS_KER_TestDataFactory_TST.createCampaignInfluence(maqCampaign.Id,sistSale.Id, acc.FinServ__PrimaryContact__c);
    }
    
    /**
	 * Create Sale from Goal
	*/
	@isTest    
    static void createOppSale() {
		Opportunity obj = [select Id from Opportunity where Name = 'Test sistematica goal'];
        Opportunity sale = [select Id from Opportunity where Name = 'Test sistematica sale'];
        
        List<CRAN_VAS_MAQ_VentasObjetivos__c> salesGoals = [select CRAN_VAS_MAQ_L_Venta__C, 
                                                  CRAN_VAS_MAQ_MD_Objetivo__C 
                                                  from CRAN_VAS_MAQ_VentasObjetivos__c
                                                  where CRAN_VAS_MAQ_L_Venta__c = :sale.Id
													AND CRAN_VAS_MAQ_MD_Objetivo__C = : obj.Id];

        System.assert(!salesGoals.isEmpty());
	}
    
    /**
	 * Update sale to stage Closed Won from Opportunity Page
	*/
	@isTest    
    static void updateOppSale() {
        Id recordTypeVentaGanada = CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_GANADA_RT);
        Opportunity sale = [select Id,StageName,CRAN_VAS_MAQ_T_IdOperacionComercial__c from Opportunity where Name = 'Test sistematica sale'];
        Opportunity obj = [select Id,CRAN_VAS_MAQ_F_B_Objetivo_Conseguido__c from Opportunity where Name = 'Test sistematica goal'];
        List<CRAN_VAS_MAQ_VentasObjetivos__c> salesGoals = [select CRAN_VAS_MAQ_L_Venta__C, 
                                                  CRAN_VAS_MAQ_MD_Objetivo__C 
                                                  from CRAN_VAS_MAQ_VentasObjetivos__c
                                                  where CRAN_VAS_MAQ_L_Venta__c = :sale.Id
													AND CRAN_VAS_MAQ_MD_Objetivo__C = : obj.Id];
        System.assert(!salesGoals.isEmpty());
        
        System.debug('Venta a actualizar: '+sale);
        sale.StageName = 'Closed Won';
        sale.CRAN_VAS_MAQ_T_IdOperacionComercial__c = '132456';
        
        
        update sale;
        
        obj = [select Id,CRAN_VAS_MAQ_F_B_Objetivo_Conseguido__c from Opportunity where Name = 'Test sistematica goal'];       
        boolean completed = obj.CRAN_VAS_MAQ_F_B_Objetivo_Conseguido__c;
        System.assert(completed);
        
        sale = [select Id, RecordTypeId from Opportunity where Name = 'Test sistematica sale'];
        boolean saleRecordTypeChanged = sale.RecordTypeId == recordTypeVentaGanada;                
        System.assert(saleRecordTypeChanged);
       
	}

	/**
	 * Update sale to stage Closed Won from Opportunity Page
	*/
	@isTest    
    static void updateOppSaleMaq() {
		Opportunity sale = [select Id from Opportunity where Name = 'Test marketing sale'];
        sale.StageName = 'Closed Won';
        sale.CRAN_VAS_MAQ_T_IdOperacionComercial__c = '132456';
        update sale;
        
        Opportunity obj = [select Id,CRAN_VAS_MAQ_F_B_Objetivo_Conseguido__c from Opportunity where Name = 'Test marketing goal'];
       	boolean completed = false;
        
        completed = obj.CRAN_VAS_MAQ_F_B_Objetivo_Conseguido__c;
        
        System.assert(completed);
       
	}

    
    /**
	 * Delete Sale
	*/
	@isTest static void deleteOppSale() {
		Opportunity sale = [select Id from Opportunity where Name = 'Test sistematica sale'];
        delete sale;
        List<CRAN_VAS_MAQ_VentasObjetivos__c> salesGoals = [select CRAN_VAS_MAQ_L_Venta__C, 
                                                  CRAN_VAS_MAQ_MD_Objetivo__C 
                                                  from CRAN_VAS_MAQ_VentasObjetivos__c
                                                  where CRAN_VAS_MAQ_L_Venta__C = :sale.Id];
        boolean found = false;
        if(salesGoals.size()>0){
            found = true;
        }
        System.assert(!found);
	}
    
     /**
	 * Closed Won Sale
	*/
	@isTest static void closedWonOppSale() {
		Opportunity sale = [select Id from Opportunity where Name = 'Test sistematica sale'];
        sale.CRAN_VAS_MAQ_T_IdOperacionComercial__c='123123';
        sale.StageName = 'Closed Won';
        update sale;
        
 		sale = [select Id, RecordTypeId from Opportunity where Name = 'Test sistematica sale'];
        
        System.assert(sale.RecordTypeId == CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_GANADA_RT));
	}
    
    /**
	 * Closed Won Sale
	*/
	@isTest static void cancelledOppSale() {
        
		Opportunity sale = [select Id from Opportunity where Name = 'Test sistematica sale'];
        sale.CRAN_VAS_MAQ_T_IdOperacionComercial__c='123123';
        sale.StageName = 'Closed Won';        
        update sale;

 		sale = [select Id, RecordTypeId from Opportunity where Name = 'Test sistematica sale'];        
        sale.StageName = 'Cancelled';
        update sale;
        
        sale = [select Id, RecordTypeId from Opportunity where Name = 'Test sistematica sale'];
        
        System.assert(sale.RecordTypeId == CRAN_VAS_KER_RecordTypeUtil_CLS.getRecTypeId('Opportunity', CRAN_VAS_KER_Constants_CLS.OPP_VENTA_CANCELADA_RT));
	}
}