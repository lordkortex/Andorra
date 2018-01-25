public with sharing class CRAN_VEC_ADV_MatrixRow_Serialize {
	public List<CRAN_VEC_ADV_MatrixColumn_Serialize> columnList{get;set;}
	public String questionText{get;set;}
	public String idAvaloq{get;set;}

	public CRAN_VEC_ADV_MatrixRow_Serialize(List<CRAN_VEC_ADV_MatrixColumn_Serialize> columnList, String questionText, String idAvaloq){
		this.columnList = columnList;
		this.questionText = questionText;
		this.idAvaloq = idAvaloq;
	}	
}