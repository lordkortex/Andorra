public with sharing class CRAN_VEC_ADV_CloneVersion_CTR {

    private final Quote myQuote;

    public Boolean showError {get; private set;}
    public Boolean showInfo {get; private set;}

    public CRAN_VEC_ADV_CloneVersion_CTR(ApexPages.StandardController stdController) {
        showError = false;
        showInfo = true;
        this.myQuote = (Quote)stdController.getRecord();
    }

    public PageReference cloneQuote() {
            List<CRAN_VEC_ADV_Investment_Proposition_Line__c> newLinesList = new List<CRAN_VEC_ADV_Investment_Proposition_Line__c> ();
            List<CRAN_VEC_ADV_IPL_Restriction__c> newRestrisList = new List<CRAN_VEC_ADV_IPL_Restriction__c> ();

            String soql = CRAN_VEC_ADV_Utils.getCustomFieldsAndDefinedStandardsSOQL('Quote', 'Id=\'' + myQuote.Id + '\'', 'Name, OpportunityId,Opportunity.CRAN_VEC_ADV_N_Max_Version_Number__c, AccountId, Status');
            Quote oldQuote = (Quote)Database.query(soql);

            Quote quoteNew = oldQuote.clone(false, true, false, false);
            quoteNew.CRAN_VEC_ADV_P_Quote_ID__c = null;
            quoteNew.CRAN_VEC_ADV_N_Version__c = oldQuote.Opportunity.CRAN_VEC_ADV_N_Max_Version_Number__c + 1;
            quoteNew.CRAN_VEC_ADV_B_Final__c = false;
            quoteNew.CRAN_VEC_ADV_P_Quote_ID__c = null;
            quoteNew.CRAN_VEC_ADV_B_OverrideAll__c = false;
            quoteNew.CRAN_VEC_ADV_B_FinalBK__c = false;
            insert quoteNew;

            String soqlLines = CRAN_VEC_ADV_Utils.getCustomFieldsAndDefinedStandardsSOQL('CRAN_VEC_ADV_Investment_Proposition_Line__c', 'CRAN_VEC_ADV_L_Version__c=\'' + myQuote.Id + '\' ORDER BY CRAN_VEC_ADV_N_Secuence__c', 'Name');
            List<CRAN_VEC_ADV_Investment_Proposition_Line__c> linesOld = (List<CRAN_VEC_ADV_Investment_Proposition_Line__c>)Database.query(soqlLines);

            Map<Id, Id> lineSecMap = new Map<Id, Id>();
            for (CRAN_VEC_ADV_Investment_Proposition_Line__c old : linesOld) {
                lineSecMap.put(old.Id, old.CRAN_VEC_ADV_L_Assets__c);
            }

            Map<Id, FinServ__Securities__c> secMap = new Map<Id, FinServ__Securities__c>([SELECT Id, FinServ__SourceSystemId__c FROM FinServ__Securities__c WHERE ID IN: lineSecMap.values()]);

            for (CRAN_VEC_ADV_Investment_Proposition_Line__c  lin : linesOld ) {
                CRAN_VEC_ADV_Investment_Proposition_Line__c newLine = lin.clone(false, true, false, false);
                newLine.CRAN_VEC_ADV_L_Version__c = quoteNew.Id; //set parent ref
                if (lin.CRAN_VEC_ADV_L_Assets__c != null) {
                    FinServ__Securities__c tmpSecu = secMap.get(lin.CRAN_VEC_ADV_L_Assets__c);
                    newLine.CRAN_VEC_ADV_L_Assets__c = tmpSecu.Id;
                    newLine.CRAN_VEC_ADV_T_Key__c = quoteNew.Id + tmpSecu.FinServ__SourceSystemId__c;
                } else {
                    newLine.CRAN_VEC_ADV_T_Key__c = quoteNew.Id + lin.CRAN_VEC_ADV_T_NodeId__c;
                }
                newLine.CRAN_VEC_ADV_L_Proposition__c = null;
                newLine.CRAN_VEC_ADV_FieldChangedbyUser__c = null;
                newLinesList.add(newLine);
            }
            CRAN_VEC_KER_TriggerHandler_CLS.bypass('CRAN_VEC_ADV_IPLTriggerHandler_CLS');
            insert newLinesList;

            String soqlRest = CRAN_VEC_ADV_Utils.getCustomFieldsAndDefinedStandardsSOQL('CRAN_VEC_ADV_IPL_Restriction__c', 'CRAN_VEC_ADV_L_Version__c=\'' + myQuote.Id + '\'', 'Name');
            List<CRAN_VEC_ADV_IPL_Restriction__c> restsOld = (List<CRAN_VEC_ADV_IPL_Restriction__c>)Database.query(soqlRest);

            Integer i = 0;
            for (CRAN_VEC_ADV_IPL_Restriction__c res : restsOld ) {
                CRAN_VEC_ADV_IPL_Restriction__c newRes = res.clone(false, true, false, false);
                newRes.CRAN_VEC_ADV_L_Version__c = quoteNew.Id;
                newRestrisList.add(newRes);
                i++;
            }

            insert newRestrisList;

            return new PageReference('/' + quoteNew.Id);
    }
}