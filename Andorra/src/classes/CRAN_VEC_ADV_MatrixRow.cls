public class CRAN_VEC_ADV_MatrixRow {
	public List<CRAN_VEC_ADV_MatrixColumn> columnList{get;set;}
	public String questionText{get;set;}
	public String questionHeader{get;set;}
	public String idAvaloq{get;set;}

	public CRAN_VEC_ADV_MatrixRow(List<CRAN_VEC_ADV_MatrixColumn> columnList, String questionText, String questionHeader, String idAvaloq){
		this.columnList = columnList;
		this.questionText = questionText;
		this.questionHeader = questionHeader;
		this.idAvaloq = idAvaloq;
	}	
}