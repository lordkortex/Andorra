public with sharing class CRAN_VAS_KER_DocusignLoginResponse {
	private List<LoginAccounts> loginAccounts;
	public class LoginAccounts 
	{
		public String name;
		public String accountId;
		public String baseUrl;
		public String isDefault;
		public String userName;
		public String userId;
		public String email;
		public String siteDescription;
	}	
	
	public List<LoginAccounts> getLoginAccounts(){
		return loginAccounts;
	}
    
}