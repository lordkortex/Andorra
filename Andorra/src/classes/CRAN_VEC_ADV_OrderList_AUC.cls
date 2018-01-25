/**
 *
 * Fecha: 28/11/2016
 * @author  Vector ITC
 * 
 * @version 1.5
 * Code optimizations
 *
*/

public class CRAN_VEC_ADV_OrderList_AUC {

    @AuraEnabled
    public static List<List<CRAN_VEC_ADV_FieldDataIpl_CLS>> DataList( String recordId, String nKey, String aFilter, String objectName ) {

        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(objectName);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();

        String sOrder = CRAN_VEC_ADV_Constants_CLS.EMPTY;
        List<String> fieldNames = new List<String>();
        List<CRAN_VEC_ADV_FieldDataIpl_CLS> headerFields = new List<CRAN_VEC_ADV_FieldDataIpl_CLS>();

        // El orden de los campos no se debe modificar.
        // El primer campo debe ser siempre isEdit (si es que existe en el objeto)
        // y el segundo siempre el Name.
        fieldNames.add('CRAN_VEC_ADV_F_isEdit__c');
        fieldNames.add('CRAN_VEC_ADV_B_Execute__c');
        fieldNames.add('CRAN_VEC_ADV_B_ManualConfirm__c');
        fieldNames.add('Name');
        fieldNames.add('CRAN_VEC_ADV_T_AvaloqStatus__c');
        if ( aFilter.contains('STEX') ) {
            fieldNames.add('CRAN_VEC_ADV_T_AssetName__c');
            fieldNames.add('Type');
            fieldNames.add('CRAN_VEC_ADV_N_Quantity__c');
            fieldNames.add('CRAN_VEC_ADV_F_Price__c');
            fieldNames.add('CRAN_VEC_ADV_N_Amount__c');
        } else if ( aFilter.contains('FXTR') ) {
            fieldNames.add('Type');
            fieldNames.add('CRAN_VEC_ADV_N_xRateType__c');
            fieldNames.add('CRAN_VEC_ADV_N_BuyAmount__c');
            fieldNames.add('CRAN_VEC_ADV_P_BuyCurry__c');
            fieldNames.add('CRAN_VEC_ADV_N_SellAmount__c');
            fieldNames.add('CRAN_VEC_ADV_P_SellCurry__c');
        }
        fieldNames.add('CRAN_VEC_ADV_P_Type__c');
        fieldNames.add('CRAN_VEC_ADV_N_Limit__c');
        fieldNames.add('CRAN_VEC_ADV_D_TRXDate__c');
        fieldNames.add('CRAN_VEC_ADV_HasError__c');
        fieldNames.add('CRAN_VEC_ADV_T_HasRestr__c');
        fieldNames.add('CRAN_VEC_ADV_B_Signed__c');
        fieldNames.add('Id');
        fieldNames.add('CRAN_VEC_ADV_P_SFStatus__c');
        sOrder = 'CRAN_VEC_ADV_T_OrderId__c DESC';

        for (String fieldName : fieldNames) {
            CRAN_VEC_ADV_FieldDataIpl_CLS fc = new CRAN_VEC_ADV_FieldDataIpl_CLS();
            fc.fieldLabel  = fieldMap.get(fieldName).getDescribe().getLabel();
            fc.fieldValue  = fieldMap.get(fieldName).getDescribe().getName();
            fc.dataType    = fieldMap.get(fieldName).getDescribe().getType().name();
            if ( fc.fieldValue == 'CRAN_VEC_ADV_F_isEdit__c' ) {
                fc.isVisible = false;
                fc.fieldLabel = System.Label.CRAN_VEC_ADV_IP_Label_Edit;
            } else if ( fc.fieldValue == 'CRAN_VEC_ADV_B_Signed__c' ) {
                fc.isVisible = false;
            } else if ( fc.fieldValue == 'Type' ) {
                fc.fieldLabel = System.Label.CRAN_VEC_ADV_IP_Label_OrderType;
            } if ( fc.fieldValue == 'CRAN_VEC_ADV_HasError__c' ) {
                fc.fieldLabel = 'Err';
                /* Si finalmente no se quiere mostrar la columna Err porque
                 * es suficiente con el color de la fila, habría descomentar
                 * la siguiente instrucción aquí y más abajo en el registro:
                 * fc.isVisible = false;
                */
            }
            headerFields.add(fc);
        }

        String strFields = CRAN_VEC_ADV_Constants_CLS.EMPTY;
        for (String fl : fieldNames) {
            strFields = strFields + ' ' + fl + ',';
        }
        strFields = strFields.substring(0, strFields.length() - 1);
        if ( aFilter != CRAN_VEC_ADV_Constants_CLS.EMPTY ) {
            aFilter = ' AND ' + aFilter;
        }

        String myQry = 'SELECT ' + strFields + ' FROM ' + objectName + ' WHERE ' + nKey + ' = \'' + recordId + '\'' + aFilter ;
        if ( sOrder.length() > 0 ) {
            myQry += ' ORDER BY ' + sOrder;
        }

        List<sObject> sObjList = Database.query(myQry);
        List<List<CRAN_VEC_ADV_FieldDataIpl_CLS>> fieldDataList = new List<List<CRAN_VEC_ADV_FieldDataIpl_CLS>>();
        fieldDataList.add(headerFields);

        for (sObject sol : sObjList ) {
            Integer colIndex = 0;
            Boolean isEdit   = false;
            Boolean isSigned = false;
            Boolean hasError = false;
            List<CRAN_VEC_ADV_FieldDataIpl_CLS> fieldDataRow = new List<CRAN_VEC_ADV_FieldDataIpl_CLS>();

            for ( String dataCell : fieldNames ) {
                CRAN_VEC_ADV_FieldDataIpl_CLS fd = new CRAN_VEC_ADV_FieldDataIpl_CLS();
                if ( (headerFields[colIndex].dataType == 'DOUBLE' || headerFields[colIndex].dataType == 'PERCENT' ) && sol.get(dataCell) <> Null ) {
                    Integer scale = fieldMap.get(dataCell).getDescribe().getScale();
                    fd.fieldLabel = CRAN_VEC_ADV_Utils.formatNumber(String.valueOf(sol.get(dataCell)), scale);
                } else if (headerFields[colIndex].dataType == 'DATE') {
                    fd.fieldLabel = CRAN_VEC_ADV_Utils.formatDateForList(String.valueOf(sol.get(dataCell)));
                } else {
                    if ((('CRAN_VEC_ADV_T_HasRestr__c').equals(headerFields[colIndex].fieldValue) || ('CRAN_VEC_ADV_T_AssetName__c').equals(headerFields[colIndex].fieldValue )) && sol.get(dataCell) != null && (String.valueOf(sol.get(dataCell)).length() > 40)) {
                        fd.fieldLabel = CRAN_VEC_ADV_Utils.subStrMaxLongi(String.valueOf(sol.get(dataCell)), 37) + '...';
                    } else
                        fd.fieldLabel = String.valueOf(sol.get(dataCell));
                }

                fd.fieldValue = String.valueOf(sol.get(dataCell));
                fd.dataType   = headerFields[colIndex].dataType;

                // Adjudica el valor para ser editado o no.
                if (dataCell == 'CRAN_VEC_ADV_F_isEdit__c') {
                    fd.isEdit      = Boolean.valueOf(fd.fieldValue);
                    fd.fieldLabel  = System.Label.CRAN_VEC_ADV_IP_Label_Edit;
                    fd.isVisible = false;
                    isEdit = fd.isEdit;   // Marcamos la variable isEdit para volcar sobre los checkbox Exec y Disc.
                } else if (dataCell == 'CRAN_VEC_ADV_B_Signed__c') {
                    fd.isVisible = false;
                    fd.isHyperLink = true;
                    isSigned = ( fd.fieldLabel == 'true' );
                } else if (dataCell == 'CRAN_VEC_ADV_hasError__c') {
                    hasError = ( fd.fieldLabel == 'true' );
                }

                fieldDataRow.add(fd);
                colIndex++;
            }

            fieldDataList.add(fieldDataRow);  //Añade la fila (registro) a la lista (conjunto de registros).

            Integer nRec = fieldDataList.size() - 1; // Sirve para ir al último registro introducido.
            Integer nCol = fieldDataRow.size() - 1; // Sirve para ir al último campo del registro, que es el Id.

            fieldDataList.get(nRec).get(0).fieldValue = fieldDataList.get(nRec).get(nCol).fieldValue;           // Busca el valor del Id para adjudicárselo al valor de la columna 'Edit' que es la primera.
            fieldDataList.get(nRec).get(1).isEdit = isEdit;                                                     // Asigna el valor de isEdit al checkbox de la columna Select (primera columna presentada).
            fieldDataList.get(nRec).get(colIndex - 2).isEdit = isEdit;                                          // Asigna el valor de isEdit al icono de la última columna presentada.
            fieldDataList.get(nRec).get(1).fieldValue = fieldDataList.get(nRec).get(nCol).fieldValue;           // Asigna el Id al checkbox de la columna Select (primera columna presentada).
            if (isSigned) {
                fieldDataList.get(nRec).get(2).fieldValue  = fieldDataList.get(nRec).get(nCol).fieldValue;      // Asigna el Id al Name (segunda columna presentada).
                fieldDataList.get(nRec).get(2).isHyperLink = true;                                              // Pone en modo HyperLink el campo Name(segunda columna presentada).
            }
            fieldDataList.get(nRec).get(colIndex - 2).fieldValue = fieldDataList.get(nRec).get(nCol).fieldValue; // Asigna el Id al icono de la última columna presentada.            
        }

        return fieldDataList;
    }


