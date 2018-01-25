public with sharing class CRAN_VEC_ADV_MatrixColumn_Serialize {
	public CRAN_VEC_ADV_CustomForm_Answer__c answer{get;set;}
	public CRAN_VEC_ADV_CustomForm_Question__c question{get;set;}

	public CRAN_VEC_ADV_MatrixColumn_Serialize(CRAN_VEC_ADV_CustomForm_Answer__c answer,CRAN_VEC_ADV_CustomForm_Question__c question) {
		this.answer = answer;
		this.question = question;
	}
}