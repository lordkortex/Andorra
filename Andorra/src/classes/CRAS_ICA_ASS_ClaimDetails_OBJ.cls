public class CRAS_ICA_ASS_ClaimDetails_OBJ {
	@AuraEnabled public String ClaimNumber {get; Set;}
    @AuraEnabled public DateTime StartDate {get; Set;}
    @AuraEnabled public DateTime PayDay {get; Set;}
    @AuraEnabled public String AccountNumber {get; Set;}
    @AuraEnabled public String Total {get; Set;}
}