    @AuraEnabled
    public static Object DataListStexForex( String recordId) {

    try{    
            System.debug('method DataListStexForex');
            Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Order').getDescribe().fields.getMap();

            ////////////////
            /////STEX///////
            ////////////////

            String sOrderStex = CRAN_VEC_ADV_Constants_CLS.EMPTY;
            Set<String> fieldNamesStex = new Set<String>();
            List<CRAN_VEC_ADV_FieldDataIpl_CLS> headerFieldsStex = new List<CRAN_VEC_ADV_FieldDataIpl_CLS>();

            // rellena los campos a consultar en la consulta de las STEX
            fieldNamesStex = CRAN_VEC_ADV_OrderList_AUC.getFieldsStex();
            sOrderStex = 'CRAN_VEC_ADV_T_OrderId__c DESC';

            for (String fieldNameStex : fieldNamesStex) {
                CRAN_VEC_ADV_FieldDataIpl_CLS fc = new CRAN_VEC_ADV_FieldDataIpl_CLS();
                fc.fieldLabel  = fieldMap.get(fieldNameStex).getDescribe().getLabel();
                fc.fieldValue  = fieldMap.get(fieldNameStex).getDescribe().getName();
                fc.dataType    = fieldMap.get(fieldNameStex).getDescribe().getType().name();
                if ( fc.fieldValue == 'CRAN_VEC_ADV_F_isEdit__c' ) {
                    fc.isVisible = false;
                    fc.fieldLabel = System.Label.CRAN_VEC_ADV_IP_Label_Edit;
                } else if ( fc.fieldValue == 'CRAN_VEC_ADV_B_Signed__c' ) {
                    fc.isVisible = false;
                } else if ( fc.fieldValue == 'Type' ) {
                    fc.fieldLabel = System.Label.CRAN_VEC_ADV_IP_Label_OrderType;
                } if ( fc.fieldValue == 'CRAN_VEC_ADV_HasError__c' ) {
                    fc.fieldLabel = 'Err';
                }
                headerFieldsStex.add(fc);
            }

            String strFieldsStex = CRAN_VEC_ADV_Constants_CLS.EMPTY;
            for (String fl : fieldNamesStex) {
                strFieldsStex = strFieldsStex + ' ' + fl + ',';
            }
            strFieldsStex = strFieldsStex.substring(0, strFieldsStex.length() - 1);
                    
            String myQryStex = 'SELECT ' + strFieldsStex + ' FROM Order WHERE OpportunityId = \'' + recordId + '\' AND CRAN_VEC_ADV_P_MetaType__c=\'STEX\'' ;
            if ( sOrderStex.length() > 0 ) {
                myQryStex += ' ORDER BY ' + sOrderStex;
            }

            List<sObject> sObjListStex = Database.query(myQryStex);
            List<List<CRAN_VEC_ADV_FieldDataIpl_CLS>> fieldDataListStex = new List<List<CRAN_VEC_ADV_FieldDataIpl_CLS>>();
            fieldDataListStex.add(headerFieldsStex);

            for (sObject sol : sObjListStex ) {

                Integer colIndexStex = 0;
                Boolean isEditStex   = false;
                Boolean isSignedStex = false;
                Boolean hasErrorStex = false;
                List<CRAN_VEC_ADV_FieldDataIpl_CLS> fieldDataRowStex = new List<CRAN_VEC_ADV_FieldDataIpl_CLS>();

                for ( String dataCell : fieldNamesStex) {                
                    CRAN_VEC_ADV_FieldDataIpl_CLS fd = new CRAN_VEC_ADV_FieldDataIpl_CLS();
                    if ( (headerFieldsStex[colIndexStex].dataType == 'DOUBLE' || headerFieldsStex[colIndexStex].dataType == 'PERCENT' ) && sol.get(dataCell) <> Null ) {
                        Integer scale = fieldMap.get(dataCell).getDescribe().getScale();
                        fd.fieldLabel = CRAN_VEC_ADV_Utils.formatNumber(String.valueOf(sol.get(dataCell)), scale);
                    } else if (headerFieldsStex[colIndexStex].dataType == 'DATE') {
                        fd.fieldLabel = CRAN_VEC_ADV_Utils.formatDateForList(String.valueOf(sol.get(dataCell)));
                    } else {
                        if ((('CRAN_VEC_ADV_T_HasRestr__c').equals(headerFieldsStex[colIndexStex].fieldValue) || ('CRAN_VEC_ADV_T_AssetName__c').equals(headerFieldsStex[colIndexStex].fieldValue )) && sol.get(dataCell) != null && (String.valueOf(sol.get(dataCell)).length() > 40)) {
                            fd.fieldLabel = CRAN_VEC_ADV_Utils.subStrMaxLongi(String.valueOf(sol.get(dataCell)), 37) + '...';
                        } else
                            fd.fieldLabel = String.valueOf(sol.get(dataCell));
                    }

                    fd.fieldValue = String.valueOf(sol.get(dataCell));
                    fd.dataType   = headerFieldsStex[colIndexStex].dataType;

                    // Adjudica el valor para ser editado o no.
                    if (dataCell == 'CRAN_VEC_ADV_F_isEdit__c') {
                        fd.isEdit      = Boolean.valueOf(fd.fieldValue);
                        fd.fieldLabel  = System.Label.CRAN_VEC_ADV_IP_Label_Edit;
                        fd.isVisible = false;
                        isEditStex = fd.isEdit;   // Marcamos la variable isEdit para volcar sobre los checkbox Exec y Disc.
                    } else if (dataCell == 'CRAN_VEC_ADV_B_Signed__c') {
                        fd.isVisible = false;
                        fd.isHyperLink = true;
                        isSignedStex = ( fd.fieldLabel == 'true' );
                    } else if (dataCell == 'CRAN_VEC_ADV_hasError__c') {
                        hasErrorStex = ( fd.fieldLabel == 'true' );
                    }

                    fieldDataRowStex.add(fd);
                    colIndexStex++;
                }

                fieldDataListStex.add(fieldDataRowStex);  //Añade la fila (registro) a la lista (conjunto de registros).

                Integer nRecStex = fieldDataListStex.size() - 1; // Sirve para ir al último registro introducido.
                Integer nColStex = fieldDataRowStex.size() - 1; // Sirve para ir al último campo del registro, que es el Id.

                fieldDataListStex.get(nRecStex).get(0).fieldValue = fieldDataListStex.get(nRecStex).get(nColStex).fieldValue;           // Busca el valor del Id para adjudicárselo al valor de la columna 'Edit' que es la primera.
                fieldDataListStex.get(nRecStex).get(1).isEdit = isEditStex;                                                     // Asigna el valor de isEdit al checkbox de la columna Select (primera columna presentada).
                fieldDataListStex.get(nRecStex).get(colIndexStex - 2).isEdit = isEditStex;                                          // Asigna el valor de isEdit al icono de la última columna presentada.
                fieldDataListStex.get(nRecStex).get(1).fieldValue = fieldDataListStex.get(nRecStex).get(nColStex).fieldValue;           // Asigna el Id al checkbox de la columna Select (primera columna presentada).
                if (isSignedStex) {
                    fieldDataListStex.get(nRecStex).get(2).fieldValue  = fieldDataListStex.get(nRecStex).get(nColStex).fieldValue;      // Asigna el Id al Name (segunda columna presentada).
                    fieldDataListStex.get(nRecStex).get(2).isHyperLink = true;                                              // Pone en modo HyperLink el campo Name(segunda columna presentada).
                }
                fieldDataListStex.get(nRecStex).get(colIndexStex - 2).fieldValue = fieldDataListStex.get(nRecStex).get(nColStex).fieldValue; // Asigna el Id al icono de la última columna presentada.            
            }

            ////////////////
            /////FOREX//////
            ////////////////

            String sOrderForex = CRAN_VEC_ADV_Constants_CLS.EMPTY;
            Set<String> fieldNamesForex = new Set<String>();
            List<CRAN_VEC_ADV_FieldDataIpl_CLS> headerFieldsForex = new List<CRAN_VEC_ADV_FieldDataIpl_CLS>();

            // rellena los campos a consultar en la consulta de las FOREX
            fieldNamesForex = CRAN_VEC_ADV_OrderList_AUC.getFieldsForex();        

            sOrderForex = 'CRAN_VEC_ADV_T_OrderId__c DESC';

            for (String fieldNameForex : fieldNamesForex) {
                CRAN_VEC_ADV_FieldDataIpl_CLS fc = new CRAN_VEC_ADV_FieldDataIpl_CLS();
                fc.fieldLabel  = fieldMap.get(fieldNameForex).getDescribe().getLabel();
                fc.fieldValue  = fieldMap.get(fieldNameForex).getDescribe().getName();
                fc.dataType    = fieldMap.get(fieldNameForex).getDescribe().getType().name();
                if ( fc.fieldValue == 'CRAN_VEC_ADV_F_isEdit__c' ) {
                    fc.isVisible = false;
                    fc.fieldLabel = System.Label.CRAN_VEC_ADV_IP_Label_Edit;
                } else if ( fc.fieldValue == 'CRAN_VEC_ADV_B_Signed__c' ) {
                    fc.isVisible = false;
                } else if ( fc.fieldValue == 'Type' ) {
                    fc.fieldLabel = System.Label.CRAN_VEC_ADV_IP_Label_OrderType;
                } if ( fc.fieldValue == 'CRAN_VEC_ADV_HasError__c' ) {
                    fc.fieldLabel = 'Err';
                }
                headerFieldsForex.add(fc);
            }

            String strFieldsForex = CRAN_VEC_ADV_Constants_CLS.EMPTY;
            for (String fl : fieldNamesForex) {
                strFieldsForex = strFieldsForex + ' ' + fl + ',';
            }
            strFieldsForex = strFieldsForex.substring(0, strFieldsForex.length() - 1);
                
            String myQryForex = 'SELECT ' + strFieldsForex + ' FROM Order WHERE OpportunityId = \'' + recordId + '\' AND CRAN_VEC_ADV_P_MetaType__c=\'FXTR\'';
            if ( sOrderForex.length() > 0 ) {
                myQryForex += ' ORDER BY ' + sOrderForex;
            }

            List<sObject> sObjListForex = Database.query(myQryForex);
            List<List<CRAN_VEC_ADV_FieldDataIpl_CLS>> fieldDataListForex = new List<List<CRAN_VEC_ADV_FieldDataIpl_CLS>>();
            fieldDataListForex.add(headerFieldsForex);


            for (sObject sol : sObjListForex ) {
                Integer colIndexForex = 0;
                Boolean isEditForex  = false;
                Boolean isSignedForex = false;
                Boolean hasErrorForex = false;
                List<CRAN_VEC_ADV_FieldDataIpl_CLS> fieldDataRowForex = new List<CRAN_VEC_ADV_FieldDataIpl_CLS>();

                for ( String dataCell : fieldNamesForex ) {
                    CRAN_VEC_ADV_FieldDataIpl_CLS fd = new CRAN_VEC_ADV_FieldDataIpl_CLS();
                    if ( (headerFieldsForex[colIndexForex].dataType == 'DOUBLE' || headerFieldsForex[colIndexForex].dataType == 'PERCENT' ) && sol.get(dataCell) <> Null ) {
                        Integer scale = fieldMap.get(dataCell).getDescribe().getScale();
                        fd.fieldLabel = CRAN_VEC_ADV_Utils.formatNumber(String.valueOf(sol.get(dataCell)), scale);
                    } else if (headerFieldsForex[colIndexForex].dataType == 'DATE') {
                        fd.fieldLabel = CRAN_VEC_ADV_Utils.formatDateForList(String.valueOf(sol.get(dataCell)));
                    } else {
                        if ((('CRAN_VEC_ADV_T_HasRestr__c').equals(headerFieldsForex[colIndexForex].fieldValue) || ('CRAN_VEC_ADV_T_AssetName__c').equals(headerFieldsForex[colIndexForex].fieldValue )) && sol.get(dataCell) != null && (String.valueOf(sol.get(dataCell)).length() > 40)) {
                            fd.fieldLabel = CRAN_VEC_ADV_Utils.subStrMaxLongi(String.valueOf(sol.get(dataCell)), 37) + '...';
                        } else
                            fd.fieldLabel = String.valueOf(sol.get(dataCell));
                    }

                    fd.fieldValue = String.valueOf(sol.get(dataCell));
                    fd.dataType   = headerFieldsForex[colIndexForex].dataType;

                    // Adjudica el valor para ser editado o no.
                    if (dataCell == 'CRAN_VEC_ADV_F_isEdit__c') {
                        fd.isEdit      = Boolean.valueOf(fd.fieldValue);
                        fd.fieldLabel  = System.Label.CRAN_VEC_ADV_IP_Label_Edit;
                        fd.isVisible = false;
                        isEditForex = fd.isEdit;   // Marcamos la variable isEdit para volcar sobre los checkbox Exec y Disc.
                    } else if (dataCell == 'CRAN_VEC_ADV_B_Signed__c') {
                        fd.isVisible = false;
                        fd.isHyperLink = true;
                        isSignedForex = ( fd.fieldLabel == 'true' );
                    } else if (dataCell == 'CRAN_VEC_ADV_hasError__c') {
                        hasErrorForex = ( fd.fieldLabel == 'true' );
                    }

                    fieldDataRowForex.add(fd);
                    colIndexForex++;
                }

                fieldDataListForex.add(fieldDataRowForex);  //Añade la fila (registro) a la lista (conjunto de registros).

                Integer nRecForex = fieldDataListForex.size() - 1; // Sirve para ir al último registro introducido.
                Integer nColForex = fieldDataRowForex.size() - 1; // Sirve para ir al último campo del registro, que es el Id.

                fieldDataListForex.get(nRecForex).get(0).fieldValue = fieldDataListForex.get(nRecForex).get(nColForex).fieldValue;           // Busca el valor del Id para adjudicárselo al valor de la columna 'Edit' que es la primera.
                fieldDataListForex.get(nRecForex).get(1).isEdit = isEditForex;                                                     // Asigna el valor de isEdit al checkbox de la columna Select (primera columna presentada).
                fieldDataListForex.get(nRecForex).get(colIndexForex - 2).isEdit = isEditForex;                                          // Asigna el valor de isEdit al icono de la última columna presentada.
                fieldDataListForex.get(nRecForex).get(1).fieldValue = fieldDataListForex.get(nRecForex).get(nColForex).fieldValue;           // Asigna el Id al checkbox de la columna Select (primera columna presentada).
                if (isSignedForex) {
                    fieldDataListForex.get(nRecForex).get(2).fieldValue  = fieldDataListForex.get(nRecForex).get(nColForex).fieldValue;      // Asigna el Id al Name (segunda columna presentada).
                    fieldDataListForex.get(nRecForex).get(2).isHyperLink = true;                                              // Pone en modo HyperLink el campo Name(segunda columna presentada).
                }
                fieldDataListForex.get(nRecForex).get(colIndexForex - 2).fieldValue = fieldDataListForex.get(nRecForex).get(nColForex).fieldValue; // Asigna el Id al icono de la última columna presentada.            
            }

            return new SuccessResponse(fieldDataListStex, fieldDataListForex);

        } catch (Exception e) {
            return new ErrorResponse(e);
        }       
    } 

