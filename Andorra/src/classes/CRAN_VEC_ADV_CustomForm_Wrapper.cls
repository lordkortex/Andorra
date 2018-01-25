public class CRAN_VEC_ADV_CustomForm_Wrapper {

	public CRAN_VEC_ADV_CustomForm_Question__c question{get;set;}
	public CRAN_VEC_ADV_CustomForm_Answer__c answer{get;set;}
	
	public CRAN_VEC_ADV_CustomForm_Wrapper(CRAN_VEC_ADV_CustomForm_Question__c question,CRAN_VEC_ADV_CustomForm_Answer__c answer) {
		this.question = question;
		this.answer = answer;
	}
}