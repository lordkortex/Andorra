public with sharing class CRAN_VEC_ADV_Section_Wrapper {
	public String nameSection{get;set;}
	public List<CRAN_VEC_ADV_CustomForm_Wrapper> questions{get;set;}
	public CRAN_VEC_ADV_Section_Wrapper() {
		questions = new List<CRAN_VEC_ADV_CustomForm_Wrapper>();
	}
}