    public static Set<String> getFieldsStex(){
        Set<String> fieldNamesStex = new Set<String>();

        fieldNamesStex.add('CRAN_VEC_ADV_F_isEdit__c');
        fieldNamesStex.add('CRAN_VEC_ADV_B_Execute__c');
        fieldNamesStex.add('CRAN_VEC_ADV_B_ManualConfirm__c');
        fieldNamesStex.add('Name');
        fieldNamesStex.add('CRAN_VEC_ADV_T_AvaloqStatus__c');
        fieldNamesStex.add('CRAN_VEC_ADV_T_AssetName__c');
        fieldNamesStex.add('Type');
        fieldNamesStex.add('CRAN_VEC_ADV_N_Quantity__c');
        fieldNamesStex.add('CRAN_VEC_ADV_F_Price__c');
        fieldNamesStex.add('CRAN_VEC_ADV_N_Amount__c');
        fieldNamesStex.add('CRAN_VEC_ADV_P_Type__c');
        fieldNamesStex.add('CRAN_VEC_ADV_N_Limit__c');
        fieldNamesStex.add('CRAN_VEC_ADV_D_TRXDate__c');
        fieldNamesStex.add('CRAN_VEC_ADV_HasError__c');
        fieldNamesStex.add('CRAN_VEC_ADV_T_HasRestr__c');
        fieldNamesStex.add('CRAN_VEC_ADV_B_Signed__c');
        fieldNamesStex.add('Id');
        fieldNamesStex.add('CRAN_VEC_ADV_P_SFStatus__c');
        return fieldNamesStex;
    }


    public static Set<String> getFieldsForex(){
        Set<String> fieldNamesForex = new Set<String>();
        fieldNamesForex.add('CRAN_VEC_ADV_F_isEdit__c');
        fieldNamesForex.add('CRAN_VEC_ADV_B_Execute__c');
        fieldNamesForex.add('CRAN_VEC_ADV_B_ManualConfirm__c');
        fieldNamesForex.add('Name');
        fieldNamesForex.add('CRAN_VEC_ADV_T_AvaloqStatus__c');
        fieldNamesForex.add('Type');
        fieldNamesForex.add('CRAN_VEC_ADV_N_xRateType__c');
        fieldNamesForex.add('CRAN_VEC_ADV_N_BuyAmount__c');
        fieldNamesForex.add('CRAN_VEC_ADV_P_BuyCurry__c');
        fieldNamesForex.add('CRAN_VEC_ADV_N_SellAmount__c');
        fieldNamesForex.add('CRAN_VEC_ADV_P_SellCurry__c');
        fieldNamesForex.add('CRAN_VEC_ADV_P_Type__c');
        fieldNamesForex.add('CRAN_VEC_ADV_N_Limit__c');
        fieldNamesForex.add('CRAN_VEC_ADV_D_TRXDate__c');
        fieldNamesForex.add('CRAN_VEC_ADV_HasError__c');
        fieldNamesForex.add('CRAN_VEC_ADV_T_HasRestr__c');
        fieldNamesForex.add('CRAN_VEC_ADV_B_Signed__c');
        fieldNamesForex.add('Id');
        fieldNamesForex.add('CRAN_VEC_ADV_P_SFStatus__c');
        return fieldNamesForex;
    }   
    @AuraEnabled
    public static String showHeader(Id recordId) {
        String sObjName  = recordId.getSObjectType().getDescribe().getName();
        String sObjLabel = recordId.getSObjectType().getDescribe().getLabel();
        List<sObject> sObjList = Database.query( 'SELECT Name FROM ' + sObjName + ' WHERE Id = :recordId LIMIT 1' );
        String nHeader = sObjLabel + ' ' + sObjList.get(0).get('Name');
        return nHeader;
    }

    @AuraEnabled
    public static Object execServiceModeGet(String recordId) {
        try {
            List<Opportunity> myOpp = [SELECT Id, AccountId,StageName, CRAN_VEC_ADV_T_AvaloqPropId__c, CRAN_VEC_ADV_P_Bunit__c 
                                       FROM Opportunity 
                                       WHERE Id = :recordId ];


            //valido que la Opportunity esta en estado advSimulated o advDone 
            if(myOpp.size()<1 || (!CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_SIMULATED.equals(myOpp[0].StageName) && 
                !CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_DONE.equals(myOpp[0].StageName)))
                return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_ExecGetState);
       
            List<Order> listOrders = [SELECT Id, AccountId, CRAN_VEC_ADV_N_Price__c, Status, CRAN_VEC_ADV_N_xRateType__c, 
                                             CRAN_VEC_ADV_P_BuyCurry__c, CRAN_VEC_ADV_N_BuyAmount__c, CRAN_VEC_ADV_P_SellCurry__c, CRAN_VEC_ADV_N_SellAmount__c,
                                             CRAN_VEC_ADV_N_Limit__c, CRAN_VEC_ADV_T_AssetName__c, CRAN_VEC_ADV_N_Amount__c, CRAN_VEC_ADV_N_Quantity__c, RecordTypeId,
                                             EffectiveDate, QuoteId, OpportunityId, CRAN_VEC_ADV_T_OrderId__c, CRAN_VEC_ADV_T_HasRestr__c, 
                                             CRAN_VEC_ADV_T_MetaTypeId__c, CRAN_VEC_ADV_P_MetaType__c, CRAN_VEC_ADV_T_TypeId__c, CRAN_VEC_ADV_P_Type__c, CRAN_VEC_ADV_T_OrderTypeId__c,
                                             Type, CRAN_VEC_ADV_T_AvaloqStatusId__c, CRAN_VEC_ADV_T_AvaloqStatus__c 
                                      FROM Order 
                                      WHERE OpportunityId = : recordId];
                                      
            List<RecordType> myRecordType = CRAN_VEC_ADV_Constants_CLS.ORDER_RECORDTYPE;
            List<Quote> myFinalQuote = [SELECT Id FROM Quote WHERE OpportunityId = :recordId AND CRAN_VEC_ADV_B_Final__c = :true];

            ///////// LLAMADA AL SERVICIO EXEC /////////
            CRAN_VEC_ADV_ExecRebalpRQ_CLS rq = new CRAN_VEC_ADV_ExecRebalpRQ_CLS();

            //entrada de parametros//
            rq.lang = CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage());
            rq.mode = CRAN_VEC_ADV_Constants_CLS.MODE_GET;
            CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
            order.setOrderNr(myOpp[0].CRAN_VEC_ADV_T_AvaloqPropId__c);
            rq.order = order;
            //fin entrada de parametros//

