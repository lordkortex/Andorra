public with sharing class CRAN_VAS_KER_MetadataResponse {
	
	public Order orderList;

	public class Order 
	{
		public OrderMetadata order;	    
	}
	
	public class OrderMetaData 
	{
		public String mailActionId;
		public String mail;
		public String source;
		public String mailId;
		public String langName;
		public String timeStampCreate;
		public String langId;
		public String timeStampExpiry;
		public String mailAction;
		public String mailType;
		public String orderNr;	
		public String metadaTypeId;
		public String metadaTypeName;		
	}	
    
}