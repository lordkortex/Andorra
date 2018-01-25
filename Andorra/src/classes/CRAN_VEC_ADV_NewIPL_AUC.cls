public with sharing class CRAN_VEC_ADV_NewIPL_AUC {


    @AuraEnabled
    public static List <FinServ__Securities__c> fetchAsset(String searchKeyWord) {
        String searchKey = searchKeyWord + '%';
        List < FinServ__Securities__c > returnList = [SELECT Id, Name FROM FinServ__Securities__c WHERE Name LIKE: searchKey];
        return returnList;
    }

    @AuraEnabled
    public static Object checkQuoteStatus(String quoId) {
        Opportunity o  = [SELECT CRAN_VEC_ADV_F_isNotEdit__c FROM Opportunity WHERE Id IN (SELECT OpportunityId FROM Quote WHERE Id = :quoId)];
        if (o.CRAN_VEC_ADV_F_isNotEdit__c) {
            return new ErrorResponse(Label.CRAN_VEC_ADV_IP_Closed_Quote);
        }
        return new SuccessResponse();
    }


    @AuraEnabled
    public static Object saveIPL(CRAN_VEC_ADV_Investment_Proposition_Line__c iplToSave,
                                 String quoId, String assetId, Decimal fQua, Decimal fMav, Decimal fPq ) {
        try {
            Map<String, String> fieldToAPINameMap = new Map<String, String> {'Quantity' => 'CRAN_VEC_ADV_N_PropQtty__c', 'Market Value' => 'CRAN_VEC_ADV_N_PropMktValue__c', 'Percentage' => 'CRAN_VEC_ADV_N_PercentQtty__c'};
            List<CRAN_VEC_ADV_Investment_Proposition_Line__c> iplsList =
                [SELECT CRAN_VEC_ADV_L_Assets__c FROM CRAN_VEC_ADV_Investment_Proposition_Line__c
                 WHERE CRAN_VEC_ADV_L_Version__c = : quoId];

            for (CRAN_VEC_ADV_Investment_Proposition_Line__c ipl : iplsList) {
                if (ipl.CRAN_VEC_ADV_L_Assets__c == Id.valueOf(assetId)) {
                    return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_AssetDupl);
                }

            }
            Quote q = [SELECT Opportunity.Id , CRAN_VEC_ADV_N_LineItems__c, CRAN_VEC_ADV_B_Final__c  FROM Quote WHERE ID = :quoId];
            iplToSave.CRAN_VEC_ADV_N_PropQtty__c = fQua;
            iplToSave.CRAN_VEC_ADV_N_PropMktValue__c = fMav;
            iplToSave.CRAN_VEC_ADV_N_PercentQtty__c = fPq;
            iplToSave.CRAN_VEC_ADV_L_Version__c = Id.valueOf(quoId);
            FinServ__Securities__c sec = [SELECT Name, FinServ__SourceSystemId__c FROM FinServ__Securities__c WHERE ID = : assetId];

            iplToSave.CRAN_VEC_ADV_P_ChangedField__c = fieldToAPINameMap.containsKey(iplToSave.CRAN_VEC_ADV_FieldChangedbyUser__c) ? fieldToAPINameMap.get(iplToSave.CRAN_VEC_ADV_FieldChangedbyUser__c) : 'Null';

            iplToSave.CRAN_VEC_ADV_L_Assets__c = Id.valueOf(assetId);
            iplToSave.Name = sec.Name;
            iplToSave.CRAN_VEC_ADV_P_nodeType__c = 'pos';
            iplToSave.CRAN_VEC_ADV_N_Secuence__c = Integer.valueOf(q.CRAN_VEC_ADV_N_LineItems__c) + 1;
            iplToSave.CRAN_VEC_ADV_N_PropMktValueBK__c = 0;
            iplToSave.CRAN_VEC_ADV_N_PercentQttyBK__c = 0;
            iplToSave.CRAN_VEC_ADV_N_PropQttyBK__c = 0;
            iplToSave.CRAN_VEC_ADV_T_Key__c  = quoId + sec.FinServ__SourceSystemId__c;
            iplToSave.CRAN_VEC_ADV_N_Level__c = 0;
            iplToSave.CRAN_VEC_ADV_B_isEdit__c = true;

            if (q !=null & q.CRAN_VEC_ADV_B_Final__c) {
                iplToSave.CRAN_VEC_ADV_L_Proposition__c = q.Opportunity.Id;
            }
            insert iplToSave;
            return new SuccessResponse(iplToSave);
        } catch (Exception e) {
            return new ErrorResponse(e.getMessage());
        }
    }

    @TestVisible
    class SuccessResponse {

        @AuraEnabled public Boolean success {get; set;}
        @AuraEnabled public CRAN_VEC_ADV_Investment_Proposition_Line__c ipl {get; set;}
        @AuraEnabled public String messageSuccess {get; set;}

        public SuccessResponse(CRAN_VEC_ADV_Investment_Proposition_Line__c ipl) {
            this.success = true;
            this.ipl = ipl;
            this.messageSuccess = Label.CRAN_VEC_ADV_Created_Properly;
        }

        public SuccessResponse() {
            this.success = true;
            this.messageSuccess = Label.CRAN_VEC_ADV_Created_Properly;
        }
    }

    @TestVisible
    class ErrorResponse {
        @AuraEnabled public Boolean success {get; set;}
        @AuraEnabled public String messageError {get; set;}

        public ErrorResponse(String s) {
            this.success = false;
            this.messageError = s;
        }
    }
}