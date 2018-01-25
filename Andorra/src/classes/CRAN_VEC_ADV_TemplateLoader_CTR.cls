/**
 * CRAN_VEC_ADV_TemplateLoader_CTR
 *
 * Fecha: 24/02/2017
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/
public with sharing class CRAN_VEC_ADV_TemplateLoader_CTR {

  	public String customObject {get;set;} 
    public Blob csvFileBody{get;set;}
    public String[] contactDataLines {get;set;}
    public List <CRAN_VEC_ADV_CustomForm__c> lstCustomForm {get;set;}
    public List <CRAN_VEC_ADV_CustomForm_Section__c> lstSection {get;set;}
    public List <CRAN_VEC_ADV_CustomForm_Question__c> lstQuestion {get;set;}
    public boolean readSuccess {get;set;}
    public List<String> lstFieldNames{get;set;}
    CRAN_VEC_ADV_CustomForm__c conObj;
    CRAN_VEC_ADV_CustomForm_Section__c secObj;
    CRAN_VEC_ADV_CustomForm_Question__c quesObj;
    String contactDataAsString;
    String fieldValue;
    Integer fieldNumber;
    Map <String, Integer> fieldNumberMap = new Map < String, Integer > ();

	public CRAN_VEC_ADV_TemplateLoader_CTR() {
	    readSuccess = FALSE;
	    contactDataLines = new String[] {};
	    lstCustomForm = new List <CRAN_VEC_ADV_CustomForm__c> ();
	    lstSection = new List <CRAN_VEC_ADV_CustomForm_Section__c> ();
	    lstQuestion = new List <CRAN_VEC_ADV_CustomForm_Question__c> ();
	    lstFieldNames = new List<String>();
	}

	public List<SelectOption> getItems() {
        List<SelectOption> op = new List<SelectOption>();
        op.add(new SelectOption('CRAN_VEC_ADV_CustomForm__c', 'CustomForm'));
        op.add(new SelectOption('CRAN_VEC_ADV_CustomForm_Section__c', 'Section'));
        op.add(new SelectOption('CRAN_VEC_ADV_CustomForm_Question__c', 'Question'));
        return op;
    }

    public void readFromFile(){
        try{
            contactDataAsString = csvFileBody.toString();
            readCSVFile();
        }
        catch(exception e){
            readSuccess = FALSE;
            ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.Severity.ERROR, e + 'Error reading CSV file');
            ApexPages.addMessage(errorMessage);
        }
    }    

    public void readCSVFile() {
        lstCustomForm.clear();
        lstSection.clear();
        lstQuestion.clear();
            contactDataLines = contactDataAsString.split('\r');
            string[] csvFieldNames = contactDataLines[0].split(';');
            for (Integer i = 0; i < csvFieldNames.size(); i++) {
                fieldNumberMap.put(csvFieldNames[i], i);
                lstFieldNames.add(csvFieldNames[i].trim());
            }

            if('CRAN_VEC_ADV_CustomForm__c'.equals(customObject)){
            	for (Integer i = 1; i < contactDataLines.size(); i++) {
                conObj = new CRAN_VEC_ADV_CustomForm__c();
                string[] csvRecordData = contactDataLines[i].split(';');
                for (String fieldName: csvFieldNames) {
                    fieldNumber = fieldNumberMap.get(fieldName);
                    fieldValue = csvRecordData[fieldNumber];
                    if(fieldValue.equals('TRUE') || fieldValue.equals('FALSE')){
                    	 conObj.put(fieldName.trim(), Boolean.valueOf(fieldValue));
                    }else if(checkifDecimal(fieldValue)){
                    	 conObj.put(fieldName.trim(), Decimal.valueOf(fieldValue));
                    }else{
                    	 conObj.put(fieldName.trim(), fieldValue.trim());
                    }
                }
                lstCustomForm.add(conObj);
            }

            if(lstCustomForm.size() > 0){
                readSuccess = TRUE;
            }

            }else if('CRAN_VEC_ADV_CustomForm_Section__c'.equals(customObject)){
            	for (Integer i = 1; i < contactDataLines.size(); i++) {
                secObj = new CRAN_VEC_ADV_CustomForm_Section__c();
                string[] csvRecordData = contactDataLines[i].split(';');
                for (String fieldName: csvFieldNames) {
                     fieldNumber = fieldNumberMap.get(fieldName);
                     fieldValue = csvRecordData[fieldNumber];
                	if(!'CRAN_VEC_ADV_T_CFEID_C__C'.equals(fieldName)){
    	                if(fieldValue.equals('TRUE') || fieldValue.equals('FALSE')){
    	                	 secObj.put(fieldName.trim(), Boolean.valueOf(fieldValue));
    	                }else if(checkifDecimal(fieldValue)){
    	                	 secObj.put(fieldName.trim(), Decimal.valueOf(fieldValue));
    	                }else{
    	                	 secObj.put(fieldName.trim(), fieldValue.trim());
    	                }
                	}else{
                		//rellenar master detail
                		secObj.CRAN_VEC_ADV_MD_CUSTOMFORM__r = new CRAN_VEC_ADV_CustomForm__c(CRAN_VEC_ADV_T_EXTERNALID__C = fieldValue);
                	}
                }
                lstSection.add(secObj);
                }
                if(lstSection.size() > 0){
                    readSuccess = TRUE;
                }
            }else if('CRAN_VEC_ADV_CustomForm_Question__c'.equals(customObject)){

            	for (Integer i = 1; i < contactDataLines.size(); i++) {
                quesObj = new CRAN_VEC_ADV_CustomForm_Question__c();
                string[] csvRecordData = contactDataLines[i].split(';');
                for (String fieldName: csvFieldNames) {
                    fieldNumber = fieldNumberMap.get(fieldName);
                    fieldValue = csvRecordData[fieldNumber];
                    if(!'CRAN_VEC_ADV_T_QPARENTID__C'.equals(fieldName)){
                        if('CRAN_VEC_ADV_T_SECTIONEXID__C'.equals(fieldName)){
                            //quesObj.CRAN_VEC_ADV_MD_SECTION__C = searchSect(fieldValue);
                            quesObj.CRAN_VEC_ADV_MD_SECTION__r = new CRAN_VEC_ADV_CustomForm_Section__c(CRAN_VEC_ADV_T_EXTERNALID__C = fieldValue);
                        }else{
                            if(fieldValue.equals('TRUE') || fieldValue.equals('FALSE')){
                            	 quesObj.put(fieldName.trim(), Boolean.valueOf(fieldValue));
                            }else if(checkifDecimal(fieldValue)){
                            	 quesObj.put(fieldName.trim(), Decimal.valueOf(fieldValue));
                            }else{
                            	 quesObj.put(fieldName.trim(), fieldValue.trim());
                            }
                        }
                    }else{
                        quesObj.CRAN_VEC_ADV_L_Question_Father__r = new CRAN_VEC_ADV_CustomForm_Question__c(CRAN_VEC_ADV_T_EXTERNALID__C = fieldValue);
                    }
                }
                lstQuestion.add(quesObj);
                }

                if(lstQuestion.size() > 0){
                    readSuccess = TRUE;
                }
            }else{
            	ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR, 'Select 1 customObject option');
          		ApexPages.addMessage(errorMessage);
            }
  }
  public void saveData() {
    try {
    	 if('CRAN_VEC_ADV_CustomForm__c'.equals(customObject)){
    	 	INSERT lstCustomForm;
    	 }else if('CRAN_VEC_ADV_CustomForm_Section__c'.equals(customObject)){
    	 	INSERT lstSection;
    	 }else if('CRAN_VEC_ADV_CustomForm_Question__c'.equals(customObject)){
    	 	INSERT lstQuestion;
   	    }
      ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.INFO, customObject+' records inserted successfully');
      ApexPages.addMessage(errorMessage);

        lstCustomForm.clear();
        lstSection.clear();
        lstQuestion.clear();
        fieldNumberMap.clear();
        lstFieldNames.clear();

    } catch (Exception e) {

        lstCustomForm.clear();
        lstSection.clear();
        lstQuestion.clear();
        fieldNumberMap.clear();
        lstFieldNames.clear();

      ApexPages.Message errorMessage = new ApexPages.Message(ApexPages.severity.ERROR, 'An error has occured while saving data: ' +e);
      ApexPages.addMessage(errorMessage);
    }
  }

	private Boolean checkifDecimal(String decimalPoint){
		Boolean isValidDecimal = false;
		if(decimalPoint != null && decimalPoint.contains('.')){
			try{
				Decimal.valueOf(decimalPoint);
				return true;
			}
			catch(TypeException e){
				return false;
			}
		}
		return isValidDecimal;
	}


    public Boolean automatedDataLoad(){
        try{
            StaticResource sr = [Select Body From StaticResource Where Name = 'CustomFormDataLoad' LIMIT 1];
            customObject = 'CRAN_VEC_ADV_CustomForm__c';
            csvFileBody = sr.body;
            readFromFile();
            saveData();

            StaticResource sr2 = [Select Body From StaticResource Where Name = 'SectionDataLoad' LIMIT 1];
            customObject = 'CRAN_VEC_ADV_CustomForm_Section__c';
            csvFileBody = sr2.body;
            readFromFile();
            saveData();

            StaticResource sr3 = [Select Body From StaticResource Where Name = 'QuestionDataLoad_Part1' LIMIT 1];
            customObject = 'CRAN_VEC_ADV_CustomForm_Question__c';
            csvFileBody = sr3.body;
            readFromFile();
            saveData();

            StaticResource sr4 = [Select Body From StaticResource Where Name = 'QuestionDataLoad_Part2' LIMIT 1];
            customObject = 'CRAN_VEC_ADV_CustomForm_Question__c';
            csvFileBody = sr4.body;
            readFromFile();
            saveData();

        }catch (Exception e){
            return false;
        }
        return true;
    }

}