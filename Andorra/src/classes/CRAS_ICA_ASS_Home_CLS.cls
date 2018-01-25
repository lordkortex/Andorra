public class CRAS_ICA_ASS_Home_CLS {

    public static String getRiskSet(Id userId){
        List<CRAS_ICA_ASS_VCResponse_OBJ> result = new List<CRAS_ICA_ASS_VCResponse_OBJ>();
        result.addAll((List<CRAS_ICA_ASS_VCResponse_OBJ>)System.JSON.deserialize(CRAS_ICA_ASS_VentasCancelaciones_CTR.getVentasCancelacionesYear1(), List<CRAS_ICA_ASS_VCResponse_OBJ>.class));
        result.addAll((List<CRAS_ICA_ASS_VCResponse_OBJ>)System.JSON.deserialize(CRAS_ICA_ASS_VentasCancelaciones_CTR.getVentasCancelacionesYear2(), List<CRAS_ICA_ASS_VCResponse_OBJ>.class));
        return JSON.serialize(result);
    }
    

    public static String getRiskInsSet(Id userId){
      
        List<CRAS_ICA_ASS_VCResponse_OBJ> result = new List<CRAS_ICA_ASS_VCResponse_OBJ>();
        result.addAll((List<CRAS_ICA_ASS_VCResponse_OBJ>)System.JSON.deserialize(CRAS_ICA_ASS_VentasCancelaciones_CTR.getVentasCancelacionesYearIns1(), List<CRAS_ICA_ASS_VCResponse_OBJ>.class));
        result.addAll((List<CRAS_ICA_ASS_VCResponse_OBJ>)System.JSON.deserialize(CRAS_ICA_ASS_VentasCancelaciones_CTR.getVentasCancelacionesYearIns2(), List<CRAS_ICA_ASS_VCResponse_OBJ>.class));
        return JSON.serialize(result);
    }
    

    public static String getSavingsSet(Id userId){
        
        List<CRAS_ICA_ASS_VCResponse_OBJ> result = new List<CRAS_ICA_ASS_VCResponse_OBJ>();
        result.addAll((List<CRAS_ICA_ASS_VCResponse_OBJ>)System.JSON.deserialize(CRAS_ICA_ASS_VentasCancelaciones_CTR.getVentasCancelacionesYear3(), List<CRAS_ICA_ASS_VCResponse_OBJ>.class));
        result.addAll((List<CRAS_ICA_ASS_VCResponse_OBJ>)System.JSON.deserialize(CRAS_ICA_ASS_VentasCancelaciones_CTR.getVentasCancelacionesYear4(), List<CRAS_ICA_ASS_VCResponse_OBJ>.class));
        
        return JSON.serialize(result);

    }

    public static String getVentasObjetivos(String market)
    {
        String result;
        if(market=='health'){
            result = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_ventasobjetivos');
        } else if (market=='life') {
            result = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_ventasobjetivos2');
        } else if (market=='savings') {
            result = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_ventasobjetivos3');
        }             
        return result;
    }
    

    public static String getRecibosDevueltos(){
        String result = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_RecibosDevueltos');
        System.debug('result: ' + result);
        return result;
    }
    

    public static String getPropuestasPendientes(){
        String result = CRAS_ICA_ASS_Helpers_CLS.getDataFromWS('CRAS_ICA_ASS_PropuestasPendientes');
        System.debug(LoggingLevel.error,'result: ' + result);
        return result;
    }
    
}