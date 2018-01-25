public class CRAN_VEC_ADV_IplList_AUC {    

    @AuraEnabled
	public static List<List<CRAN_VEC_ADV_FieldDataIpl_CLS>> DataList( String recordId, String nKey, String aFilter, String objectName ) {                                       
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(objectName);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        
        /* Para que no aparezca el campo Mod miramos si el registro
        * se puede editar o no, según el valor de CRAN_VEC_ADV_F_isNotEdit__c. 
        */                
        Boolean isNotEdit = true;
        List<sObject> sObList = Database.query('SELECT CRAN_VEC_ADV_F_isNotEdit__c FROM Opportunity WHERE Id=:recordId LIMIT 1');
        if ( sObList!=null && sObList.size()>0 ) {
        	isNotEdit = Boolean.valueOf(sObList[0].get('CRAN_VEC_ADV_F_isNotEdit__c'));    
        }        
               
        List<String> fieldNames = new List<String>();
        List<CRAN_VEC_ADV_FieldDataIpl_CLS> headerFields = new List<CRAN_VEC_ADV_FieldDataIpl_CLS>();
        
        // El orden de los campos no se debe modificar. 
        // El primer campo debe ser siempre isEdit (si es que existe en el objeto)
        // y el segundo siempre el Name.
		fieldNames.add('CRAN_VEC_ADV_F_isEdit__c');
        fieldNames.add('Name');
		if ( !isNotEdit ) { fieldNames.add('CRAN_VEC_ADV_F_IPLMod__c'); }
		fieldNames.add('CRAN_VEC_ADV_F_Restriction__c');
		fieldNames.add('CRAN_VEC_ADV_T_Rating__c');
		fieldNames.add('CRAN_VEC_ADV_N_Price__c');
		fieldNames.add('CRAN_VEC_ADV_P_Currency__c');
		fieldNames.add('CRAN_VEC_ADV_N_PropQtty__c');
		fieldNames.add('CRAN_VEC_ADV_N_PropAccrual__c');                        
		fieldNames.add('CRAN_VEC_ADV_N_PropMktValue__c');
		fieldNames.add('CRAN_VEC_ADV_N_PercentQtty__c');
		fieldNames.add('CRAN_VEC_ADV_N_PortfolioQtty__c');
		fieldNames.add('CRAN_VEC_ADV_N_Delta__c');
		fieldNames.add('CRAN_VEC_ADV_N_MPF__c');
		fieldNames.add('CRAN_VEC_ADV_B_Extl__c');
		fieldNames.add('CRAN_VEC_ADV_B_AggrPosition__c');
		fieldNames.add('CRAN_VEC_ADV_T_Remark__c');
		fieldNames.add('CRAN_VEC_ADV_T_RestrInfo__c');
		fieldNames.add('CRAN_VEC_ADV_N_Secuence__c');
		fieldNames.add('CRAN_VEC_ADV_P_nodeType__c');
		fieldNames.add('CRAN_VEC_ADV_N_Level__c');
		String sOrder = 'CRAN_VEC_ADV_N_Secuence__c ASC';
        fieldNames.add('Id');            
        
        for (String fieldName: fieldNames) {                 
            CRAN_VEC_ADV_FieldDataIpl_CLS fc = new CRAN_VEC_ADV_FieldDataIpl_CLS();            
            fc.fieldLabel  = fieldMap.get(fieldName).getDescribe().getLabel();
            fc.fieldValue  = fieldMap.get(fieldName).getDescribe().getName();
            fc.dataType    = fieldMap.get(fieldName).getDescribe().getType().name();
			if ( fc.fieldValue == 'CRAN_VEC_ADV_F_isEdit__c' ) {
                fc.fieldLabel = System.Label.CRAN_VEC_ADV_IP_Label_Edit;
            } else if ( fc.fieldValue =='CRAN_VEC_ADV_N_Secuence__c' || fc.fieldValue == 'CRAN_VEC_ADV_P_nodeType__c' ||                            
                 		fc.fieldValue == 'CRAN_VEC_ADV_N_Level__c'   || fc.fieldValue == 'Id' ) {
                fc.isVisible = false;
            }
            headerFields.add(fc);      
        }
                
        String strFields = '';
        for (String fl : fieldNames) {
            strFields = strFields + ' ' + fl + ',';
        }
        strFields = strFields.substring(0, strFields.length()-1);
        if ( aFilter != '' ) {
            aFilter = ' AND ' + aFilter;
        }             
        String myQry = 'SELECT ' + strFields + ' FROM ' + objectName + ' WHERE ' + nKey + ' = \'' + recordId + '\'' + aFilter ;
        if ( sOrder.length() > 0 ) {
            myQry += ' ORDER BY ' + sOrder ;
        }        
        List<sObject> sObjList = Database.query(myQry);
                       
       	List<List<CRAN_VEC_ADV_FieldDataIpl_CLS>> fieldDataList = new List<List<CRAN_VEC_ADV_FieldDataIpl_CLS>>();
        fieldDataList.add(headerFields);
        
        for (sObject sol : sObjList ) {
			Integer colIndex = 0;
            Boolean isEdit   = false;
            String iplLevel  = '0';
            Boolean isNode   = false;
 		    List<CRAN_VEC_ADV_FieldDataIpl_CLS> fieldDataRow = new List<CRAN_VEC_ADV_FieldDataIpl_CLS>();

            for ( String dataCell : fieldNames ) {
                CRAN_VEC_ADV_FieldDataIpl_CLS fd = new CRAN_VEC_ADV_FieldDataIpl_CLS();               			                
                if ( (headerFields[colIndex].dataType=='DOUBLE' || headerFields[colIndex].dataType=='PERCENT' ) && sol.get(dataCell) <> Null ) {
                    Integer scale = fieldMap.get(dataCell).getDescribe().getScale();
                    fd.fieldLabel = CRAN_VEC_ADV_Utils.formatNumber(String.valueOf(sol.get(dataCell)),scale);
                } else if (headerFields[colIndex].dataType=='DATE') {
                    fd.fieldLabel = CRAN_VEC_ADV_Utils.formatDateForList(String.valueOf(sol.get(dataCell)));
                } else {
                    fd.fieldLabel = String.valueOf(sol.get(dataCell));
                }
                
                fd.fieldValue = String.valueOf(sol.get(dataCell));
                fd.dataType   = headerFields[colIndex].dataType;
                                
                // Adjudica el valor para ser editado o no.
                if (dataCell == 'CRAN_VEC_ADV_F_isEdit__c') { 
                    fd.isEdit      = Boolean.valueOf(fd.fieldValue);
                    fd.isHyperLink = Boolean.valueOf(fd.fieldValue);  //Si es Edit es HyperLink
                    fd.fieldLabel  = System.Label.CRAN_VEC_ADV_IP_Label_Edit;
                }
                
                // Gestiona la indentación y la distinción entre
                // nodo y posición para aplicarla 
                // más abajo a todos los campos del registro (fila).
                if (dataCell == 'CRAN_VEC_ADV_N_Level__c') {  // Indentación
                    iplLevel = fd.fieldValue;
                } else if (dataCell == 'CRAN_VEC_ADV_P_nodeType__c') {  // isNodeType
                    isNode = ( fd.fieldValue == 'node' );
                }                
                
                if (dataCell == 'CRAN_VEC_ADV_N_Secuence__c' || 
                    dataCell == 'CRAN_VEC_ADV_P_nodeType__c' || 
                    dataCell == 'CRAN_VEC_ADV_N_Level__c' || 
                   	dataCell == 'Id') {
                        fd.isVisible = false;
                }                
                
                fieldDataRow.add(fd);                
                colIndex++;                
            } 
            
            fieldDataList.add(fieldDataRow);  //Añade la fila (registro) a la lista (conjunto de registros).
            
            Integer nRec = fieldDataList.size()-1; // Sirve para ir al último registro introducido.
            Integer nCol = fieldDataRow.size()-1;  // Sirve para ir al último campo del registro, que es el Id.
       	
			fieldDataList.get(nRec).get(0).fieldValue = fieldDataList.get(nRec).get(nCol).fieldValue; // Busca el valor del Id para adjudicárselo al valor de la columna 'Edit' que es la primera.
			fieldDataList.get(nRec).get(1).iplIndent = iplLevel; 	// Asigna el valor de indentación a la segunda columna que es el Name.   				              
			for ( Integer m=0 ; m <colIndex ; m++ ) {				// Asigna el valor de isNode a toda la fila.
				fieldDataList.get(nRec).get(m).isNodeType = isNode;   
			}
        }
        return fieldDataList;
	}

    
    @AuraEnabled
	public static String showHeader(Id recordId) {        
        String sObjName  = recordId.getSObjectType().getDescribe().getName();
        String sObjLabel = recordId.getSObjectType().getDescribe().getLabel();                        
        List<sObject> sObjList = Database.query( 'SELECT Name FROM ' + sObjName + ' WHERE Id = :recordId LIMIT 1' );
        String nHeader = sObjLabel + ' ' + sObjList.get(0).get('Name');
        return nHeader;
    } 
    
}