            String jsonRequest = JSON.serialize(rq);
            String bu = myOpp[0].CRAN_VEC_ADV_P_Bunit__c;
            CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_EXEC, bu, jsonRequest);
            CRAN_VEC_ADV_ExecRebalpRS_CLS results = (CRAN_VEC_ADV_ExecRebalpRS_CLS)JSON.deserialize(restClient.responseBody, CRAN_VEC_ADV_ExecRebalpRS_CLS.class);
            ///////// FIN LLAMADA AL SERVICIO EXEC /////////

            if (results != null && results.errors != null) {
                return new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(results.errors));
            } else if  (results != null && results.orderNr != null && results.refOrderList == null) {
                return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_Exec_Zero);
            } else if (results != null && results.errors == null && results.orderNr != null && results.refOrderList != null && results.refOrderList.orderItem != null) {

                //genero maps<CRAN_VEC_ADV_OrderId__c,String> para buscar si ya estan
                //las que trae el servicio y realizar update
                Map<String, Order> myMap = new Map<String, Order>();
                For(Order orderTemp : listOrders) {
                    myMap.put(orderTemp.CRAN_VEC_ADV_T_OrderId__c, orderTemp);
                }

                List<Order> myListOrder = new List<Order>();
                Order myOrder;

                for (CRAN_VEC_ADV_ExecRebalpRS_CLS.CRAN_VEC_ADV_OrderItem_CLS myOrderItem : results.refOrderList.orderItem) {
                    Boolean isNew;
                    if (myMap.containsKey(myOrderItem.orderNr)) {
                        isNew = false;
                        myOrder = myMap.get(myOrderItem.orderNr);
                    } else {
                        isNew = true;
                        myOrder = new Order();
                    }
                    
                    //creo o actualizo orders con los datos devueltos de servicio
                    myOrder = CRAN_VEC_ADV_Utils.completeOrder(myOrder, myOpp[0], myFinalQuote, recordId, myRecordType[0], myOrderItem, CRAN_VEC_ADV_Constants_CLS.MODE_GET,isNew);
                    myListOrder.add(myOrder);
                }

                //inserto y actualizo las ordenes devueltas por el servicio

                RootMode rootMode = new RootMode();
                rootMode.upsertOrders(myListOrder);

                Object resultDataListStexForex = CRAN_VEC_ADV_OrderList_AUC.DataListStexForex(recordId);
																	  
                if(resultDataListStexForex instanceof CRAN_VEC_ADV_OrderList_AUC.SuccessResponse){
                    CRAN_VEC_ADV_OrderList_AUC.SuccessResponse tempSuccess = (CRAN_VEC_ADV_OrderList_AUC.SuccessResponse)resultDataListStexForex;
                    return tempSuccess;
                } else if(resultDataListStexForex instanceof CRAN_VEC_ADV_OrderList_AUC.ErrorResponse) {
                        CRAN_VEC_ADV_OrderList_AUC.ErrorResponse tempError = (CRAN_VEC_ADV_OrderList_AUC.ErrorResponse)resultDataListStexForex;
                        return tempError;
                }
            }
            return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_Exec);
        } catch (Exception e) {
            return new ErrorResponse(e);
        }
    }

        @AuraEnabled
    public static Object execServiceModeFinal(String recordId) {
        try {
            Opportunity myOpp = [SELECT Id, AccountId, CRAN_VEC_ADV_T_AvaloqPropId__c, CRAN_VEC_ADV_F_ValidPerson__c,CRAN_VEC_ADV_P_Bunit__c FROM Opportunity WHERE Id = :recordId ];            
            if(myOpp !=null && !myOpp.CRAN_VEC_ADV_F_ValidPerson__c){
                return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_NoContactToFirmOrd,false);
            }
    
            List<Order> listOrdersToSign =              [SELECT Id, CRAN_VEC_ADV_T_OrderId__c,CRAN_VEC_ADV_P_MetaType__c
                                                        FROM Order 
                                                        WHERE OpportunityId =: recordId AND CRAN_VEC_ADV_B_Execute__c = true AND CRAN_VEC_ADV_F_isEdit__c = true];
                                                        
            List<Order> listOrdersToSendWaiting =       [SELECT Id, CRAN_VEC_ADV_T_OrderId__c,CRAN_VEC_ADV_P_MetaType__c
                                                        FROM Order 
                                                        WHERE OpportunityId =: recordId AND CRAN_VEC_ADV_B_Execute__c = true AND CRAN_VEC_ADV_P_SFStatus__c = :CRAN_VEC_ADV_Constants_CLS.OPP_ORDER_PENDINGSIGN];                                           

            System.debug('/////////////////////////////////////' + listOrdersToSign);
            System.debug('/////////////////////////////////////' + listOrdersToSendWaiting);

            if(!listOrdersToSign.isEmpty()){
                
                 List<Order> listOrdersToSendSimulated = [SELECT Id, AccountId, Status, CRAN_VEC_ADV_B_Signed__c,CRAN_VEC_ADV_N_Price__c, CRAN_VEC_ADV_N_xRateType__c, CRAN_VEC_ADV_P_BuyCurry__c, CRAN_VEC_ADV_N_BuyAmount__c, CRAN_VEC_ADV_P_SellCurry__c, 
                                                        CRAN_VEC_ADV_N_SellAmount__c, CRAN_VEC_ADV_N_Limit__c, CRAN_VEC_ADV_T_AssetName__c, CRAN_VEC_ADV_N_Amount__c, CRAN_VEC_ADV_N_Quantity__c, RecordTypeId, EffectiveDate,
                                                        QuoteId, OpportunityId, CRAN_VEC_ADV_T_OrderId__c, CRAN_VEC_ADV_T_HasRestr__c, CRAN_VEC_ADV_T_MetaTypeId__c, CRAN_VEC_ADV_P_MetaType__c, CRAN_VEC_ADV_T_TypeId__c, CRAN_VEC_ADV_P_Type__c, 
                                                        CRAN_VEC_ADV_T_OrderTypeId__c, Type, CRAN_VEC_ADV_B_ExecuteToConfirm__c,CRAN_VEC_ADV_T_AvaloqStatusId__c, CRAN_VEC_ADV_T_AvaloqStatus__c, CRAN_VEC_ADV_B_Execute__c 
                                                        FROM Order 
                                                        WHERE OpportunityId =: recordId AND CRAN_VEC_ADV_B_Execute__c = true AND CRAN_VEC_ADV_P_SFStatus__c = :CRAN_VEC_ADV_Constants_CLS.OPP_ORDER_SIMULATED_ORDER];

                System.debug('/////////////////////////////////////' + listOrdersToSendSimulated);                                          
                if(!listOrdersToSendSimulated.isEmpty()){
            
                    System.debug('///////// LLAMADA AL SERVICIO EXEC /////////');           
                    List<RecordType> myRecordType = CRAN_VEC_ADV_Constants_CLS.ORDER_RECORDTYPE;
                    List<RecordType> myRecordTypeTRest = CRAN_VEC_ADV_Constants_CLS.TREST_RECORDTYPE;
                    List<Quote> myFinalQuote = [SELECT Id FROM Quote WHERE OpportunityId =: recordId AND CRAN_VEC_ADV_B_Final__c =: true];
                    
                    ///////// LLAMADA AL SERVICIO EXEC /////////
                    CRAN_VEC_ADV_ExecRebalpFinalRQ_CLS rq = new CRAN_VEC_ADV_ExecRebalpFinalRQ_CLS();
                    //entrada de parametros//
                    rq.lang = CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage());
                    rq.mode = CRAN_VEC_ADV_Constants_CLS.MODE_FINAL;
                    CRAN_VEC_ADV_Order_CLS order = new CRAN_VEC_ADV_Order_CLS();
                    order.setOrderNr(myOpp.CRAN_VEC_ADV_T_AvaloqPropId__c);
                    rq.order = order;

                    List<CRAN_VEC_ADV_ExecRebalpFinalRQ_CLS.CRAN_VEC_ADV_transList_CLS> myTransListToSend = new List<CRAN_VEC_ADV_ExecRebalpFinalRQ_CLS.CRAN_VEC_ADV_transList_CLS>();


                    for (Order ordToSend : listOrdersToSendSimulated) {
                            CRAN_VEC_ADV_ExecRebalpFinalRQ_CLS.CRAN_VEC_ADV_transList_CLS send = new CRAN_VEC_ADV_ExecRebalpFinalRQ_CLS.CRAN_VEC_ADV_transList_CLS();
                            send.orderNr = ordToSend.CRAN_VEC_ADV_T_OrderId__c;
                            //añado las ordenes a enviar
                            send.action = true;
                            myTransListToSend.add(send);
                    }
                    rq.transList = myTransListToSend;

                    //fin entrada de parametros//
                    String jsonRequest = JSON.serialize(rq);

                    String bu = myOpp.CRAN_VEC_ADV_P_Bunit__c;
                    CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_EXEC, bu, jsonRequest);

                    CRAN_VEC_ADV_ExecRebalpRS_CLS results = (CRAN_VEC_ADV_ExecRebalpRS_CLS)JSON.deserialize(restClient.responseBody, CRAN_VEC_ADV_ExecRebalpRS_CLS.class);

                    System.debug('results'+results);

                    ///////// FIN LLAMADA AL SERVICIO EXEC /////////

                    if (results == null) {
                        return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_Exec,true);
                    } else if (results.errors != null) {
                        return new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(results.errors),true);
                    } else if (results.orderNr != null && results.refOrderList == null) {
                        return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_Exec_Zero,true);
                    } else if (results.errors == null && results.orderNr != null && results.refOrderList != null && results.refOrderList.orderItem != null) {

                        //genero maps<CRAN_VEC_ADV_OrderId__c,String> para buscar si ya estan
                        //las que trae el servicio y realizar update

                        Map<String, Order> myMap = new Map<String, Order>();
                        For(Order orderTemp : listOrdersToSendSimulated) {
                            myMap.put(orderTemp.CRAN_VEC_ADV_T_OrderId__c, orderTemp);
                        }

                        List<Order> myListOrder = new List<Order>();
                        Order myOrder;

                        for (CRAN_VEC_ADV_ExecRebalpRS_CLS.CRAN_VEC_ADV_OrderItem_CLS myOrderItem : results.refOrderList.orderItem) {
                            Boolean isNew;
                            if (myMap.containsKey(myOrderItem.orderNr)) {
                                isNew = false;
                                myOrder = myMap.get(myOrderItem.orderNr);
                            } else {
                                isNew = true;
                                myOrder = new Order();
                            }

                            //creo o actualizo orders con los datos devueltos de servicio
                            myOrder = CRAN_VEC_ADV_Utils.completeOrder(myOrder, myOpp, myFinalQuote, recordId, myRecordType[0], myOrderItem, CRAN_VEC_ADV_Constants_CLS.MODE_FINAL,isNew);
                            myOrder.CRAN_VEC_ADV_B_Execute__c = false;                    

                            myListOrder.add(myOrder);
                        }
						
                        //Controlamos la respuesta del servicio updateFinal , solo van a firma las ordenes sin restricciones
						List<Order> listOrderSign = new List<Order>();
						for(Order tempOrder: myListOrder){
							if(String.isBlank(tempOrder.CRAN_VEC_ADV_T_HasRestr__c)){
								listOrderSign.add(tempOrder);
							}
						}
                        
                        CRAN_VAS_KER_OrderSignHndlr signerHandler = new CRAN_VAS_KER_OrderSignHndlr();
                        
                         String url;
                        
                        if(!listOrdersToSendWaiting.isEmpty()){
                            listOrdersToSendWaiting.addAll(listOrderSign);
                            signerHandler.getDocumentId(listOrdersToSendWaiting,myOpp.CRAN_VEC_ADV_P_Bunit__c);
                            url = signerHandler.getSignatureUrl(myOpp.ID);
                        }else{
                            if(!listOrderSign.isEmpty()){
                               signerHandler.getDocumentId(listOrderSign,myOpp.CRAN_VEC_ADV_P_Bunit__c);
                               url = signerHandler.getSignatureUrl(myOpp.ID);
                            }
                        }

                        //inserto y actualizo las ordenes devueltas por el servicio

                        RootMode rootMode = new RootMode();
                        rootMode.upsertOrders(myListOrder);

                        Boolean allwithErr = true;
                        Boolean oneOrMoreErrors = false;
                        String nameOfOrdersWithErr = Label.CRAN_VEC_ADV_IP_MSG_OrdersWithErrors + '\n';
                        //compruebo que si al menos una tiene error se muestre
                        for (CRAN_VEC_ADV_ExecRebalpRS_CLS.CRAN_VEC_ADV_OrderItem_CLS myOrderItem : results.refOrderList.orderItem) {
                            if(myOrderItem.hasRestr!=null &&  myOrderItem.hasRestr!=CRAN_VEC_ADV_Constants_CLS.EMPTY){
                                oneOrMoreErrors = true;
                                nameOfOrdersWithErr += myOrderItem.orderNr + '\n';  
                            } else {
                                allwithErr = false;                  
                            }                               
                        }

                        if(oneOrMoreErrors && allwithErr){
                            if(!listOrdersToSendWaiting.isEmpty()){
                                 return new SuccessResponse(url,true,nameOfOrdersWithErr);
                            }else{
                                return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_AllOrdersWithErrors,false);
                            }                    
                        }else if(oneOrMoreErrors){
                            return new SuccessResponse(url,true,nameOfOrdersWithErr);
                        } else{
                            return new SuccessResponse(url,false,CRAN_VEC_ADV_Constants_CLS.EMPTY);
                        }
                    }
                
                    return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_Exec,true);
                }
                
                CRAN_VAS_KER_OrderSignHndlr signerHandler = new CRAN_VAS_KER_OrderSignHndlr();
                signerHandler.getDocumentId(listOrdersToSendWaiting,myOpp.CRAN_VEC_ADV_P_Bunit__c);
                String url = signerHandler.getSignatureUrl(myOpp.ID);

                return new SuccessResponse(url,false,CRAN_VEC_ADV_Constants_CLS.EMPTY);
            }
            return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_Exec,true);
            
        } catch (Exception e) {

            //desmarco todas las enviadas al servicio
            List<Order> listOrdersToSign = [SELECT Id,OpportunityId,CRAN_VEC_ADV_B_Execute__c,CRAN_VEC_ADV_B_ExecuteToConfirm__c,CRAN_VEC_ADV_F_isEdit__c
                                                        FROM Order 
                                                        WHERE OpportunityId = : recordId AND CRAN_VEC_ADV_B_Execute__c = true AND CRAN_VEC_ADV_F_isEdit__c = true];
            for (Order listToCheckOut : listOrdersToSign) {                                                        
                    listToCheckOut.CRAN_VEC_ADV_B_Execute__c = false;
                    listToCheckOut.CRAN_VEC_ADV_B_ExecuteToConfirm__c = false;
            }

            RootMode rootMode = new RootMode();
            rootMode.updateOrders(listOrdersToSign);

            return new ErrorResponse(e,true);
        }
    }

    @AuraEnabled
    public static Object execServiceModeFinalDiscard(String recordId) {

        try {
            Opportunity myOpp = [SELECT Id, AccountId, CRAN_VEC_ADV_T_AvaloqPropId__c, CRAN_VEC_ADV_P_Bunit__c FROM Opportunity WHERE Id = :recordId ];
            List<Order> listOrdersToSendSimulated = [SELECT Id, OpportunityId, CRAN_VEC_ADV_T_OrderId__c, 
                                                        CRAN_VEC_ADV_B_ExecuteToConfirm__c, CRAN_VEC_ADV_T_AvaloqStatusId__c, CRAN_VEC_ADV_T_AvaloqStatus__c, 
                                                        CRAN_VEC_ADV_B_Execute__c, CRAN_VEC_ADV_B_Signed__c, Name 
                                                        FROM Order 
                                                        WHERE OpportunityId = : recordId AND CRAN_VEC_ADV_B_Execute__c = true AND CRAN_VEC_ADV_F_isEdit__c = true AND CRAN_VEC_ADV_B_Signed__c = false];

            System.debug('listOrdersToSendSimulated' + listOrdersToSendSimulated);

            List<RecordType> myRecordType = CRAN_VEC_ADV_Constants_CLS.ORDER_RECORDTYPE;
            List<RecordType> myRecordTypeTRest = CRAN_VEC_ADV_Constants_CLS.TREST_RECORDTYPE;
            List<Quote> myFinalQuote = [SELECT Id FROM Quote WHERE OpportunityId = :recordId AND CRAN_VEC_ADV_B_Final__c = :true];
            ///////// LLAMADA AL SERVICIO EXEC /////////
            CRAN_VEC_ADV_OrderConfirm_RQ rq = new CRAN_VEC_ADV_OrderConfirm_RQ();

            //entrada de parametros//
            rq.lang = CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage());

            List<CRAN_VEC_ADV_OrderPrintList_CLS> myTransListToSend = new List<CRAN_VEC_ADV_OrderPrintList_CLS>();


            for (Order ordToSend : listOrdersToSendSimulated) {
                CRAN_VEC_ADV_OrderPrintList_CLS send = new CRAN_VEC_ADV_OrderPrintList_CLS();
                send.orderNr = ordToSend.CRAN_VEC_ADV_T_OrderId__c;
                //añado las ordenes a descartar
                myTransListToSend.add(send);
            }
            rq.orderList = myTransListToSend;

            //fin entrada de parametros//
            String jsonRequest = JSON.serialize(rq);
            System.debug('jsonRequest '+jsonRequest);
            String bu = myOpp.CRAN_VEC_ADV_P_Bunit__c;
            CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_ORDER_DISCARD,jsonRequest, true);

            CRAN_VEC_ADV_OrderConfirm_RS results = (CRAN_VEC_ADV_OrderConfirm_RS)JSON.deserialize(restClient.responseBody, CRAN_VEC_ADV_OrderConfirm_RS.class);
            System.debug('results '+results);
            ///////// FIN LLAMADA AL SERVICIO EXEC /////////

            if (results != null && results.errors != null && (results.orderList == null || results.orderList.size()<1)) {
                return new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsServiceUlList(results.errors));
            } else if (results != null && results.orderList != null && results.orderList.size()>0) {

                //genero maps<CRAN_VEC_ADV_OrderId__c,String> para buscar si ya estan
                //las que trae el servicio y realizar update
                Map<String, Order> myMap = new Map<String, Order>();
                For(Order orderTemp : listOrdersToSendSimulated) {
                    myMap.put(orderTemp.CRAN_VEC_ADV_T_OrderId__c, orderTemp);
                }

                List<Order> myListOrder = new List<Order>();
                Order myOrder;

                for (CRAN_VEC_ADV_OrderPrintList_CLS myOrderItem : results.orderList) {
                    if (myMap.containsKey(myOrderItem.orderNr)) {
                        myOrder = myMap.get(myOrderItem.orderNr);
                        myOrder.CRAN_VEC_ADV_P_SFStatus__c = CRAN_VEC_ADV_Constants_CLS.OPP_ORDER_DISCARDED_ORDER;
                        myOrder.CRAN_VEC_ADV_T_AvaloqStatus__c = Label.CRAN_VEC_ADV_IP_DiscardedOrder;
                        myOrder.CRAN_VEC_ADV_T_AvaloqStatusId__c = CRAN_VEC_ADV_Constants_CLS.OPP_ORDER_DISCARDED;


                        //myOrder.CRAN_VEC_ADV_B_isService__c = true;
                        myOrder.CRAN_VEC_ADV_B_Execute__c = false;
                        myOrder.CRAN_VEC_ADV_B_ExecuteToConfirm__c = false;
                    }                     
                    myListOrder.add(myOrder);
                }

                //inserto y actualizo las ordenes devueltas por el servicio
                RootMode rootMode = new RootMode();
                rootMode.upsertOrders(myListOrder);

                if(results.errors != null && results.errors.size()>0){

                    return new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsServiceUlList(results.errors));
                } else {

                    return new SuccessResponse();
                }

            }

            return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_Exec);

        } catch (Exception e) {

            return new ErrorResponse(e);
        }
    }    


    @AuraEnabled
    public static Boolean isOpportunityStageOpen(String recordId) {
        Opportunity opp = [SELECT StageName FROM Opportunity WhERE Id = : recordId];
        if (opp.StageName  == CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_DONE) {
            return true;
        }
        return false;
    }

 @AuraEnabled
    public static Object infoToSendArchive(String idOrder, String idOpportunity, String numOrder) {
        

        
        try {

            List<Order> listOrder = [SELECT Id, CRAN_VEC_ADV_ReferenceLine__c, 
                                     Account.CRAN_VEC_ADV_N_Number__c 
                                     FROM Order 
                                     WHERE  Id = : idOrder AND CRAN_VEC_ADV_ReferenceLine__c != NULL 
                                     LIMIT 1];
            List<Opportunity> myOpp = [SELECT Id, Name
                                       FROM Opportunity WHERE Id = :idOpportunity LIMIT 1];

            
            if (listOrder != null && listOrder.size() > 0) {
            
                CRAN_VEC_ADV_ArchiveRQ rq = new CRAN_VEC_ADV_ArchiveRQ();
               
                rq.bpId = listOrder[0].Account.CRAN_VEC_ADV_N_Number__c;
		        rq.orderNr = numOrder;
                rq.referenceLine = listOrder[0].CRAN_VEC_ADV_ReferenceLine__c;
                
                String jsonRequest = JSON.serialize(rq);
                CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_ARCHIVE_DOC,jsonRequest,false);
                CRAN_VEC_ADV_ArchiveRS response = (CRAN_VEC_ADV_ArchiveRS)JSON.deserialize(restClient.responseBody,CRAN_VEC_ADV_ArchiveRS.class);

                System.debug(' ----------------- ');
                System.debug(' Print ArchiveDocument Orders');
                System.debug(' ----------------- ');

                if(response != null && response.pdfContent != null){
                        CRAN_VEC_ADV_Utils.deleteContentDocument('Signed_'+myOpp[0].Name);
                        String content = CRAN_VEC_ADV_Utils.saveContentVersion(response.pdfContent, 'Signed_'+myOpp[0].Name);
                        System.debug('****> content: ' + content);
                        System.debug('****> HeapSize: ' + Limits.getHeapSize());
                        System.debug('****> LimitHeapSize: ' + Limits.getLimitHeapSize());
                        return new SuccessResponse(content);
                }else{
                    return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_Archive);
                }
            }else
                return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_Archive);
        } catch (Exception e) {
            return new ErrorResponse(e);
        }
    }

    @AuraEnabled
    public static Object updateStatusOrderExec(String recordId, String idOrder, Boolean execute) {
        try {
            List<Order> listToDeleteTrans = [SELECT Id, CRAN_VEC_ADV_B_Execute__c,CRAN_VEC_ADV_B_ExecuteToConfirm__c, CRAN_VEC_ADV_F_isEdit__c,CRAN_VEC_ADV_P_SFStatus__c FROM Order WHERE OpportunityId = : recordId AND Id = : idOrder];

            if (listToDeleteTrans[0].CRAN_VEC_ADV_F_isEdit__c || CRAN_VEC_ADV_Constants_CLS.OPP_ORDER_SIGNED_PENDINGEXEC.equals(listToDeleteTrans[0].CRAN_VEC_ADV_P_SFStatus__c)) {
				Boolean setExecuted = !listToDeleteTrans[0].CRAN_VEC_ADV_B_Execute__c;
                listToDeleteTrans[0].CRAN_VEC_ADV_B_Execute__c = setExecuted;
                listToDeleteTrans[0].CRAN_VEC_ADV_B_ExecuteToConfirm__c = setExecuted;
                RootMode rootMode = new RootMode();
                rootMode.updateOrd(listToDeleteTrans[0]);
            }

            return new SuccessResponse();

        } catch (Exception e) {
            return new ErrorResponse(e);
        }
    }



    @AuraEnabled
    public static Object updateStatusOrderManual(String recordId, String idOrder, Boolean manual) {
        try {
            List<Order> listToDeleteTrans = [SELECT Id, CRAN_VEC_ADV_B_ManualConfirm__c,CRAN_VEC_ADV_B_ExecuteToConfirm__c, CRAN_VEC_ADV_F_isEdit__c FROM Order WHERE OpportunityId = : recordId AND Id = : idOrder];

            if (listToDeleteTrans[0].CRAN_VEC_ADV_F_isEdit__c) {
                listToDeleteTrans[0].CRAN_VEC_ADV_B_ManualConfirm__c = !listToDeleteTrans[0].CRAN_VEC_ADV_B_ManualConfirm__c;
                RootMode rootMode = new RootMode();
                rootMode.updateOrd(listToDeleteTrans[0]);
            }
            return new SuccessResponse();
        } catch (Exception e) {
            return new ErrorResponse(e);
        }
    }
    

    /*@AuraEnabled
    public static Object ActiveBtnOrders(String recordId) {
        Opportunity opp = [SELECT StageName FROM Opportunity WhERE Id = : recordId];
        if (opp.StageName == CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_DONE) {
            return new SuccessResponse();
        } else if (opp.StageName == CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_SIMULATED) {
            return new ErrorResponse();
        } else {
            return null;
        }
    }*/


    /*@AuraEnabled
    public static List<Boolean> ActiveBtnOrders(String recordId) {
        Opportunity opp = [SELECT StageName FROM Opportunity WhERE Id = : recordId];
        Integer nActOrders = 0;
        Integer nGetOrders = 0;
        Integer nPrtOrders = 0;
        Integer nSgnOrders = 0;
        Integer nCnfOrders = 0;
        List<Boolean> values = new List<Boolean>();
        if (opp.StageName == CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_DONE) {
            nActOrders = database.countQuery('SELECT Count() FROM Order WHERE OpportunityId=:recordId AND CRAN_VEC_ADV_F_isEdit__c=true LIMIT 1');            
            nGetOrders = 1; // Siempre que la oportunidad esté en advDone o advSimulated se activa el botón de GetOrders.
            nPrtOrders = database.countQuery('SELECT Count() FROM Order WHERE OpportunityId=:recordId AND CRAN_VEC_ADV_B_Execute__c=true AND CRAN_VEC_ADV_F_isEdit__c=true LIMIT 1');
            nSgnOrders = database.countQuery('SELECT Count() FROM Order WHERE OpportunityId=:recordId AND CRAN_VEC_ADV_B_Execute__c=true AND CRAN_VEC_ADV_F_isEdit__c=true AND CRAN_VEC_ADV_B_Signed__c=false LIMIT 1');
            nCnfOrders = database.countQuery('SELECT Count() FROM Order WHERE OpportunityId=:recordId AND CRAN_VEC_ADV_B_ExecuteToConfirm__c=true AND ((CRAN_VEC_ADV_F_WaitSign__c=true AND CRAN_VEC_ADV_HasError__c = true) OR CRAN_VEC_ADV_F_SignedPending__c=true) LIMIT 1');
        } else if (opp.StageName == CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_SIMULATED) {
            nGetOrders = 1; // Siempre que la oportunidad esté en advDone o advSimulated se activa el botón de GetOrders.
        }
        values.add( nActOrders > 0 );
        values.add( nGetOrders > 0 );
        values.add( nPrtOrders > 0 );
        values.add( nSgnOrders > 0 );
        values.add( nCnfOrders > 0 );
        return values;
    }*/


    @AuraEnabled
    public static Object selectAll(String recordId, Boolean isSelected, Boolean viewAllStex, Boolean viewAllFxtr) {
        try {

            //comprueba que la Opportunity esta en el estado correcto
            Opportunity selectedOpp = [SELECT Id, StageName FROM Opportunity WHERE Id = :recordId];   

            if(selectedOpp.StageName != CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_DONE){
                return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_NoCorrectToAll);    
            }              

            List<Order> listToDeleteTrans;
            if (viewAllStex != null && viewAllStex) {
                listToDeleteTrans = [SELECT Id, CRAN_VEC_ADV_B_Execute__c, CRAN_VEC_ADV_B_ExecuteToConfirm__c, CRAN_VEC_ADV_F_isEdit__c FROM Order WHERE OpportunityId = : recordId AND (CRAN_VEC_ADV_F_isEdit__c = true OR CRAN_VEC_ADV_P_SFStatus__c = : CRAN_VEC_ADV_Constants_CLS.OPP_ORDER_SIGNED_PENDINGEXEC) AND CRAN_VEC_ADV_P_MetaType__c = : CRAN_VEC_ADV_Constants_CLS.STEX];
            } else if (viewAllFxtr != null && viewAllFxtr) {
                listToDeleteTrans = [SELECT Id, CRAN_VEC_ADV_B_Execute__c, CRAN_VEC_ADV_B_ExecuteToConfirm__c, CRAN_VEC_ADV_F_isEdit__c FROM Order WHERE OpportunityId = : recordId AND (CRAN_VEC_ADV_F_isEdit__c = true OR CRAN_VEC_ADV_P_SFStatus__c = : CRAN_VEC_ADV_Constants_CLS.OPP_ORDER_SIGNED_PENDINGEXEC) AND CRAN_VEC_ADV_P_MetaType__c = : CRAN_VEC_ADV_Constants_CLS.FXTR];
            } else {
                listToDeleteTrans = [SELECT Id, CRAN_VEC_ADV_B_Execute__c, CRAN_VEC_ADV_B_ExecuteToConfirm__c, CRAN_VEC_ADV_F_isEdit__c FROM Order WHERE OpportunityId = : recordId AND (CRAN_VEC_ADV_F_isEdit__c = true OR CRAN_VEC_ADV_P_SFStatus__c = : CRAN_VEC_ADV_Constants_CLS.OPP_ORDER_SIGNED_PENDINGEXEC)];
            }

            if(listToDeleteTrans.size()<1)
                return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_NoCorrectToAll);

            for (Order myOrder : listToDeleteTrans) {
                myOrder.CRAN_VEC_ADV_B_Execute__c = isSelected;
                myOrder.CRAN_VEC_ADV_B_ExecuteToConfirm__c = isSelected;                
            }

            RootMode rootMode = new RootMode();
            rootMode.updateOrders(listToDeleteTrans);

            return new SuccessResponse(CRAN_VEC_ADV_Constants_CLS.EMPTY);

        } catch (Exception e) {
            return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_NoCorrectToAll);
        }
    }

    @AuraEnabled
    public static Object callOmsPrint(String propId) {
        try {
            System.debug('--> callOmsPrint   ' + propId);
            //RECUPERAMOS LA LISTA DE IDS DE ORDENES PARA SOLICITAR SUS IDS OMS
            Opportunity selectedOpp = [SELECT Id, CRAN_VEC_ADV_P_Bunit__c FROM Opportunity WHERE Id = :propId];
            System.debug('--> selectedOpp   ' + selectedOpp);
            
            List<Order> orderList = [SELECT Id, CRAN_VEC_ADV_T_OrderId__c 
                                    FROM Order o 
                                    WHERE CRAN_VEC_ADV_B_Execute__c = true AND o.OpportunityId = :propId AND CRAN_VEC_ADV_B_Signed__c = false 
                                    AND RecordType.DeveloperName = :CRAN_VEC_ADV_Constants_CLS.CRAN_VEC_ADV_ORDER_INVT_PROP];

            System.debug('--> orderList   ' + orderList);
            if (orderList != null && orderList.size() > 0) {
                CRAN_VEC_ADV_OmsPrintList_RQ rq = new CRAN_VEC_ADV_OmsPrintList_RQ();
                rq.orderList = new List<CRAN_VEC_ADV_OrderPrintList_CLS>();

                for (Order order : orderList) {
                    CRAN_VEC_ADV_OrderPrintList_CLS orderCls = new CRAN_VEC_ADV_OrderPrintList_CLS();
                    orderCls.orderNr = order.CRAN_VEC_ADV_T_OrderId__c;
                    rq.orderList.add(orderCls);
                }

                String omsPrintjsonRequest = JSON.serialize(rq);

                CRAN_VEC_ADV_RestClient_CLS avaloqClient;
                avaloqClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_OMS_LIST_PRINT, selectedOpp.CRAN_VEC_ADV_P_Bunit__c,omsPrintjsonRequest);

                CRAN_VEC_ADV_OmsPrintList_RS results = (CRAN_VEC_ADV_OmsPrintList_RS) JSON.deserialize(avaloqClient.responseBody, CRAN_VEC_ADV_OmsPrintList_RS.class);

                if (results != null && results.errors != null) {
                    return new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(results.errors));
                } else if (results != null && results.errors == null && results.omsIdList != null) {
                    CRAN_VEC_ADV_MergeOMS_RQ mergeRequest = new CRAN_VEC_ADV_MergeOMS_RQ();
                    if (results.omsIdList.size() > 0) {
                        //LLAMADA A MERGEADO DE LISTAS
                        String mergeIds = CRAN_VEC_ADV_Constants_CLS.EMPTY;
                        for (CRAN_VEC_ADV_OmsPrintList_RS.oms printOMS : results.omsIdList) {
                            if (mergeIds.equals(CRAN_VEC_ADV_Constants_CLS.EMPTY)) {
                                mergeIds = printOMS.omsId;
                            } else {
                                mergeIds = mergeIds + ';' + printOMS.omsId;
                            }
                        }
                        System.debug('****> resultMerge: ' + mergeIds);
                        //COMPROBAMOS ERRORES EN EL MERGEO DE PDF
                        return new SuccessResponse(mergeIds);
                    } else {
                        return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_Error);
                    }
                } else {
                    return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_Error);
                }
            } else {
                return null;
            }
        } catch (Exception e) {
            return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_Error);
        }
    }


    @AuraEnabled
    public static Object execServiceOrderConfirm(String recordId) {

        Opportunity selectedOpp = [SELECT Id, StageName FROM Opportunity WHERE Id = :recordId];

        List<Order> listOrders = [SELECT Id, CRAN_VEC_ADV_T_OrderId__c
                                  FROM Order
                                  WHERE OpportunityId = : recordId AND  CRAN_VEC_ADV_B_ExecuteToConfirm__c = true 
                                  AND ((CRAN_VEC_ADV_F_WaitSign__c = true AND CRAN_VEC_ADV_HasError__c = true) OR CRAN_VEC_ADV_F_SignedPending__c = true) 
                                  AND RecordType.DeveloperName = :CRAN_VEC_ADV_Constants_CLS.CRAN_VEC_ADV_ORDER_INVT_PROP];

        System.debug('listOrders  --> '+ listOrders);

        if (listOrders.isEmpty()) {
            return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_NO_ORDERS_TO_CONFIRM);            
        }
        if(selectedOpp.StageName != CRAN_VEC_ADV_Constants_CLS.OPP_STAGENAME_DONE){
            return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_NoSelectedOrders);
        }

        Map<String, Order> mapOrders = new Map<String, Order>();
        String mensajeError = CRAN_VEC_ADV_Constants_CLS.EMPTY;

        for (Order orden : listOrders) {
            if (orden.CRAN_VEC_ADV_T_OrderId__c != null) {
                mapOrders.put(orden.CRAN_VEC_ADV_T_OrderId__c, orden);
            }
        }
        system.debug('Mapa ordenes : ' + mapOrders);

        try {
            CRAN_VEC_ADV_OrderConfirm_RQ rq = new CRAN_VEC_ADV_OrderConfirm_RQ();

            List<CRAN_VEC_ADV_OrderPrintList_CLS> lstOrders = new List<CRAN_VEC_ADV_OrderPrintList_CLS>();

            for (Order orden : listOrders) {
                CRAN_VEC_ADV_OrderPrintList_CLS order = new CRAN_VEC_ADV_OrderPrintList_CLS();
                order.orderNr = orden.CRAN_VEC_ADV_T_OrderId__c;
                lstOrders.add(order);
            }

            rq.orderList = lstOrders;
            rq.lang = CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage());

            String jsonRequest = JSON.serialize(rq);

            CRAN_VEC_ADV_RestClient_CLS avaloqClient;
            avaloqClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_ORDER_CONFIRM, jsonRequest,true);

            CRAN_VEC_ADV_OrderConfirm_RS results;
            if(avaloqClient.responseBody != null){
                System.debug('Respuesta servicio Json: ' + avaloqClient.responseBody);
                results = (CRAN_VEC_ADV_OrderConfirm_RS) JSON.deserialize(avaloqClient.responseBody, CRAN_VEC_ADV_OrderConfirm_RS.class);
            }
            System.debug('Respuesta servicio: ' + results);

            if (results != null && results.errors != null) {
                String OrdersOk = CRAN_VEC_ADV_Constants_CLS.EMPTY;
                if (results.orderList != null) {
                    Map<String, Order> mapOrdersOk = new Map<String, Order>();
                    for (CRAN_VEC_ADV_OrderPrintList_CLS ordenesRs : results.orderList) {
                        mapOrdersOk.put(ordenesRs.orderNr, mapOrders.get(ordenesRs.orderNr));
                        mapOrders.remove(ordenesRs.orderNr);
                        OrdersOk += ordenesRs.orderNr + ', ';
                    }
                    CRAN_VEC_ADV_ESignatureTriggerUtil.updateOrderError(null, mapOrdersOk, false);
                    if(OrdersOk != CRAN_VEC_ADV_Constants_CLS.EMPTY){
                        OrdersOk = OrdersOk.substringBeforeLast(',') + '.\n';
                    }                   
                }
                if (!mapOrders.isEmpty()) {
                    System.debug( ' -------------------- ERROR EN EL SERVICIO -------------------- ');
                    System.debug('ERROR : ' + CRAN_VEC_ADV_Utils.getAllErrorsService(results.errors));
                    CRAN_VEC_ADV_ESignatureTriggerUtil.updateOrderError(CRAN_VEC_ADV_Utils.getAllErrorsService(results.errors), mapOrders, false);
                }

                if (OrdersOk != CRAN_VEC_ADV_Constants_CLS.EMPTY) {
                    mensajeError += Label.CRAN_VEC_ADV_OrderConfirm + OrdersOk + '\n';
                }

                mensajeError += Label.CRAN_VEC_ADV_OrderConfirmErrors + ': ' + CRAN_VEC_ADV_Utils.getAllErrorsServiceUlList(results.errors);
                mensajeError += Label.CRAN_VEC_ADV_OrderListRefresh;
            } else if (results != null && results.errors == null && results.orderList != null) {
                CRAN_VEC_ADV_ESignatureTriggerUtil.updateOrderError(null, mapOrders, false);
                System.debug('  -------------------- CONFIRMACION ORDENES OK --------------------');
            } else {
                mensajeError += Label.CRAN_VEC_ADV_IP_MSG_Error + '\n';
                System.debug( ' -------------------- ERROR EN EL SERVICIO -------------------- ');
                System.debug('ERROR : ' + Label.CRAN_VEC_ADV_IP_MSG_Error);
                CRAN_VEC_ADV_ESignatureTriggerUtil.updateOrderError(Label.CRAN_VEC_ADV_IP_MSG_Error, mapOrders, false);
                mensajeError += ' \n ' + Label.CRAN_VEC_ADV_OrderListRefresh;
            }
            
        } catch (Exception e) {
            mensajeError += e.getMessage() + '\n';
            System.debug( ' -------------------- ERROR EN EL SERVICIO -------------------- ');
            System.debug('ERROR : ' + e.getTypeName() + '; MENSAJE DEL ERROR : ' + e.getMessage() + '; CAUSA DEL ERROR : ' + e.getCause() + '; ERROR EN LA LINEA : ' + e.getLineNumber()
                         + '; TRAZA : ' + e.getStackTraceString());
            CRAN_VEC_ADV_ESignatureTriggerUtil.updateOrderError(e.getMessage(), mapOrders, false);
            mensajeError += ' \n ' + Label.CRAN_VEC_ADV_OrderListRefresh;																																	 
        }
		// Actualizo forex y stex
        Object resultDataListStexForex = CRAN_VEC_ADV_OrderList_AUC.DataListStexForex(recordId);

        if(resultDataListStexForex instanceof CRAN_VEC_ADV_OrderList_AUC.SuccessResponse){
                    CRAN_VEC_ADV_OrderList_AUC.SuccessResponse tempSuccess = (CRAN_VEC_ADV_OrderList_AUC.SuccessResponse)resultDataListStexForex;
                    if (mensajeError != CRAN_VEC_ADV_Constants_CLS.EMPTY) {
                        return new ErrorResponse(tempSuccess.dataListStex, tempSuccess.dataListForex, mensajeError);
                    } else {
                        return new SuccessResponse(tempSuccess.dataListStex, tempSuccess.dataListForex, Label.CRAN_VEC_ADV_OrderConfirmSucces);
                    }

        } else {
                    CRAN_VEC_ADV_OrderList_AUC.ErrorResponse tempError = (CRAN_VEC_ADV_OrderList_AUC.ErrorResponse)resultDataListStexForex;
                    if (mensajeError != CRAN_VEC_ADV_Constants_CLS.EMPTY) {
                        return new ErrorResponse(tempError.dataListStex, tempError.dataListForex, mensajeError+ ''+tempError.messageError);
                    } else {
                            return new SuccessResponse( tempError.dataListStex, tempError.dataListForex,Label.CRAN_VEC_ADV_OrderConfirmSucces+' Error'+tempError.messageError);
                    }
        }
        // Fin actualizo forex y stex
    }

    @AuraEnabled
    public static Object printPreviewOrders(String propId) {
        Opportunity opp = [SELECT Id, Name FROM Opportunity WHERE ID = : propId];
        Object response = callOmsPrint(propId);
        if(response == null){
            return new SuccessResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_Exec_Num,true);
        }

        System.debug('Response: ' + response);

        if (response instanceof SuccessResponse) {
            SuccessResponse success = (SuccessResponse)response;
            String documentId = success.mergeIDs;
            System.debug('documentId ' + documentId);
            if (documentId != null) {
                List<String> omsIdList = documentId.split(';');
                System.debug('domcument split: ' + omsIdList);
                if (omsIdList.size() > 0) {
                    CRAN_VEC_ADV_MergeOMS_RQ mergeRequest = new CRAN_VEC_ADV_MergeOMS_RQ();
                    //LLAMADA A MERGEADO DE LISTAS
                    mergeRequest.omsList = new List<CRAN_VEC_ADV_MergeOMS_RQ.Oms>();

                    for (String printOMS : omsIdList) {
                        CRAN_VEC_ADV_MergeOMS_RQ.Oms tmp = new CRAN_VEC_ADV_MergeOMS_RQ.Oms();
                        tmp.omsId = printOMS;
                        mergeRequest.omsList.add(tmp);
                    }

                    System.debug(' ----------------- ');
                    System.debug(' mergeRequest : ' + mergeRequest);
                    System.debug(' ----------------- ');

                    String mergeOmsjsonRequest = JSON.serialize(mergeRequest);
                    System.debug('****> mergeOmsjsonRequest: ' + mergeOmsjsonRequest);
                    System.debug('****> HeapSize: ' + Limits.getHeapSize());
                    String resultCallout = CRAN_VEC_ADV_PrintRestPDF_CTR.printPDFcallOut(CRAN_VEC_ADV_Constants_CLS.SERVICE_MERGE_PDF, mergeOmsjsonRequest);
                    System.debug('****> resultCallout: ' + resultCallout);
                    if (resultCallout != null) {
                        CRAN_VEC_ADV_Utils.deleteContentDocument(opp.Name);
                        String content = CRAN_VEC_ADV_Utils.saveContentVersion(resultCallout, opp.Name);
                        System.debug('****> content: ' + content);
                        System.debug('****> HeapSize: ' + Limits.getHeapSize());
                        System.debug('****> LimitHeapSize: ' + Limits.getLimitHeapSize());
                        //COMPROBAMOS ERRORES EN EL MERGEO DE PDF
                        if (String.isNotBlank(resultCallout)) {
                            return new SuccessResponse(content);
                        } else {
                            return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_Error);
                        }
                    } else {
                        return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_Error);
                    }
                } else {
                    return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_Error);
                }
            } else {
                return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_Error);
            }
        } else {
            return new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_Error);
        }
    }
    
    /*---Merge [MKT] Cambio firma modal boletas + update validation rule--*/
    @AuraEnabled 
    public static Map<String, String> getMobilePhoneInfo(Id recId) {
        return CRAN_VAS_KER_SignatureUtils.getMobilePhoneInfo(recId, true);
    }  
    
    /*---------------------------------------------------------*/
    /*     CLASE PARA HACER ACIONES WITHOUT SHARING METHODS    */
    /*---------------------------------------------------------*/

    private without sharing class RootMode{
        public void upsertOrders(List<Order> lstOrders){
            upsert lstOrders;
        }

        public void updateOrders(List<Order> lstOrders){
            update lstOrders;
        }

        public void updateOrd(Order ord){
            update ord;
        }

    }

    @TestVisible
    class SuccessResponse {

        @AuraEnabled public Boolean success {get; set;}
        @AuraEnabled public SObject obj {get; set;}
        @AuraEnabled public String mergeIDs {get; set;}
        @AuraEnabled public String bpId {get; set;}
        @AuraEnabled public String inLineEsignature {get; set;}
        @AuraEnabled public Boolean callExecRebalp {get; set;}
        @AuraEnabled public Boolean isEmpty {get; set;}
		@AuraEnabled public List<List<CRAN_VEC_ADV_FieldDataIpl_CLS>> dataListStex {get; set;}
        @AuraEnabled public List<List<CRAN_VEC_ADV_FieldDataIpl_CLS>> dataListForex {get; set;}
        @AuraEnabled public String msg {get; set;}										   

        public SuccessResponse() {
            this.success = true;
            this.isEmpty = false;
        }

        public SuccessResponse(Opportunity obj) {
            this.success = true;
            this.obj = obj;
            this.isEmpty = false;
        }

        public SuccessResponse(String mergeIDs) {
            this.success = true;
            this.mergeIDs = mergeIDs;
            this.isEmpty = false;
        }

        public SuccessResponse(String mergeIDs,Boolean isEmpty) {
            this.success = true;
            this.mergeIDs = mergeIDs;
            this.isEmpty = isEmpty;
        }

        public SuccessResponse(String inLineEsignature, String bpId) {
            this.success = true;
            this.inLineEsignature = inLineEsignature;
            this.bpId = bpId;
            this.isEmpty = false;
        }

        public SuccessResponse(String url, Boolean withOutErr,String msg) {
            this.success = true;
            this.inLineEsignature = msg;
            this.mergeIDs = url;
            this.isEmpty = withOutErr;
        }        

		public SuccessResponse(List<List<CRAN_VEC_ADV_FieldDataIpl_CLS>> dStex, List<List<CRAN_VEC_ADV_FieldDataIpl_CLS>> dForex) {
            this.success = true;
            this.dataListStex = dStex;
            this.dataListForex = dForex;
        } 

        public SuccessResponse(List<List<CRAN_VEC_ADV_FieldDataIpl_CLS>> dStex, List<List<CRAN_VEC_ADV_FieldDataIpl_CLS>> dForex, String msg) {
            this.success = true;
            this.dataListStex = dStex;
            this.dataListForex = dForex;
            this.msg = msg;
        } 						
    }
    @TestVisible
    class ErrorResponse {
        @AuraEnabled public Boolean success {get; set;}
        @AuraEnabled public Integer lineNumber {get; set;}
        @AuraEnabled public String messageError {get; set;}
        @AuraEnabled public String typeError {get; set;}
        @AuraEnabled public String stackTrace {get; set;}
        @AuraEnabled public Boolean personIsValid {get; set;}
		@AuraEnabled public List<List<CRAN_VEC_ADV_FieldDataIpl_CLS>> dataListStex {get; set;}
        @AuraEnabled public List<List<CRAN_VEC_ADV_FieldDataIpl_CLS>> dataListForex {get; set;}												   												

        public ErrorResponse(Exception e) {
            this.success = false;
            this.lineNumber = e.getLineNumber();
            this.typeError = e.getTypeName();
            this.messageError = e.getMessage();
            this.stackTrace = e.getStackTraceString();
        }

        public ErrorResponse(String str) {
            this.success = false;
            this.messageError = str;
        }

        public ErrorResponse(String str,Boolean personIsValid) {
            this.success = false;
            this.messageError = str;
            this.personIsValid = personIsValid;
        }

        public ErrorResponse() {
            this.success = false;
        }

        public ErrorResponse(Exception e, Boolean personIsValid) {
            this.success = false;
            this.lineNumber = e.getLineNumber();
            this.typeError = e.getTypeName();
            this.messageError = e.getMessage();
            this.stackTrace = e.getStackTraceString();
            this.personIsValid = personIsValid;
        }
		
		public ErrorResponse(List<List<CRAN_VEC_ADV_FieldDataIpl_CLS>> dStex, List<List<CRAN_VEC_ADV_FieldDataIpl_CLS>> dForex, String str) {
            this.success = false;
            this.dataListStex = dStex;
            this.dataListForex = dForex;
            this.messageError = str;
        } 
    }

}