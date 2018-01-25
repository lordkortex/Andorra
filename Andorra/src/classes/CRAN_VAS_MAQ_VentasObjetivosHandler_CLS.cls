public class CRAN_VAS_MAQ_VentasObjetivosHandler_CLS extends TriggerHandler{
	
    private Map<Id, CRAN_VAS_MAQ_VentasObjetivos__c> 	newVentasObjetivosMap;
    private Map<Id, CRAN_VAS_MAQ_VentasObjetivos__c> 	oldVentasObjetivosMap;
    private List<CRAN_VAS_MAQ_VentasObjetivos__c> 		newVentasObjetivosList;
    private List<CRAN_VAS_MAQ_VentasObjetivos__c> 		oldVentasObjetivosList;
    
    public CRAN_VAS_MAQ_VentasObjetivosHandler_CLS(SObjectType objectType) {
        super(objectType);
        this.newVentasObjetivosMap 	= (Map<id, CRAN_VAS_MAQ_VentasObjetivos__c>) 	Trigger.newMap;
        this.oldVentasObjetivosMap 	= (Map<id, CRAN_VAS_MAQ_VentasObjetivos__c>) 	Trigger.oldMap;
        this.newVentasObjetivosList = (List<CRAN_VAS_MAQ_VentasObjetivos__c>) 		Trigger.new;
        this.oldVentasObjetivosList = (List<CRAN_VAS_MAQ_VentasObjetivos__c>) 		Trigger.old;    
    }
    
    public override void beforeInsert() {        
        CRAN_VAS_MAQ_VentasObjetivosHelper_CLS.reflectFormulaFields(newVentasObjetivosList);
    }
    
    public override void beforeUpdate() {        
        if (!TriggerHandler.isBypassed(super.getHandlerName())) {
            TriggerHandler.bypass(super.getHandlerName());  
            CRAN_VAS_MAQ_VentasObjetivosHelper_CLS.reflectFormulaFields(newVentasObjetivosList);
        }
    }
}