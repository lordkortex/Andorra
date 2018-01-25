public class CRAN_VEC_ADV_Constants_CLS {

	public static final String DONE = 'Done';
	public static final String MEDIUMUPDATED = 'Medium updated';
	public static final String BP = 'bp';
	public static final String HOLD = 'hold';
	public static final String PERSON = 'person';
	public static final String QUEST = 'quest';
	public static final String CONTAINER = 'cont';
	public static final String STEX = 'STEX';
	public static final String FXTR = 'FXTR';
	public static final String MODE_GET = 'get';
	public static final String MODE_FINAL = 'final';
	public static final String SIGNED = 'Signed';
	public static final String POS = 'pos';
	public static final String DRAFT = 'Draft';
	public static final String GMT = 'GMT';
	public static final String VALUE_50 = '50';
	public static final String PROP = 'Prop_';
	public static final String EMPTY = '';


	public static final String IN_PROGRESS_DOCUSIGN = 'In Progress';
	public static final String SEND_TOARCHIVE_DOCUSIGN = 'Sent to Archive';

	public static final String PICKLIST_TYPE = 'Picklist';
	public static final String EMPTY_ANSWER_PICK = '$0$';
	public static final String EMPTY_ANSWER_PICK_LABEL = '--None--';

	public static final String DATE_FORMAT = 'yyyy-MM-dd kk:mm';
	public static final String DATE_FORMAT_DDMMYYYY = 'dd-MM-YYYY';
	public static final String DATE_HEADER = 'Date';

	public static final String ID_TEMPLATE = 'mdb$mifid';

	public static final String OPTION_PRINTPREVIEW = 'provisional';
	public static final String OPPORTUNITY_OBJ = 'Opportunity';

	public static final String GET = 'GET';
	public static final String POST = 'POST';

	//Nombre servicios para MQ
	public static final String SERVICE_RECUPERAR_CUESTIONARIOS = 'SfQuestList';
	public static final String SERVICE_CREAR_NUEVO = 'SfNewQuest';
	public static final String SERVICE_PORTFOLIO = 'SfPortfolio';
	public static final String SERVICE_DESCARTAR_ORDEN = 'SfDiscdProf';
	public static final String SERVICE_PDF = 'getDocumento';
	public static final String SERVICE_IP = 'getProposal';
	public static final String SERVICE_CREAR_ORDER_MODIFICACION = 'SfModQuest';
	public static final String SERVICE_VERIFICAR = 'SfVfyProf';
	public static final String SERVICE_CALCULAR = 'SfCalcProf';
	//Nombre servicios Propuesta de inversion
	public static final String SERVICE_DESCARTAR_OPORTUNIDAD = 'SfDiscdRebalpReq';
	public static final String SERVICE_NUEVA_OPORTUNIDAD = 'SfNewRebalpReq';
	public static final String SERVICE_FIRMA_OPORTUNIDAD = 'SfSignRebalpReq';
	public static final String SERVICE_REGEN_OPORTUNIDAD = 'SfReGenRebalp';
    public static final String SERVICE_GEN_TRX = 'SfSignRebalp2';	
    public static final String SERVICE_UPDATE_MEDIUM = 'SfUpdateMedium';	
	//Conservamos el nombre y servicio antiguo de detalle para reutilizar mas adelante en otras fases
	public static final String SERVICE_DET_OPORTUNIDAD = 'SfRebalpDetReq';
	public static final String SERVICE_CLOSE_OPORTUNIDAD = 'SfCloseRebalpReq';
	public static final String SERVICE_CALCULAR_OPORTUNIDAD = 'SfCalcRebalpReq';
	public static final String SERVICE_FIRMA_CONTRATO = 'SfSignContrReq';
	public static final String SERVICE_LIST_OPORTUNIDAD = 'SfRebalpList2';
	public static final String SERVICE_OMS_PRINT = 'SfOmsPrint';
	public static final String SERVICE_OMS_LIST_PRINT = 'SfOmsListPrint';
	public static final String SERVICE_WAIT_SIGN = 'SfWaitSign';
	//Nombre servicios Boletas
	public static final String SERVICE_EXEC = 'SfExecRebalp';
	public static final String SERVICE_EXEC_LIST = 'SfExecReq';
	public static final String SERVICE_EXEC_FINAL = 'SfExecReq'; 

	public static final String SERVICE_EXEC_MODEGET = 'get';
	public static final String SERVICE_EXEC_MODEFINAL = 'final';

	//Version nueva detalle que realmente funciona como calcular oportunidad la primera vez despues de crearla en Salesforce
	public static final String SERVICE_DET_OPORTUNIDAD_V2 = 'SfRebalpDet3';
	// Recuperar doc del OMS
	public static final String SERVICE_GET_OMS_DOC = '/service1/documentService/oms';

	public static final String SERVICE_ORDER_CONFIRM = '/service1/avaloqService/confirmOrders';
	public static final String SERVICE_ORDER_DISCARD = '/service1/avaloqService/discardOrders';
	public static final String SERVICE_MANUAL_EXEC = '/service1/avaloqService/orderManual';
	// Recuperar doc archive
	public static final String SERVICE_ARCHIVE_DOC = '/service1/documentService/archive';
	public static final String SERVICE_MERGE_PDF = '/service2/SFCservicesCreditAndorra/APIv1.0/service/getMergedPDF';

	public static String ARCHIVE = 'ARCHIVE';
  	public static String OMS = 'OMS';
  	public static String MERGEPDF = 'MERGEPDF';
	

	public static final String CALLOUT_FAIL = 'Failed to execute callout. SFDC Reports: ';
	public static final String PREFIX = 'CRAN_VEC_ADV';
	
	//Opportunity StageName
	public static final String OPP_STAGENAME_DONE = 'advDone';
	public static final String OPP_STAGENAME_SIMULATED = 'advSimulated';
	public static final String OPP_STAGENAME_PEND_SIGN = 'advToSign';
	public static final String OPP_STAGENAME_OPEN = 'advOpen';
	public static final String OPP_STAGENAME_PROPGEN = 'advPropGen';
	public static final String OPP_STAGENAME_DISCARTED = 'advDiscarded';
	public static final String OPP_STAGENAME_ERRSIM = 'advErrSim';

	//Opportunity OrderStatusSF
	public static final String OPP_ORDER_SIMULATED_ORDER = 'advSimulated';
	public static final String OPP_ORDER_DISCARDED_ORDER = 'advDiscarded';
	public static final String OPP_ORDER_DONE_ORDER = 'advDone';
	public static final String OPP_ORDER_INPROCESS_ORDER = 'advInProcess';
	public static final String OPP_ORDER_SIGNED_PENDINGEXEC = 'advSigned';
	public static final String OPP_ORDER_PENDINGSIGN = 'advWaitSign';

	//Opportunity OrderStatus
	public static final String OPP_ORDER_DISCARDED = '91';
	public static final String OPP_ORDER_SIMULATED = '1400';

	//Order RENTA VARIABLE O FIJA
	public static final String OPP_ORDER_P_CATACTIVO = '504783';

	//Developer Name RecordTypes
	public static final String CRAN_VEC_ADV_BUSINESS = 'CRAN_VEC_ADV_Business';
	public static final String CRAN_VEC_ADV_BP = 'CRAN_VEC_ADV_Business_Partner';
	public static final String CRAN_VEC_ADV_INDIVIDUAL = 'CRAN_VEC_ADV_Individual';
	public static final String CRAN_VEC_ADV_OPP_INVT_PROP = 'CRAN_VEC_ADV_Invt_Prop';
	public static final String CRAN_VEC_ADV_QUOTE_INVT_PROP = 'CRAN_VEC_ADV_Invt_Prop';
	public static final String CRAN_VEC_ADV_ORDER_INVT_PROP = 'CRAN_VEC_ADV_Investment_Proposition';
	//Text states
	public static final String CRAN_VEC_ADV_TEXT_ORDER_DISCARD = 'BO: Discarded';


	public static final Map<String, String> BU_AVALOQ_MAP = createBuAvaloqMap();

	public static final Map<String, String> ADVID_AVALOQ_MAP = createAdvisoryIdMap();

	public static final Map<String, String> OPP_STAGENAME_MAP = createOppStagenameMap();

	public static final Map<String, String> SF_STATUS_ORDER_MAP = createStatusOrderMap();

	//RecordTypes
	public static final List<RecordType> ORDER_RECORDTYPE = getRecordType('Order');
	public static final List<RecordType> INVSPROP_RECORDTYPE = getRecordTypeName('Investment Proposition');
	public static final List<RecordType> TREST_RECORDTYPE = getRecordType('CRAN_VEC_ADV_IPL_Restriction__c');
	public static final List<RecordType> CR_RECORDTYPE = getRecordTypeDeveloperName('FinServ__FinancialAccountRole__c', 'ContactRole');
	public static final List<RecordType> FA_RECORDTYPE = getRecordTypeDeveloperName('FinServ__FinancialAccount__c', 'CRAN_VEC_ADV_Container');


	private static Map<String, String> createStatusOrderMap() {
        Map<String, String> result = new Map<String, String>();
        result.put('1400', OPP_ORDER_SIMULATED_ORDER);
        result.put('1600', OPP_ORDER_SIGNED_PENDINGEXEC);
        result.put('8020', OPP_ORDER_SIGNED_PENDINGEXEC);
        result.put('8010', OPP_ORDER_PENDINGSIGN);
        result.put('1500', OPP_ORDER_PENDINGSIGN);
        result.put('91', OPP_ORDER_DISCARDED_ORDER);
        result.put('80', OPP_ORDER_DONE_ORDER);
        result.put('90', OPP_ORDER_DONE_ORDER);
        return result;
    }


	private static Map<String, String> createOppStagenameMap() {
        Map<String, String> result = new Map<String, String>();
        result.put('0', OPP_STAGENAME_OPEN);
        result.put('2', OPP_STAGENAME_OPEN);
        result.put('3', OPP_STAGENAME_OPEN);
        result.put('4', OPP_STAGENAME_PROPGEN);
        result.put('5', OPP_STAGENAME_OPEN);
        result.put('6', OPP_STAGENAME_OPEN);
        result.put('7', OPP_STAGENAME_OPEN);
        result.put('40', OPP_STAGENAME_OPEN);
        result.put('50', OPP_STAGENAME_SIMULATED);
        result.put('51', OPP_STAGENAME_ERRSIM);
        result.put('90', OPP_STAGENAME_DONE);
        result.put('91', OPP_STAGENAME_DISCARTED);
        return result;
    }

	//Correspondencia entre BU de Avaloq y  Codigo aplicacion origen para direccion de MQ
    private static Map<String, String> createBuAvaloqMap() {
      Map<String, String> result = new Map<String, String>();
        try{
            CRAN_VEC_ADV_AvaloqSettings__c cs = CRAN_VEC_ADV_AvaloqSettings__c.getInstance();
            String stringMap = cs.CRAN_VEC_ADV_T_WasBuMap__c;
           
            for(String keyValue : stringMap.split(';')) {
                String[] pairs = keyValue.split(',', 2);
                result.put(pairs[0], pairs[1]);
			}
        }catch (Exception ex){
            System.debug('createBuAvaloqMap:  No se ha podido cargar el mapeo de BU');
            return result;
        }
        return result;
    }

    //Correspondencia entre Ids perfilados de Avaloq y Codigo perfilados servicios de carga/salesforce id
    private static Map<String, String> createAdvisoryIdMap() {
        Map<String, String> result = new Map<String, String>();
        result.put('mdb$mifid_dflt$r_def', '535010');
        result.put('mdb$mifid_dflt$r_con', '535011');
        result.put('mdb$mifid_dflt$r_mod', '535012');
        result.put('mdb$mifid_dflt$r_eq', '535013');
        result.put('mdb$mifid_dflt$r_din', '535014');
        return result;
    }


    private static List<RecordType> getRecordType(String sobjectType) {
        return [SELECT Id, SobjectType FROM RecordType WHERE SobjectType =: sobjectType AND IsActive = true];
    }


    private static List<RecordType> getRecordTypeDeveloperName(String sobjectType, String developerName) {
        return [SELECT Id, SobjectType FROM RecordType WHERE SobjectType =: sobjectType AND DeveloperName =: developerName AND IsActive = true];
    }

    private static List<RecordType> getRecordTypeName(String name) {
        return [SELECT Id, SobjectType FROM RecordType WHERE Name =: name AND IsActive = true];
    }
}