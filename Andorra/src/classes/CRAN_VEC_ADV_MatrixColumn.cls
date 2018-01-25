public with sharing class CRAN_VEC_ADV_MatrixColumn {	
	public String headerName{get;set;}
	public CRAN_VEC_ADV_CustomForm_Answer__c answer{get;set;}
	public CRAN_VEC_ADV_CustomForm_Question__c question{get;set;}
	public List<SelectOption> lstSelectOption{get;set;}
	public String idAvaloq{get;set;}

	public CRAN_VEC_ADV_MatrixColumn(String headerName, CRAN_VEC_ADV_CustomForm_Answer__c answer,CRAN_VEC_ADV_CustomForm_Question__c question, String customMetadata, String idAvaloq) {
		
		if(question.CRAN_VEC_ADV_P_Child_Type__c.equals(CRAN_VEC_ADV_Constants_CLS.PICKLIST_TYPE)){
			updatePickList(question.Name,customMetadata);
		}
		this.headerName = headerName;
		this.answer = answer;
		this.question = question;
		this.idAvaloq = idAvaloq;
	}

	private void updatePickList(String fieldPickList, String customMetadata){
		fieldPickList = fieldPickList + '__C';
		this.lstSelectOption = new List<SelectOption>();
        Map<String, Schema.SobjectField> FsMap = Schema.getGlobalDescribe().get(customMetadata).getDescribe().fields.getMap();
        List<Schema.PicklistEntry> ple = FsMap.get(fieldPickList).getDescribe().getPicklistValues();
        lstSelectOption.add(new SelectOption(CRAN_VEC_ADV_Constants_CLS.EMPTY_ANSWER_PICK, CRAN_VEC_ADV_Constants_CLS.EMPTY_ANSWER_PICK_LABEL));
        for(Schema.PicklistEntry p : ple){
            this.lstSelectOption.add(new SelectOption(p.getValue(), p.getLabel()));
        }
	}
}