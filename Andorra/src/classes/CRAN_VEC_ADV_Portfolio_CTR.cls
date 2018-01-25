/**
 * CRAN_VEC_ADV_Portfolio_CTR Show chart portfolio
 *
 * Fecha: 18/01/2017
 * @author  Iñaki Hernando Urcullu  (Cloud Coachers)
 *
*/

public with sharing class CRAN_VEC_ADV_Portfolio_CTR {

    public Account account {get; set;}
    public FinServ__FinancialAccount__c finnacialAccount {get; set;}
    public Contact contact {get; set;}

    public Id idSF;

    public String advReportId {get; private set;}
    public String advChartReportId {get; private set;}
    public String advFilters {get; private set;}
    public String advUrlReport {get; private set;}

    public String assReportId {get; private set;}
    public String assChartReportId {get; private set;}
    public String assFilters {get; private set;}
    public String assUrlReport {get; private set;}

    public String chartSize {get; private set;}

    public Boolean showError {get; private set;}

    public Boolean showRetryLink {get; private set;}
    public Boolean showDetailsLink {get; private set;}

    public List<String> lstAvaloqIdBPs {get; private set;}
    public Map<String,Account> mapAvaloqIdBPs {get; private set;}
    public List<ID> lstSFIdBPs {get; private set;}
    public CRAN_VEC_ADV_Portfolio__c cs{get; private set;}

    public String errorDetail {get; private set;}
    private static Id advisoryFHRecordTypeId;

    public String CRAS_ICA_ASS_T_AxisPersonID {get; private set;}
    public Boolean showGraphicASS {get; private set;}
    
    // Unique label corresponding to the continuation
    //public String requestLabel;

    /*-----------------------*/
    /*     CONSTRUCTOR       */
    /*-----------------------*/

    public CRAN_VEC_ADV_Portfolio_CTR(ApexPages.StandardController std) {
        try{
			CRAS_ICA_ASS_T_AxisPersonID = '';
            showGraphicASS = false;
            String advFieldChart;
            String assFieldChart;
            showError = false;
            lstAvaloqIdBPs = new List<String>();
            lstSFIdBPs = new List<ID>();
            cs = CRAN_VEC_ADV_Portfolio__c.getInstance();
            showRetryLink = cs.CRAN_VEC_ADV_showRetry__c;
            showDetailsLink = cs.CRAN_VEC_ADV_showDetailsErrors__c;

            idSF = std.getId();
            Schema.SObjectType objectAPIName = idSF.getSObjectType();
            string allIds = '';
            mapAvaloqIdBPs = new Map<String,Account>();
            if (objectAPIName == Schema.Account.SObjectType || objectAPIName == Schema.Contact.SObjectType) { // Account
                if (objectAPIName == Schema.Account.SObjectType) { // Account
                    if (!Test.isRunningTest()) {
                        std.addFields(new List<String> { 'Id',
                                                     'CRAN_VEC_ADV_T_BPId__c',
                                                     'CRAN_VEC_ADV_P_Bunit__c',
                            						 'CRAS_ICA_ASS_T_AxisBPID__c'
                                                   });
                        account = (Account)std.getRecord();
                    }else{
                        account = [SELECT Id,
                                            CRAN_VEC_ADV_T_BPId__c,
                                            CRAN_VEC_ADV_P_Bunit__c,
                                   			CRAS_ICA_ASS_T_AxisBPID__c
                                     FROM Account WHERE Id = :idSF LIMIT 1];
                    }
                    
                    if (String.isBlank(account.CRAN_VEC_ADV_T_BPId__c)){
                        contact = [SELECT Id, 
                                        CRAN_VEC_ADV_P_PersonType__c,
                                        CRAN_VEC_ADV_P_Bunit__c,
                                   		CRAS_ICA_ASS_T_AxisPersonID__c
                               FROM Contact
                               WHERE AccountId = :idSF];
                        idSF = contact.Id;
                        CRAS_ICA_ASS_T_AxisPersonID = contact.CRAS_ICA_ASS_T_AxisPersonID__c;
                        if (String.isBlank(CRAS_ICA_ASS_T_AxisPersonID)){
                            CRAS_ICA_ASS_T_AxisPersonID = '';
                        }
                    }
                } else { // Contact
                    if (!Test.isRunningTest()) {
                        std.addFields(new List<String> { 'CRAN_VEC_ADV_T_BPId__c',
                                                     'CRAN_VEC_ADV_P_Bunit__c',
                                                     'AccountId'
                                                   });
                        contact = (Contact)std.getRecord();
                    }else{
                        contact = [SELECT Id,CRAN_VEC_ADV_P_Bunit__c,AccountId FROM Contact WHERE Id = :idSf];    
                    }
                    
                    account = [SELECT   Id, 
                                        CRAN_VEC_ADV_T_BPId__c,
                                        CRAN_VEC_ADV_P_Bunit__c,
                               			CRAS_ICA_ASS_T_AxisBPID__c
                               FROM Account
                               WHERE Id = :contact.AccountId];
                }
                
                if (String.isNotBlank(account.CRAN_VEC_ADV_T_BPId__c)) { //BP
                    advReportId = cs.CRAN_VEC_ADV_ReportId_BP__c;
                    advchartReportId = cs.CRAN_VEC_ADV_ChartReportId_BP__c;

                    assReportId = cs.CRAS_ICA_ASS_ReportId_BP__c;
                    asschartReportId = cs.CRAS_ICA_ASS_ChartReportId_BP__c;
					
                    lstAvaloqIdBPs.add(account.CRAN_VEC_ADV_T_BPId__c);
                    lstSFIdBPs.add(account.Id);
                    mapAvaloqIdBPs.put(CRAN_VEC_ADV_Utils.getIdAvaloq(account.CRAN_VEC_ADV_T_BPId__c), account);
                    allIds = string.join(lstSFIdBPs,',');
                    advFieldChart = cs.CRAN_VEC_ADV_fieldChartBP__c;
                    assFieldChart = cs.CRAS_ICA_ASS_fieldChartBP__c;
                } else { // Person
                    idSF = contact.Id;
                    
                    advReportId = cs.CRAN_VEC_ADV_ReportId_Person__c;
                    advChartReportId = cs.CRAN_VEC_ADV_ChartReportId_Person__c;
					getBPs(idSF);
                    
                    if (String.isNotBlank(contact.CRAS_ICA_ASS_T_AxisPersonID__c)) { 
                        assReportId = cs.CRAS_ICA_ASS_ReportId_Person__c;
                        assChartReportId = cs.CRAS_ICA_ASS_ChartReportId_Person__c;
                        showGraphicASS = true;
                    }
                    else if(String.isNotBlank(account.CRAS_ICA_ASS_T_AxisBPID__c)){
                        showGraphicASS = false;
                    }

                    allIds = string.join(lstSFIdBPs,',');
                    advFieldChart = cs.CRAN_VEC_ADV_fieldChartPerson__c;
                    assFieldChart = cs.CRAS_ICA_ASS_fieldChartPerson__c;
                }

                advUrlReport = '/one/one.app#/sObject/' + advReportId + '/view?t=1484738421291'
                            + '&fv0=' + allIds;

                assUrlReport = '/one/one.app#/sObject/' + assReportId + '/view?t=1484738421291'
                            + '&fv0=' + idSF;
                advFilters = '[{column:\'' + advFieldChart + '\',operator:\'equals\', value:\'' + allIds + '\'}]';
                assFilters = '[{column:\'' + assFieldChart + '\',operator:\'equals\', value:\'' + idSF + '\'}]';
            } else if (objectAPIName == Schema.FinServ__FinancialAccount__c.SObjectType) {  //Financial Account
                if (!Test.isRunningTest()) {
                    std.addFields(new List<String> { 'CRAN_VEC_DEV_T_ContainerID__c',
                                                 'CRAN_VEC_ADV_P_Bunit__c',
                                                 'FinServ__PrimaryOwner__c',
                                                 'Id'
                                               });
                    finnacialAccount = (FinServ__FinancialAccount__c)std.getRecord();
                }else{
                    finnacialAccount = [SELECT Id,CRAN_VEC_DEV_T_ContainerID__c,CRAN_VEC_ADV_P_Bunit__c,FinServ__PrimaryOwner__c FROM FinServ__FinancialAccount__c WHERE Id = :idSF];

                }
                system.debug('finnacialAccount: ' + finnacialAccount);

                account = [SELECT   Id, 
                                        CRAN_VEC_ADV_T_BPId__c,
                                        CRAN_VEC_ADV_P_Bunit__c
                               FROM Account
                               WHERE Id = :finnacialAccount.FinServ__PrimaryOwner__c];

                List<Contact> lstContacts = [SELECT Id, 
                                  CRAN_VEC_ADV_P_PersonType__c,
                                  CRAN_VEC_ADV_P_Bunit__c
                           FROM Contact
                           WHERE AccountId = :finnacialAccount.FinServ__PrimaryOwner__c];
                if(lstContacts.size()>0){
                    contact = lstContacts[0];
                    idSF = contact.Id;
                }

                lstAvaloqIdBPs.add(account.CRAN_VEC_ADV_T_BPId__c);

                lstSFIdBPs.add(account.Id);
                mapAvaloqIdBPs.put(CRAN_VEC_ADV_Utils.getIdAvaloq(account.CRAN_VEC_ADV_T_BPId__c), account);
                allIds = string.join(lstSFIdBPs,',');

                advReportId = cs.CRAN_VEC_ADV_ReportId_FA__c;
                advChartReportId = cs.CRAN_VEC_ADV_ChartReportId_FA__c;

                assReportId = cs.CRAS_ICA_ASS_ReportId_FA__c;
                assChartReportId = cs.CRAS_ICA_ASS_ChartReportId_FA__c;

                advFieldChart = cs.CRAN_VEC_ADV_fieldChartFA__c;
                assFieldChart = cs.CRAS_ICA_ASS_fieldChartFA__c;

                advUrlReport = '/one/one.app#/sObject/' + advReportId + '/view?t=1484738421291' + '&fv0=' + finnacialAccount.Id;
                assUrlReport = '/one/one.app#/sObject/' + assReportId + '/view?t=1484738421291' + '&fv0=' + finnacialAccount.Id;
                
                advFilters = '[{column:\'' + advFieldChart + '\',operator:\'equals\', value:\'' + finnacialAccount.Id + '\'}]';
                assFilters = '[{column:\'' + assFieldChart + '\',operator:\'equals\', value:\'' + finnacialAccount.Id + '\'}]';
            }
        } catch (Exception e) {
            showError = true;
            System.debug('Exception: ' + e.getMessage());
            errorDetail = 'Error Detail' + '<br/>Line: ' + e.getLineNumber() + '<br/>Cause: ' + e.getCause() + '<br/>Type: ' + e.getTypeName() + '<br/>Message: ' + e.getMessage() + '<br/>Trace: ' + e.getStackTraceString();
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '' + e.getTypeName() + ' - ' + e.getMessage()));
        }
	}

    /*------------------------*/
    /*     PRIVATE METHODS    */
    /*------------------------*/

    private void getBPs(Id contactId) {
        System.debug('Contact Id: ' + contactId);
        // Se seleccionan todos los BPs relacionados con el Person.
        List<FinServ__FinancialAccountRole__c> lstFAR = CRAN_VEC_ADV_Utils.getRelatedBpsFromContactIDPortfolio(contactId);

        Set<String> setAvaloqIds = new Set<String>();
        Set<ID> setSFIds = new Set<ID>();
        

        for (FinServ__FinancialAccountRole__c far : lstFAR) {
            setAvaloqIds.add(far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_T_BPId__c);
            setSFIds.add(far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__c);
            mapAvaloqIdBPs.put(CRAN_VEC_ADV_Utils.getIdAvaloq(far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_T_BPId__c), far.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r);
        }

        lstAvaloqIdBPs = new List<String>(setAvaloqIds);
        lstSFIdBPs = new List<ID>(setSFIds);
    }

    /*-----------------------*/
    /*     ACTION BUTTONS    */
    /*-----------------------*/

    public void refreshPortfolio() {
        try {
            if(lstAvaloqIdBPs != null && lstAvaloqIdBPs.size() > 0){
                showError = false;
                if(!CRAN_VEC_ADV_RestClient_CLS.isServiceMock(CRAN_VEC_ADV_Constants_CLS.SERVICE_PORTFOLIO)){

                    List<CRAN_VEC_ADV_Portfolio_ObjAvaloq_CLS> lstObjAvaloq = new List<CRAN_VEC_ADV_Portfolio_ObjAvaloq_CLS>();
                    CRAN_VEC_ADV_Portfolio_ObjAvaloq_CLS auxObjAvaloq = new CRAN_VEC_ADV_Portfolio_ObjAvaloq_CLS();

                    auxObjAvaloq.setObjType('bp');

                    String idBU;

                    List<CRAN_VEC_ADV_Portfolio_id_CLS> lstObjIds = new List<CRAN_VEC_ADV_Portfolio_id_CLS>();

                    for (String idToAdd : lstAvaloqIdBPs) {
                        
                        CRAN_VEC_ADV_Portfolio_id_CLS auxAvaloqId = new CRAN_VEC_ADV_Portfolio_id_CLS();
                        auxAvaloqId.setAvqId(Integer.valueOf(CRAN_VEC_ADV_Utils.getIdAvaloq(idToAdd)));
                        idBU = CRAN_VEC_ADV_Utils.getBUAvaloq(idToAdd);
                        lstObjIds.add(auxAvaloqId);
                    }
                    auxObjAvaloq.setObjLst(lstObjIds);

                    lstObjAvaloq.add(auxObjAvaloq);

                    // Create Request
                    CRAN_VEC_ADV_PortfolioRQ_CLS rq = new CRAN_VEC_ADV_PortfolioRQ_CLS();
                    rq.setDateTo(null);
                    rq.setObjList(lstObjAvaloq);

                    rq.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));

                    String jsonRequest = JSON.serialize(rq);
                    
                    CRAN_VEC_ADV_RestClient_CLS avaloqClient;
                    errorDetail = 'Request: ' + jsonRequest;
                    avaloqClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_PORTFOLIO,idBU,jsonRequest);
                    errorDetail = 'Response: ' + avaloqClient.responseBody;
                    CRAN_VEC_ADV_PortfolioRS_CLS response = (CRAN_VEC_ADV_PortfolioRS_CLS)JSON.deserialize(avaloqClient.responseBody, CRAN_VEC_ADV_PortfolioRS_CLS.class);
                    List<CRAN_VEC_ADV_ProcessSTError_CLS> lstErrors = response.getErrors();
                    if(lstErrors!=null){
                        System.debug('lstErrors.size():' + lstErrors.size());
                        if(lstErrors.size()>0){
                            showError = true;
                            errorDetail = 'Avaloq errors:';
                            for(CRAN_VEC_ADV_ProcessSTError_CLS error: lstErrors){
                                errorDetail += '<br/>Code: ' + error.getCode();
                                errorDetail += '<br/>Description: ' + error.getDesc();
                            }
                            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '' + CRAN_VEC_ADV_Utils.getAllErrorsService(lstErrors)));
                        }else{
                            insertResponse(response);
                        }
                    }else{
                        insertResponse(response);
                    }
                }
            }else{
                showError = true;
                errorDetail = Label.CRAN_VEC_ADV_PORTFOLIO_MSG_NO_BP;
                System.debug('errorDetail: ' + Label.CRAN_VEC_ADV_PORTFOLIO_MSG_NO_BP);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '' + Label.CRAN_VEC_ADV_PORTFOLIO_MSG_NO_BP + ' - '  , Label.CRAN_VEC_ADV_PORTFOLIO_MSG_NO_BP));
            }
        } catch (Exception e) {
            showError = true;
            errorDetail = 'Error Detail' + '<br/>Line: ' + e.getLineNumber() + '<br/>Cause: ' + e.getCause() + '<br/>Type: ' + e.getTypeName() + '<br/>Message: ' + e.getMessage() + '<br/>Trace: ' + e.getStackTraceString();
            System.debug('Exception: ' + e.getMessage());
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, '' + e.getTypeName() + ' - ' + e.getMessage()));
        }
    }


    private void insertResponse(CRAN_VEC_ADV_PortfolioRS_CLS response) {
        System.debug('insertResponse');

        Datetime now = Datetime.now();
        Set<String> setContainers = new Set<String>();
        List<FinServ__FinancialHolding__c> lstFH = new List<FinServ__FinancialHolding__c>();

        advisoryFHRecordTypeId = [SELECT Id, Name, DeveloperName FROM RecordType WHERE SObjectType = 'FinServ__FinancialHolding__c' AND DeveloperName='CRAN_VEC_ADV_Position'][0].Id;
        
        if (response != null && response.getPorfGrandTotal() != null &&  response.getPorfGrandTotal().getBp() != null) {
            for(CRAN_VEC_ADV_Portfolio_BpRS_CLS bpRS : response.getPorfGrandTotal().getBp()){
                String bu = mapAvaloqIdBPs.get(String.valueOf(bpRS.getId())).CRAN_VEC_ADV_P_Bunit__c;
                for (CRAN_VEC_ADV_Portfolio_Container_CLS container : bpRS.getContainers()) {
                    setContainers.add(String.valueOf(container.getId()));
                    FinServ__FinancialAccount__c relatedFA = new FinServ__FinancialAccount__c(CRAN_VEC_DEV_T_ContainerID__c = bu + '_' + String.valueOf(container.getId()));
                    for (CRAN_VEC_ADV_CategoriesLv1_CLS categoryLv1 : container.getCategoriesLv1()) {
                        for (CRAN_VEC_ADV_CategoriesLv2_CLS categoryLv2 : categoryLv1.getCategoriesLv2()) {
                            for (CRAN_VEC_ADV_CategoriesLv3_CLS categoryLv3 : categoryLv2.getCategoriesLv3()) {
                                if(categoryLv3.getPositions()==null){
                                        FinServ__FinancialHolding__c finnacialHolding = new FinServ__FinancialHolding__c();
                                        finnacialHolding.RecordTypeId = advisoryFHRecordTypeId;
                                        finnacialHolding.CRAN_VEC_ADV_P_PFMMktCat__c = String.valueOf(categoryLv1.getId());
                                        finnacialHolding.CRAN_VEC_ADV_P_PFMMktClass__c = String.valueOf(categoryLv2.getId());
                                        finnacialHolding.CRAN_VEC_ADV_P_PFMMkt__c = String.valueOf(categoryLv3.getId());
                                        finnacialHolding.FinServ__FinancialAccount__r =  relatedFA;
                                        lstFH.add(finnacialHolding);
                                }else{
                                    for (CRAN_VEC_ADV_Portfolio_Positions_CLS position : categoryLv3.getPositions()) {
                                        FinServ__FinancialHolding__c finnacialHolding = new FinServ__FinancialHolding__c();

                                        finnacialHolding.RecordTypeId = advisoryFHRecordTypeId;

                                        CRAN_VEC_ADV_Asset_CLS asset =  position.getAssets()[0];
                                        String codeSecurity = String.valueOf(asset.getAssetBU()) + '_' + String.valueOf(asset.getAssetID());
                                        FinServ__Securities__c relatedSecurity = new FinServ__Securities__c(FinServ__SourceSystemId__c = codeSecurity);
                                        
                                        finnacialHolding.FinServ__Securities__r =  relatedSecurity;
                                        
                                        finnacialHolding.CRAN_VEC_ADV_N_CurrPrice__c =  position.getCurrPrice();
                                        finnacialHolding.CRAN_VEC_ADV_N_currValAsset__c =  position.getCurrValAssetCcy();
                                        finnacialHolding.CRAN_VEC_ADV_N_currValNoAccr__c =  position.getCurrValNoAccr();

                                        finnacialHolding.CRAN_VEC_ADV_N_currVal__c =  position.getCurrVal();
                                        finnacialHolding.CRAN_VEC_ADV_N_currXrate__c =  position.getCurrXrate();
                                        finnacialHolding.CRAN_VEC_ADV_N_HistPrice__c =  position.getHistPrice();
                                        finnacialHolding.CRAN_VEC_ADV_N_histXrate__c =  position.getHistXrate();
                                        finnacialHolding.CRAN_VEC_ADV_N_percAllocParent__c =  position.getAllocParent();
                                        finnacialHolding.CRAN_VEC_ADV_N_percYTM__c =  position.getYtm();
                                        finnacialHolding.CRAN_VEC_ADV_T_IBAN__c = position.getIban();
                                        finnacialHolding.CRAN_VEC_ADV_P_PFMMktCat__c = String.valueOf(categoryLv1.getId());
                                        finnacialHolding.CRAN_VEC_ADV_P_PFMMktClass__c = String.valueOf(categoryLv2.getId());
                                        finnacialHolding.CRAN_VEC_ADV_P_PFMMkt__c = String.valueOf(categoryLv3.getId());
                                        finnacialHolding.CRAN_VEC_ADV_N_qtyHistPrice__c =  position.getQtyHistPrice();
                                        finnacialHolding.CRAN_VEC_ADV_T_Number__c =  String.valueOf(position.getId());

                                        try{
                                          finnacialHolding.CRAN_VEC_ADV_T_PercVar__c = Decimal.valueOf(position.getPercVar());    

                                        }catch (Exception e){
                                           System.debug('Exception: ' + e.getMessage());
                                        }

                                        finnacialHolding.CRAN_VEC_ADV_T_pSafeKeep__c =  position.getPSafeKeep();
                                        finnacialHolding.FinServ__FinancialAccount__r =  relatedFA;
                                        finnacialHolding.FinServ__Shares__c =  position.getQuantity();
                                        finnacialHolding.FinServ__SourceSystemId__c = String.valueOf(position.getId());
                                        finnacialHolding.Name =  position.getName().left(80);
                                        finnacialHolding.CRAN_VEC_ADV_P_posCcy__c = position.getCurry();   
                                        lstFH.add(finnacialHolding);
                                    }
                                }
                            }
                        }
                    }
                }
            }

            RootMode rMode = new RootMode();
            errorDetail = rMode.upsertFH(lstFH);

            if(String.isNotBlank(errorDetail)){
            	showError = true;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, Label.CRAN_VEC_ADV_PF_ErrorInsertingPositions));
            }

        } else {
            showError = true;
            errorDetail = '';
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, Label.CRAN_VEC_ADV_PF_ErrorResponse));
        }
        if(!showError){
            List<FinServ__FinancialHolding__c> lstFHtoDelete = [SELECT Id FROM FinServ__FinancialHolding__c WHERE FinServ__FinancialAccount__r.CRAN_VEC_DEV_T_ContainerID__c IN :setContainers AND RecordTypeId = :advisoryFHRecordTypeId AND LastModifiedDate < :now];
            CRAN_VEC_ADV_Utils.deleteSOs(lstFHtoDelete);
        }
    }
    /*----------------------------------------------------------*/
    /*     CLASE PARA HACER ACCIONES WITHOUT SHARING METHODS    */
    /*----------------------------------------------------------*/

    private without sharing class RootMode{
        public String upsertFH(List<FinServ__FinancialHolding__c> lstFH){
            Schema.SObjectField f = FinServ__FinancialHolding__c.Fields.CRAN_VEC_ADV_T_Number__c;
            Database.UpsertResult [] cr = Database.upsert(lstFH, f, false);
            String errorDetail = '';
            for (Database.UpsertResult r : cr) {
                if (!r.isSuccess()) {
                    for (Database.Error tmpError : r.getErrors()) {
                        System.debug('Error: ' + tmpError.getMessage());
                        errorDetail += 'Fields: ' + tmpError.getFields() + '<br/>StatusCode: ' + tmpError.getStatusCode() + '<br/>Message: ' + tmpError.getMessage() + '<br/>';
                    }
                }
            }
            return errorDetail;
        }
    }
}