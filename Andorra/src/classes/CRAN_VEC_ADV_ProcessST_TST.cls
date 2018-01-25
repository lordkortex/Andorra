@isTest
private class CRAN_VEC_ADV_ProcessST_TST {
	
	@isTest 
	static void CRAN_VEC_ADV_ProcessST_Section_TST() {
			CRAN_VEC_ADV_ProcessSTSection_CLS temp = new CRAN_VEC_ADV_ProcessSTSection_CLS('name','type','value');
			temp.setValue('val');
			temp.getValue();
			temp.setName('name');
			temp.getName();
			temp.setType('type');
			temp.getType();
			
	}

	@isTest 
	static void CRAN_VEC_ADV_ProcessST_Question_TST() {
			CRAN_VEC_ADV_ProcessSTQuestion_CLS temp = new CRAN_VEC_ADV_ProcessSTQuestion_CLS();
			temp.setId('Id');
			temp.getId();
			temp.getAnswers();	
			List<CRAN_VEC_ADV_ProcessSTAnswerList_CLS> answ = new List<CRAN_VEC_ADV_ProcessSTAnswerList_CLS>();
			CRAN_VEC_ADV_ProcessSTAnswerList_CLS anw = new CRAN_VEC_ADV_ProcessSTAnswerList_CLS();
			
			List<CRAN_VEC_ADV_ProcessSTAnswer_CLS> temp2 = new List<CRAN_VEC_ADV_ProcessSTAnswer_CLS>();
			anw.setAnswers(temp2);
			anw.getAnswers();
			List<CRAN_VEC_ADV_ProcessSTMatrixAnswer_CLS> matrixAns = new List<CRAN_VEC_ADV_ProcessSTMatrixAnswer_CLS>();
			anw.setMatrixAnswers(matrixAns);

			anw.getMatrixAnswers();
			temp.setAnswers(answ);
	}

	@isTest 
	static void CRAN_VEC_ADV_ProcessST_Matrix_TST() {
			CRAN_VEC_ADV_ProcessSTMatrixAnswer_CLS temp = new CRAN_VEC_ADV_ProcessSTMatrixAnswer_CLS('groupId',new List<CRAN_VEC_ADV_ProcessSTSection_CLS>());
			temp.setGroupID('groupId');	
			temp.getGroupID();
			temp.setSections(new List<CRAN_VEC_ADV_ProcessSTSection_CLS>());
			temp.getSections();
	}

	@isTest 
	static void CRAN_VEC_ADV_ProcessST_Answer_TST() {
			CRAN_VEC_ADV_ProcessSTAnswer_CLS temp = new CRAN_VEC_ADV_ProcessSTAnswer_CLS('value','type');
			temp.setValue('val');
			temp.getValue();
			temp.setType('type');
			temp.getType();

			CRAN_VEC_ADV_ProcessSTAnswer_CLS temp2 = new CRAN_VEC_ADV_ProcessSTAnswer_CLS('value','type','text');
			temp2.getText();
			temp2.setText('text');
	}

}