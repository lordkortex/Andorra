public with sharing class CRAN_VAS_KER_DocuSignRecipientInfo {
	
	private String email;
	private String name;
	private String secondSignerEmail;
	private String secondSignerName;
	private String secondSignerLang;
	private String thirdSignerEmail;
	private String thirdSignerName;
	private String thirdSignerLang;
	private String subject;
	private String docName;
	private String template;
	private String language;
	private String objectId;
	// Comma separated phone list with Country Prefix - No longer, just mobilePhone
	private String customerPhoneNumber;
    // Advisor 1 Phone Number - needed for EU Advanced Signature
    private String secondSignerPhoneNumber;
    // Advisor 2 Phone Number
    private String thirdSignerPhoneNumber;    
	// Possible values include ##SFContract, ##SFLead, ##SFAccount, ##SFOpportunity and ##SFCase 
	// if the sObject is one of those, DSFSSourceObjectId for other sources.
	// Note that for envelope status to be reflected in one custom object additional config is needed.
	private String linkField = 'DSFSSourceObjectId';
	private Set<String> docusignLanguages = new Set<String>{'ar', 'id', 'ms', 'bg', 'cs', 'zh_CN', 'zh_TW', 'hr', 'da', 'nl', 'en', 'en_GB', 'et', 'fa', 'fi', 'fr', 'fr_CA', 'de', 'el', 'he', 'hi', 'hu', 'it', 'ja', 'ko', 'lv', 'lt', 'no', 'pl', 'pt', 'pt_BR', 'ro', 'ru', 'sr', 'sk', 'sl', 'es', 'es_MX', 'sv', 'th', 'tr', 'uk', 'vi'};
	
	public void setEmail(String direccion) {
		this.email = direccion;
	}
	
	public String getEmail() {
		return email;
	}
	
	public void setName(String nombre) {
		this.name = nombre;
	}
	
	public String getName() {
		return name;
	}
	
	public void setSecondSignerEmail(String direccion) {
		this.secondSignerEmail = direccion;
	}
	
	public String getSecondSignerEmail() {
		return secondSignerEmail;
	}
	
	public void setSecondSignerName(String nombre) {
		this.secondSignerName = nombre;
	}
	
	public String getSecondSignerName() {
		return secondSignerName;
	}
	
	public void setSecondSignerLang(String bankSignerLanguage) {
		this.secondSignerLang = docusignLanguagesFilter(bankSignerLanguage);
	}	
	
	public String getSecondSignerLang() {
		return this.secondSignerLang;
	}	
	
	public void setThirdSignerEmail(String direccion) {
		this.thirdSignerEmail = direccion;
	}
	
	public String getThirdSignerEmail() {
		return thirdSignerEmail;
	}
	
	public void setThirdSignerName(String nombre) {
		this.thirdSignerName = nombre;
	}
	
	public String getThirdSignerName() {
		return thirdSignerName;
	}		
	
	public void setThirdSignerLang(String bankSignerLanguage) {
		this.thirdSignerLang = docusignLanguagesFilter(bankSignerLanguage);
	}	
	
	public String getThirdSignerLang() {
		return this.thirdSignerLang;
	}

	public void setSubject(String asunto) {
		this.subject = asunto;
	}
	
	public String getSubject() {
		return subject;
	}
	
	public void setDocName(String nombreDoc) {
		this.docName = nombreDoc;
	}
	
	public String getDocName() {
		return docName;
	}
	
	public void setTemplate(String templateId) {
		this.template = templateId;
	}
	
	public String getTemplate() {
		return template;
	}
	
	public void setLanguage(String clientLanguage) {
		this.language = docusignLanguagesFilter(clientLanguage);
	}	
	
	public String getLanguage() {
		return this.language;
	}
	
	public void setObjectId(String id) {
		this.objectId = id;
	}
    
    public String getObjectId() {
    	return objectId;
    }
    
    public void setCustomerPhoneNumber(String phoneNumber) {
		this.customerPhoneNumber = phoneNumber;
	}
    
    public String getCustomerPhoneNumber() {
    	return customerPhoneNumber;
    }

    public void setSecondSignerPhoneNumber(String phoneNumber) {
        this.secondSignerPhoneNumber = phoneNumber;
    }
    
    public String getSecondSignerPhoneNumber() {
        return secondSignerPhoneNumber;
    }
	
    public void setThirdSignerPhoneNumber(String phoneNumber) {
        this.thirdSignerPhoneNumber = phoneNumber;
    }
    
    public String getThirdSignerPhoneNumber() {
        return thirdSignerPhoneNumber;
    }    
	public void setLinkField(String linkBy) {
		this.linkField = linkBy;
	}
    
    public String getLinkField() {
    	return linkField;
    }
    
    private String docusignLanguagesFilter(String savedLanguage) {
    	if(savedLanguage == null || !docusignLanguages.contains(savedLanguage)) {
    		return 'es';
    	}
    	else {
    		return savedLanguage;
    	}     	
    }
}