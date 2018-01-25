public class CRAN_VAS_MAQ_ListSales_AUC {
    
    @TestVisible
    private static String listViewLabel = '30-Day Closing Sales';

    @AuraEnabled
    public static List<Opportunity> getSales() {        
        Id 					user = UserInfo.getUserId();
        List<Opportunity> 	sales = new List<Opportunity>();
                            sales = [SELECT Id, Name, Amount, CRAN_VAS_MAQ_L_BP__r.Name, Account.Name, CloseDate 
                                     FROM Opportunity 
                                     WHERE RecordType.DeveloperName ='CRAN_VAS_MAQ_Venta'
                                     AND StageName != 'Closed Won'
                                     AND StageName != 'Closed Lost'
                                     AND CloseDate < :Date.today().addDays(30)
                                     AND OwnerId = :user
                                     LIMIT 3];

        return sales;
    }
    @AuraEnabled
    public static String getListViewId() {
    	
        String q = 'SELECT Name FROM Opportunity LIMIT 1';

		ApexPages.StandardSetController controller 	= new ApexPages.StandardSetController(Database.getQueryLocator(q));
       	List<SelectOption> 				listViews 	= controller.getListViewOptions();
        
       	for (SelectOption w : listViews ) {
			if (w.getLabel() == listViewLabel) {
				return w.getValue().left(15);		
			}
		}
        
		return '';
    } 
}