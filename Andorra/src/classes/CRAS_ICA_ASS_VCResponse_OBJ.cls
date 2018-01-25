public class CRAS_ICA_ASS_VCResponse_OBJ {

    @AuraEnabled public String queryType {get; Set;} //pol/ins
    @AuraEnabled public String status {get; Set;} //valid/cancelled
    @AuraEnabled public String periodicity {get; Set;} //month/year
    @AuraEnabled public String grouping {get; Set;} //risk/savings
    @AuraEnabled public Integer polCount {get; Set;}
    @AuraEnabled public Decimal polAmount {get; Set;}
    @AuraEnabled public Integer insCount {get; Set;}

    
}