trigger CRAN_VAS_MAQ_VentasObjetivosTrigger on CRAN_VAS_MAQ_VentasObjetivos__c (before insert, before update) {
	new CRAN_VAS_MAQ_VentasObjetivosHandler_CLS(CRAN_VAS_MAQ_VentasObjetivos__c.getSObjectType()).run();
}