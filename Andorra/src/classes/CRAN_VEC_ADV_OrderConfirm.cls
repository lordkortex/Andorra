/**
 * Clase que llama al servicio 'SERVICE_ORDER_CONFIRM' y trata la respuesta del servicio.
 *
 * Fecha: 20/06/2017
 * @author  Javier Touchard Vicente (Vector ITC)
 * @version 1.2  MANUAL CONFIRM  28/08/2017
 *
*/
public without sharing class CRAN_VEC_ADV_OrderConfirm implements Queueable, Database.AllowsCallouts {

    private List<Order> listOrders;  
    private Map<Id, Id> mapObIdTargetId; //MAPA QUE RELACIONA EL ID DE LA ORDEN CON LA PERSONA A LA QUE MANDARE LA NOTIFICACION.
    private Map<String, Order> mapOrders; //MAPA CON TODAS LAS ORDENES QUE ENTRAN, DE ESTE MAPA SE IRAN QUITANDO LAS ORDENES QUE SE CONFIRMEN BIEN PARA DESPUES MANDAR EL RESTO A CAMBIAR DE ESTADO.
    private Map<String, Order> mapAutomaticOrders; //MAPA CON LAS ORDENES QUE VAN A CONFIRMARSE AUTOMATICAMENTE, SE QUITARAN LAS ORDENES QUE SE CONFIRMAN BIEN Y LAS QUE QUEDEN SE MANDAN A ACTUALIZAR LOS CAMPOS DE ERROR.
    private Map<String, Order> mapOrdersOkConfirm; //MAPA EN EL QUE SE METERA LAS ORDENES QUE SE HAN CONFIRMADO BIEN PARA DESPUES MANDARLAS A BLANQUEAR LOS CAMPOS DE ERROR
    private String errorConfirm;
    private List<String> OrdersOk;
    private Boolean sendNotification;
    private CRAN_VEC_ADV_OrderConfirm_RS results;

    public CRAN_VEC_ADV_OrderConfirm(List<Order> listOrders, Map<Id, Id> mapObIdTargetId){
        this.listOrders = listOrders;
        this.mapObIdTargetId = mapObIdTargetId;
        sendNotification = false;
        mapOrders = new Map<String, Order>();
        mapAutomaticOrders = new Map<String, Order>();
        for(Order orden : listOrders){
            if(orden.CRAN_VEC_ADV_T_OrderId__c != null){
                mapOrders.put(orden.CRAN_VEC_ADV_T_OrderId__c, orden);
            }
            if(!orden.CRAN_VEC_ADV_B_ManualConfirm__c){
                mapAutomaticOrders.put(orden.CRAN_VEC_ADV_T_OrderId__c, orden);
            }       
        }

        System.debug('AUTOMATICAS: ' + mapAutomaticOrders);

    }

    public void execute(QueueableContext context) {
        System.debug('----------ENTRA A EXECUTE----------');
                
        //SI HAY ALGUNA ORDEN CON CONFIRMACION AUTOMATICA SE LLAMA AL SEVICIO DE CONFIRMAR.
        if(!mapAutomaticOrders.isEmpty()){
            try{
                CRAN_VEC_ADV_OrderConfirm_RQ rq = new CRAN_VEC_ADV_OrderConfirm_RQ();

                List<CRAN_VEC_ADV_OrderPrintList_CLS> lstOrders = new List<CRAN_VEC_ADV_OrderPrintList_CLS>();

                for(String key : mapAutomaticOrders.keySet()){
                    CRAN_VEC_ADV_OrderPrintList_CLS order = new CRAN_VEC_ADV_OrderPrintList_CLS();
                    order.orderNr = key;            
                    lstOrders.add(order);
                }
                        
                rq.orderList = lstOrders;
                rq.lang = CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage());
                
                String jsonRequest = JSON.serialize(rq);
                
                CRAN_VEC_ADV_RestClient_CLS avaloqClient;

                avaloqClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_ORDER_CONFIRM, jsonRequest, true);
            
                if(avaloqClient.responseBody != null){
                    results = (CRAN_VEC_ADV_OrderConfirm_RS) JSON.deserialize(avaloqClient.responseBody, CRAN_VEC_ADV_OrderConfirm_RS.class);
                }

                manageResultConfirm(results);

            }catch(Exception e){
                System.debug( ' -------------------- ERROR EN EL SERVICIO -------------------- ');
                System.debug('ERROR : ' + e.getTypeName() + '; MENSAJE DEL ERROR : ' + e.getMessage() + '; CAUSA DEL ERROR : ' + e.getCause() + '; ERROR EN LA LINEA : ' + e.getLineNumber() 
                              + '; TRAZA : ' + e.getStackTraceString());
                //errorConfirm = e.getMessage();
                CRAN_VEC_ADV_ESignatureTriggerUtil.updateOrderError(e.getMessage(), mapAutomaticOrders, false);
                if(!listOrders.isEmpty() && listOrders[0].Opportunity != null && listOrders[0].Opportunity.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c != null){
                    CRAN_VEC_ADV_ESignatureTriggerUtil.sendNotifications(null, e.getMessage(), false, null, listOrders[0].Opportunity.Name, 
                                                                          mapObIdTargetId.get(listOrders[0].Id), listOrders[0].Opportunity.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c);
                }         
            }
        }
        

        //SI HAY ALGUNA ORDEN DE CONFIRMANCION MANUAL O HA FALLADO ALGUNA ORDEN DE CONFIRMACION AUTOMATICA DE LLAMA AL SERVICIO 'SERVICE_MANUAL_EXEC' 
        //PARA CAMBIAR EL ESTADO A 'SIGNED¬PENDIN EXECUTION'.
        if(!mapOrders.isEmpty()){
            try{
                CRAN_VEC_ADV_OrderConfirm_RQ rqManual = new CRAN_VEC_ADV_OrderConfirm_RQ();

                List<CRAN_VEC_ADV_OrderPrintList_CLS> lstOrdersManual = new List<CRAN_VEC_ADV_OrderPrintList_CLS>();

                for(String clave : mapOrders.keySet()){
                    CRAN_VEC_ADV_OrderPrintList_CLS orderManual = new CRAN_VEC_ADV_OrderPrintList_CLS();
                    orderManual.orderNr = clave;          
                    lstOrdersManual.add(orderManual);
                }
                        
                rqManual.orderList = lstOrdersManual;
                rqManual.lang = CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage());
                
                String jsonRequestManual = JSON.serialize(rqManual);
                
                CRAN_VEC_ADV_RestClient_CLS avaloqClientManual;

                avaloqClientManual = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_MANUAL_EXEC, jsonRequestManual, true);

                CRAN_VEC_ADV_OrderConfirm_RS resultsManual;
                if(avaloqClientManual.responseBody != null){
                    resultsManual = (CRAN_VEC_ADV_OrderConfirm_RS) JSON.deserialize(avaloqClientManual.responseBody, CRAN_VEC_ADV_OrderConfirm_RS.class);
                }

                manageResultChangeStatus(resultsManual);

            }catch(Exception e){
                System.debug( ' -------------------- ERROR EN EL SERVICIO -------------------- ');
                System.debug('ERROR : ' + e.getTypeName() + '; MENSAJE DEL ERROR : ' + e.getMessage() + '; CAUSA DEL ERROR : ' + e.getCause() + '; ERROR EN LA LINEA : ' + e.getLineNumber() 
                              + '; TRAZA : ' + e.getStackTraceString());
                CRAN_VEC_ADV_ESignatureTriggerUtil.updateOrderError(e.getMessage(), mapOrders, true);        
            }
        }

        //SE ACTUALIZAN LAS ORDENES.
        if(!mapAutomaticOrders.isEmpty() && mapOrdersOkConfirm != null && !mapOrdersOkConfirm.isEmpty()){
            CRAN_VEC_ADV_ESignatureTriggerUtil.updateOrderErrorJob(errorConfirm, mapAutomaticOrders, mapOrdersOkConfirm, false);
            sendNotification = true;
        } else if (!mapAutomaticOrders.isEmpty() && (mapOrdersOkConfirm == null || mapOrdersOkConfirm.isEmpty())) {
            CRAN_VEC_ADV_ESignatureTriggerUtil.updateOrderError(errorConfirm, mapAutomaticOrders, false);
            sendNotification = true;
        } else if (mapAutomaticOrders.isEmpty() && mapOrdersOkConfirm != null && !mapOrdersOkConfirm.isEmpty()) {
            CRAN_VEC_ADV_ESignatureTriggerUtil.updateOrderError(null, mapOrdersOkConfirm, false);           
        }

        //SE MANDAN NOTIFICACIONES.
        if(sendNotification){
            if(OrdersOk.isEmpty()){
                if(!listOrders.isEmpty() && listOrders[0].OpportunityId != null && listOrders[0].Opportunity.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c != null){
                    CRAN_VEC_ADV_ESignatureTriggerUtil.sendNotifications(null, errorConfirm, false, results.errors, 
                           listOrders[0].Opportunity.Name, mapObIdTargetId.get(listOrders[0].Id), listOrders[0].Opportunity.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c); 
                }                                            
            }else{
                if(!listOrders.isEmpty() && listOrders[0].OpportunityId != null && listOrders[0].Opportunity.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c != null){
                     CRAN_VEC_ADV_ESignatureTriggerUtil.sendNotifications(OrdersOk, errorConfirm, false, results.errors, 
                            listOrders[0].Opportunity.Name, mapObIdTargetId.get(listOrders[0].Id), listOrders[0].Opportunity.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c);
                }                    
            }
            sendNotification = false;
        }


    }


    public void manageResultConfirm(CRAN_VEC_ADV_OrderConfirm_RS results){

            if (results != null && results.errors != null) {
                OrdersOk = new List<String>();
                if(results.orderList != null){
                    mapOrdersOkConfirm = new Map<String, Order>();                   
                    for(CRAN_VEC_ADV_OrderPrintList_CLS ordenesRs : results.orderList){
                        mapOrdersOkConfirm.put(ordenesRs.orderNr, mapOrders.get(ordenesRs.orderNr));                       
                        mapOrders.remove(ordenesRs.orderNr);
                        mapAutomaticOrders.remove(ordenesRs.orderNr);
                        OrdersOk.add(ordenesRs.orderNr);
                    }             
                }
                if(!mapAutomaticOrders.isEmpty()){
                     System.debug( ' -------------------- ERROR EN EL SERVICIO -------------------- ');
                     System.debug('ERROR : ' + CRAN_VEC_ADV_Utils.getAllErrorsService(results.errors));
                     errorConfirm = CRAN_VEC_ADV_Utils.getAllErrorsService(results.errors);
                } 

            } else if (results != null && results.errors == null && results.orderList != null) {
                mapOrdersOkConfirm = new Map<String, Order>();
                System.debug('  -------------------- CONFIRMACION ORDENES OK --------------------');
                for(CRAN_VEC_ADV_OrderPrintList_CLS ordenesRs : results.orderList){ 
                    mapOrdersOkConfirm.put(ordenesRs.orderNr, mapOrders.get(ordenesRs.orderNr));                    
                    mapOrders.remove(ordenesRs.orderNr);
                    mapAutomaticOrders.remove(ordenesRs.orderNr);
                }
            } else {
                System.debug( ' -------------------- ERROR EN EL SERVICIO -------------------- ');
                System.debug('ERROR : ' + Label.CRAN_VEC_ADV_IP_MSG_Error);
                errorConfirm = Label.CRAN_VEC_ADV_IP_MSG_Error;
                if(!listOrders.isEmpty() && listOrders[0].OpportunityId != null && listOrders[0].Opportunity.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c != null){
                    CRAN_VEC_ADV_ESignatureTriggerUtil.sendNotifications(null, Label.CRAN_VEC_ADV_IP_MSG_Error, false, null, listOrders[0].Opportunity.Name, 
                                                                          mapObIdTargetId.get(listOrders[0].Id), listOrders[0].Opportunity.FinServ__FinancialAccount__r.CRAS_ICA_ASS_F_FullName__c);
                }                
            }

    }


    public void manageResultChangeStatus(CRAN_VEC_ADV_OrderConfirm_RS results){

        if (results != null && results.errors != null) {
            Map<String, Order> mapOrdersOk;
            if(results.orderList != null){
                mapOrdersOk = new Map<String, Order>();                   
                for(CRAN_VEC_ADV_OrderPrintList_CLS ordenesRs : results.orderList){
                    mapOrdersOk.put(ordenesRs.orderNr, mapOrders.get(ordenesRs.orderNr));                       
                    mapOrders.remove(ordenesRs.orderNr);
                }              
            }
            if(!mapOrders.isEmpty()){
                System.debug( ' -------------------- ERROR EN EL SERVICIO -------------------- ');
                System.debug('ERROR : ' + CRAN_VEC_ADV_Utils.getAllErrorsService(results.errors));
            } 
            CRAN_VEC_ADV_ESignatureTriggerUtil.updateOrderErrorJob(CRAN_VEC_ADV_Utils.getAllErrorsService(results.errors), mapOrders, mapOrdersOk, true);
        } else if (results != null && results.errors == null && results.orderList != null) {
            CRAN_VEC_ADV_ESignatureTriggerUtil.updateOrderError(null, mapOrders, true);
            System.debug('  -------------------- CAMBIO DE ESTADO OK --------------------');
        } else {
            System.debug( ' -------------------- ERROR EN EL SERVICIO -------------------- ');
            System.debug('ERROR : ' + Label.CRAN_VEC_ADV_IP_MSG_Error);
            CRAN_VEC_ADV_ESignatureTriggerUtil.updateOrderError(Label.CRAN_VEC_ADV_IP_MSG_Error, mapOrders, true);              
        }
    }

}