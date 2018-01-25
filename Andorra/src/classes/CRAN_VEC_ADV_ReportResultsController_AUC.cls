public class CRAN_VEC_ADV_ReportResultsController_AUC {    

    @AuraEnabled
	public static List<List<CRAN_VEC_ADV_FieldData_CLS>> DataList( String recordId, String nKey, String aFilter, String objectName ) {                               
        
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(objectName);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        
        Map<String,String> pckLst = new Map<String,String>();
        
        /* Para que no aparezca el campo Mod miramos si el registro
        * se puede editar o no, según el valor de CRAN_VEC_ADV_F_isNotEdit__c. 
        */                
        Boolean isNotEdit = true;
        List<sObject> sObList = Database.query('SELECT CRAN_VEC_ADV_F_isNotEdit__c FROM Opportunity WHERE Id=:recordId LIMIT 1');
        if ( sObList!=null && sObList.size()>0 ) {
        	isNotEdit = Boolean.valueOf(sObList[0].get('CRAN_VEC_ADV_F_isNotEdit__c'));    
        }        
        
        String sOrder = '';
        List<String> fieldNames = new List<String>();
        List<CRAN_VEC_ADV_FieldData_CLS> headerFields = new List<CRAN_VEC_ADV_FieldData_CLS>();
        
        // El orden de los campos no se debe modificar. 
        // El primer campo debe ser siempre isEdit (si es que existe en el objeto)
        // y el segundo siempre el Name.
        if (objectName<>'Opportunity') {
            fieldNames.add('CRAN_VEC_ADV_F_isEdit__c');
        }
        fieldNames.add('Name');
        if (objectName=='Opportunity') {
            fieldNames.add('StageName');           
            fieldNames.add('CRAN_VEC_ADV_D_StartDate__c');
            fieldNames.add('CRAN_VEC_ADV_N_SimulatedOrders__c');
            fieldNames.add('CRAN_VEC_ADV_N_DiscardedOrders__c');
            fieldNames.add('CRAN_VEC_ADV_N_TotalOrders__c');            
            fieldNames.add('CRAN_VEC_ADV_P_InvMethod__c');
            fieldNames.add('CRAN_VEC_ADV_N_InvAmount__c');
            fieldNames.add('CRAN_VEC_ADV_P_Currency__c');
            sOrder = 'CRAN_VEC_ADV_N_OrderList__c ASC, CRAN_VEC_ADV_D_StartDate__c DESC, Name ASC';
                        
            Schema.DescribeFieldResult sN = Opportunity.StageName.getDescribe();
            List<Schema.PicklistEntry> sP = sN.getPicklistValues();
            for ( Schema.PicklistEntry s : sP) {
                if ( s.isActive() ) {
                    pckLst.put(s.getValue(), s.getLabel());
                }                
            }
            
        } else if (objectName=='Quote') {
            fieldNames.add('CRAN_VEC_ADV_N_Version__c');
            fieldNames.add('CRAN_VEC_ADV_B_Final__c');
            if ( !isNotEdit ) { fieldNames.add('CRAN_VEC_ADV_F_QuoteMod__c'); }            
            fieldNames.add('CRAN_VEC_ADV_F_Investment_method__c');
            fieldNames.add('CRAN_VEC_ADV_N_InvAmount__c');
            fieldNames.add('CRAN_VEC_ADV_P_Currency__c');
            fieldNames.add('CRAN_VEC_ADV_B_OverrideAll__c');
            sOrder = 'CRAN_VEC_ADV_N_Version__c ASC';            
            
        } else if (objectName=='CRAN_VEC_ADV_IPL_Restriction__c') {
            if ( !isNotEdit ) { fieldNames.add('CRAN_VEC_ADV_F_RestrictionMod__c'); }            
            fieldNames.add('CRAN_VEC_ADV_T_RestrictionTypeName__c');            
            fieldNames.add('CRAN_VEC_ADV_B_Override__c');
            fieldNames.add('CRAN_VEC_ADV_T_Justification__c');           
            fieldNames.add('CRAN_VEC_ADV_T_Priority__c');
            fieldNames.add('CRAN_VEC_ADV_T_TopRestriction__c');
            fieldNames.add('CRAN_VEC_ADV_T_Remark__c');
            fieldNames.add('CRAN_VEC_ADV_T_EvalResult__c');
            fieldNames.add('CRAN_VEC_ADV_T_ValueFrom__c');
            fieldNames.add('CRAN_VEC_ADV_T_ValueTo__c');
            fieldNames.add('CRAN_VEC_ADV_T_ViolObject__c');
            fieldNames.add('CRAN_VEC_ADV_T_ViolClass__c');
            fieldNames.add('CRAN_VEC_ADV_T_ViolValue__c');            
            
        }
        fieldNames.add('Id');            
        
        for (String fieldName: fieldNames) {                 
            CRAN_VEC_ADV_FieldData_CLS fc = new CRAN_VEC_ADV_FieldData_CLS();            
            fc.fieldLabel  = fieldMap.get(fieldName).getDescribe().getLabel();
            fc.fieldValue  = fieldMap.get(fieldName).getDescribe().getName();
            fc.dataType    = fieldMap.get(fieldName).getDescribe().getType().name();
            if ( objectName=='Opportunity' && fc.fieldValue == 'CRAN_VEC_ADV_N_InvAmount__c' ) {
                fc.fieldLabel = System.Label.CRAN_VEC_ADV_IP_Label_I_Amount;
            } else if ( objectName=='Opportunity' && fc.fieldValue == 'CRAN_VEC_ADV_P_Currency__c' ) {
                fc.fieldLabel = System.Label.CRAN_VEC_ADV_IP_Label_I_Ccy;                
            } else if ( fc.fieldValue == 'CRAN_VEC_ADV_P_InvMethod__c' ) {
                fc.fieldLabel = System.Label.CRAN_VEC_ADV_IP_Label_I_Method;                
            } else if ( fc.fieldValue == 'CRAN_VEC_ADV_F_isEdit__c' ) {
                fc.fieldLabel = System.Label.CRAN_VEC_ADV_IP_Label_Edit;
            } else if ( fc.fieldValue == 'StageName' ) {
                fc.fieldLabel = System.Label.CRAN_VEC_ADV_IP_Label_Stage;                
            } else if ( fc.fieldValue == 'Id' ) {
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
       	List<List<CRAN_VEC_ADV_FieldData_CLS>> fieldDataList = new List<List<CRAN_VEC_ADV_FieldData_CLS>>();
        fieldDataList.add(headerFields);
        
        for (sObject sol : sObjList ) {
			Integer colIndex = 0;
            Boolean isEdit   = false;
 		    List<CRAN_VEC_ADV_FieldData_CLS> fieldDataRow = new List<CRAN_VEC_ADV_FieldData_CLS>();

            for ( String dataCell : fieldNames ) {
                CRAN_VEC_ADV_FieldData_CLS fd = new CRAN_VEC_ADV_FieldData_CLS();               			                
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
                
                // Este if permite marcar el Name del registro para que se pueda
                // navegar a la página de detalle.                                 
                if ( dataCell=='Name' )  {
                    fd.fieldValue  = String.valueOf(sol.get('Id'));
                    // Solo está activado para Opportunities y Quotes porque para el resto 
                    // no es necesario acceder a sus detalles para nada.
                    if ( objectName=='Opportunity' || objectName=='Quote') {
                        fd.isHyperLink = true; 
                    }                    
                }                
                
                // Cambia el valor del picklist de StageName al idioma correspondiente.
                if (dataCell == 'StageName') {  
                    fd.fieldLabel = pckLst.get(fd.fieldValue);
                }
                
                // Adjudica el valor para ser editado o no.
                if (dataCell == 'CRAN_VEC_ADV_F_isEdit__c') { 
                    fd.isEdit      = Boolean.valueOf(fd.fieldValue);
                    fd.isHyperLink = Boolean.valueOf(fd.fieldValue);  //Si es Edit es HyperLink
                    fd.fieldLabel  = System.Label.CRAN_VEC_ADV_IP_Label_Edit;
                }                                
                if ( dataCell == 'Id' ) {
                    fd.isVisible = false;
                }                                
                fieldDataRow.add(fd);                
                colIndex++;                
            }             
            fieldDataList.add(fieldDataRow);  //Añade la fila (registro) a la lista (conjunto de registros).
            
            Integer nRec = fieldDataList.size()-1; // Sirve para ir al último registro introducido.
            Integer nCol = fieldDataRow.size()-1;  // Sirve para ir al último campo del registro, que es el Id.
            if ( objectName<>'Opportunity' ) {            	
            	fieldDataList.get(nRec).get(0).fieldValue = fieldDataList.get(nRec).get(nCol).fieldValue; // Busca el valor del Id para adjudicárselo al valor de la columna 'Edit' que es la primera.
            }
        }
		system.debug('fieldDataList: ' + fieldDataList);
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