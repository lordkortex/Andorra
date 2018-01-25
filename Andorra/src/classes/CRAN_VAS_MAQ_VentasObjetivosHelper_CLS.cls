public class CRAN_VAS_MAQ_VentasObjetivosHelper_CLS {

    public static void reflectFormulaFields (List<CRAN_VAS_MAQ_VentasObjetivos__c> ventasObjetivos) {
        
        List<CRAN_VAS_MAQ_VentasObjetivos__c> records = new List<CRAN_VAS_MAQ_VentasObjetivos__c>();       
        
        for (CRAN_VAS_MAQ_VentasObjetivos__c vobj: ventasObjetivos){
			vobj.CRAN_VAS_MAQ_B_VentaGanada__c 		= vobj.CRAN_VAS_MAQ_F_B_Ganada__c;
            vobj.CRAN_VAS_MAQ_C_VentaImporte__c 	= vobj.CRAN_VAS_MAQ_F_C_Importe__c;
            vobj.CRAN_VAS_MAQ_N_VentaVolumen__c 	= vobj.CRAN_VAS_MAQ_F_C_Volumen__c;
            vobj.CRAN_VAS_MAQ_B_SaleValidated__c 	= vobj.CRAN_VAS_MAQ_F_B_SaleValidated__c;      
        } 
    } 
}