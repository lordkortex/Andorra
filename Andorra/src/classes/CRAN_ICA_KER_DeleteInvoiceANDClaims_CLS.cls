global class CRAN_ICA_KER_DeleteInvoiceANDClaims_CLS implements Schedulable {
	global void execute(SchedulableContext sc) 
    {
        CRAN_ICA_KER_DeleteAClaims_Batch cleanBatch = new CRAN_ICA_KER_DeleteAClaims_Batch();
        Database.executeBatch(cleanBatch);
    }
}