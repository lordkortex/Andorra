global class CRAN_ICA_KER_ChangeOwnersSchedulable_CLS implements Schedulable {
	global void execute(SchedulableContext sc) 
    {
        CRAN_ICA_KER_ChangeOwners_Batch oBatch = new CRAN_ICA_KER_ChangeOwners_Batch();
        Database.executeBatch(oBatch);
        CRAN_ICA_KER_ChangeIdentityCntcAcc_Batch iBatch = new CRAN_ICA_KER_ChangeIdentityCntcAcc_Batch();
        Database.executeBatch(iBatch);
    }
}