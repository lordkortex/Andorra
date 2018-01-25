public class CRAS_ICA_ASS_VentasObjetivos_CTR {
    
    private static String ALTA = '101ASS';
    private static String BAJA = '102ASS';
    
    public static List<String> getVentasObjetivos(){
        List<String> result = new List<String>();
        CRAS_ICA_ASS_InsuranceGlobal_CS__c  gCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
        List<List<String>> resultList = new List<List<String>>();
                
        //determinar si por rol debe mostrar doble gráfico (oficina 995)
        Boolean showDoubleBar = CRAS_ICA_ASS_Helpers_CLS.gerenciaSegurosRolesList.containsKey(CRAS_ICA_ASS_Helpers_CLS.getUserRolDevName());
        Boolean showCampaignReal = CRAS_ICA_ASS_Helpers_CLS.viewAllRolesList.containsKey(CRAS_ICA_ASS_Helpers_CLS.getUserRolDevName());
        
        String healthCode = CRAS_ICA_ASS_Helpers_CLS.healthMKTCode;
        
        //obtener objetivos (ramo salud)
        List<AggregateResult> arLst2 = Database.query(getObjetivosQuery(healthCode, false, ''));
        AggregateResult ar2 = arLst2[0];
        
        //obtener campaña asociada
        Campaign c = getCurrentCampaign();
        
        //obtener ventas (ramo salud)
        String customLogic = 'AND (CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c= \'' + healthCode + '\' ' +
            'OR CRAN_ICA_KER_MD_FinancialAccount__r.CRAS_ICA_ASS_T_ProductId__c = \'' + CRAS_ICA_ASS_Helpers_CLS.PROD_CREDIT_BAIXA_ID + '\') ' +
            'AND CRAN_ICA_KER_MD_FinancialAccount__r.CRAS_ICA_ASS_T_ProductId__c != \'' + CRAS_ICA_ASS_Helpers_CLS.PROD_ASISTENCIA_SANITARIA_ID + '\''; 
        List<AggregateResult> arLst = Database.query(getQuery(healthCode, ALTA, c.startDate, c.endDate, oficinasComercial(), customLogic, '', 1));
        
        String customLogicMinus = customLogic + ' AND CRAS_ICA_ASS_F_EsBajaDescuento__c = true';            
        List<AggregateResult> arLstMinus = Database.query(getQuery(healthCode, BAJA, c.startDate, c.endDate, oficinasComercial_995(), customLogicMinus, '', 1));
        
        updateResult(result, arLst, arLstMinus, arLst2, true, healthCode);
        
        if(showDoubleBar){
            arLst = Database.query(getQuery(healthCode, ALTA, c.startDate, c.endDate, new List<string>{CRAS_ICA_ASS_Helpers_CLS.OFICINA_SEGUROS_995}, customLogic, '', 2));
            arLstMinus = Database.query(getQuery(healthCode, BAJA, c.startDate, c.endDate, oficinasComercial_995(), customLogicMinus, '', 2));
            arLst2 = Database.query(getObjetivosQuery(healthCode, true, ''));
            
            updateResult(result, arLst, arLstMinus, arLst2, false, healthCode, false);
            result.add('DoubleBar');
        } else {
            result.add('0');
            result.add('0');
            result.add('noDoubleBar');
        }
        
        if(showCampaignReal){
            result.add(String.valueOf(c.CRAS_ICA_ASS_C_RealTargetHealth__c));
        } else {
            result.add('noCampaignReal');
        }
        
        return result;
    }
    /* --------------------------------------------------- LIFE -------------------------------------------
* -----------------------------------------------------------------------------------------------------*/
    
    public static List<String> getVentasObjetivosLife(){
        
        CRAS_ICA_ASS_InsuranceGlobal_CS__c  gCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
        List<String> result = new List<String>();
        List<List<String>> resultList = new List<List<String>>();
        String lifeCode = CRAS_ICA_ASS_Helpers_CLS.lifeMKTCode;
        
        //determinar si por rol debe mostrar doble gráfico (oficina 995)
        Boolean showDoubleBar = CRAS_ICA_ASS_Helpers_CLS.gerenciaSegurosRolesList.containsKey(CRAS_ICA_ASS_Helpers_CLS.getUserRolDevName());
        Boolean showCampaignReal = CRAS_ICA_ASS_Helpers_CLS.viewAllRolesList.containsKey(CRAS_ICA_ASS_Helpers_CLS.getUserRolDevName());
        
        //obtener objetivos (ramo salud)
        List<AggregateResult> arLst2 = Database.query(getObjetivosQuery(lifeCode, false, ''));
        AggregateResult ar2 = arLst2[0];
        
        //obtener campaña asociada
        Campaign c = getCurrentCampaign();
        
        //obtener ventas (ramo salud)        
        String customLogic = 'AND CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c= \'' + lifeCode + '\''; 
        List<AggregateResult> arLst = Database.query(getQuery(lifeCode, ALTA, c.startDate, c.endDate, oficinasComercial(), customLogic, '', 1));
        
        String customLogicMinus = customLogic + ' AND CRAS_ICA_ASS_F_EsBajaDescuento__c = true';
        
        List<AggregateResult> arLstMinus = Database.query(getQuery(lifeCode, BAJA, c.startDate, c.endDate, oficinasComercial_995(), customLogicMinus, '', 1));
        
        updateResult(result, arLst, arLstMinus, arLst2, true, lifeCode);

        if(showDoubleBar){
            arLst = Database.query(getQuery(lifeCode, ALTA, c.startDate, c.endDate, new List<string>{CRAS_ICA_ASS_Helpers_CLS.OFICINA_SEGUROS_995}, customLogic, '', 2));
            arLstMinus = Database.query(getQuery(lifeCode, BAJA, c.startDate, c.endDate, oficinasComercial_995(), customLogicMinus, '', 2));
            arLst2 = Database.query(getObjetivosQuery(lifeCode, true, ''));

            updateResult(result, arLst, arLstMinus, arLst2, false, lifeCode, false);
            result.add('DoubleBar');
        } else {
            result.add('0');
            result.add('0');
            result.add('noDoubleBar');
        }
        
        if(showCampaignReal){
            result.add(String.valueOf(c.CRAS_ICA_ASS_C_RealTargetLife__c));
        } else {
            result.add('noCampaignReal');
        }        
        
        return result;
    }
    
    /* --------------------------------------------------- SAVINGS -------------------------------------------
* -----------------------------------------------------------------------------------------------------*/    
    
    public static List<String> getVentasObjetivosSavings(){
        List<String> result = new List<String>();
        List<List<String>> resultList = new List<List<String>>();
        String savingsCode = CRAS_ICA_ASS_Helpers_CLS.savingsMKTCode;

        //determinar si por rol debe mostrar doble gráfico (oficina 995)
        Boolean showDoubleBar = CRAS_ICA_ASS_Helpers_CLS.gerenciaSegurosRolesList.containsKey(CRAS_ICA_ASS_Helpers_CLS.getUserRolDevName());
        Boolean showCampaignReal = CRAS_ICA_ASS_Helpers_CLS.viewAllRolesList.containsKey(CRAS_ICA_ASS_Helpers_CLS.getUserRolDevName());
        
        //obtener objetivos (ramo ahorro)
        String selectQry = 'sum(TotalOpportunityQuantity) qty, max (closeDate) maxdate';
        List<AggregateResult> arLst2 = Database.query(getObjetivosQuery(savingsCode, false, selectQry));
        AggregateResult ar2 = arLst2[0];

        //obtener campaña asociada
        Campaign c = getCurrentCampaign();    
        
        //obtener ventas (ramo ahorro)
        String customSelect = 'count(id) cnt, max(CRAN_ICA_KER_MovementDate__c) maxdate';
        
        String customLogic = 'AND CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c= \'' + savingsCode + '\' ' +
            				 'AND CRAS_ICA_ASS_P_CambioProducto__c != \'103ASS\''; 
        List<AggregateResult> arLst = Database.query(getQuery(savingsCode, ALTA, c.startDate, c.endDate, oficinasComercial(), customLogic, customSelect, 1));
        
        String customLogicMinus = customLogic + ' AND CRAS_ICA_ASS_F_EsBajaDescuento__c = true';
        List<AggregateResult> arLstMinus = Database.query(getQuery(savingsCode, BAJA, c.startDate, c.endDate, oficinasComercial_995(), customLogicMinus, customSelect, 1));
     
        updateResult(result, arLst, arLstMinus, arLst2, false, savingsCode, 'cnt', 'qty', true);

        if(showDoubleBar){
            arLst = Database.query(getQuery(savingsCode, ALTA, c.startDate, c.endDate, new List<string>{CRAS_ICA_ASS_Helpers_CLS.OFICINA_SEGUROS_995}, customLogic, customSelect, 2));
            arLstMinus = Database.query(getQuery(savingsCode, BAJA, c.startDate, c.endDate, oficinasComercial_995(), customLogicMinus, customSelect, 2));
            arLst2 = Database.query(getObjetivosQuery(savingsCode, true, selectQry));
            
            updateResult(result, arLst, arLstMinus, arLst2, false, savingsCode, 'cnt', 'qty', false);
            result.add('DoubleBar');
        } else {
            result.add('0');
            result.add('0');
            result.add('noDoubleBar');
        }
        
        if(showCampaignReal){
            result.add(String.valueOf(c.CRAS_ICA_ASS_C_RealTargetSaving__c));
        } else {
            result.add('noCampaignReal');
        }
        
        return result;
    }
    
    public static List<String> oficinasComercial(){
        CRAS_ICA_ASS_InsuranceGlobal_CS__c  gCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
        return gCS.CRAS_ICA_ASS_OficinasBancaComercial__c.split(',');
    }
    
    public static List<String> oficinasComercial_995(){
        List<String> oficinasBajas = new List<String>();
        oficinasBajas.addAll(oficinasComercial());
        oficinasBajas.add(CRAS_ICA_ASS_Helpers_CLS.OFICINA_SEGUROS_995);
        return oficinasBajas;
    }
    
    public static Date getMaxDate(){
        CRAS_ICA_ASS_InsuranceGlobal_CS__c  gCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
        
        List<AggregateResult> arList = [SELECT max(closeDate) maxdate
                                        FROM OPPORTUNITY
                                        WHERE RecordTypeId = :gCS.CRAS_ICA_ASS_OppObjetivos_RT__c];
        
        Date result = (Date)arList.get(0).get('maxdate');
        
        return result;
    }
    
    public static Campaign getCurrentCampaign(){
        
        CRAS_ICA_ASS_InsuranceGlobal_CS__c  gCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
        
        List<Opportunity> cpL = [SELECT CampaignId
                                 FROM Opportunity
                                 WHERE RecordTypeId = :gCS.CRAS_ICA_ASS_OppObjetivos_RT__c
                                 AND closeDate = :getMaxDate()
                                 AND CRAN_ICA_KER_P_Oficina__c != :CRAS_ICA_ASS_Helpers_CLS.OFICINA_SEGUROS_995
                                 LIMIT 1
                                ];
        Id campaignId;
        
        if(cpL.size() > 0){
            campaignId = cpL.get(0).CampaignId;
        }
        
        List<Campaign> cL = [SELECT id, Name, StartDate, EndDate, CRAS_ICA_ASS_C_RealTargetHealth__c, CRAS_ICA_ASS_C_RealTargetLife__c, CRAS_ICA_ASS_C_RealTargetSaving__c
                             FROM Campaign
                             WHERE RecordTypeId = :gCS.CRAS_ICA_ASS_CampaignRT_ID__c
                             and id = :campaignId 
                            ];
        
        if(cL.size() > 0){
            return cL[0];
        } else {
            return null;
        }
    }
    
    public static void updateResult(List<String> result, List<AggregateResult> arLst, List<AggregateResult> arLstMinus, List<AggregateResult> arLst2, Boolean calcIncentivo, String ramo){
        updateResult(result, arLst, arLstMinus, arLst2, calcIncentivo, ramo, 'ventas', 'objetivos', true);
    }
    
    public static void updateResult(List<String> result, List<AggregateResult> arLst, List<AggregateResult> arLstMinus, List<AggregateResult> arLst2, Boolean calcIncentivo, String ramo, Boolean addDate){
        updateResult(result, arLst, arLstMinus, arLst2, calcIncentivo, ramo, 'ventas', 'objetivos', addDate);
    }
    
    public static void updateResult(List<String> result, List<AggregateResult> arLst, List<AggregateResult> arLstMinus, List<AggregateResult> arLst2, Boolean calcIncentivo, String ramo, String valName, String objName, Boolean addDate){
        
        CRAS_ICA_ASS_InsuranceGlobal_CS__c  gCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
        
        AggregateResult ar2 = null;
        
        if (arLst2.size() > 0){
            ar2 = arLst2[0];
        }
        
        if(arLst.size() > 0)
        {
            if(arLstMinus.size() > 0)
            {
                if(arLstMinus[0].get(valName) != null)
                {
                    Decimal calc = null;
                    if (ramo != CRAS_ICA_ASS_Helpers_CLS.savingsMKTCode){
                    	calc = (Decimal)arLst[0].get(valName) + (Decimal)arLstMinus[0].get(valName);    
                    }else {
                        calc = (Decimal)arLst[0].get(valName) - (Decimal)arLstMinus[0].get(valName);    
                    }
                    result.add(arLst[0].get(valName)!=null ? String.valueOf(calc) : String.valueOf((Decimal)arLstMinus[0].get(valName)));
                }
                else
                {
                    result.add(arLst[0].get(valName)!=null ? String.valueOf((Decimal)arLst[0].get(valName)) : '0');
                }
                
            }
            else
            {
                result.add(arLst[0].get(valName)!=null ? String.valueOf((Decimal)arLst[0].get(valName)) : '0');
            }
        }
        
        result.add((ar2 != null && ar2.get(objName)!=null) ? String.valueOf((Decimal)ar2.get(objName)) : '0');
        
        if (calcIncentivo && !CRAS_ICA_ASS_Helpers_CLS.filterDirector()){
            //añadimos los valores multiplicados por el porcentaje variables
            Decimal ventasPct = gCS.CRAS_ICA_ASS_PctVariable__c * Decimal.valueOf(result[0]);
            ventasPct = ventasPct < 0 ? 0 : ventasPct;
            result.add(String.valueOf(ventasPct.setScale(2)));
            Decimal objetivoPct = gCS.CRAS_ICA_ASS_PctVariable__c * Decimal.valueOf(result[1]);
            objetivoPct =  objetivoPct < 0 ? 0 : objetivoPct;
            result.add(String.valueOf(objetivoPct.setScale(2)));
        } else if (addDate) {
            result.add('0');
            result.add('0');
        }
        
        //añadimos la fecha máxima
        if (addDate){
            result.add((ar2 != null && ar2.get('maxdate')!=null) ? String.valueOf((Date)ar2.get('maxdate')).split(' ')[0] : '0');
        }
    }
  
    public static List<String> getCampaignUsers(String ramo, Integer canal){ //canal: 1 - Banca Comercial, 2 - Canal Directo (995)
        CRAS_ICA_ASS_InsuranceGlobal_CS__c  gCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();

        String filterOficina = '';
        if (canal == 1){
            filterOficina = 'AND CRAN_ICA_KER_P_Oficina__c != \'' + CRAS_ICA_ASS_Helpers_CLS.OFICINA_SEGUROS_995 + '\'';
        }
        else if (canal == 2){
            filterOficina = 'AND CRAN_ICA_KER_P_Oficina__c = \'' + CRAS_ICA_ASS_Helpers_CLS.OFICINA_SEGUROS_995 + '\' ';
        }
        if (CRAS_ICA_ASS_Helpers_CLS.filterDirector()){
            filterOficina = 'AND CRAN_ICA_KER_P_Oficina__c = \'' + CRAS_ICA_ASS_Helpers_CLS.getUserOffice() + '\' ';
        }
        
        String query = 'SELECT OwnerId ' +
            		   'FROM Opportunity ' + 
                       'WHERE RecordtypeId = \'' + gCS.CRAS_ICA_ASS_OppObjetivos_RT__c + '\' AND ' +
            				 'closedate = ' + CRAS_ICA_ASS_Helpers_CLS.getSOQLDate(getMaxDate()) + ' AND ' +
                             'CRAN_VEC_ADV_P_PFMMkt__c = \'' + ramo + '\' ' +
            				  filterOficina  + 
             		   'GROUP BY OwnerId';
        
        List<AggregateResult> oppOwners = Database.query(query);
        
        List<String> result = new List<String>();
        
        for (AggregateResult ar: oppOwners){
            result.add((String)ar.get('OwnerId'));
        }
        
        return result;
    }
        
    public static String getObjetivosQuery(String ramo, Boolean is995, String selectQry){
        
        CRAS_ICA_ASS_InsuranceGlobal_CS__c  gCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
        
        String defaultSelect = 'SUM(Amount) objetivos, max (closeDate) maxdate';        
        if (String.isNotBlank(selectQry)){
            defaultSelect = selectQry;
        }
        
        String customOffice = 'CRAN_ICA_KER_P_Oficina__c != \'' + CRAS_ICA_ASS_Helpers_CLS.OFICINA_SEGUROS_995 + '\'';
        String currentUserFilter = '';
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner() || CRAS_ICA_ASS_Helpers_CLS.filterDirector()){
            currentUserFilter = ' AND OwnerId in (\''+ String.join(CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers(), '\',\'') + '\')';
        }
        if (CRAS_ICA_ASS_Helpers_CLS.filterDirector()){
            customOffice = customOffice + ' AND CRAN_ICA_KER_P_Oficina__c = \''+ CRAS_ICA_ASS_Helpers_CLS.getUserOffice() + '\'';
        }
        if (is995){
            customOffice = 'CRAN_ICA_KER_P_Oficina__c = \'' + CRAS_ICA_ASS_Helpers_CLS.OFICINA_SEGUROS_995 + '\'';
        }
        
        String query = 'SELECT ' + defaultSelect + ' ' +
            		   'FROM Opportunity ' + 
            		   'WHERE RecordTypeId = \'' + gCS.CRAS_ICA_ASS_OppObjetivos_RT__c + '\' AND ' + 
            				 'closeDate = ' + CRAS_ICA_ASS_Helpers_CLS.getSOQLDate(getMaxDate()) + ' AND ' +
            				 'CRAN_VEC_ADV_P_PFMMkt__c =  \'' + ramo + '\' AND ' + 
            				  customOffice + 
            				  currentUserFilter;
        
        //System.debug(query);
        return query;
    }
    
    public static String getQuery(String ramo, String tipo, Date startDate, Date endDate, List<String> filtroOficina, String customLogic, String selectQry, Integer canal){
        String currentUserFilter = '';
        String defaultSelect = 'SUM(CRAS_ICA_ASS_F_PrimaVariacion__c) ventas, ' +
                        	   'max(CRAN_ICA_KER_MovementDate__c) maxdate';
        String defaultOficinaField = 'CRAS_ICA_ASS_P_OficinaVenta__c';
        
        if (String.isNotBlank(selectQry)){
            defaultSelect = selectQry;
        }
        
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner()){
            currentUserFilter = 'AND CRAN_ICA_KER_FinancialMovement__c.CRAS_ICA_ASS_L_GestorVenta__c in (\''+ String.join(CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers(), '\',\'') + '\')';
        }
        else if (CRAS_ICA_ASS_Helpers_CLS.filterDirector()){
            filtroOficina.clear();
            filtroOficina.add(CRAS_ICA_ASS_Helpers_CLS.getUserOffice());
            defaultOficinaField = 'CRAN_ICA_KER_MD_FinancialAccount__r.CRAS_ICA_ASS_F_Oficina__c';
            List<String> usersOffice = getCampaignUsers(ramo, canal);
            currentUserFilter = 'OR CRAN_ICA_KER_FinancialMovement__c.CRAS_ICA_ASS_L_GestorVenta__c in (\''+ String.join(usersOffice, '\',\'') + '\')';
        }
        else {
            List<String> usersOffice = getCampaignUsers(ramo, canal);
            currentUserFilter = 'AND CRAN_ICA_KER_FinancialMovement__c.CRAS_ICA_ASS_L_GestorVenta__c in (\''+ String.join(usersOffice, '\',\'') + '\')';
        }
        String query = 'SELECT ' + defaultSelect + ' ' +
                       'FROM  CRAN_ICA_KER_FinancialMovement__c ' + 
                       'WHERE CRAN_ICA_KER_MovementDate__c >= ' + CRAS_ICA_ASS_Helpers_CLS.getSOQLDate(startDate) + ' AND ' +
                        	 'CRAN_ICA_KER_MovementDate__c <= ' + CRAS_ICA_ASS_Helpers_CLS.getSOQLDate(endDate) + ' AND ' +
                        	 'CRAN_ICA_KER_P_Type__c = \'' + tipo + '\' AND ' +
            				 '(' + defaultOficinaField + ' IN (\'' + String.join(filtroOficina, '\',\'') + '\') ' +
                        	  currentUserFilter + ') ' + 
                        	  customLogic;
        
        //System.debug(query);
        return query;
    }
}