/**
 * CRAN_VEC_ADV_Utils generic Utils class
 *
 * Fecha: 31/08/2017
 * 
 * Fix encrypted mock response for Portfolio service
 * @version 1.4
 * 
 *
*/
public without sharing class CRAN_VEC_ADV_Utils {

    private Static CRAN_VEC_ADV_OrdersManualConfirm__c cs = CRAN_VEC_ADV_OrdersManualConfirm__c.getInstance();
    private Static Boolean FOREXACTIVE = cs.FOREX__c;
    private Static Boolean STEXACTIVE = cs.STEX__c;
    private Static String INSTRGROUP_LIST = cs.INSTRGROUP__c;
    private Static String INSTRGROUPUNMARK_LIST = cs.INSTRGROUPUNMARK__c;
    private Static String CATACTIVO_LIST = cs.CATACTIVO__c;
    private Static Set<String> INSTRGROUP_MANUAL_SET = getInstrGroupManualList(INSTRGROUP_LIST);
    private Static Set<String> INSTRGROUP_AUTOMATIC_SET = getInstrGroupAutList(INSTRGROUPUNMARK_LIST);
    private Static Set<String> CATACTIVO_MANUAL_SET = getCatActivoManualList(CATACTIVO_LIST);
    
    // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
    public static string getCreatableFieldsSOQL(String objectName, String whereClause){
        String selects = '';
        if (whereClause == null || whereClause == ''){ return null; }
         
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
         
        System.debug(fMap);
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isAccessible()){ // field is creatable
                    selectFields.add(fd.getName());
                }
            }
        }
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}    
        }
        System.debug(selects);
        System.debug(objectName);
        if(String.isNotBlank(whereClause)){
            return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
        }else{
            return 'SELECT ' + selects + ' FROM ' + objectName;
        }
    }

    // Returns a dynamic SOQL statement for the whole object, includes only custom fields since we will be inserting a cloned result of this query
    public static string getCustomFieldsAndDefinedStandardsSOQL(String objectName, String whereClause, String standardFields){
        String selects = '';
        if (whereClause == null || whereClause == ''){ return null; }
         
        // Get a map of field name and field token
        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
        list<string> selectFields = new list<string>();
         
        if (fMap != null){
            for (Schema.SObjectField ft : fMap.values()){ // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
                if (fd.isCustom()){ // field is custom
                    selectFields.add(fd.getName());
                }
            }
        }
        if (!selectFields.isEmpty()){
            for (string s:selectFields){
                selects += s + ',';
            }
            if (selects.endsWith(',')){selects = selects.substring(0,selects.lastIndexOf(','));}    
        }
        if(standardFields != null){
            selects = standardFields + ', '+ selects;
        }
        if(String.isNotBlank(whereClause)){
            return 'SELECT '+ selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
        }else{
            return 'SELECT '+ selects + ' FROM ' + objectName;
        }
    }


    public static String getIdAvaloq(String code){
        String sol ='';
        if(String.isNotBlank(code) && code.contains('_')){
            String[] parts = code.split('_');
            String idAvaloq = parts[1];
            if(String.isNotBlank(idAvaloq))
                sol = idAvaloq;
        } 
        return sol;
    }

    public static String getBUAvaloq(String code){
        String sol ='';
        if(String.isNotBlank(code) && code.contains('_')){
            String[] parts = code.split('_');
            String idAvaloq = parts[0];
            if(String.isNotBlank(idAvaloq))
                sol = idAvaloq;
        } 
        return sol;
    }

    public static String getUserLanguage(String code){
        String lng ='';
        if(String.isNotBlank(code) && code.contains('_')){
            String[] parts = code.split('_');
            String idAvaloq = parts[0];
            if(String.isNotBlank(idAvaloq))
                lng = idAvaloq;
        } 
        return lng;
    }

    public static void insertSOs(List<SObject> lstSO){
        insert lstSO;
    }

    public static void insertSO(Sobject so){
        insert so;
    }

    public static void updateSO(Sobject so){
        update so;
    }

    public static void updateSOs(List<SObject> lstSO){
        update lstSO;
    }
    
    public static void upsertSO(Sobject so){
        upsert so;
    }

    public static void deleteSOs(List<SObject> lstSO){
        delete lstSO;
    }
    
    public static Database.SaveResult[] DBinsertIPL(List<CRAN_VEC_ADV_Investment_Proposition_Line__c> lstIPL){
        return Database.insert(lstIPL, false);
    }

    public static Date stringDateTimeToDate(String value,String format){
        List<String> lstValueDT = value.split(' ');
        return stringToDate(lstValueDT[0],format);
    }

    public static Date stringToDate(String value){
        List<String> lstValueDT = value.split(' ');
        List<String> lstStringD;
        List<String> lstStringT;

        lstStringD = lstValueDT[0].split('-');
        Date d = Date.newinstance(Integer.valueOf(lstStringD[2]),Integer.valueOf(lstStringD[1]),Integer.valueOf(lstStringD[0]));

        return d;
    }
    

    public static Date stringToDate(String value,String format){
        Date d; 
        List<String> lstStringD;
        if(format=='dd/MM/yyyy'){
            lstStringD = value.split('/');
            d = Date.newinstance(Integer.valueOf(lstStringD[2]),Integer.valueOf(lstStringD[1]),Integer.valueOf(lstStringD[0]));
        }else if(format=='dd-MM-yyyy'){
            lstStringD = value.split('-');
            d = Date.newinstance(Integer.valueOf(lstStringD[2]),Integer.valueOf(lstStringD[1]),Integer.valueOf(lstStringD[0]));
        }else if(format=='MM-dd-yyyy'){
            lstStringD = value.split('-');
            d = Date.newinstance(Integer.valueOf(lstStringD[2]),Integer.valueOf(lstStringD[0]),Integer.valueOf(lstStringD[1]));
        }else if(format=='MM/dd/yyyy'){
            lstStringD = value.split('/');
            d = Date.newinstance(Integer.valueOf(lstStringD[2]),Integer.valueOf(lstStringD[0]),Integer.valueOf(lstStringD[1]));
        }else if(format=='yyyy-MM-dd'){
            d = Date.valueOf(value);
        }else{
            throw new CRAN_VEC_ADV_UtilException('stringToDate format "' + format + '" is not defined');
        }
        return d;
    }

    public static Time stringToTime(String value,String format){
        List<String> lstStringT;
        Integer miliSeconds = 0;
        if(format=='HH:mm:ss'){
            lstStringT = value.split(':');
        }else if(format=='HH.mm.ss'){
            lstStringT = value.split('.');
        }else if(format=='HHmmss'){
            value = 'HH:mm:ss';
            lstStringT = value.split(':');
        }else{
            throw new CRAN_VEC_ADV_UtilException('stringToTime format "' + format + '" is not defined');
        }
        return  Time.newInstance(Integer.valueOf(lstStringT[0]), Integer.valueOf(lstStringT[1]), Integer.valueOf(lstStringT[2]), Integer.valueOf(miliSeconds));
    }

    public static Datetime stringToDatetime(String value,String format){
        Datetime dt; 
        List<String> lstValueDT;
        List<String> lstFormatDT;
        if( format.startsWith('dd/MM/yyyy ')  || format.startsWith('dd-MM-yyyy ') || 
            format.startsWith('MM-dd-yyyy ')  || format.startsWith('MM/dd/yyyy ')){
            lstValueDT = value.split(' ');
            lstFormatDT = value.split(' ');
            Date d = stringToDate(lstValueDT[0],lstFormatDT[0]);
            Time t = stringToTime(lstValueDT[1],lstFormatDT[1]);
            dt = Datetime.newInstanceGmt(d,t);
        }else if( format.startsWith('dd/MM/yyyyT')  || format.startsWith('dd-MM-yyyyT') || 
            format.startsWith('MM-dd-yyyyT')  || format.startsWith('MM/dd/yyyyT')){
            lstValueDT = value.split('T');
            lstFormatDT = value.split('T');
            Date d = stringToDate(lstValueDT[0],lstFormatDT[0]);
            Time t = stringToTime(lstValueDT[1],lstValueDT[1]);
            dt = Datetime.newInstanceGmt(d,t);
        }else if(format=='yyyy-MM-dd HH:mm:ss'){
            dt = Datetime.valueOf(value);
        }else if(format=='yyyy-MM-ddTHH:mm:ss'){
            dt = Datetime.valueOf(value.replace('T', ' '));
        }else{
            throw new CRAN_VEC_ADV_UtilException('stringToDatetime format "' + format  + '" is not defined');
        }
        return dt;
    }

	public static String formatNumber (String sNumber, Integer scale) {
		// Utiliza un número para obtener los separadores de miles y decimales
		// en el formato del usuario.
        Decimal value = 1000.10;
		String formattedValue = value.format();
        String thousandSep = formattedValue.substring(1,2);
		String decimalSep = formattedValue.substring(5,6);
		
        String sEntero = sNumber;
		String nConvert = '';
		String cadena = '';
		String pDec = '';
        String neg = '';
        
		if ( scale > 0  ) {
			Decimal fNumber = decimal.valueOf(sNumber);
			fNumber = fNumber.setScale(2, RoundingMode.HALF_UP);			
			String myLabel = String.valueOf(fNumber);
			pDec = myLabel.Substring(myLabel.length()-2,myLabel.length());
			Integer entero = (integer)fNumber;			
			sEntero = String.valueOf(entero);
        } else {
            decimalSep = '';
        }
        if ( sEntero.Substring(0,1)=='-' ) {   // Si el número es negativo
            sEntero = sEntero.Substring(1,sEntero.length());
            neg = '-';
        }
        
		for (integer i=sEntero.length(); i>=1 ; i--) {
			nConvert = sEntero.Substring(sEntero.length()-i,sEntero.length()-i+1);        
			if ( math.mod(i,3) == 0 ) {
                cadena += thousandSep;
            }
			cadena += nConvert;
		}
		if ( cadena.Substring(0,1)==thousandSep ) {  // Si se ha colado una coma a la izquierda
			cadena = cadena.Substring(1,cadena.length());
		}
        cadena += decimalSep + pDec;
        cadena = neg + cadena;
		return cadena;		
    }
    
    public static String formatDateForList (String sField) {
        String myLabel = sField.left(10);   // yyyy-mm-dd ss:ss:ss        
        String yy = myLabel.left(4);
        String mm = myLabel.substring(5,7);
        String dd = myLabel.substring(8,10);
        return dd + '/' + mm + '/' + yy;    // dd/mm/yyyy
    }
        
    public static String getAllErrorsServiceUlList(List<CRAN_VEC_ADV_ProcessSTError_CLS> errors){
        String solError ='';
        if(errors.size()==1){
             solError += errors[0].getCode()+' - '+errors[0].getDesc();
        }else{
            for(CRAN_VEC_ADV_ProcessSTError_CLS error: errors){
            solError += '<li type=disc>'+error.getCode()+' - '+error.getDesc() +'\n'+'</li>';
            }
        }
        return '<ul>'+solError+'</ul>';
    }

    public static String getAllErrorsService(List<CRAN_VEC_ADV_ProcessSTError_CLS> errors){
        String solError ='';
        if(errors.size()==1){
             solError += errors[0].getCode()+' - '+errors[0].getDesc();
        }else{
            for(CRAN_VEC_ADV_ProcessSTError_CLS error: errors){
            solError += error.getCode()+' - '+error.getDesc() +'\n';
            }
        }
        return solError;
    }


    /**
     * GetRelatedBpsFromContactID 
     * Se seleccionan todos los BPs relacionados con el Person.
     * Para ello se selecciona todos los Primary Owner de los financial account que esten relacionados con el person (Contact)
     * a traves del financial account role en los que el person sea 
     * "Account Owner" - código 1, "Apoderado" - código 1005, "Tutor" -código ]
     * 
     * @param   contactId 
     * @return  List FinServ__FinancialAccountRole__c
     * @author  jgonzalezg (Vector ITC Group)
     */
    public static List<FinServ__FinancialAccountRole__c> getRelatedBpsFromContactID(Id contactId){

        //Cambiado 12/05/2017
        //(FinServ__Role__c = '1' OR FinServ__Role__c = '1005' OR FinServ__Role__c = '1012')

        List<FinServ__FinancialAccountRole__c> lstFAR =  [SELECT 
                                                                Id,
                                                                Name,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Name,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Id,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__c,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_T_BPId__c,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_P_Bunit__c,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.AccountNumber
                                                        FROM FinServ__FinancialAccountRole__c
                                                        WHERE FinServ__RelatedContact__c = :contactId
                                                        AND  FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_B_AdvAccount__c = false
                                                        AND  FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_B_ULK__c = false
                                                        AND  FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_B_eCreditAdvised__c = false
                                                        AND  FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_P_MngdAccount__c = null
                                                        AND FinServ__Role__c = '1'
                                                        AND FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_T_BPId__c != null
                                                        AND FinServ__FinancialAccount__r.FinServ__PrimaryOwner__c != null];
                                                        
        return lstFAR;
    }

    /**
     * getRelatedBpsFromContactIDRenovate 
     * Se seleccionan todos los BPs relacionados con el Person.
     * Para ello se selecciona todos los Primary Owner de los financial account que esten relacionados con el person (Contact)
     * a traves del financial account role en los que el person sea 
     * "Account Owner" - código 1, "Apoderado" - código 1005, "Tutor" -código ]
     * 
     * @param   contactId 
     * @return  List FinServ__FinancialAccountRole__c
     * @author  jgonzalezg (Vector ITC Group)
     */
    public static List<FinServ__FinancialAccountRole__c> getRelatedBpsFromContactIDRenovate(Id contactId){

        List<FinServ__FinancialAccountRole__c> lstFAR =  [SELECT 
                                                                Id,
                                                                Name,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Name,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Id,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__c,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_T_BPId__c,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_P_Bunit__c,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.AccountNumber
                                                        FROM FinServ__FinancialAccountRole__c
                                                        WHERE FinServ__RelatedContact__c = :contactId
                                                        AND  FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_B_AdvAccount__c = true
                                                        AND  FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_B_ULK__c = false
                                                        AND  FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_B_eCreditAdvised__c = false
                                                        AND  FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_P_MngdAccount__c = null
                                                        AND FinServ__Role__c = '1'
                                                        AND FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_T_BPId__c != null
                                                        AND FinServ__FinancialAccount__r.FinServ__PrimaryOwner__c != null];
                                                        
        return lstFAR;
    }

    /**
     * getRelatedBpsFromContactIDPortfolio
     * Version para portfolio no incluye roles '1005' ni '1012'
     * @param  contactId 
     * @return  List FinServ__FinancialAccountRole__c
     */
    public static List<FinServ__FinancialAccountRole__c> getRelatedBpsFromContactIDPortfolio(Id contactId){
        List<FinServ__FinancialAccountRole__c> lstFAR =  [SELECT 
                                                                Id,
                                                                Name,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Name,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Id,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__c,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_T_BPId__c,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_P_Bunit__c,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.AccountNumber
                                                        FROM FinServ__FinancialAccountRole__c
                                                        WHERE FinServ__RelatedContact__c = :contactId
                                                        AND (FinServ__EndDate__c = null OR FinServ__EndDate__c>TODAY)
                                                        AND (FinServ__Role__c = '1')
                                                        AND FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_T_BPId__c != null
                                                        AND FinServ__FinancialAccount__r.FinServ__PrimaryOwner__c != null];
        return lstFAR;
    }

    /**
     * getRelatedBpsFromContactIDConvert
     * Version para servicio SfNewQuest, recupera solo las cuentas que no son de Advisory (CRAN_VEC_ADV_B_AdvAccount__c = false)
     * @param  contactId
     * @return  List FinServ__FinancialAccountRole__c
     */
    public static List<FinServ__FinancialAccountRole__c> getRelatedBpsFromContactIDConvert(Id contactId){
        List<FinServ__FinancialAccountRole__c> lstFAR =  [SELECT 
                                                                Id,
                                                                Name,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Name,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Id,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__c,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_T_BPId__c,
                                                                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_P_Bunit__c
                                                        FROM FinServ__FinancialAccountRole__c
                                                        WHERE FinServ__RelatedContact__c = :contactId
                                                        AND  FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_B_AdvAccount__c = false
                                                        AND (FinServ__Role__c = '1' OR FinServ__Role__c = '1005' OR FinServ__Role__c = '1012')
                                                        AND FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_T_BPId__c != null
                                                        AND FinServ__FinancialAccount__r.FinServ__PrimaryOwner__c != null];

        return lstFAR;
    }



    public static List<CRAN_VEC_ADV_Investment_Proposition_Line__c> recorreArbol(List<CRAN_VEC_ADV_CalcRebalpNodeListRS> nodeList, integer nivel, List<CRAN_VEC_ADV_Investment_Proposition_Line__c> myMap) {
        System.debug('recorreArbol');
        for (CRAN_VEC_ADV_CalcRebalpNodeListRS element : nodeList) {
            if (element != null && element.getNodeDet() != null) {
                System.debug(element.getNodeDet().getName() + ' nivel ' + nivel);
                List<CRAN_VEC_ADV_Investment_Proposition_Line__c> temp3;

                if (element.getNodeDet().getNodeId().getNodeType().equals('node')) {
                    myMap.add(new CRAN_VEC_ADV_Investment_Proposition_Line__c(Name = CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getName(),80),CRAN_VEC_ADV_T_Rating__c = CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRat(),255),CRAN_VEC_ADV_P_Currency__c = element.getNodeDet().getCurry(),CRAN_VEC_ADV_N_Price__c = element.getNodeDet().getPrice(), CRAN_VEC_ADV_T_NodeId__c = element.getNodeDet().getNodeId().getValue() , CRAN_VEC_ADV_N_PropAccrual__c = element.getNodeDet().getCpfAccr() , CRAN_VEC_ADV_N_MPF__c = element.getNodeDet().getMpfPerc(), CRAN_VEC_ADV_N_PercentQtty__c = element.getNodeDet().getCpfPerc(), CRAN_VEC_ADV_N_PropMktValue__c = element.getNodeDet().getCpfMktVal(), CRAN_VEC_ADV_P_nodeType__c = 'node', CRAN_VEC_ADV_T_Remark__c = CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRemark(),255), CRAN_VEC_ADV_N_PortfolioQtty__c = element.getNodeDet().getSpfQty(), CRAN_VEC_ADV_N_PropQtty__c = element.getNodeDet().getCpfqty(),CRAN_VEC_ADV_P_ChangedField__c = 'Null', CRAN_VEC_ADV_N_Level__c = nivel,CRAN_VEC_ADV_T_RestrInfo__c= CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRestrInfo(),255),CRAN_VEC_ADV_T_RestrIcon__c = element.getNodeDet().getRestrIcon()));

                } else if (element.getNodeDet().getNodeId().getNodeType().equals('pos')) {
                    myMap.add(new CRAN_VEC_ADV_Investment_Proposition_Line__c(Name = CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getName(),80),CRAN_VEC_ADV_P_PFMMktCat__c = element.getNodeDet().getPfmMarketCatId(),CRAN_VEC_ADV_T_Rating__c = CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRat(),255),CRAN_VEC_ADV_N_Price__c = element.getNodeDet().getPrice(),CRAN_VEC_ADV_N_PropAccrual__c = element.getNodeDet().getCpfAccr(), CRAN_VEC_ADV_N_MPF__c = element.getNodeDet().getMpfPerc(),CRAN_VEC_ADV_B_isEdit__c = element.getNodeDet().getIsEdit(), CRAN_VEC_ADV_T_RestrIcon__c = element.getNodeDet().getRestrIcon(), CRAN_VEC_ADV_T_RestrInfo__c = CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRestrInfo(),255), CRAN_VEC_ADV_T_NodeId__c = element.getNodeDet().getNodeId().getValue(), CRAN_VEC_ADV_T_Key__c = element.getNodeDet().getAssetBuId() + '_' + element.getNodeDet().getAssetId(), CRAN_VEC_ADV_P_Currency__c =  element.getNodeDet().getCurry(), CRAN_VEC_ADV_B_Extl__c = element.getNodeDet().getExtl(), CRAN_VEC_ADV_B_AggrPosition__c = element.getNodeDet().getAggrPos(), CRAN_VEC_ADV_N_PercentQtty__c = element.getNodeDet().getSpfPerc(), CRAN_VEC_ADV_N_PropQtty__c = element.getNodeDet().getCpfqty(), CRAN_VEC_ADV_N_PropMktValue__c = element.getNodeDet().getCpfMktVal(), CRAN_VEC_ADV_L_Assets__r = new FinServ__Securities__c(FinServ__SourceSystemId__c = element.getNodeDet().getAssetBuId() + '_' + element.getNodeDet().getAssetId()), CRAN_VEC_ADV_P_nodeType__c = 'pos', CRAN_VEC_ADV_T_Remark__c = CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRemark(),255), CRAN_VEC_ADV_N_PropMktValueBK__c = element.getNodeDet().getCpfMktVal(),CRAN_VEC_ADV_N_PropMktValueBKK__c = element.getNodeDet().getCpfMktVal(), CRAN_VEC_ADV_N_PropQttyBK__c = element.getNodeDet().getCpfqty(),CRAN_VEC_ADV_N_PropQttyBKK__c = element.getNodeDet().getCpfqty(), CRAN_VEC_ADV_N_PercentQttyBK__c = element.getNodeDet().getSpfPerc(),CRAN_VEC_ADV_N_PercentQttyBKK__c = element.getNodeDet().getSpfPerc(), CRAN_VEC_ADV_T_RemarkBK__c = CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRemark(),255),CRAN_VEC_ADV_T_RemarkBKK__c = CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRemark(),255), CRAN_VEC_ADV_P_ChangedField__c = 'Null', CRAN_VEC_ADV_N_Level__c = nivel,CRAN_VEC_ADV_N_PortfolioQtty__c = element.getNodeDet().getSpfQty()));
                }

            }

            if (element != null && element.getNodeList() != null) {
                recorreArbol(element.getNodeList(), nivel + 1, myMap);
            }
        }

        return myMap;
    }
    

    //Return mock response body for each service
    public static String getMockBody(String service){
        //'{\"service\":\"'+service+'\",\"content\":\"{}\"}';
        if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_CALCULAR)){
            return '{"profileType":"mdb$mifid_dflt$r_eq","profileText":"Equilibrado","avisos":null,"errors":null}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_CREAR_NUEVO)){
            return '{"order":{"orderNr":548922012,"isNew":true},"objList":[{"objType":"bp","obj":[{"avqId":9397924,"keyList":[{"keyType":"sort_nr","value":"1202335"}]}]}],"errors":null}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_CREAR_ORDER_MODIFICACION)){
            return '{"order":{"orderNr":548915527,"new":false},"errors":null}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_DESCARTAR_ORDEN)){
             return '{\"service\":\"'+service+'\",\"content\":\"{\\"orderList\\":[{\\"orderNr\\":548921852,\\"isNew\\":false}],\\"errors\\":[{\\"code\\":\\"sf_999009\\",\\"descError\\":\\"548921333 - \\"}]}\"}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_PORTFOLIO)){
            return '{"porfGrandTotal":{"currValNoAccr ":1040314.57,"currVal ":1040314.57,"allocParent ":100.0,"bp ":[{"id ":606592,"name ":"HOTEL Girón S.L.","currValNoAccr ":1040314.57,"currVal ":1040314.57,"allocParent ":100.0,"containers ":[{"id ":836225,"type ":"Servei oficina ","name ":"Advisory - (C00038) - HOTEL Girón S.L.","currValNoAccr ":990314.57,"currVal ":990314.57,"allocParent ":95.19,"categoriesLv1 ":[{"id ":504000,"name ":"Cash and Money Market ","currValNoAccr ":990314.57,"currVal ":990314.57,"allocParent ":100.0,"categoriesLv2 ":[{"id ":504001,"name ":"Cash accounts and mmkt ","currValNoAccr ":990314.57,"currVal ":990314.57,"allocParent ":100.0,"categoriesLv3 ":[{"id ":504002,"name ":"Cash accounts and mmkt EUR ","currValNoAccr ":5106.52,"currVal ":5106.52,"allocParent ":0.52,"positions ":[{"id ":1045119,"name ":"Cuenta corriente - EUR - AD2700031101101207510101 ","percVar ":"0.00 ","quantity ":5106.52,"curry ":"EUR ","pSafeKeep ":null,"quantity2 ":null,"currPrice ":null,"currValAssetCcy ":5106.52,"histPrice ":1.0,"qtyHistPrice ":5106.52,"histXrate ":null,"currXrate ":null,"currValNoAccr ":5106.52,"ytm ":null,"currVal ":5106.52,"allocParent ":100.0,"assets ":[{"assetBU ":"9 ","assetID ":32907,"isin ":null,"cranCode ":"874951 ","buID ":"9 "}],"iban ":"AD2700031101101207510101 "}]},{"id ":504003,"name ":"Cash accounts and mmkt USD ","currValNoAccr ":418025.25,"currVal ":418025.25,"allocParent ":42.21,"positions ":[{"id ":9791768,"name ":"Cuenta corriente - USD - AD7000031101101207510103 ","percVar ":"0.00 ","quantity ":500000.0,"curry ":"USD ","pSafeKeep ":null,"quantity2 ":null,"currPrice ":null,"currValAssetCcy ":500000.0,"histPrice ":1.0,"qtyHistPrice ":500000.0,"histXrate ":1.1961,"currXrate ":1.1961,"currValNoAccr ":418025.25,"ytm ":null,"currVal ":418025.25,"allocParent ":100.0,"assets ":[{"assetBU ":"9 ","assetID ":32928,"isin ":null,"cranCode ":"874969 ","buID ":"9 "}],"iban ":"AD7000031101101207510103 "}]},{"id ":504005,"name ":"Cash accounts and mmkt GBP ","currValNoAccr ":567182.8,"currVal ":567182.8,"allocParent ":57.27,"positions ":[{"id ":9791769,"name ":"Cuenta corriente - GBP - AD4300031101101207510104 ","percVar ":"0.00 ","quantity ":500000.0,"curry ":"GBP ","pSafeKeep ":null,"quantity2 ":null,"currPrice ":null,"currValAssetCcy ":500000.0,"histPrice ":1.0,"qtyHistPrice ":500000.0,"histXrate ":0.88155,"currXrate ":0.88155,"currValNoAccr ":567182.8,"ytm ":null,"currVal ":567182.8,"allocParent ":100.0,"assets ":[{"assetBU ":"9 ","assetID ":32962,"isin ":null,"cranCode ":"874994 ","buID ":"9 "}],"iban ":"AD4300031101101207510104 "}]}]}]}]},{"id ":9791634,"type ":"Servei oficina ","name ":"Advisory - HOTEL Girón S.L.","currValNoAccr ":50000.0,"currVal ":50000.0,"allocParent ":4.81,"categoriesLv1 ":[{"id ":504000,"name ":"Cash and Money Market ","currValNoAccr ":50000.0,"currVal ":50000.0,"allocParent ":100.0,"categoriesLv2 ":[{"id ":504001,"name ":"Cash accounts and mmkt ","currValNoAccr ":50000.0,"currVal ":50000.0,"allocParent ":100.0,"categoriesLv3 ":[{"id ":504002,"name ":"Cash accounts and mmkt EUR ","currValNoAccr ":50000.0,"currVal ":50000.0,"allocParent ":100.0,"positions ":[{"id ":9791636,"name ":"Cuenta corriente Asesoramiento - EUR - AD1600031101101207510202 ","percVar ":"0.00 ","quantity ":50000.0,"curry ":"EUR ","pSafeKeep ":null,"quantity2 ":null,"currPrice ":null,"currValAssetCcy ":50000.0,"histPrice ":1.0,"qtyHistPrice ":50000.0,"histXrate ":null,"currXrate ":null,"currValNoAccr ":50000.0,"ytm ":null,"currVal ":50000.0,"allocParent ":100.0,"assets ":[{"assetBU ":"9 ","assetID ":8924230,"isin ":null,"cranCode ":null,"buID ":"9 "}],"iban ":"AD1600031101101207510202 "}]}]}]}]}]}]},"errors ":null}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_RECUPERAR_CUESTIONARIOS)){
            return '{"objList":[{"objType":"questr","obj":[{"avqId":5473887,"date":"19-12-2019 00:00:00","type":"mdb$mifid","version":"mdb$mifid_dflt_v1","status":null}]}],"errors":null}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_VERIFICAR)){
              return '{"objList":[{"objType":"questr","obj":[{"avqId":9398393}]}],"errors":null}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_PDF) || service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_IP) ||
                service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_ARCHIVE_DOC) || service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_GET_OMS_DOC)){
                return 'JVBERi0xLjQKJcfsj6IKNCAwIG9iago8PC9MaW5lYXJpemVkIDEvTCAxMzk0Ny9IWyAxMTQ4NyAxMzhdL08gNi9FIDExNDg3L04gMS9UIDEzODI2Pj4KZW5kb2JqCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAp4cmVmCjQgMTMKMDAwMDAwMDAxNSAwMDAwMCBuIAowMDAwMDAwNTY4IDAwMDAwIG4gCjAwMDAwMDA2ODEgMDAwMDAgbiAKMDAwMDAwMDg0MSAwMDAwMCBuIAowMDAwMDAxMTk2IDAwMDAwIG4gCjAwMDAwMDEyMTUgMDAwMDAgbiAKMDAwMDAwMTI1NiAwMDAwMCBuIAowMDAwMDAxNDc4IDAwMDAwIG4gCjAwMDAwMDE2NzUgMDAwMDAgbiAKMDAwMDAwMTcwNSAwMDAwMCBuIAowMDAwMDAxNzM2IDAwMDAwIG4gCjAwMDAwMTExNTIgMDAwMDAgbiAKMDAwMDAxMTQ4NyAwMDAwMCBuIAoKdHJhaWxlcgo8PC9TaXplIDE3L0luZm8gMSAwIFIvUm9vdCA1IDAgUi9JRFs8RkYzNDk3ODk2RDBBRkEyMkUwOTA3MzNDRUQ0MzZFMTQ+PEZGMzQ5Nzg5NkQwQUZBMjJFMDkwNzMzQ0VENDM2RTE0Pl0vUHJldiAxMzgxOD4+CnN0YXJ0eHJlZg0KMAolJUVPRgogICAgCjUgMCBvYmoKPDwvVHlwZSAvQ2F0YWxvZyAvUGFnZXMgMiAwIFIKL1BhZ2VMYXlvdXQvU2luZ2xlUGFnZQovUGFnZU1vZGUvVXNlTm9uZQovUGFnZSAxCi9NZXRhZGF0YSAzIDAgUgo+PgplbmRvYmoKNiAwIG9iago8PC9UeXBlL1BhZ2UvTWVkaWFCb3ggWzAgMCA1OTUgODQyXQovUm90YXRlIDAvUGFyZW50IDIgMCBSCi9SZXNvdXJjZXM8PC9Qcm9jU2V0Wy9QREYgL1RleHRdCi9FeHRHU3RhdGUgMTIgMCBSCi9Gb250IDEzIDAgUgo+PgovQ29udGVudHMgNyAwIFIKPj4KZW5kb2JqCjcgMCBvYmoKPDwvTGVuZ3RoIDggMCBSL0ZpbHRlciAvRmxhdGVEZWNvZGU+PgpzdHJlYW0KeJxVUDtP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MDByXDAwMCBcMDAwMlwwMDAuXDAwMDNcMDAwLlwwMDAwXDAwMC5cMDAwMVwwMDAwXDAwMDMpCi9DcmVhdGlvbkRhdGUoRDoyMDE3MTAzMTE2MDIzNyswMScwMCcpCi9Nb2REYXRlKEQ6MjAxNzEwMzExNjAyMzcrMDEnMDAnKQovVGl0bGUoXDM3NlwzNzdcMDAwRFwwMDBvXDAwMGNcMDAwdVwwMDBtXDAwMGVcMDAwblwwMDB0XDAwMG9cMDAwMSkKL0F1dGhvcihcMzc2XDM3N1wwMDBqXDAwMGpcMDAwdlwwMDBlXDAwMGxcMDAwYVwwMDBzXDAwMGNcMDAwb1wwMDBnKQovU3ViamVjdCgpCi9LZXl3b3JkcygpCi9DcmVhdG9yKFwzNzZcMzc3XDAwMFBcMDAwRFwwMDBGXDAwMENcMDAwclwwMDBlXDAwMGFcMDAwdFwwMDBvXDAwMHJcMDAwIFwwMDAyXDAwMC5cMDAwM1wwMDAuXDAwMDBcMDAwLlwwMDAxXDAwMDBcMDAwMyk+PmVuZG9iagoyIDAgb2JqCjw8IC9UeXBlIC9QYWdlcyAvS2lkcyBbCjYgMCBSCl0gL0NvdW50IDEKPj4KZW5kb2JqCjMgMCBvYmoKPDwvVHlwZS9NZXRhZGF0YQovU3VidHlwZS9YTUwvTGVuZ3RoIDE1NzA+PnN0cmVhbQo8P3hwYWNrZXQgYmVnaW49J++7vycgaWQ9J1c1TTBNcENlaGlIenJlU3pOVGN6a2M5ZCc/Pgo8P2Fkb2JlLXhhcC1maWx0ZXJzIGVzYz0iQ1JMRiI/Pgo8eDp4bXBtZXRhIHhtbG5zOng9J2Fkb2JlOm5zOm1ldGEvJyB4OnhtcHRrPSdYTVAgdG9vbGtpdCAyLjkuMS0xMywgZnJhbWV3b3JrIDEuNic+CjxyZGY6UkRGIHhtbG5zOnJkZj0naHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIycgeG1sbnM6aVg9J2h0dHA6Ly9ucy5hZG9iZS5jb20vaVgvMS4wLyc+CjxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSd1dWlkOjA4Mjc5MjVkLWMwYTgtMTFlNy0wMDAwLTRhMDUwYmI4NjAwZCcgeG1sbnM6cGRmPSdodHRwOi8vbnMuYWRvYmUuY29tL3BkZi8xLjMvJz48cGRmOlByb2R1Y2VyPlBERkNyZWF0b3IgMi4zLjAuMTAzPC9wZGY6UHJvZHVjZXI+CjxwZGY6S2V5d29yZHM+PC9wZGY6S2V5d29yZHM+CjwvcmRmOkRlc2NyaXB0aW9uPgo8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0ndXVpZDowODI3OTI1ZC1jMGE4LTExZTctMDAwMC00YTA1MGJiODYwMGQnIHhtbG5zOnhtcD0naHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyc+PHhtcDpNb2RpZnlEYXRlPjIwMTctMTAtMzFUMTY6MDI6MzcrMDE6MDA8L3htcDpNb2RpZnlEYXRlPgo8eG1wOkNyZWF0ZURhdGU+MjAxNy0xMC0zMVQxNjowMjozNyswMTowMDwveG1wOkNyZWF0ZURhdGU+Cjx4bXA6Q3JlYXRvclRvb2w+UERGQ3JlYXRvciAyLjMuMC4xMDM8L3htcDpDcmVhdG9yVG9vbD48L3JkZjpEZXNjcmlwdGlvbj4KPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9J3V1aWQ6MDgyNzkyNWQtYzBhOC0xMWU3LTAwMDAtNGEwNTBiYjg2MDBkJyB4bWxuczp4YXBNTT0naHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLycgeGFwTU06RG9jdW1lbnRJRD0ndXVpZDowODI3OTI1ZC1jMGE4LTExZTctMDAwMC00YTA1MGJiODYwMGQnLz4KPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9J3V1aWQ6MDgyNzkyNWQtYzBhOC0xMWU3LTAwMDAtNGEwNTBiYjg2MDBkJyB4bWxuczpkYz0naHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8nIGRjOmZvcm1hdD0nYXBwbGljYXRpb24vcGRmJz48ZGM6dGl0bGU+PHJkZjpBbHQ+PHJkZjpsaSB4bWw6bGFuZz0neC1kZWZhdWx0Jz5Eb2N1bWVudG8xPC9yZGY6bGk+PC9yZGY6QWx0PjwvZGM6dGl0bGU+PGRjOmNyZWF0b3I+PHJkZjpTZXE+PHJkZjpsaT5qanZlbGFzY29nPC9yZGY6bGk+PC9yZGY6U2VxPjwvZGM6Y3JlYXRvcj48ZGM6ZGVzY3JpcHRpb24+PHJkZjpBbHQ+PHJkZjpsaSB4bWw6bGFuZz0neC1kZWZhdWx0Jz48L3JkZjpsaT48L3JkZjpBbHQ+PC9kYzpkZXNjcmlwdGlvbj48L3JkZjpEZXNjcmlwdGlvbj4KPC9yZGY6UkRGPgo8L3g6eG1wbWV0YT4KICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAo8P3hwYWNrZXQgZW5kPSd3Jz8+CmVuZHN0cmVhbQplbmRvYmoKeHJlZgowIDQKMDAwMDAwMDAwMCA2NTUzNSBmIAowMDAwMDExNjI1IDAwMDAwIG4gCjAwMDAwMTIxMTMgMDAwMDAgbiAKMDAwMDAxMjE3MiAwMDAwMCBuIAp0cmFpbGVyCjw8L1NpemUgND4+CnN0YXJ0eHJlZgoxNDYKJSVFT0YK';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_DESCARTAR_OPORTUNIDAD)){
            return '{"order":{"orderNr":"99485433","isNew":false},"status":"rdy_trx_gen","errors":null}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_NUEVA_OPORTUNIDAD)){
            return '{"order":{"orderNr":"99485433","isNew":true},"status":"hold","errors":null}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_FIRMA_OPORTUNIDAD)){
            return '{"order":{"orderNr":"99485433","isNew":true},"status":"rdy_trx_gen","errors":null}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_REGEN_OPORTUNIDAD)){
            return '{"order":{"orderNr":"99485433","isNew":false},"status":"rdy_trx_gen","errors":null}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_DET_OPORTUNIDAD)){
            return '{"order":{"orderNr":"99485433","isNew":false},"status":"trx_gend","errors":null}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_CLOSE_OPORTUNIDAD)){
            return '{"order":{"orderNr":"99485433","isNew":false},"status":"done","errors":null}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_CALCULAR_OPORTUNIDAD)){
            return '{"order":{"orderNr":"569495514","isNew":false},"versionList":[{"isFinal":true,"name":"FSC copia de trabajo","id":"3","invstAmount":432.0,"invstCurry":"EUR","node":{"nodeDet":{"nodeId":{"nodeType":"node","value":"35938"},"name":"MAA_1","cpfAccr":-0.02,"cpfMktVal":21921.83,"cpfPerc":100.0},"nodeList":[{"nodeDet":{"nodeId":{"nodeType":"node","value":"1176440"},"name":"Shares (0801)","cpfAccr":0.0,"cpfMktVal":0.0,"cpfPerc":0.0},"nodeList":null},{"nodeDet":{"nodeId":{"nodeType":"node","value":"1176441"},"name":"EQ funds (0802)","cpfAccr":0.0,"cpfMktVal":0.0,"cpfPerc":0.0},"nodeList":[{"nodeDet":{"nodeId":{"nodeType":"node","value":"1176442"},"name":"Fund - Exchange Trade Equity (03)","cpfAccr":0.0,"cpfMktVal":0.0,"cpfPerc":0.0},"nodeList":null},{"nodeDet":{"nodeId":{"nodeType":"node","value":"1176443"},"name":"Other Assets","cpfAccr":0.0,"cpfMktVal":0.0,"cpfPerc":0.0},"nodeList":null}]},{"nodeDet":{"nodeId":{"nodeType":"node","value":"1176444"},"name":"Private equity (12)","cpfAccr":0.0,"cpfMktVal":0.0,"cpfPerc":0.0},"nodeList":null},{"nodeDet":{"nodeId":{"nodeType":"node","value":"1176445"},"name":"Cash EQ (0101)","cpfAccr":0.0,"cpfMktVal":0.0,"cpfPerc":0.0},"nodeList":null},{"nodeDet":{"nodeId":{"nodeType":"node","value":"1176446"},"name":"Bonds and Cash FI","cpfAccr":-0.02,"cpfMktVal":4141.07,"cpfPerc":18.89,"mpfPerc":0.0},"nodeList":[{"nodeDet":{"nodeId":{"nodeType":"pos","value":"9508205"},"assetId":"9508205","assetBuId":"6","name":" ETFS SHORT GBP LONG EUR EUR 782001","cpfAccr":0.0,"cpfMktVal":494.76,"cpfPerc":2.26,"price":41.23,"curry":"EUR","cpfQty":12.0,"spfQty":12.0,"spfAccr":0.0,"spfMktVal":494.76,"spfPerc":2.26,"extl":false,"aggrPos":false,"isEdit":true},"nodeList":null},{"nodeDet":{"nodeId":{"nodeType":"pos","value":"32924"},"assetId":"32924","assetBuId":"6","name":"1010269.10412/EUR/Compte gestionat FI EUR 1010269.10412","cpfAccr":-0.02,"cpfMktVal":3646.31,"cpfPerc":16.63,"mpfPerc":0.0,"price":1.0,"curry":"EUR","cpfQty":3646.31,"spfQty":5039.3,"spfAccr":-0.02,"spfMktVal":5039.3,"spfPerc":22.99,"extl":false,"aggrPos":false,"isEdit":false},"nodeList":null},{"nodeDet":{"nodeId":{"nodeType":"pos","value":"33022"},"assetId":"33022","assetBuId":"6","name":"1010269.10414/USD/Compte gestionat FI USD 1010269.10414","cpfAccr":0.0,"cpfMktVal":0.0,"cpfPerc":0.0,"price":1.0,"curry":"USD","cpfQty":0.0,"spfQty":0.0,"spfAccr":0.0,"spfMktVal":0.0,"spfPerc":0.0,"extl":false,"aggrPos":false,"isEdit":false},"nodeList":null},{"nodeDet":{"nodeId":{"nodeType":"pos","value":"34045"},"assetId":"34045","assetBuId":"6","name":"1010269.10413/EUR/Compte de marge EUR 1010269.10413 B15","cpfAccr":0.0,"cpfMktVal":0.0,"cpfPerc":0.0,"price":1.0,"curry":"EUR","cpfQty":0.0,"spfQty":0.0,"spfAccr":0.0,"spfMktVal":0.0,"spfPerc":0.0,"extl":false,"aggrPos":false,"isEdit":false},"nodeList":null},{"nodeDet":{"nodeId":{"nodeType":"pos","value":"33383"},"assetId":"33383","assetBuId":"6","name":"1010269.10417/GBP/Compte de marge GBP 1010269.10417 B15","cpfAccr":0.0,"cpfMktVal":0.0,"cpfPerc":0.0,"price":1.0,"curry":"GBP","cpfQty":0.0,"spfQty":0.0,"spfAccr":0.0,"spfMktVal":0.0,"spfPerc":0.0,"extl":false,"aggrPos":false,"isEdit":false},"nodeList":null},{"nodeDet":{"nodeId":{"nodeType":"pos","value":"34162"},"assetId":"34162","assetBuId":"6","name":"1010269.10415/USD/Compte de marge USD 1010269.10415 B15","cpfAccr":0.0,"cpfMktVal":0.0,"cpfPerc":0.0,"price":1.0,"curry":"USD","cpfQty":0.0,"spfQty":0.0,"spfAccr":0.0,"spfMktVal":0.0,"spfPerc":0.0,"extl":false,"aggrPos":false,"isEdit":false},"nodeList":null}]},{"nodeDet":{"nodeId":{"nodeType":"node","value":"1176447"},"name":"FI funds (0902)","cpfAccr":0.0,"cpfMktVal":15070.03,"cpfPerc":68.74},"nodeList":[{"nodeDet":{"nodeId":{"nodeType":"node","value":"1176448"},"name":"Fund - Exchange Trade Bond (04)","cpfAccr":0.0,"cpfMktVal":1732.35,"cpfPerc":7.9,"mpfPerc":0.0},"nodeList":[{"nodeDet":{"nodeId":{"nodeType":"pos","value":"9223012"},"assetId":"9223012","assetBuId":"6","name":" LYX ETF BTP 10Y MTS ITBD DR EUR 10693","cpfAccr":0.0,"cpfMktVal":1172.25,"cpfPerc":5.35,"price":130.25,"curry":"EUR","cpfQty":9.0,"spfQty":9.0,"spfAccr":0.0,"spfMktVal":1172.25,"spfPerc":5.35,"extl":false,"aggrPos":false,"isEdit":true},"nodeList":null},{"nodeDet":{"nodeId":{"nodeType":"pos","value":"3237853"},"assetId":"3237853","assetBuId":"6","name":" LYXOR ETF SGI DAILY DOUBLE SHORT BUND EUR 10693","cpfAccr":0.0,"cpfMktVal":560.1,"cpfPerc":2.55,"price":37.34,"curry":"EUR","cpfQty":15.0,"spfQty":15.0,"spfAccr":0.0,"spfMktVal":560.1,"spfPerc":2.55,"extl":false,"aggrPos":false,"isEdit":true},"nodeList":null}]},{"nodeDet":{"nodeId":{"nodeType":"node","value":"1176449"},"name":"Other Assets","cpfAccr":0.0,"cpfMktVal":13337.68,"cpfPerc":60.84,"mpfPerc":60.85},"nodeList":[{"nodeDet":{"nodeId":{"nodeType":"pos","value":"55730"},"assetId":"55730","assetBuId":"6","name":" CARMIGNAC SECURITE FUND EUR CRAN01","cpfAccr":0.0,"cpfMktVal":2135.19,"cpfPerc":9.74,"mpfPerc":9.74,"price":1755.91,"curry":"EUR","cpfQty":1.22,"spfQty":1.2,"spfAccr":0.0,"spfMktVal":2098.31,"spfPerc":9.57,"extl":false,"aggrPos":false,"isEdit":true},"nodeList":null},{"nodeDet":{"nodeId":{"nodeType":"pos","value":"51224"},"assetId":"51224","assetBuId":"6","name":" CREDIINVEST SICAV FIXED INC. EUR (I) EUR CRAN01","cpfAccr":0.0,"cpfMktVal":3201.84,"cpfPerc":14.61,"mpfPerc":14.61,"price":10.8609,"curry":"EUR","cpfQty":294.8,"spfQty":288.78,"spfAccr":0.0,"spfMktVal":3136.4,"spfPerc":14.31,"extl":false,"aggrPos":false,"isEdit":true},"nodeList":null},{"nodeDet":{"nodeId":{"nodeType":"pos","value":"5655043"},"assetId":"5655043","assetBuId":"6","name":" CREDIINVEST SICAV SHORT TERM FIXED INCOME EURO i1 EUR  EUR CRAN01","cpfAccr":0.0,"cpfMktVal":1066.6,"cpfPerc":4.87,"mpfPerc":4.87,"price":10.0823,"curry":"EUR","cpfQty":105.79,"spfQty":103.68,"spfAccr":0.0,"spfMktVal":1045.36,"spfPerc":4.77,"extl":false,"aggrPos":false,"isEdit":true},"nodeList":null},{"nodeDet":{"nodeId":{"nodeType":"pos","value":"7067516"},"assetId":"7067516","assetBuId":"6","name":" EDR FINANCIAL BONDS EUR C EUR CRAN01","cpfAccr":0.0,"cpfMktVal":1066.55,"cpfPerc":4.87,"mpfPerc":4.87,"price":131.95,"curry":"EUR","cpfQty":8.08,"spfQty":8.0,"spfAccr":0.0,"spfMktVal":1055.73,"spfPerc":4.82,"extl":false,"aggrPos":false,"isEdit":true},"nodeList":null},{"nodeDet":{"nodeId":{"nodeType":"pos","value":"7439387"},"assetId":"7439387","assetBuId":"6","name":" JUPITER DYNAMIC BOND EUR DIST EUR CRAN01","cpfAccr":0.0,"cpfMktVal":2135.18,"cpfPerc":9.74,"mpfPerc":9.74,"price":11.69,"curry":"EUR","cpfQty":182.65,"spfQty":179.53,"spfAccr":0.0,"spfMktVal":2098.71,"spfPerc":9.57,"extl":false,"aggrPos":false,"isEdit":true},"nodeList":null},{"nodeDet":{"nodeId":{"nodeType":"pos","value":"3306149"},"assetId":"3306149","assetBuId":"6","name":" MUZINICH FUNDS - ENHANCED YIELD SHORT-TERM FUND EUR CRAN01","cpfAccr":0.0,"cpfMktVal":1066.57,"cpfPerc":4.87,"mpfPerc":4.87,"price":140.69,"curry":"EUR","cpfQty":7.58,"spfQty":7.45,"spfAccr":0.0,"spfMktVal":1047.86,"spfPerc":4.78,"extl":false,"aggrPos":false,"isEdit":true},"nodeList":null},{"nodeDet":{"nodeId":{"nodeType":"pos","value":"6354045"},"assetId":"6354045","assetBuId":"6","name":" SALAR FUND PLC-E3EUR EUR CRAN01","cpfAccr":0.0,"cpfMktVal":1065.97,"cpfPerc":4.86,"mpfPerc":4.87,"price":126.15,"curry":"EUR","cpfQty":8.45,"spfQty":8.25,"spfAccr":0.0,"spfMktVal":1040.74,"spfPerc":4.75,"extl":false,"aggrPos":false,"isEdit":true},"nodeList":null},{"nodeDet":{"nodeId":{"nodeType":"pos","value":"8958540"},"assetId":"8958540","assetBuId":"6","name":" UBAM GLOB HIGH YLD SOL-ACE EUR CRAN01","cpfAccr":0.0,"cpfMktVal":1599.78,"cpfPerc":7.3,"mpfPerc":7.3,"price":153.28,"curry":"EUR","cpfQty":10.44,"spfQty":10.24,"spfAccr":0.0,"spfMktVal":1570.2,"spfPerc":7.16,"extl":false,"aggrPos":false,"isEdit":true},"nodeList":null}]}]},{"nodeDet":{"nodeId":{"nodeType":"node","value":"1176450"},"name":"Cross asset investments (10)","cpfAccr":0.0,"cpfMktVal":0.0,"cpfPerc":0.0,"mpfPerc":0.0},"nodeList":null},{"nodeDet":{"nodeId":{"nodeType":"node","value":"1176451"},"name":"Hedge Funds (11)","cpfAccr":0.0,"cpfMktVal":2710.73,"cpfPerc":12.37,"mpfPerc":7.5},"nodeList":[{"nodeDet":{"nodeId":{"nodeType":"pos","value":"56615"},"assetId":"56615","assetBuId":"6","name":" CREDIT FONS GESTIO ALT. DOLAR USD 2748705.303","cpfAccr":0.0,"cpfMktVal":1335.86,"cpfPerc":6.09,"mpfPerc":6.09,"price":0.9607,"curry":"USD","cpfQty":1514.12,"spfQty":489.09,"spfAccr":0.0,"spfMktVal":431.51,"spfPerc":1.97,"extl":false,"aggrPos":false,"isEdit":true},"nodeList":null},{"nodeDet":{"nodeId":{"nodeType":"pos","value":"6249916"},"assetId":"6249916","assetBuId":"6","name":" GAMCO MERGER ARBITRAGE-A EUR EUR CRAN01","cpfAccr":0.0,"cpfMktVal":1066.59,"cpfPerc":4.87,"price":11.0861,"curry":"EUR","cpfQty":96.21,"spfQty":93.85,"spfAccr":0.0,"spfMktVal":1040.43,"spfPerc":4.75,"extl":false,"aggrPos":false,"isEdit":true},"nodeList":null},{"nodeDet":{"nodeId":{"nodeType":"pos","value":"54475"},"assetId":"54475","assetBuId":"6","name":" INVESTCREDIT VALIRA CONSERVATIVE USD (A) USD 10693","cpfAccr":0.0,"cpfMktVal":308.28,"cpfPerc":1.41,"mpfPerc":1.41,"price":0.7437,"curry":"USD","cpfQty":451.37,"spfQty":132.01,"spfAccr":0.0,"spfMktVal":90.16,"spfPerc":0.41,"extl":false,"aggrPos":false,"isEdit":true},"nodeList":null}]},{"nodeDet":{"nodeId":{"nodeType":"node","value":"1176452"},"name":"Other Assets","cpfAccr":0.0,"cpfMktVal":0.0,"cpfPerc":0.0,"mpfPerc":0.0},"nodeList":null}]},"omsId":null,"restrList":null}],"errors":null}}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_FIRMA_CONTRATO)){
            return '{"objList":{"objType":null,"obj":[{"avqId":5473887}]},"status":"trx_gend","errors":null}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_LIST_OPORTUNIDAD)){
            // original
            return '{"rebalPropList":[{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"19-04-2017 00:00:00","propOrderNr":"569496631","propDesc":null,"propInvMeth":"manual","propCurry":"EUR","propAmount":100.0,"refOrderList":[{"orderNr":"562777976","metaType":"STEX","orderType":"Compra","type":"At Market","orderStatusId":90,"orderStatus":"BO: Done","orderPrcEstim":29.6,"orderQty":1013.0,"orderTrxDate":"09-03-2017 00:00:00","apprxAmount":30220.36,"omsId":null,"assetItem":{"assetCatId":"504786","instrGroupId":"8034","assetName":"BOLSAS Y MERCADOS ESPA�OLES","isin":"ES0115056139","assetType":"Equities","assetRefCurry":"EUR"}}]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"09-05-2017 00:00:00","propOrderNr":"569496466","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":100000.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"26-04-2017 00:00:00","propOrderNr":"569485792","propDesc":null,"propInvMeth":"manual","propCurry":"EUR","propAmount":3333333.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"26-04-2017 00:00:00","propOrderNr":"569485778","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":88766.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"26-04-2017 00:00:00","propOrderNr":"569485765","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":3645.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"26-04-2017 00:00:00","propOrderNr":"569485761","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":3645.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"26-04-2017 00:00:00","propOrderNr":"569485738","propDesc":null,"propInvMeth":"manual","propCurry":"EUR","propAmount":7897777.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"26-04-2017 00:00:00","propOrderNr":"569485737","propDesc":null,"propInvMeth":"manual","propCurry":"EUR","propAmount":787878.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"26-04-2017 00:00:00","propOrderNr":"569485736","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":324.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"26-04-2017 00:00:00","propOrderNr":"569485735","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":20000.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"26-04-2017 00:00:00","propOrderNr":"569485734","propDesc":null,"propInvMeth":"manual","propCurry":"EUR","propAmount":10000.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"26-04-2017 00:00:00","propOrderNr":"569485733","propDesc":null,"propInvMeth":"manual","propCurry":"EUR","propAmount":236.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"26-04-2017 00:00:00","propOrderNr":"569485580","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":2357.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"26-04-2017 00:00:00","propOrderNr":"569485386","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":6.5416515E7,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"91","propStatus":"Discarded","propDate":"24-04-2017 00:00:00","propOrderNr":"569481759","propDesc":null,"propInvMeth":"manual","propCurry":"EUR","propAmount":250000.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"25-04-2017 00:00:00","propOrderNr":"569482105","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":15000.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"25-04-2017 00:00:00","propOrderNr":"569482066","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":1500000.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"24-04-2017 00:00:00","propOrderNr":"569482065","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":150000.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"91","propStatus":"Discarded","propDate":"24-04-2017 00:00:00","propOrderNr":"569482032","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":4324.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"91","propStatus":"Discarded","propDate":"24-04-2017 00:00:00","propOrderNr":"569481700","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":550000.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"90","propStatus":"Hold","propDate":"24-04-2017 00:00:00","propOrderNr":"569481392","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":2.5E7,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"90","propStatus":"Hold","propDate":"24-04-2017 00:00:00","propOrderNr":"569481711","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":23500.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"90","propStatus":"Hold","propDate":"24-04-2017 00:00:00","propOrderNr":"569481390","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":100000.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"24-04-2017 00:00:00","propOrderNr":"569481389","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":2.5E7,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"21-04-2017 00:00:00","propOrderNr":"569480832","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":34234.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"21-04-2017 00:00:00","propOrderNr":"569480828","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":3423.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"21-04-2017 00:00:00","propOrderNr":"569480823","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":45345.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"21-04-2017 00:00:00","propOrderNr":"569480820","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":111.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"21-04-2017 00:00:00","propOrderNr":"569480819","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":234.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"21-04-2017 00:00:00","propOrderNr":"569480818","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":23534.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"21-04-2017 00:00:00","propOrderNr":"569480817","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":4214.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"21-04-2017 00:00:00","propOrderNr":"569480816","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":1230000.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"21-04-2017 00:00:00","propOrderNr":"569480815","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":534.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"21-04-2017 00:00:00","propOrderNr":"569480814","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":423.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"21-04-2017 00:00:00","propOrderNr":"569480813","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":1234.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"21-04-2017 00:00:00","propOrderNr":"569480812","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":124000.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"21-04-2017 00:00:00","propOrderNr":"569480811","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":232.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"21-04-2017 00:00:00","propOrderNr":"569480777","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":1250000.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"21-04-2017 00:00:00","propOrderNr":"569480768","propDesc":null,"propInvMeth":"manual","propCurry":null,"propAmount":null,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"21-04-2017 00:00:00","propOrderNr":"569480762","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":1200000.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"21-04-2017 00:00:00","propOrderNr":"569480719","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":1.5E7,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"21-04-2017 00:00:00","propOrderNr":"569480718","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":1000900.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"21-04-2017 00:00:00","propOrderNr":"569480717","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":1000000.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"20-04-2017 00:00:00","propOrderNr":"569480673","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":1000.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"20-04-2017 00:00:00","propOrderNr":"569480639","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":4263475.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"20-04-2017 00:00:00","propOrderNr":"569480638","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":123.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"20-04-2017 00:00:00","propOrderNr":"569480525","propDesc":null,"propInvMeth":"manual","propCurry":"EUR","propAmount":2000000.0,"refOrderList":[]},{"bpId":"8212919","contId":"6845786","propStatusId":"50","propStatus":"Hold","propDate":"20-04-2017 00:00:00","propOrderNr":"569480476","propDesc":null,"propInvMeth":"ips","propCurry":"EUR","propAmount":1.5E7,"refOrderList":[]}],"errors":null}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_OMS_PRINT)){
            return '{"omsIdList":[{"id":"09_000785438149"}],"orderNr":564159613,"errors":null}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_WAIT_SIGN)){
            return '{"order":{"orderNr":"59485433","isNew":false},"omsId":"09_54544665464"}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_DET_OPORTUNIDAD_V2)){
           return '{ "order": { "orderNr": "577498383","personId": "347533","rolId":"1","expiryDate":"26-06-2017 00:00:00","expired":"false","isNew": null }, "versionList": [ { "name": null, "isFinal": true, "id": "2", "invstAmount": null, "invstCurry": null, "node": { "nodeDet": { "nodeId": { "nodeType": "node", "value": "9076068" }, "name": "All Assets", "cpfAccr": 0, "cpfMktVal": 2733065.39, "cpfPerc": 100, "mpfPerc": 100 }, "nodeList": [ { "nodeDet": { "nodeId": { "nodeType": "node", "value": "9076069" }, "name": "Money market", "cpfAccr": 0, "cpfMktVal": 204980.78, "cpfPerc": 7.5, "mpfPerc": 7.5 }, "nodeList": [ { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "7601210" }, "name": " BNP INSTICASH MONEY 3M-I CAP EUR CRAN01", "cpfAccr": 0, "cpfMktVal": 204979.9, "cpfPerc": 7.5, "mpfPerc": 7.5, "assetId": "7601210", "assetBuId": "6", "price": 101.0709, "curry": "EUR", "cpfQty": 2028.08, "spfQty": 0, "spfAccr": 0, "spfMktVal": 0, "spfPerc": 0, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "32907" }, "name": "1202545.10101/EUR/Compte corrent EUR 1202545.10101", "cpfAccr": 0, "cpfMktVal": 0.88, "cpfPerc": 0, "assetId": "32907", "assetBuId": "9", "price": 1, "curry": "EUR", "cpfQty": 0.88, "spfQty": 329358.1, "spfAccr": 0, "spfMktVal": 329358.1, "spfPerc": 12.05, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "32928" }, "name": "1202545.10102/USD/Compte corrent USD 1202545.10102", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "assetId": "32928", "assetBuId": "9", "price": 1, "curry": "USD", "cpfQty": 0, "spfQty": 2298.26, "spfAccr": 0, "spfMktVal": 2102.71, "spfPerc": 0.08, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null } ] }, { "nodeDet": { "nodeId": { "nodeType": "node", "value": "9076070" }, "name": "Fixed income", "cpfAccr": 0, "cpfMktVal": 1011233.46, "cpfPerc": 37, "mpfPerc": 37 }, "nodeList": [ { "nodeDet": { "nodeId": { "nodeType": "node", "value": "9113816" }, "name": "Emerging Market", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "mpfPerc": 0 }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "node", "value": "9113817" }, "name": "Other Assets", "cpfAccr": 0, "cpfMktVal": 1011233.46, "cpfPerc": 37, "mpfPerc": 37 }, "nodeList": [ { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "6574210" }, "name": " AB FCP I-AMER INC-A2 H EUR ALCAFUND", "cpfAccr": 0, "cpfMktVal": 163983.92, "cpfPerc": 6, "mpfPerc": 6, "assetId": "6574210", "assetBuId": "6", "price": 18.72, "curry": "EUR", "cpfQty": 8759.83, "spfQty": 0, "spfAccr": 0, "spfMktVal": 0, "spfPerc": 0, "extl": false, "aggrPos": false, "isEdit": true }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "6737612" }, "name": " BLACKROCK FIXED INCOME STRAT A2 EUR EUR ALCAFUND", "cpfAccr": 0, "cpfMktVal": 163983.22, "cpfPerc": 6, "mpfPerc": 6, "assetId": "6737612", "assetBuId": "6", "price": 120.39, "curry": "EUR", "cpfQty": 1362.1, "spfQty": 0, "spfAccr": 0, "spfMktVal": 0, "spfPerc": 0, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "55730" }, "name": " CARMIGNAC SECURITE FUND EUR CRAN01", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "assetId": "55730", "assetBuId": "6", "price": 1756.61, "curry": "EUR", "cpfQty": 0, "spfQty": 85.52, "spfAccr": 0, "spfMktVal": 150228.8, "spfPerc": 5.5, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "51224" }, "name": " CREDIINVEST SICAV FIXED INC. EUR (I) EUR CRAN01", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "assetId": "51224", "assetBuId": "6", "price": 10.9342, "curry": "EUR", "cpfQty": 0, "spfQty": 7000, "spfAccr": 0, "spfMktVal": 76539.4, "spfPerc": 2.8, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "7440491" }, "name": " DWS FLOATING RATE NOTES EUR CRAN01", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "assetId": "7440491", "assetBuId": "6", "price": 84.35, "curry": "EUR", "cpfQty": 0, "spfQty": 1185.96, "spfAccr": 0, "spfMktVal": 100035.57, "spfPerc": 3.66, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "6778885" }, "name": " G FUND-ALPHA FIXED INCOME-NC EUR CRAN01", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "assetId": "6778885", "assetBuId": "6", "price": 105.69, "curry": "EUR", "cpfQty": 0, "spfQty": 710, "spfAccr": 0, "spfMktVal": 75039.9, "spfPerc": 2.75, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "8949621" }, "name": " GROUPAMA INDX INFLATION M-M EUR CRAN01", "cpfAccr": 0, "cpfMktVal": 136653.21, "cpfPerc": 5, "mpfPerc": 5, "assetId": "8949621", "assetBuId": "6", "price": 150.3, "curry": "EUR", "cpfQty": 909.2, "spfQty": 460, "spfAccr": 0, "spfMktVal": 69138, "spfPerc": 2.53, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "5027686" }, "name": " JANUS CAPITAL US SHORT-TERM BOND-AEAC EUR ALCAFUND", "cpfAccr": 0, "cpfMktVal": 163983.92, "cpfPerc": 6, "mpfPerc": 6, "assetId": "5027686", "assetBuId": "6", "price": 18.22, "curry": "EUR", "cpfQty": 9000.22, "spfQty": 0, "spfAccr": 0, "spfMktVal": 0, "spfPerc": 0, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "7439387" }, "name": " JUPITER JGF DY B FD-LEUR EUR CRAN01", "cpfAccr": 0, "cpfMktVal": 81992, "cpfPerc": 3, "mpfPerc": 3, "assetId": "7439387", "assetBuId": "6", "price": 11.73, "curry": "EUR", "cpfQty": 6989.94, "spfQty": 12875.53, "spfAccr": 0, "spfMktVal": 151029.97, "spfPerc": 5.53, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "2668470" }, "name": " M&G OPTIMAL INCOME-A-EURO-A EUR CRAN01", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "assetId": "2668470", "assetBuId": "6", "price": 19.7179, "curry": "EUR", "cpfQty": 0, "spfQty": 7626.87, "spfAccr": 0, "spfMktVal": 150385.92, "spfPerc": 5.5, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "3306149" }, "name": " MUZINICH FUNDS - ENHANCED YIELD SHORT-TERM FUND EUR CRAN01", "cpfAccr": 0, "cpfMktVal": 136653.29, "cpfPerc": 5, "mpfPerc": 5, "assetId": "3306149", "assetBuId": "6", "price": 141.39, "curry": "EUR", "cpfQty": 966.5, "spfQty": 1065.19, "spfAccr": 0, "spfMktVal": 150607.07, "spfPerc": 5.51, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "8570406" }, "name": " NORDEA 1-FLEXIBLE FI-BP EUR EUR ALCAFUND", "cpfAccr": 0, "cpfMktVal": 163983.9, "cpfPerc": 6, "mpfPerc": 6, "assetId": "8570406", "assetBuId": "6", "price": 106.67, "curry": "EUR", "cpfQty": 1537.3, "spfQty": 0, "spfAccr": 0, "spfMktVal": 0, "spfPerc": 0, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "5553387" }, "name": " SALAR FUND PLC  EUR CRAN01", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "assetId": "5553387", "assetBuId": "6", "price": 143.75, "curry": "EUR", "cpfQty": 0, "spfQty": 480, "spfAccr": 0, "spfMktVal": 69000, "spfPerc": 2.52, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null } ] } ] }, { "nodeDet": { "nodeId": { "nodeType": "node", "value": "9076071" }, "name": "Equities", "cpfAccr": 0, "cpfMktVal": 1024899.47, "cpfPerc": 37.5, "mpfPerc": 37.5 }, "nodeList": [ { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "50267" }, "name": " ALKEN FUND- EUROP OPPORTUN-R EUR ALCAFUND", "cpfAccr": 0, "cpfMktVal": 163983.92, "cpfPerc": 6, "mpfPerc": 6, "assetId": "50267", "assetBuId": "6", "price": 233.52, "curry": "EUR", "cpfQty": 702.23, "spfQty": 0, "spfAccr": 0, "spfMktVal": 0, "spfPerc": 0, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "6170286" }, "name": " ALLIANZ EUROPE EQUITY GROWTH-AT H2 USD USD CRAN01", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "assetId": "6170286", "assetBuId": "6", "price": 16.36, "curry": "USD", "cpfQty": 0, "spfQty": 6800, "spfAccr": 0, "spfMktVal": 101782.25, "spfPerc": 3.72, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "5484006" }, "name": " AMUNDI INTERNATIONAL SICAV -AHE-C EUR CRAN01", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "assetId": "5484006", "assetBuId": "6", "price": 161.43, "curry": "EUR", "cpfQty": 0, "spfQty": 933.88, "spfAccr": 0, "spfMktVal": 150756.41, "spfPerc": 5.52, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "51200" }, "name": " CREDIINVEST SICAV EUROPEAN VALUE I1 EUR ALCAFUND", "cpfAccr": 0, "cpfMktVal": 109322.61, "cpfPerc": 4, "mpfPerc": 4, "assetId": "51200", "assetBuId": "6", "price": 17.8782, "curry": "EUR", "cpfQty": 6114.86, "spfQty": 0, "spfAccr": 0, "spfMktVal": 0, "spfPerc": 0, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "2932713" }, "name": " CREDIINVEST SICAV INTERNATIONAL VALUE USD HI3 USD CRAN01", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "assetId": "2932713", "assetBuId": "6", "price": 15.0582, "curry": "USD", "cpfQty": 0, "spfQty": 19034.38, "spfAccr": 0, "spfMktVal": 262235.63, "spfPerc": 9.59, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "51208" }, "name": " CREDIINVEST SICAV US AMERICAN VALUE USD ALCAFUND", "cpfAccr": 0, "cpfMktVal": 177649.25, "cpfPerc": 6.5, "mpfPerc": 6.5, "assetId": "51208", "assetBuId": "6", "price": 19.8808, "curry": "USD", "cpfQty": 9766.74, "spfQty": 0, "spfAccr": 0, "spfMktVal": 0, "spfPerc": 0, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "5153998" }, "name": " M&G GLOBAL DIVIDEND FUND EUR EUR CRAN01", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "assetId": "5153998", "assetBuId": "6", "price": 24.2078, "curry": "EUR", "cpfQty": 0, "spfQty": 4029.61, "spfAccr": 0, "spfMktVal": 97547.97, "spfPerc": 3.57, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "50121" }, "name": " MFS MERIDIAN FUND EUROPEAN VALUE EUR EUR ALCAFUND", "cpfAccr": 0, "cpfMktVal": 163983.88, "cpfPerc": 6, "mpfPerc": 6, "assetId": "50121", "assetBuId": "6", "price": 39.91, "curry": "EUR", "cpfQty": 4108.84, "spfQty": 0, "spfAccr": 0, "spfMktVal": 0, "spfPerc": 0, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "4545244" }, "name": " MORGAN STANLEY IF - US ADVANTAGE (A) USD ALCAFUND", "cpfAccr": 0, "cpfMktVal": 163983.91, "cpfPerc": 6, "mpfPerc": 6, "assetId": "4545244", "assetBuId": "6", "price": 67.92, "curry": "USD", "cpfQty": 2638.91, "spfQty": 0, "spfAccr": 0, "spfMktVal": 0, "spfPerc": 0, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "9298423" }, "name": " MP RSAM SMART MATERIAL-C EUR CRAN01", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "assetId": "9298423", "assetBuId": "6", "price": 280.46, "curry": "EUR", "cpfQty": 0, "spfQty": 100, "spfAccr": 0, "spfMktVal": 28046, "spfPerc": 1.03, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "9298274" }, "name": " PARVEST GLOBAL ENVIRONMEN-CC EUR CRAN01", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "assetId": "9298274", "assetBuId": "6", "price": 189, "curry": "EUR", "cpfQty": 0, "spfQty": 150, "spfAccr": 0, "spfMktVal": 28350, "spfPerc": 1.04, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "6386507" }, "name": " PICTET-JAPAN EQ SELECT-HP EUR EUR ALCAFUND", "cpfAccr": 0, "cpfMktVal": 109322.62, "cpfPerc": 4, "mpfPerc": 4, "assetId": "6386507", "assetBuId": "6", "price": 89.4, "curry": "EUR", "cpfQty": 1222.85, "spfQty": 0, "spfAccr": 0, "spfMktVal": 0, "spfPerc": 0, "extl": false, "aggrPos": false, "isEdit": true }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "6709295" }, "name": " ROBECO CAPITAL GROWTH -BP GLOBAL PREMIUM- USD USD CRAN01", "cpfAccr": 0, "cpfMktVal": 136653.28, "cpfPerc": 5, "mpfPerc": 5, "assetId": "6709295", "assetBuId": "6", "price": 137.5, "curry": "USD", "cpfQty": 1086.27, "spfQty": 1180, "spfAccr": 0, "spfMktVal": 148444.64, "spfPerc": 5.43, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "9229408" }, "name": " ROBO GLOBAL ROBOTICS AND AUT ETF EUR 18613", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "assetId": "9229408", "assetBuId": "6", "price": 11.74, "curry": "EUR", "cpfQty": 0, "spfQty": 2360, "spfAccr": 0, "spfMktVal": 27706.4, "spfPerc": 1.01, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "6152262" }, "name": " T.ROWE PRICE-US SML CO EQ-A USD CRAN01", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "assetId": "6152262", "assetBuId": "6", "price": 38.67, "curry": "USD", "cpfQty": 0, "spfQty": 2115, "spfAccr": 0, "spfMktVal": 74828.04, "spfPerc": 2.74, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null } ] }, { "nodeDet": { "nodeId": { "nodeType": "node", "value": "9076072" }, "name": "Mixed funds", "cpfAccr": 0, "cpfMktVal": 95657.29, "cpfPerc": 3.5, "mpfPerc": 3.5 }, "nodeList": [ { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "8028534" }, "name": " AURIGA INVESTORS - BELGRAVIA LYNX EUR CRAN01", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "assetId": "8028534", "assetBuId": "6", "price": 172.65, "curry": "EUR", "cpfQty": 0, "spfQty": 703.31, "spfAccr": 0, "spfMktVal": 121427.16, "spfPerc": 4.44, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "5465812" }, "name": " BNY MELLON GLOBAL REAL RETURN FUND EUR AA EUR ALCAFUND", "cpfAccr": 0, "cpfMktVal": 95657.29, "cpfPerc": 3.5, "mpfPerc": 3.5, "assetId": "5465812", "assetBuId": "6", "price": 1.2694, "curry": "EUR", "cpfQty": 75356.3, "spfQty": 0, "spfAccr": 0, "spfMktVal": 0, "spfPerc": 0, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "8546341" }, "name": " FLAB SICAV-SIF-FLAB CORE-H USD 10693", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "assetId": "8546341", "assetBuId": "6", "price": 132.41, "curry": "USD", "cpfQty": 0, "spfQty": 798.87, "spfAccr": 0, "spfMktVal": 96777.41, "spfPerc": 3.54, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "7817088" }, "name": " SEXTANT GRAND LARGE EUR 10693", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "assetId": "7817088", "assetBuId": "6", "price": 443.19, "curry": "EUR", "cpfQty": 0, "spfQty": 282.41, "spfAccr": 0, "spfMktVal": 125160.84, "spfPerc": 4.58, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null } ] }, { "nodeDet": { "nodeId": { "nodeType": "node", "value": "9076073" }, "name": "Alternative investments", "cpfAccr": 0, "cpfMktVal": 396294.39, "cpfPerc": 14.5, "mpfPerc": 14.5 }, "nodeList": [ { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "8195565" }, "name": " AVIVA MULTI-ST TARG RT-AEUR  EUR ALCAFUND", "cpfAccr": 0, "cpfMktVal": 204979.9, "cpfPerc": 7.5, "mpfPerc": 7.5, "assetId": "8195565", "assetBuId": "6", "price": 10.5957, "curry": "EUR", "cpfQty": 19345.57, "spfQty": 0, "spfAccr": 0, "spfMktVal": 0, "spfPerc": 0, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "6249916" }, "name": " GAMCO MERGER ARBITRAGE-A EUR EUR CRAN01", "cpfAccr": 0, "cpfMktVal": 191314.49, "cpfPerc": 7, "mpfPerc": 7, "assetId": "6249916", "assetBuId": "6", "price": 11.2589, "curry": "EUR", "cpfQty": 16992.29, "spfQty": 0, "spfAccr": 0, "spfMktVal": 0, "spfPerc": 0, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null }, { "nodeDet": { "nodeId": { "nodeType": "pos", "value": "6254967" }, "name": " GAMCO MERGER ARBITRAGE-A USD USD CRAN01", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "assetId": "6254967", "assetBuId": "6", "price": 11.4466, "curry": "USD", "cpfQty": 0, "spfQty": 13992.38, "spfAccr": 0, "spfMktVal": 146537.21, "spfPerc": 5.36, "extl": false, "aggrPos": false, "isEdit": false }, "nodeList": null } ] }, { "nodeDet": { "nodeId": { "nodeType": "node", "value": "9076075" }, "name": "Other Assets", "cpfAccr": 0, "cpfMktVal": 0, "cpfPerc": 0, "mpfPerc": 0 }, "nodeList": null } ] }, "restrList": null, "tradeList": [ { "warning": "false", "estimQty": -5885.59, "effQty": -5885.59, "assetId": 7439387, "assetBuId": 6, "assetName": "JUPITER JGF DY B FD-LEUR", "price": 11.73, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": 69037.97, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": -7000, "effQty": -7000, "assetId": 51224, "assetBuId": 6, "assetName": "CREDIINVEST SICAV FIXED INC. EUR (I)", "price": 10.93, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": 76539.4, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": -98.69, "effQty": -98.69, "assetId": 3306149, "assetBuId": 6, "assetName": "MUZINICH FUNDS - ENHANCED YIELD SHORT-TERM FUND", "price": 141.39, "curry": "EUR", "marketId": 1266200, "marketBuId": null, "marketName": "ORC PLACEMENT COLECTIVE ET VALEURS MOBILIERES", "amount": 13953.78, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": -85.52, "effQty": -85.52, "assetId": 55730, "assetBuId": 6, "assetName": "CARMIGNAC SECURITE FUND", "price": 1756.61, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": 150228.8, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": -710, "effQty": -710, "assetId": 6778885, "assetBuId": 6, "assetName": "G FUND-ALPHA FIXED INCOME-NC", "price": 105.69, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": 75039.9, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": -7626.87, "effQty": -7626.87, "assetId": 2668470, "assetBuId": 6, "assetName": "M&G OPTIMAL INCOME-A-EURO-A", "price": 19.72, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": 150385.92, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": -4029.61, "effQty": -4029.61, "assetId": 5153998, "assetBuId": 6, "assetName": "M&G GLOBAL DIVIDEND FUND EUR", "price": 24.21, "curry": "EUR", "marketId": 1173709, "marketBuId": null, "marketName": "Financial Express Prestel, EUR", "amount": 97547.97, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": -933.88, "effQty": -933.88, "assetId": 5484006, "assetBuId": 6, "assetName": "AMUNDI INTERNATIONAL SICAV -AHE-C", "price": 161.43, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": 150756.41, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": -19034.38, "effQty": -19034.38, "assetId": 2932713, "assetBuId": 6, "assetName": "CREDIINVEST SICAV INTERNATIONAL VALUE USD HI3", "price": 15.06, "curry": "USD", "marketId": 1174650, "marketBuId": null, "marketName": "FINESTI, USD", "amount": 286623.56, "cost": 0, "maccId": 9418609, "maccName": "Compte corrent USD 1202545.10102", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": -282.41, "effQty": -282.41, "assetId": 7817088, "assetBuId": 6, "assetName": "SEXTANT GRAND LARGE", "price": 443.19, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": 125160.84, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": -703.31, "effQty": -703.31, "assetId": 8028534, "assetBuId": 6, "assetName": "AURIGA INVESTORS - BELGRAVIA LYNX", "price": 172.65, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": 121427.16, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": -13992.38, "effQty": -13992.38, "assetId": 6254967, "assetBuId": 6, "assetName": "GAMCO MERGER ARBITRAGE-A USD", "price": 11.45, "curry": "USD", "marketId": 1174650, "marketBuId": null, "marketName": "FINESTI, USD", "amount": 160165.18, "cost": 0, "maccId": 9418609, "maccName": "Compte corrent USD 1202545.10102", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": -1185.96, "effQty": -1185.96, "assetId": 7440491, "assetBuId": 6, "assetName": "DWS FLOATING RATE NOTES", "price": 84.35, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": 100035.57, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": -798.87, "effQty": -798.87, "assetId": 8546341, "assetBuId": 6, "assetName": "FLAB SICAV-SIF-FLAB CORE-H", "price": 132.41, "curry": "USD", "marketId": 1174650, "marketBuId": null, "marketName": "FINESTI, USD", "amount": 105777.71, "cost": 0, "maccId": 9418609, "maccName": "Compte corrent USD 1202545.10102", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": -93.73, "effQty": -93.73, "assetId": 6709295, "assetBuId": 6, "assetName": "ROBECO CAPITAL GROWTH -BP GLOBAL PREMIUM- USD", "price": 137.5, "curry": "USD", "marketId": 1174650, "marketBuId": null, "marketName": "FINESTI, USD", "amount": 12887.96, "cost": 0, "maccId": 9418609, "maccName": "Compte corrent USD 1202545.10102", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": -2115, "effQty": -2115, "assetId": 6152262, "assetBuId": 6, "assetName": "T.ROWE PRICE-US SML CO EQ-A", "price": 38.67, "curry": "USD", "marketId": 1174650, "marketBuId": null, "marketName": "FINESTI, USD", "amount": 81787.05, "cost": 0, "maccId": 9418609, "maccName": "Compte corrent USD 1202545.10102", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": -6800, "effQty": -6800, "assetId": 6170286, "assetBuId": 6, "assetName": "ALLIANZ EUROPE EQUITY GROWTH-AT H2 USD", "price": 16.36, "curry": "USD", "marketId": 1173706, "marketBuId": null, "marketName": "Financial Express Prestel, USD", "amount": 111248, "cost": 0, "maccId": 9418609, "maccName": "Compte corrent USD 1202545.10102", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": -150, "effQty": -150, "assetId": 9298274, "assetBuId": 6, "assetName": "PARVEST GLOBAL ENVIRONMEN-CC", "price": 189, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": 28350, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": -100, "effQty": -100, "assetId": 9298423, "assetBuId": 6, "assetName": "MP RSAM SMART MATERIAL-C", "price": 280.46, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": 28046, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": -2360, "effQty": -2360, "assetId": 9229408, "assetBuId": 6, "assetName": "ROBO GLOBAL ROBOTICS AND AUT ETF", "price": 11.74, "curry": "EUR", "marketId": 1035, "marketBuId": null, "marketName": "MERCATO CONTINUO ITALIANO", "amount": 27706.4, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": -480, "effQty": -480, "assetId": 5553387, "assetBuId": 6, "assetName": "SALAR FUND PLC ", "price": 143.75, "curry": "EUR", "marketId": 1173709, "marketBuId": null, "marketName": "Financial Express Prestel, EUR", "amount": 69000, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": 449.2, "effQty": 449.2, "assetId": 8949621, "assetBuId": 6, "assetName": "GROUPAMA INDX INFLATION M-M", "price": 150.3, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": -67515.21, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": 4108.84, "effQty": 4108.84, "assetId": 50121, "assetBuId": 6, "assetName": "MFS MERIDIAN FUND EUROPEAN VALUE EUR", "price": 39.91, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": -163983.88, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": 702.23, "effQty": 702.23, "assetId": 50267, "assetBuId": 6, "assetName": "ALKEN FUND- EUROP OPPORTUN-R", "price": 233.52, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": -163983.92, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": 6114.86, "effQty": 6114.86, "assetId": 51200, "assetBuId": 6, "assetName": "CREDIINVEST SICAV EUROPEAN VALUE I1", "price": 17.88, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": -109322.61, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": 9766.74, "effQty": 9766.74, "assetId": 51208, "assetBuId": 6, "assetName": "CREDIINVEST SICAV US AMERICAN VALUE", "price": 19.88, "curry": "USD", "marketId": 1174650, "marketBuId": null, "marketName": "FINESTI, USD", "amount": -194170.64, "cost": 0, "maccId": 9418609, "maccName": "Compte corrent USD 1202545.10102", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": 2638.91, "effQty": 2638.91, "assetId": 4545244, "assetBuId": 6, "assetName": "MORGAN STANLEY IF - US ADVANTAGE (A)", "price": 67.92, "curry": "USD", "marketId": 1173706, "marketBuId": null, "marketName": "Financial Express Prestel, USD", "amount": -179234.43, "cost": 0, "maccId": 9418609, "maccName": "Compte corrent USD 1202545.10102", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": 9000.22, "effQty": 9000.22, "assetId": 5027686, "assetBuId": 6, "assetName": "JANUS CAPITAL US SHORT-TERM BOND-AEAC", "price": 18.22, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": -163983.92, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": 75356.3, "effQty": 75356.3, "assetId": 5465812, "assetBuId": 6, "assetName": "BNY MELLON GLOBAL REAL RETURN FUND EUR AA", "price": 1.27, "curry": "EUR", "marketId": 1173709, "marketBuId": null, "marketName": "Financial Express Prestel, EUR", "amount": -95657.29, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": 16992.3, "effQty": 16992.29, "assetId": 6249916, "assetBuId": 6, "assetName": "GAMCO MERGER ARBITRAGE-A EUR", "price": 11.26, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": -191314.49, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": 1222.85, "effQty": 1222.85, "assetId": 6386507, "assetBuId": 6, "assetName": "PICTET-JAPAN EQ SELECT-HP EUR", "price": 89.4, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": -109322.62, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": 8759.83, "effQty": 8759.83, "assetId": 6574210, "assetBuId": 6, "assetName": "AB FCP I-AMER INC-A2 H", "price": 18.72, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": -163983.92, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": 1362.11, "effQty": 1362.1, "assetId": 6737612, "assetBuId": 6, "assetName": "BLACKROCK FIXED INCOME STRAT A2 EUR", "price": 120.39, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": -163983.22, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": 2028.08, "effQty": 2028.08, "assetId": 7601210, "assetBuId": 6, "assetName": "BNP INSTICASH MONEY 3M-I CAP", "price": 101.07, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": -204979.9, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": 19345.57, "effQty": 19345.57, "assetId": 8195565, "assetBuId": 6, "assetName": "AVIVA MULTI-ST TARG RT-AEUR ", "price": 10.6, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": -204979.9, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false }, { "warning": "false", "estimQty": 1537.3, "effQty": 1537.3, "assetId": 8570406, "assetBuId": 6, "assetName": "NORDEA 1-FLEXIBLE FI-BP EUR", "price": 106.67, "curry": "EUR", "marketId": 1174649, "marketBuId": null, "marketName": "FINESTI, EUR", "amount": -163983.9, "cost": 0, "maccId": 9418608, "maccName": "Compte corrent EUR 1202545.10101", "mnyDrv": false, "gen": true, "extl": false, "aggrPos": false } ], "omsId": "AVAD34.CREDITANDORRA.AD::83139990", "refOrderList": [ { "orderNr": "583353394", "hasRestr": null, "metaType": "FXTR", "orderType": "Buy", "type": "AtMarket", "orderStatusId": 1400, "orderStatus": "FO:Simulated", "orderPrcEstim": 190.07, "orderLimit": null, "metaTypeId": "1", "typeId": "1", "orderTypeId": "139092", "sellAmount": null, "sellCurry": null, "buyAmount": null, "buyCurry": null, "xrateType": null, "orderQty": 6.58, "orderTrxDate": "14-06-2017 00:00:00", "apprxAmount": 1249.9, "omsId": "AVAD34.CREDITANDORRA.AD::83660613", "assetItem": {"assetCatId":"504786","instrGroupId":"8034","assetId": "6047175", "assetBuId": "6", "assetTypeId": "504784", "assetName": "RAMEMERGINGMARKETSEQUITIESLPEUR", "isin": "LU0835722215", "assetType": "Equities", "assetRefCurry": "EUR" } }, { "orderNr": "583353392", "hasRestr": null, "metaType": "FXTR", "orderType": "Buy", "type": "AtMarket", "orderStatusId": 1400, "orderStatus": "FO:Simulated", "orderPrcEstim": 141.7, "orderLimit": null, "metaTypeId": "1", "typeId": "1", "orderTypeId": "139092", "sellAmount": null, "sellCurry": null, "buyAmount": null, "buyCurry": null, "xrateType": null, "orderQty": 8.82, "orderTrxDate": "14-06-2017 00:00:00", "apprxAmount": 1249.94, "omsId": "AVAD34.CREDITANDORRA.AD::83660614", "assetItem": {"assetCatId":"504787","instrGroupId":"8035" ,"assetId": "3306149", "assetBuId": "6", "assetTypeId": "504783", "assetName": "MUZINICHFUNDS-ENHANCEDYIELDSHORT-TERMFUND", "isin": "IE00B65YMK29", "assetType": "Fixedincome", "assetRefCurry": "EUR" } }, { "orderNr": "583353391", "hasRestr": null, "metaType": "STEX", "orderType": "Buy", "type": "AtMarket", "orderStatusId": 1400, "orderStatus": "FO:Simulated", "orderPrcEstim": 528.05, "orderLimit": null, "metaTypeId": "1", "typeId": "1", "orderTypeId": "139092", "sellAmount": null, "sellCurry": null, "buyAmount": null, "buyCurry": null, "xrateType": null, "orderQty": 8.52, "orderTrxDate": "14-06-2017 00:00:00", "apprxAmount": 4499.51, "omsId": "AVAD34.CREDITANDORRA.AD::83660615", "assetItem": {"assetCatId":"504786","instrGroupId":"8034", "assetId": "3031839", "assetBuId": "6", "assetTypeId": "504784", "assetName": "ODDOAVENIREUROPE-A", "isin": "FR0000974149", "assetType": "Equities", "assetRefCurry": "EUR" } }, { "orderNr": "583353390", "hasRestr": null, "metaType": "STEX", "orderType": "Buy", "type": "AtMarket", "orderStatusId": 1400, "orderStatus": "FO:Simulated", "orderPrcEstim": 248.01, "orderLimit": null, "metaTypeId": "1", "typeId": "1", "orderTypeId": "139092", "sellAmount": null, "sellCurry": null, "buyAmount": null, "buyCurry": null, "xrateType": null, "orderQty": 15.62, "orderTrxDate": "14-06-2017 00:00:00", "apprxAmount": 3874.99, "omsId": "AVAD34.CREDITANDORRA.AD::83660616", "assetItem": {"assetCatId":"504786","instrGroupId":"8034", "assetId": "49064", "assetBuId": "6", "assetTypeId": "504784", "assetName": "CREDIINVESTSICAVINTERNATIONALVALUE(A)", "isin": "LU0299048719", "assetType": "Equities", "assetRefCurry": "EUR" } } ]} ], "statusId": 51, "status": "Generation_failed", "errors": null }';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_ORDER_CONFIRM)){
            return '{"orderList":[{"orderNr":"59485433"}], "errors":[{"code":"sf_999000","descError":"583493389 - Orden recibida incorrecta - Orden esperada en un modo diferente"}]}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_ORDER_DISCARD)){
            return '{"orderList":[{"orderNr":"59485433"}], "errors":[{"code":"sf_999000","descError":"583493389 - Orden recibida incorrecta - Orden esperada en un modo diferente"}]}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_EXEC)){
            return '{"orderNr":"583353389","refOrderList":{"orderItem":[{"orderNr":"582772470","hasRestr":null,"metaType":"FXTR","orderType":"FX Spot","type":"At Market","orderStatusId":1500,"orderStatus":"FO: Simulated","orderPrcEstim":null,"orderLimit":null,"metaTypeId":"52","typeId":"1","orderTypeId":"52011","sellAmount":84549.19,"sellCurry":"EUR","buyAmount":95102.87,"buyCurry":"USD","xrateType":2.0,"orderQty":null,"orderTrxDate":"08-06-2017 00:00:00","apprxAmount":null,"omsId":"AVAD34.CREDITANDORRA.AD::83660850","assetItem":null},{"orderNr":"583663397","hasRestr":null,"metaType":"STEX","orderType":"Buy","type":"At Market","orderStatusId":1400,"orderStatus":"FO: Simulated","orderPrcEstim":24.55,"orderLimit":null,"metaTypeId":"1","typeId":"1","orderTypeId":"139092","sellAmount":null,"sellCurry":null,"buyAmount":null,"buyCurry":null,"xrateType":null,"orderQty":79.64,"orderTrxDate":"14-06-2017 00:00:00","apprxAmount":1874.98,"omsId":"AVAD34.CREDITANDORRA.AD::83660610","assetItem":{"assetCatId":"504786","instrGroupId":"8034","assetId":"5153998","assetBuId":"6","assetTypeId":"504784","assetName":"M&G GLOBAL DIVIDEND FUND EUR","isin":"GB00B39R2S49","assetType":"Equities","assetRefCurry":"EUR"}},{"orderNr":"583353396","hasRestr":null,"metaType":"STEX","orderType":"Buy","type":"At Market","orderStatusId":1400,"orderStatus":"FO: Simulated","orderPrcEstim":207.17,"orderLimit":null,"metaTypeId":"1","typeId":"1","orderTypeId":"139092","sellAmount":null,"sellCurry":null,"buyAmount":null,"buyCurry":null,"xrateType":null,"orderQty":16.29,"orderTrxDate":"14-06-2017 00:00:00","apprxAmount":3374.99,"omsId":"AVAD34.CREDITANDORRA.AD::83660611","assetItem":{"assetCatId":"504786","instrGroupId":"8034","assetId":"9504724","assetBuId":"6","assetTypeId":"504784","assetName":"DNCA INVEST-VALUE EUROPE-A","isin":"LU0284396016","assetType":"Equities","assetRefCurry":"EUR"}},{"orderNr":"583353395","hasRestr":null,"metaType":"STEX","orderType":"Buy","type":"At Market","orderStatusId":1400,"orderStatus":"FO: Simulated","orderPrcEstim":15.56,"orderLimit":null,"metaTypeId":"1","typeId":"1","orderTypeId":"139092","sellAmount":null,"sellCurry":null,"buyAmount":null,"buyCurry":null,"xrateType":null,"orderQty":1272.02,"orderTrxDate":"14-06-2017 00:00:00","apprxAmount":3250.0,"omsId":"AVAD34.CREDITANDORRA.AD::83660612","assetItem":{"assetCatId":"504786","instrGroupId":"8034","assetId":"9011237","assetBuId":"6","assetTypeId":"504784","assetName":"JO HAMBRO EURO SEL VAL-EUR-B","isin":"IE0032904116","assetType":"Equities","assetRefCurry":"EUR"}},{"orderNr":"583353394","hasRestr":null,"metaType":"STEX","orderType":"Buy","type":"At Market","orderStatusId":1400,"orderStatus":"FO: Simulated","orderPrcEstim":190.07,"orderLimit":null,"metaTypeId":"1","typeId":"1","orderTypeId":"139092","sellAmount":null,"sellCurry":null,"buyAmount":null,"buyCurry":null,"xrateType":null,"orderQty":6.58,"orderTrxDate":"14-06-2017 00:00:00","apprxAmount":1249.9,"omsId":"AVAD34.CREDITANDORRA.AD::83660613","assetItem":{"assetCatId":"504786","instrGroupId":"8034","assetId":"6047175","assetBuId":"6","assetTypeId":"504784","assetName":"RAM EMERGING MARKETS EQUITIES L P EUR","isin":"LU0835722215","assetType":"Equities","assetRefCurry":"EUR"}},{"orderNr":"583353392","hasRestr":null,"metaType":"STEX","orderType":"Buy","type":"At Market","orderStatusId":1400,"orderStatus":"FO: Simulated","orderPrcEstim":141.7,"orderLimit":null,"metaTypeId":"1","typeId":"1","orderTypeId":"139092","sellAmount":null,"sellCurry":null,"buyAmount":null,"buyCurry":null,"xrateType":null,"orderQty":8.82,"orderTrxDate":"14-06-2017 00:00:00","apprxAmount":1249.94,"omsId":"AVAD34.CREDITANDORRA.AD::83660614","assetItem":{"assetCatId":"504786","instrGroupId":"8034","assetId":"3306149","assetBuId":"6","assetTypeId":"504783","assetName":"MUZINICH FUNDS - ENHANCED YIELD SHORT-TERM FUND","isin":"IE00B65YMK29","assetType":"Fixed income","assetRefCurry":"EUR"}},{"orderNr":"583353391","hasRestr":null,"metaType":"STEX","orderType":"Buy","type":"At Market","orderStatusId":1400,"orderStatus":"FO: Simulated","orderPrcEstim":528.05,"orderLimit":null,"metaTypeId":"1","typeId":"1","orderTypeId":"139092","sellAmount":null,"sellCurry":null,"buyAmount":null,"buyCurry":null,"xrateType":null,"orderQty":8.52,"orderTrxDate":"14-06-2017 00:00:00","apprxAmount":4499.51,"omsId":"AVAD34.CREDITANDORRA.AD::83660615","assetItem":{"assetCatId":"504786","instrGroupId":"8034","assetId":"3031839","assetBuId":"6","assetTypeId":"504784","assetName":"ODDO AVENIR EUROPE-A","isin":"FR0000974149","assetType":"Equities","assetRefCurry":"EUR"}},{"orderNr":"583353390","hasRestr":null,"metaType":"STEX","orderType":"Buy","type":"At Market","orderStatusId":1400,"orderStatus":"FO: Simulated","orderPrcEstim":248.01,"orderLimit":null,"metaTypeId":"1","typeId":"1","orderTypeId":"139092","sellAmount":null,"sellCurry":null,"buyAmount":null,"buyCurry":null,"xrateType":null,"orderQty":15.62,"orderTrxDate":"14-06-2017 00:00:00","apprxAmount":3874.99,"omsId":"AVAD34.CREDITANDORRA.AD::83660616","assetItem":{"assetCatId":"504786","instrGroupId":"8034","assetId":"49064","assetBuId":"6","assetTypeId":"504784","assetName":"CREDIINVEST SICAV INTERNATIONAL VALUE (A)","isin":"LU0299048719","assetType":"Equities","assetRefCurry":"EUR"}},{"orderNr":"583353393","hasRestr":null,"metaType":"STEX","orderType":"Buy","type":"At Market","orderStatusId":2000,"orderStatus":"TD: Ready to be Traded","orderPrcEstim":237.54,"orderLimit":null,"metaTypeId":"1","typeId":"1","orderTypeId":"139092","sellAmount":null,"sellCurry":null,"buyAmount":null,"buyCurry":null,"xrateType":null,"orderQty":10000.0,"orderTrxDate":"14-06-2017 00:00:00","apprxAmount":2375400.0,"omsId":"AVAD34.CREDITANDORRA.AD::83660617","assetItem":{"assetCatId":"504786","instrGroupId":"8034","assetId":"48955","assetBuId":"6","assetTypeId":"504784","assetName":"ROBECO US PREMIUM EQ-$D","isin":"LU0226953718","assetType":"Equities","assetRefCurry":"USD"}}]},"errors":null}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_OMS_LIST_PRINT)){
           return '{"omsIdList":[{"omsId":"1111","orderNr":"1112"},{"omsId":"2222","orderNr":"2223"}],"errors":null}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_GEN_TRX)){
           return '{"order":{"orderNr":"99485433","isNew":false},"status":"Ready for Trx generation","statusId":"40","errors":null}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_UPDATE_MEDIUM)){
           return '{"order":{"orderNr":"99485433","errors":null}';
        }else if(service.equals(CRAN_VEC_ADV_Constants_CLS.SERVICE_MANUAL_EXEC)){
           return '{"orderList":[{"orderNr":"59485433"}], "errors":[{"code":"sf_999000","descError":"583493389 - Orden recibida incorrecta - Orden esperada en un modo diferente"}]}';
        }
        return '{"errors":[{"code":"sf_999000","descError":"Service not found"}]}';
    }


    public static String subStrMaxLongi(String info,integer longi){
        if(info!=null){
            String concat;
            if(info.length()>longi)
                concat = info.substring(0,longi-1);
            else concat = info;
            return concat;
        } else return '';
    }





    // método que actualiza la informacion de todos los campos de un Order pasada como parametro

    public static Order completeOrder(Order myOrder,Opportunity myOpp, List<Quote> myFinalQuote,String recordId,RecordType myRecordType,CRAN_VEC_ADV_ExecRebalpRS_CLS.CRAN_VEC_ADV_OrderItem_CLS myOrderItem, String mode, Boolean isNew){
        myOrder.Name = CRAN_VEC_ADV_Utils.subStrMaxLongi(myOrderItem.orderNr,80); //<orderNr>
        myOrder.CRAN_VEC_ADV_T_OrderId__c = myOrderItem.orderNr; //<orderNr>
        if(myOrderItem.hasRestr!=null)
            myOrder.CRAN_VEC_ADV_T_HasRestr__c = CRAN_VEC_ADV_Utils.subStrMaxLongi(myOrderItem.hasRestr,255); //<hasRestr>
        else myOrder.CRAN_VEC_ADV_T_HasRestr__c = null;        

        myOrder.CRAN_VEC_ADV_T_MetaTypeId__c = myOrderItem.metaTypeId; //<metaTypeId>
        myOrder.CRAN_VEC_ADV_P_MetaType__c = myOrderItem.metaType; //<metaType>
        myOrder.CRAN_VEC_ADV_T_TypeId__c = myOrderItem.typeId; //typeId
        myOrder.CRAN_VEC_ADV_P_Type__c = myOrderItem.type; // <type>
        myOrder.CRAN_VEC_ADV_T_OrderTypeId__c  = myOrderItem.orderTypeId; // <orderTypeId>
        myOrder.Type = myOrderItem.orderType; // <OrderType>
        myOrder.CRAN_VEC_ADV_T_AvaloqStatusId__c = myOrderItem.orderStatusId; // <orderStatusId>

        myOrder.CRAN_VEC_ADV_N_RealPrice__c = myOrderItem.realPrice; // <realPrice>
        
        if(myOrderItem.orderStatusId != null){
            String myStatusSF = CRAN_VEC_ADV_Constants_CLS.SF_STATUS_ORDER_MAP.get(myOrderItem.orderStatusId);
            if(myStatusSF!=null) myOrder.CRAN_VEC_ADV_P_SFStatus__c = myStatusSF;
            else myOrder.CRAN_VEC_ADV_P_SFStatus__c = CRAN_VEC_ADV_Constants_CLS.OPP_ORDER_INPROCESS_ORDER;
        }

        if(myOrder.CRAN_VEC_ADV_P_SFStatus__c==null && myOrderItem.orderStatusId !=null){
            myOrder.CRAN_VEC_ADV_P_SFStatus__c = CRAN_VEC_ADV_Constants_CLS.OPP_ORDER_INPROCESS_ORDER;
        }

        myOrder.Status = CRAN_VEC_ADV_Constants_CLS.DRAFT;

        myOrder.CRAN_VEC_ADV_T_AvaloqStatus__c = myOrderItem.orderStatus; // <orderStatus>
                      
        if(myOrderItem.orderTrxDate !=null && myOrderItem.orderTrxDate !='') 
            myOrder.CRAN_VEC_ADV_D_TRXDate__c = CRAN_VEC_ADV_Utils.stringToDate(myOrderItem.orderTrxDate);

        myOrder.AccountId = myOpp.AccountId;
        myOrder.RecordTypeId = myRecordType.Id;
        myOrder.OpportunityId = recordId;

        myOrder.EffectiveDate = Date.today();
        if(myFinalQuote!=null && myFinalQuote.size()>0)
            myOrder.QuoteId = myFinalQuote[0].Id;
        //myOrder.CRAN_VEC_ADV_B_isService__c = true;

        String myInstrGroupId = null;
        String myAssetCatId = null;

        if(myOrderItem.assetItem!=null){
            myInstrGroupId = myOrderItem.assetItem.instrGroupId;
            myAssetCatId = myOrderItem.assetItem.assetCatId;
            myOrder.CRAN_VEC_ADV_P_InstrGroup__c = myOrderItem.assetItem.instrGroupId;
            myOrder.CRAN_VEC_ADV_P_CatActivo__c = myOrderItem.assetItem.assetCatId;
        }

        //chequeo si es una nueva insercion de orden para comprobar si marco o no el manualConfirm
        if(isNew){
            Boolean manualConfirm = CRAN_VEC_ADV_Utils.checkOrderManualConfirm(myOrderItem.metaType,myInstrGroupId,myAssetCatId);
            myOrder.CRAN_VEC_ADV_B_ManualConfirm__c = manualConfirm;    
        }

        //Distingo entre tipo STEX Y FX
        if(myOrderItem.metaType.equals(CRAN_VEC_ADV_Constants_CLS.STEX)){
            myOrder.CRAN_VEC_ADV_N_Price__c = myOrderItem.orderPrcEstim; // <orderPrcEstim>
            myOrder.CRAN_VEC_ADV_N_Limit__c = myOrderItem.orderLimit; // <orderLimit>
            myOrder.CRAN_VEC_ADV_N_Quantity__c = myOrderItem.orderQty; // <orderQty>
            myOrder.CRAN_VEC_ADV_N_Amount__c = myOrderItem.apprxAmount; // <apprxAmount>
            myOrder.CRAN_VEC_ADV_T_AssetName__c = CRAN_VEC_ADV_Utils.subStrMaxLongi(myOrderItem.assetItem.assetName,255); // <assetName>
           
        }else if(myOrderItem.metaType.equals(CRAN_VEC_ADV_Constants_CLS.FXTR)){
            myOrder.CRAN_VEC_ADV_N_SellAmount__c = myOrderItem.sellAmount; // <sellAmount>
            myOrder.CRAN_VEC_ADV_P_SellCurry__c = myOrderItem.sellCurry; // <sellCurry>
            myOrder.CRAN_VEC_ADV_N_BuyAmount__c = myOrderItem.buyAmount; //<buyAmount>
            myOrder.CRAN_VEC_ADV_P_BuyCurry__c = myOrderItem.buyCurry; // <buyCurry>
            myOrder.CRAN_VEC_ADV_N_xRateType__c = myOrderItem.xrateType; // <xrateType> 
            myOrder.CRAN_VEC_ADV_N_Limit__c = myOrderItem.orderLimit; // <xrateType> 
        }

        return myOrder;
    }

    public static Id saveContentVersion(String contentsString, String fileName){
        ContentVersion v = new ContentVersion();
        v.VersionData = EncodingUtil.base64Decode(contentsString);
        v.PathOnClient ='/'+fileName+'.pdf';
        v.Title = fileName+'.pdf';
        v.Description = CRAN_VEC_ADV_Constants_CLS.PREFIX;
        insert v;
        return v.id;
    }

    public static void deleteContentDocument( String fileName){
        String title = fileName+'.pdf';
        List<ContentDocument> contenVeList = [SELECT Id FROM ContentDocument WHERE Title =: title 
        AND Description =:CRAN_VEC_ADV_Constants_CLS.PREFIX ];
        if (!contenVeList.isEmpty()){
            delete contenVeList;
        }
    }

    //Metodo que comprueba la configuracion por custom settings para la activacion manual de confirmacion de ordenes
    public static Boolean checkOrderManualConfirm(String metatype, String instrGroup, String catActivo){
        //Check metatypes
        if(FOREXACTIVE && CRAN_VEC_ADV_Constants_CLS.FXTR.equals(metatype)){
            return true;
        }
        if(STEXACTIVE && CRAN_VEC_ADV_Constants_CLS.STEX.equals(metatype)){
            return true;
        }
        if(CATACTIVO_MANUAL_SET != null && CATACTIVO_MANUAL_SET.contains(catActivo) || INSTRGROUP_MANUAL_SET != null && INSTRGROUP_MANUAL_SET.contains(instrGroup)){
            if(INSTRGROUPUNMARK_LIST != null && INSTRGROUPUNMARK_LIST.contains(instrGroup)){
                return false;
            }else{
                return true;  
            }
        }
        return false;
    }


    private static Set<String> getInstrGroupManualList(String codeList){
        if(codeList != null){
            return new Set<String>(INSTRGROUP_LIST.split(';'));
        }else{
            return null;
        }
    }

    private static Set<String> getCatActivoManualList(String codeList){
        if(codeList != null){
            return new Set<String>(CATACTIVO_LIST.split(';'));
        }else{
            return null;
        }
    } 

    private static Set<String> getInstrGroupAutList(String codeList){
        if(codeList != null){
            return new Set<String>(INSTRGROUPUNMARK_LIST.split(';'));
        }else{
            return null;
        }
    }


    /*---------------------------*/
    /*   CUSTOM CLASS EXCEPTION  */
    /*---------------------------*/

    public class CRAN_VEC_ADV_UtilException extends Exception {}
}