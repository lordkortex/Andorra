public with sharing class CRAN_VEC_ADV_New_Proposition_AUC {

    @AuraEnabled
    public static String checkValidation(String financialAccountId){

        List<Option> lstMethod;
        List<Option> lstCurrency;
        SuccessInitResponse responseSuccess;

        FinServ__FinancialAccount__c myFAccount= [SELECT Id,CRAN_VEC_ADV_P_TypeProd__c,FinServ__PrimaryOwner__c, FinServ__PrimaryOwner__r.CRAN_VEC_ADV_B_AdvAccount__c FROM FinServ__FinancialAccount__c WHERE Id= :financialAccountId];

        //recupero currency
        Schema.DescribeFieldResult fieldResultCurrency = Opportunity.CRAN_VEC_ADV_P_Currency__c.getDescribe();
        List<Schema.PicklistEntry> listCurrency = fieldResultCurrency.getPicklistValues();
        System.debug('my listCurrency '+listCurrency);  

        //recupero Investment
        Schema.DescribeFieldResult fieldResultInvestment = Opportunity.CRAN_VEC_ADV_P_InvMethod__c.getDescribe();
        List<Schema.PicklistEntry> listInvestment = fieldResultInvestment.getPicklistValues();
        System.debug('my listInvestment '+listInvestment);  

        lstMethod = getMethodSelect(listInvestment);
        lstCurrency = getMethodSelect(listCurrency);
                   
        responseSuccess = new SuccessInitResponse(lstMethod,lstCurrency,true);

        return JSON.serialize(responseSuccess);
    }
        

    public static List<CRAN_VEC_ADV_Investment_Proposition_Line__c> recorreArbol(List<CRAN_VEC_ADV_CalcRebalpNodeListRS> nodeList,integer nivel, List<CRAN_VEC_ADV_Investment_Proposition_Line__c> myMap,String nameCurrency){
        for(CRAN_VEC_ADV_CalcRebalpNodeListRS element : nodeList){            
            if(element!=null && element.getNodeDet()!=null){
                System.debug(element.getNodeDet().getName()+' nivel '+nivel);
                List<CRAN_VEC_ADV_Investment_Proposition_Line__c> temp3;

                if(element.getNodeDet().getNodeId().getNodeType().equals('node')){                    
                    myMap.add(new CRAN_VEC_ADV_Investment_Proposition_Line__c(Name = element.getNodeDet().getName(),CRAN_VEC_ADV_T_Rating__c = CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRat(),255),CRAN_VEC_ADV_T_NodeId__c = element.getNodeDet().getNodeId().getValue() ,CRAN_VEC_ADV_N_PropAccrual__c=element.getNodeDet().getCpfAccr() ,CRAN_VEC_ADV_N_MPF__c=element.getNodeDet().getMpfPerc(),CRAN_VEC_ADV_N_PercentQtty__c=element.getNodeDet().getCpfPerc(),CRAN_VEC_ADV_N_PropMktValue__c=element.getNodeDet().getCpfMktVal(), CRAN_VEC_ADV_P_nodeType__c='node',CRAN_VEC_ADV_T_Remark__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRemark(),255),CRAN_VEC_ADV_N_PropMktValueBK__c=element.getNodeDet().getCpfMktVal(),CRAN_VEC_ADV_N_PercentQttyBK__c=element.getNodeDet().getCpfPerc(),CRAN_VEC_ADV_P_ChangedField__c='Null',CRAN_VEC_ADV_N_Level__c=nivel,CRAN_VEC_ADV_T_RestrInfo__c= CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRestrInfo(),255),CRAN_VEC_ADV_T_RestrIcon__c = element.getNodeDet().getRestrIcon()));


                } else if(element.getNodeDet().getNodeId().getNodeType().equals('pos')){
                            if(!nameCurrency.equals('000'))
                                myMap.add(new CRAN_VEC_ADV_Investment_Proposition_Line__c(Name = element.getNodeDet().getName(),CRAN_VEC_ADV_P_PFMMktCat__c = element.getNodeDet().getPfmMarketCatId(),CRAN_VEC_ADV_T_Rating__c = CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRat(),255),CRAN_VEC_ADV_N_Price__c = element.getNodeDet().getPrice(),CRAN_VEC_ADV_B_isEdit__c=element.getNodeDet().getIsEdit(),CRAN_VEC_ADV_T_RestrIcon__c=element.getNodeDet().getRestrIcon(),CRAN_VEC_ADV_T_RestrInfo__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRestrInfo(),255),CRAN_VEC_ADV_T_NodeId__c = element.getNodeDet().getNodeId().getValue(),CRAN_VEC_ADV_T_Key__c=element.getNodeDet().getAssetBuId()+'_'+element.getNodeDet().getAssetId(),CRAN_VEC_ADV_P_Currency__c=nameCurrency,CRAN_VEC_ADV_B_Extl__c=element.getNodeDet().getExtl(),CRAN_VEC_ADV_B_AggrPosition__c=element.getNodeDet().getAggrPos(),CRAN_VEC_ADV_N_PercentQtty__c=element.getNodeDet().getSpfPerc(),CRAN_VEC_ADV_N_PropQtty__c=element.getNodeDet().getCpfqty(),CRAN_VEC_ADV_N_PropMktValue__c=element.getNodeDet().getCpfMktVal(),CRAN_VEC_ADV_L_Assets__r = new FinServ__Securities__c(FinServ__SourceSystemId__c = element.getNodeDet().getAssetBuId()+'_'+element.getNodeDet().getAssetId()), CRAN_VEC_ADV_P_nodeType__c='pos',CRAN_VEC_ADV_T_Remark__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRemark(),255),CRAN_VEC_ADV_N_PropMktValueBK__c=element.getNodeDet().getCpfMktVal(),CRAN_VEC_ADV_N_PropMktValueBKK__c=element.getNodeDet().getCpfMktVal(),CRAN_VEC_ADV_N_PropQttyBK__c=element.getNodeDet().getCpfqty(),CRAN_VEC_ADV_N_PropQttyBKK__c=element.getNodeDet().getCpfqty(),CRAN_VEC_ADV_N_PercentQttyBK__c=element.getNodeDet().getSpfPerc(),CRAN_VEC_ADV_N_PercentQttyBKK__c=element.getNodeDet().getSpfPerc(),CRAN_VEC_ADV_T_RemarkBK__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRemark(),255),CRAN_VEC_ADV_T_RemarkBKK__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRemark(),255),CRAN_VEC_ADV_P_ChangedField__c='Null',CRAN_VEC_ADV_N_Level__c=nivel,CRAN_VEC_ADV_N_PortfolioQtty__c = element.getNodeDet().getSpfQty()));
                            else
                                myMap.add(new CRAN_VEC_ADV_Investment_Proposition_Line__c(Name = element.getNodeDet().getName(),CRAN_VEC_ADV_P_PFMMktCat__c = element.getNodeDet().getPfmMarketCatId(),CRAN_VEC_ADV_T_Rating__c = CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRat(),255),CRAN_VEC_ADV_N_Price__c = element.getNodeDet().getPrice(),CRAN_VEC_ADV_B_isEdit__c=element.getNodeDet().getIsEdit(),CRAN_VEC_ADV_T_RestrIcon__c=element.getNodeDet().getRestrIcon(),CRAN_VEC_ADV_T_RestrInfo__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRestrInfo(),255),CRAN_VEC_ADV_T_NodeId__c = element.getNodeDet().getNodeId().getValue(),CRAN_VEC_ADV_T_Key__c=element.getNodeDet().getAssetBuId()+'_'+element.getNodeDet().getAssetId(),CRAN_VEC_ADV_B_Extl__c=element.getNodeDet().getExtl(),CRAN_VEC_ADV_B_AggrPosition__c=element.getNodeDet().getAggrPos(),CRAN_VEC_ADV_N_PercentQtty__c=element.getNodeDet().getSpfPerc(),CRAN_VEC_ADV_N_PropQtty__c=element.getNodeDet().getCpfqty(),CRAN_VEC_ADV_N_PropMktValue__c=element.getNodeDet().getCpfMktVal(),CRAN_VEC_ADV_L_Assets__r = new FinServ__Securities__c(FinServ__SourceSystemId__c = element.getNodeDet().getAssetBuId()+'_'+element.getNodeDet().getAssetId()), CRAN_VEC_ADV_P_nodeType__c='pos',CRAN_VEC_ADV_T_Remark__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRemark(),255),CRAN_VEC_ADV_N_PropMktValueBK__c=element.getNodeDet().getCpfMktVal(),CRAN_VEC_ADV_N_PropMktValueBKK__c=element.getNodeDet().getCpfMktVal(),CRAN_VEC_ADV_N_PropQttyBK__c=element.getNodeDet().getCpfqty(),CRAN_VEC_ADV_N_PropQttyBKK__c=element.getNodeDet().getCpfqty(),CRAN_VEC_ADV_N_PercentQttyBK__c=element.getNodeDet().getSpfPerc(),CRAN_VEC_ADV_N_PercentQttyBKK__c=element.getNodeDet().getSpfPerc(),CRAN_VEC_ADV_T_RemarkBK__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRemark(),255),CRAN_VEC_ADV_T_RemarkBKK__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(element.getNodeDet().getRemark(),255),CRAN_VEC_ADV_P_ChangedField__c='Null',CRAN_VEC_ADV_N_Level__c=nivel,CRAN_VEC_ADV_N_PortfolioQtty__c = element.getNodeDet().getSpfQty()));                            
                }
                    
            }
                
            if(element!=null && element.getNodeList()!=null){
                recorreArbol(element.getNodeList(),nivel+1,myMap,nameCurrency);
            }
        }

        return myMap;
    }



    @AuraEnabled
    public static Object nuevaProposition(String financialAccountId, String nameOpportunity,String nameMethod, String nameCurrency, String nameAmount){
        
        List<CRAN_VEC_ADV_Investment_Proposition_Line__c> myMap = new List<CRAN_VEC_ADV_Investment_Proposition_Line__c>();
        List<CRAN_VEC_ADV_Investment_Proposition_Line__c> myMapReturn = new List<CRAN_VEC_ADV_Investment_Proposition_Line__c>();
        CRAN_VEC_ADV_Investment_Proposition_Line__c elemenLevel0;

        try{

                String myNameAmount = '';

                FinServ__FinancialAccount__c myFAccount= [SELECT Id,CRAN_VEC_DEV_T_ContainerID__c, CRAN_ICA_KER_P_Oficina__c,CRAN_VEC_ADV_P_Bunit__c,FinServ__PrimaryOwner__r.Id FROM FinServ__FinancialAccount__c WHERE Id= :financialAccountId];

                Decimal valueAmount;

                //patonr  que comprueba que tiene numeros decimales y enteros con  comas y puntos
                Pattern numberFormat = Pattern.Compile('[-+]?([0-9]*[.,][0-9]+|[0-9]+)'); 
                Matcher numberMatch = numberFormat.matcher(nameAmount);

                if(nameAmount!=null && nameAmount!='' && numberMatch.Matches()){
                    System.debug('entra');
                    valueAmount = Decimal.valueOf(nameAmount);
                    myNameAmount = nameAmount;
                }


                ///////// LLAMADA AL SERVICIO NUEVA PROPUESTA /////////
                CRAN_VEC_ADV_NewRebalpRQ rq = new CRAN_VEC_ADV_NewRebalpRQ();

                //entrada de parametros//
                rq.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));

                List<CRAN_VEC_ADV_ObjList_CLS> objList = new List<CRAN_VEC_ADV_ObjList_CLS>();
                CRAN_VEC_ADV_ObjList_CLS obj = new CRAN_VEC_ADV_ObjList_CLS();
                obj.setObjType('cont');
                List<CRAN_VEC_ADV_Obj_CLS> aux2 = new List<CRAN_VEC_ADV_Obj_CLS>();
                CRAN_VEC_ADV_Obj_CLS aux1 = new CRAN_VEC_ADV_Obj_CLS();
                aux1.setAvqId(CRAN_VEC_ADV_Utils.getIdAvaloq(myFAccount.CRAN_VEC_DEV_T_ContainerID__c));
                aux2.add(aux1);
                obj.setObj(aux2);
                objList.add(obj);
                rq.setObjList(objList);

                rq.setRebalMethod(nameMethod);
                
                if(!myNameAmount.equals('')){ 
                    rq.setInvstAmount(myNameAmount);                
                    if(!nameCurrency.equals('000')) 
                        rq.setInvstCurry(nameCurrency);
                }


                //fin entrada de parametros//
                String jsonRequest = JSON.serialize(rq);

                String bu = myFAccount.CRAN_VEC_ADV_P_Bunit__c;

                CRAN_VEC_ADV_RestClient_CLS restClient = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_NUEVA_OPORTUNIDAD,bu,jsonRequest);

                CRAN_VEC_ADV_RebalpRS results = (CRAN_VEC_ADV_RebalpRS)JSON.deserialize(restClient.responseBody, CRAN_VEC_ADV_RebalpRS.class);

                ///////// FIN LLAMADA AL SERVICIO NUEVA PROPUESTA /////////


                if(results !=null && results.getErrors() != null){
                           return JSON.serialize(new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(results.getErrors())));   
                } else if (results!=null && results.getErrors()==null && results.getOrder()!=null){

                        ///////// LLAMADA AL SERVICIO CALCULAR/////////

                        CRAN_VEC_ADV_CalcRebalpRQ rqCalc = new CRAN_VEC_ADV_CalcRebalpRQ();

                        //entrada de parametros//
                        //MIGUEL IDIOMA FAIL REVISAR
                        rq.setLang(CRAN_VEC_ADV_Utils.getUserLanguage(UserInfo.getLanguage()));

                        CRAN_VEC_ADV_Order_CLS myOrder = new CRAN_VEC_ADV_Order_CLS();
                        myOrder.setOrderNr(results.getOrder().getOrderNr());
                        rqCalc.setOrder(myOrder);

                        rqCalc.setPrintMode('none');

                        //fin entrada de parametros//
                        String jsonRequestCalc = JSON.serialize(rqCalc);

                        System.debug('jsonRequestCalc' + rqCalc);

                        //peticion post
                        CRAN_VEC_ADV_RestClient_CLS restClientCalc = new CRAN_VEC_ADV_RestClient_CLS(CRAN_VEC_ADV_Constants_CLS.SERVICE_CALCULAR_OPORTUNIDAD,bu,jsonRequestCalc);
                    
                        System.debug('restClientCalc '+restClientCalc.responseBody);

                        CRAN_VEC_ADV_CalcRebalpRS resultsCalc = (CRAN_VEC_ADV_CalcRebalpRS)JSON.deserialize(restClientCalc.responseBody, CRAN_VEC_ADV_CalcRebalpRS.class);

                        System.debug('resultsCalc '+resultsCalc);
                        ///////// FIN LLAMADA AL SERVICIO CALCULAR/////////

                        if(resultsCalc !=null && resultsCalc.getErrors() != null){
                            return JSON.serialize(new ErrorResponse(CRAN_VEC_ADV_Utils.getAllErrorsService(resultsCalc.getErrors())));   
                        }else if(resultsCalc!=null && (resultsCalc.getVersionList()==null || resultsCalc.getOrder()==null)){
                           return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Calculate));
                        } else if(resultsCalc!=null && resultsCalc.getErrors()==null && resultsCalc.getVersionList()!=null && resultsCalc.getOrder()!=null){
                            myMap = new List<CRAN_VEC_ADV_Investment_Proposition_Line__c>();

                            //CREO OPPORTUNITY
                            List<RecordType> invsPropRecordType = CRAN_VEC_ADV_Constants_CLS.INVSPROP_RECORDTYPE;
                            //Create a map between the Record Type SobjectType and Id for easy retrieval
                            Map<String,Id> recordTypesMap = new Map<String,Id>();
                            for(RecordType rt: invsPropRecordType){
                                recordTypesMap.put(rt.SobjectType,rt.Id);
                            }

                            Opportunity myOpportunity;

                            if(!numberMatch.Matches() && myNameAmount==''){
                                myOpportunity = new Opportunity(CRAN_VEC_ADV_T_AvaloqPropId__c=results.getOrder().getOrderNr(),CRAN_ICA_KER_P_Oficina__c = myFAccount.CRAN_ICA_KER_P_Oficina__c,CRAN_VEC_ADV_N_OrderList__c=0,Name=nameOpportunity,CRAN_VEC_ADV_P_Bunit__c=bu,RecordTypeId = recordTypesMap.get('Opportunity'),StageName='advOpen',CloseDate=Date.today().addDays(30),CRAN_VEC_ADV_P_InvMethod__c=nameMethod,CRAN_VEC_ADV_D_StartDate__c=Date.today(),AccountId=myFAccount.FinServ__PrimaryOwner__r.Id,FinServ__FinancialAccount__c=financialAccountId);
                                insert myOpportunity; 

                            } else {
                                myOpportunity = new Opportunity(CRAN_VEC_ADV_T_AvaloqPropId__c=results.getOrder().getOrderNr(),CRAN_ICA_KER_P_Oficina__c = myFAccount.CRAN_ICA_KER_P_Oficina__c,CRAN_VEC_ADV_N_OrderList__c=0,Name=nameOpportunity,CRAN_VEC_ADV_P_Bunit__c=bu,RecordTypeId = recordTypesMap.get('Opportunity'),CRAN_VEC_ADV_N_InvAmount__c=valueAmount,StageName='advOpen',CloseDate=Date.today().addDays(30),CRAN_VEC_ADV_P_Currency__c=nameCurrency,CRAN_VEC_ADV_P_InvMethod__c=nameMethod,CRAN_VEC_ADV_D_StartDate__c=Date.today(),AccountId=myFAccount.FinServ__PrimaryOwner__r.Id,FinServ__FinancialAccount__c=financialAccountId);
                                insert myOpportunity;
                            }

                            // se ejecuta para cada version list
                            for(CRAN_VEC_ADV_CalcRebalpVersionRS myVersion: resultsCalc.getVersionList()){ 

                                System.debug('entra bucle');
                                //inserto nivel 0
                                elemenLevel0 = new CRAN_VEC_ADV_Investment_Proposition_Line__c(Name = CRAN_VEC_ADV_Utils.subStrMaxLongi(myVersion.getNode().getNodeDet().getName(),80),CRAN_VEC_ADV_T_Rating__c = CRAN_VEC_ADV_Utils.subStrMaxLongi(myVersion.getNode().getNodeDet().getRat(),255),CRAN_VEC_ADV_T_NodeId__c = myVersion.getNode().getNodeDet().getNodeId().getValue(),CRAN_VEC_ADV_N_PropAccrual__c=myVersion.getNode().getNodeDet().getCpfAccr() ,CRAN_VEC_ADV_N_MPF__c=myVersion.getNode().getNodeDet().getMpfPerc(),CRAN_VEC_ADV_N_PercentQtty__c=myVersion.getNode().getNodeDet().getCpfPerc(),CRAN_VEC_ADV_N_PropMktValue__c=myVersion.getNode().getNodeDet().getCpfMktVal(), CRAN_VEC_ADV_P_nodeType__c='node',CRAN_VEC_ADV_T_Remark__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(myVersion.getNode().getNodeDet().getRemark(),255),CRAN_VEC_ADV_N_PropMktValueBK__c=myVersion.getNode().getNodeDet().getCpfMktVal(),CRAN_VEC_ADV_N_PercentQttyBK__c=myVersion.getNode().getNodeDet().getCpfPerc(),CRAN_VEC_ADV_P_ChangedField__c='Null',CRAN_VEC_ADV_N_Level__c=0,CRAN_VEC_ADV_N_Secuence__c=1,CRAN_VEC_ADV_T_RestrInfo__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(myVersion.getNode().getNodeDet().getRestrInfo(),255),CRAN_VEC_ADV_T_RestrIcon__c=myVersion.getNode().getNodeDet().getRestrIcon());                

                                CRAN_VEC_ADV_CalcRebalpNodeRS node = myVersion.getNode();
                                myMapReturn = recorreArbol(node.getNodeList(),1,myMap,nameCurrency);

                                Quote myQuote;

                                if(!numberMatch.Matches() && myNameAmount==''){
                                    myQuote = new Quote(Name=CRAN_VEC_ADV_Utils.subStrMaxLongi(nameOpportunity,77)+'_v1',CRAN_VEC_ADV_P_Quote_ID__c=myVersion.getId(),status='Synchronized',CRAN_VEC_ADV_P_Bunit__c=bu,CRAN_VEC_ADV_N_Version__c=decimal.valueof('1'), OpportunityId=myOpportunity.Id,CRAN_VEC_ADV_D_StartDate__c=Date.today(),CRAN_VEC_ADV_B_OverrideAll__c=false,CRAN_VEC_ADV_B_Final__c=true,CRAN_VEC_ADV_B_FinalBK__c=true, RecordTypeId = recordTypesMap.get('Quote'));
                                    insert myQuote;
                                } else{
                                    myQuote = new Quote(Name=CRAN_VEC_ADV_Utils.subStrMaxLongi(nameOpportunity,77)+'_v1',CRAN_VEC_ADV_P_Quote_ID__c=myVersion.getId(),status='Synchronized',CRAN_VEC_ADV_P_Bunit__c=bu,CRAN_VEC_ADV_N_Version__c=decimal.valueof('1'), OpportunityId=myOpportunity.Id,CRAN_VEC_ADV_P_Currency__c=nameCurrency,CRAN_VEC_ADV_N_InvAmount__c=valueAmount,CRAN_VEC_ADV_N_InvAmountBKK__c =valueAmount,CRAN_VEC_ADV_D_StartDate__c=Date.today(),CRAN_VEC_ADV_B_OverrideAll__c=false,CRAN_VEC_ADV_B_Final__c=true,CRAN_VEC_ADV_B_FinalBK__c=true,CRAN_VEC_ADV_P_CurrencyBK__c=nameCurrency,CRAN_VEC_ADV_P_CurrencyBKK__c=nameCurrency,CRAN_VEC_ADV_N_InvAmountBK__c=valueAmount, RecordTypeId = recordTypesMap.get('Quote'));
                                    insert myQuote;
                                }
                                //************CODIGO PRUEBA**************//
                                List<CRAN_VEC_ADV_Investment_Proposition_Line__c> finalListLines = new List<CRAN_VEC_ADV_Investment_Proposition_Line__c>();

                                integer mySec = 1;
                                //relleno campos que faltan en las lineas antes de insertar
                                if(elemenLevel0!=null){
                                    elemenLevel0.CRAN_VEC_ADV_L_Version__c = myQuote.Id;
                                    elemenLevel0.CRAN_VEC_ADV_L_Proposition__c = myOpportunity.Id;
                                    elemenLevel0.RecordTypeId = recordTypesMap.get('CRAN_VEC_ADV_Investment_Proposition_Line__c');
                                    elemenLevel0.CRAN_VEC_ADV_N_Secuence__c = mySec;
                                    finalListLines.add(elemenLevel0);
                                }

                                for(CRAN_VEC_ADV_Investment_Proposition_Line__c myLine : myMapReturn){
                                    mySec = mySec+1;
                                    myLine.CRAN_VEC_ADV_L_Version__c = myQuote.Id;
                                    myLine.CRAN_VEC_ADV_L_Proposition__c = myOpportunity.Id;
                                    myLine.RecordTypeId = recordTypesMap.get('CRAN_VEC_ADV_Investment_Proposition_Line__c');
                                    myLine.CRAN_VEC_ADV_N_Secuence__c = mySec;
                                    if(myLine.CRAN_VEC_ADV_P_nodeType__c!=null && myLine.CRAN_VEC_ADV_P_nodeType__c=='pos'){
                                        if(myLine.CRAN_VEC_ADV_T_Key__c!=null && myLine.CRAN_VEC_ADV_T_Key__c!='')
                                            myLine.CRAN_VEC_ADV_T_Key__c = myQuote.Id+myLine.CRAN_VEC_ADV_T_Key__c;
                                        if(!nameCurrency.equals('000')) 
                                            myLine.CRAN_VEC_ADV_P_Currency__c = nameCurrency;

                                    }
                                    finalListLines.add(myLine);
                                }

                                for(CRAN_VEC_ADV_Investment_Proposition_Line__c myLine2 : finalListLines){
                                    System.debug(myLine2.Name+' '+ myLine2.CRAN_VEC_ADV_N_Secuence__c+' '+myLine2.CRAN_VEC_ADV_N_Level__c);
                                }

                                CRAN_VEC_KER_TriggerHandler_CLS.bypass('CRAN_VEC_ADV_IPLTriggerHandler_CLS');
                                insert finalListLines;

                                // INSERCION DE RESTRICCIONES //
                                List<CRAN_VEC_ADV_IPL_Restriction__c> restList = new List<CRAN_VEC_ADV_IPL_Restriction__c>();

                                if(myVersion!=null && myVersion.getRestrList()!=null){
                                    List<CRAN_VEC_ADV_CalcRebalpRestrictionRS> myListRestriction = myVersion.getRestrList();

                                    for(CRAN_VEC_ADV_CalcRebalpRestrictionRS elementRestriction : myListRestriction){
                                        restList.add(new CRAN_VEC_ADV_IPL_Restriction__c(Name = CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getName(),80),CRAN_VEC_ADV_T_RestrictionId__c= elementRestriction.getId(),CRAN_VEC_ADV_L_Version__c = myQuote.Id, RecordTypeId = recordTypesMap.get('CRAN_VEC_ADV_IPL_Restriction__c'), CRAN_VEC_ADV_L_Proposition__c = myOpportunity.Id,CRAN_VEC_ADV_T_RestrictionTypeName__c = CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getTypeName(),255),CRAN_VEC_ADV_T_TopRestriction__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getTopRestr(),255),CRAN_VEC_ADV_T_EvalResult__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getEvalResult(),255),CRAN_VEC_ADV_T_Remark__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getRemark(),255),CRAN_VEC_ADV_T_ViolObject__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getViolObj(),255),CRAN_VEC_ADV_T_ViolClass__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getViolClass(),255),CRAN_VEC_ADV_T_ViolValue__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getViolValue(),255),CRAN_VEC_ADV_T_ValueFrom__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getValueFrom(),255),CRAN_VEC_ADV_T_ValueTo__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getValueTo(),255),CRAN_VEC_ADV_T_Priority__c = CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getPrio(),255),CRAN_VEC_ADV_B_Override__c=elementRestriction.getOverrideRestr(),CRAN_VEC_ADV_B_OverrideBK__c=elementRestriction.getOverrideRestr(),CRAN_VEC_ADV_B_OverrideBKK__c=elementRestriction.getOverrideRestr(),CRAN_VEC_ADV_T_Justification__c=CRAN_VEC_ADV_Utils.subStrMaxLongi(elementRestriction.getJustif(),255)));
                                    }

                                    insert restList;
                                }
                                // FIN INSERCION DE RESTRICCIONES //
                            }    
                            return JSON.serialize(new SuccessResponseNewOpportunity(myOpportunity));
                        }else{
                            return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_IP_MSG_ERR_B_Calculate));
                        }
                                
                } else{
                    return JSON.serialize(new ErrorResponse(Label.CRAN_VEC_ADV_ErrorNewProposition));
                }
        
        }catch(Exception e){
            System.debug('Exception --> e' + e);
            return JSON.serialize(new ErrorResponse(e.getMessage()));
        }                


    }

    
    @TestVisible
    class ErrorResponse {
        @AuraEnabled public Boolean success {get; set;}
        @AuraEnabled public Integer lineNumber {get; set;}
        @AuraEnabled public String messageError {get; set;}
        @AuraEnabled public String typeError {get; set;}
        @AuraEnabled public String stackTrace {get; set;}

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

    }


    @AuraEnabled
    public static Integer randomWithLimit(Integer upperLimit){
        Integer rand = Math.round(Math.random()*1000);
        return Math.mod(rand, upperLimit);
    }


    public static List<Option> getMethodSelect(List<Schema.PicklistEntry> listInvestment){
        List<Option> lstOptions = new List<Option>();
                                              
        lstOptions.add(new Option('000', '--None--'));

        for(Schema.PicklistEntry element: listInvestment){
            if(element.isActive()){
                lstOptions.add(new Option(element.getLabel(), element.getLabel()));
            }
        }

        return lstOptions;
    }


    class Option{
        public String label;
        public String value;

        public Option(String value, String label){
            this.value = value;
            this.label = label;
            
        }
    }


    class SuccessInitResponse{
        public Boolean success = true;
        public Boolean check = true;
        public List<Option> optionsMethod;
        public List<Option> optionsCurrency;

        public SuccessInitResponse(List<Option> optionsMethod, List<Option> optionsCurrency,Boolean check){
            this.success = true;
            this.optionsMethod = optionsMethod;
            this.optionsCurrency = optionsCurrency;
            this.check = check;
        }
    }


    @TestVisible
    class SuccessResponseNewOpportunity {

        @AuraEnabled public Boolean success {get; set;}
        @AuraEnabled public SObject obj {get; set;}

        public SuccessResponseNewOpportunity(Opportunity obj) {
            this.success = true;
            this.obj = obj;
        }
    }

}