public class CRAS_ICA_ASS_Siniestros_CTR {
    public static List<List<String>> getSntByMarketYear() {
        List<List<String>> resultList = new List<List<String>>();
        
        List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();
        
        String savingsCode = CRAS_ICA_ASS_Helpers_CLS.savingsMKTCode;
        String rentsCode = CRAS_ICA_ASS_Helpers_CLS.rentsMKTCode;
        
        
        
        //fechas
        Date startDate = CRAS_ICA_ASS_Helpers_CLS.DateNow();
        
        List<AggregateResult> aResult = null;
        
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner()){
            aResult = [select CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c, 
                       SUM(CRAS_ICA_ASS_C_TotalNaturalYear__c) Pres, SUM(CRAS_ICA_ASS_C_TotalPagoPrimas__c) Prim
                       from CRAS_ICA_ASS_ClaimAmountHistory__c 
                       where CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :rentsCode
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_ProductId__c != '0234' //ski
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.OwnerId in :owners
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c !='' 
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_AxisFAID__c != ''
                       AND CRAS_ICA_ASS_N_Year__c = :startDate.Year()
                       GROUP BY CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c];
        }
        else{
            aResult = [select CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c, 
                       SUM(CRAS_ICA_ASS_C_TotalNaturalYear__c) Pres, SUM(CRAS_ICA_ASS_C_TotalPagoPrimas__c) Prim
                       from CRAS_ICA_ASS_ClaimAmountHistory__c 
                       where CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :rentsCode
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_ProductId__c != '0234' //ski
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c !='' 
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_AxisFAID__c != ''
                       AND CRAS_ICA_ASS_N_Year__c = :startDate.Year()
                       GROUP BY CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c];
        }
        
        
        for(AggregateResult ar:aResult){
            List<String> toadd = new List<String>(); 
            
            String marketId = (String)ar.get('CRAN_VEC_ADV_P_PFMMkt__c');
            
            List<FinServ__FinancialAccount__c> fALst = [Select toLabel(CRAN_VEC_ADV_P_PFMMkt__c) pfm 
                                                        FROM FinServ__FinancialAccount__c
                                                        WHERE CRAN_VEC_ADV_P_PFMMkt__c = :marketId];
            
            if(fALst.Size() > 0)
            {
                toadd.add((String)fALst[0].get('pfm'));
            }
            
            
            Decimal value = 0;
            if((Decimal)ar.get('Prim') > 0)
            {
                value = ((Decimal)ar.get('Pres') / (Decimal)ar.get('Prim')) * 100;
            }
            
            
            toadd.add(String.valueOf(value.setScale(2))); 
            
            
            
            //benchmark
            //seleccionar un producto del market obtenido
            List<FinServ__Securities__c> security_sample_list  = [SELECT ID, CRAN_VEC_ADV_P_PFMMkt__c
                                                                  FROM Finserv__securities__c 
                                                                  where CRAN_VEC_ADV_P_PFMMkt__c = :marketId
                                                                  limit 1];
            if(security_sample_list.size() > 0)
            {
                Id security_sample_id = security_sample_list[0].id;
                
                //añadir los benchmarks
                List<FinServ__Securities__c> benchmark_green_list = [SELECT id, CRAS_ICA_ASS_P_BenchmarkGreen__c from FinServ__Securities__c  where id = :security_sample_id];
                
                if(benchmark_green_list.size()>0){
                    toadd.add(String.valueOf(benchmark_green_list[0].CRAS_ICA_ASS_P_BenchmarkGreen__c));
                }
                
                List<FinServ__Securities__c> benchmark_yellow_list = [SELECT id, CRAS_ICA_ASS_P_BenchmarkYellow__c from FinServ__Securities__c  where id = :security_sample_id];
                if(benchmark_yellow_list.size()>0){
                    toadd.add(String.valueOf(benchmark_yellow_list[0].CRAS_ICA_ASS_P_BenchmarkYellow__c));
                }
                resultList.add(toadd);
            }
            
        }
        
        
        for(Integer i = 0; i < resultList.size(); i++)
        {
            for(Integer j = 0; j < resultList.size(); j++)
            {
                if (Decimal.valueOf(resultList[i][1]) > Decimal.valueOf(resultList[j][1])){
                    List<String> variableauxiliar = resultList[i];
                    resultList[i] = resultList[j];
                    resultList[j] = variableauxiliar;
                }
            }
        }
        
        
        return resultList;
    }
    
    public static List<List<String>> getSntByMarketAll() {
        List<List<String>> resultList = new List<List<String>>();
        
        List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();
        
        //fechas
        Date startDate = CRAS_ICA_ASS_Helpers_CLS.DateNow().addYears(-1);
        
        String savingsCode = CRAS_ICA_ASS_Helpers_CLS.savingsMKTCode;
        String rentsCode = CRAS_ICA_ASS_Helpers_CLS.rentsMKTCode;
        List<AggregateResult> aResult = null;
        
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner()){
            aResult = [select CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c, 
                       SUM(CRAS_ICA_ASS_C_TotalNaturalYear__c) Pres, SUM(CRAS_ICA_ASS_C_TotalPagoPrimas__c) Prim
                       from CRAS_ICA_ASS_ClaimAmountHistory__c 
                       where CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :rentsCode
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_ProductId__c != '0234' //ski
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.OwnerId in :owners
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c !='' 
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_AxisFAID__c != ''
                       AND CRAS_ICA_ASS_N_Year__c <= :startDate.Year()
                       GROUP BY CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c];
        }
        else{
            aResult = [select CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c, 
                       SUM(CRAS_ICA_ASS_C_TotalNaturalYear__c) Pres, SUM(CRAS_ICA_ASS_C_TotalPagoPrimas__c) Prim
                       from CRAS_ICA_ASS_ClaimAmountHistory__c 
                       where CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :rentsCode
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_ProductId__c != '0234' //ski
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c !='' 
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_AxisFAID__c != ''
                       AND CRAS_ICA_ASS_N_Year__c <= :startDate.Year()
                       GROUP BY CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c];
        }
        
        
        for(AggregateResult ar:aResult){
            
            List<String> toadd = new List<String>(); 
            
            String marketId = (String)ar.get('CRAN_VEC_ADV_P_PFMMkt__c');
            if(marketId != null && marketId != '')
            {
                
                List<FinServ__FinancialAccount__c> fALst = [Select toLabel(CRAN_VEC_ADV_P_PFMMkt__c) pfm 
                                                            FROM FinServ__FinancialAccount__c
                                                            WHERE CRAN_VEC_ADV_P_PFMMkt__c = :marketId];
                
                if(fALst.Size() > 0)
                {
                    toadd.add((String)fALst[0].get('pfm'));
                }
                
                Decimal value = 0;
                
                if((Decimal)ar.get('Prim') > 0)
                {
                    value = ((Decimal)ar.get('Pres') / (Decimal)ar.get('Prim')) * 100;
                }
                toadd.add(String.valueOf(value.setScale(2)));            
                
                
                //benchmark
                //seleccionar un producto del market obtenido
                List<FinServ__Securities__c> security_sample_list  = [SELECT ID, CRAN_VEC_ADV_P_PFMMkt__c
                                                                      FROM Finserv__securities__c 
                                                                      where CRAN_VEC_ADV_P_PFMMkt__c = :marketId
                                                                      limit 1];
                if(security_sample_list.size() > 0)
                {
                    Id security_sample_id = security_sample_list[0].id;
                    
                    //añadir los benchmarks
                    List<FinServ__Securities__c> benchmark_green_list = [SELECT id, CRAS_ICA_ASS_P_BenchmarkGreen__c from FinServ__Securities__c  where id = :security_sample_id];
                    
                    if(benchmark_green_list.size()>0){
                        toadd.add(String.valueOf(benchmark_green_list[0].CRAS_ICA_ASS_P_BenchmarkGreen__c));
                    }
                    
                    List<FinServ__Securities__c> benchmark_yellow_list = [SELECT id, CRAS_ICA_ASS_P_BenchmarkYellow__c from FinServ__Securities__c  where id = :security_sample_id];
                    if(benchmark_yellow_list.size()>0){
                        toadd.add(String.valueOf(benchmark_yellow_list[0].CRAS_ICA_ASS_P_BenchmarkYellow__c));
                    }
                    resultList.add(toadd);
                }
            }
            
        }
        
        for(Integer i = 0; i < resultList.size(); i++)
        {
            for(Integer j = 0; j < resultList.size(); j++)
            {
                if (Decimal.valueOf(resultList[i][1]) > Decimal.valueOf(resultList[j][1])){
                    List<String> variableauxiliar = resultList[i];
                    resultList[i] = resultList[j];
                    resultList[j] = variableauxiliar;
                }
            }
        }
        
        return resultList;
    }
    
    public static List<List<String>> getSntByProductYear() {
        
        List<List<String>> resultList = new List<List<String>>();
        
        List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();
        
        String savingsCode = CRAS_ICA_ASS_Helpers_CLS.savingsMKTCode;
        String rentsCode = CRAS_ICA_ASS_Helpers_CLS.rentsMKTCode;
        
        //fechas
        Date startDate = CRAS_ICA_ASS_Helpers_CLS.DateNow();
        
        List<AggregateResult> aResult = null;
        
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner()){
            aResult = [select CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c,
                       SUM(CRAS_ICA_ASS_C_TotalNaturalYear__c) Pres, SUM(CRAS_ICA_ASS_C_TotalPagoPrimas__c) Prim
                       from CRAS_ICA_ASS_ClaimAmountHistory__c 
                       where CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :rentsCode
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.OwnerId in :owners
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_AxisFAID__c != ''
                       AND CRAS_ICA_ASS_N_Year__c = :startDate.Year()
                       group by CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c];
        }
        else{
            aResult = [select CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c,
                       SUM(CRAS_ICA_ASS_C_TotalNaturalYear__c) Pres, SUM(CRAS_ICA_ASS_C_TotalPagoPrimas__c) Prim
                       from CRAS_ICA_ASS_ClaimAmountHistory__c
                       WHERE CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_AxisFAID__c != ''
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :rentsCode
                       AND CRAS_ICA_ASS_N_Year__c = :startDate.Year()
                       group by CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c];
        }
        
        for(AggregateResult ar:aResult){
            List<String> toadd = new List<String>(); 
            
            String productName = (String)ar.get('CRAS_ICA_ASS_T_ProductoPoliza__c');
            if(productName != null && productName != ''){
                toadd.add(productName);
                
                Decimal value = 0;
                if((Decimal)ar.get('Prim') > 0)
                {
                    value = ((Decimal)ar.get('Pres') / (Decimal)ar.get('Prim')) * 100;
                }
                
                toadd.add(String.valueOf(value.setScale(2)));      
                
                //benchmark
                List<FinServ__Securities__c> benchmark_green_list = [SELECT id, CRAS_ICA_ASS_P_BenchmarkGreen__c from FinServ__Securities__c  where Name = :productName];
                
                if(benchmark_green_list.size()>0){
                    toadd.add(String.valueOf(benchmark_green_list[0].CRAS_ICA_ASS_P_BenchmarkGreen__c));
                }
                
                List<FinServ__Securities__c> benchmark_yellow_list = [SELECT id, CRAS_ICA_ASS_P_BenchmarkYellow__c from FinServ__Securities__c  where Name = :productName];
                if(benchmark_yellow_list.size()>0){
                    toadd.add(String.valueOf(benchmark_yellow_list[0].CRAS_ICA_ASS_P_BenchmarkYellow__c));
                }
                resultList.add(toadd);
            } 
        }  
        
        resultList = CRAS_ICA_ASS_Helpers_CLS.securityFilter(resultList);
        
        for(Integer i = 0; i < resultList.size(); i++)
        {
            for(Integer j = 0; j < resultList.size(); j++)
            {
                if (Decimal.valueOf(resultList[i][1]) > Decimal.valueOf(resultList[j][1])){
                    List<String> variableauxiliar = resultList[i];
                    resultList[i] = resultList[j];
                    resultList[j] = variableauxiliar;
                }
            }
        }
        
        return resultList;
    }
    
    public static List<List<String>> getSntByProductAll() {
        
        List<List<String>> resultList = new List<List<String>>();
        
        List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();
        Date startDate = CRAS_ICA_ASS_Helpers_CLS.DateNow().addYears(-1);
        
        String savingsCode = CRAS_ICA_ASS_Helpers_CLS.savingsMKTCode;
        String rentsCode = CRAS_ICA_ASS_Helpers_CLS.rentsMKTCode;
        List<AggregateResult> aResult = null;
        
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner()){
            aResult = [select CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c,
                       SUM(CRAS_ICA_ASS_C_TotalNaturalYear__c) Pres, SUM(CRAS_ICA_ASS_C_TotalPagoPrimas__c) Prim
                       from CRAS_ICA_ASS_ClaimAmountHistory__c 
                       where CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :rentsCode
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.OwnerId in :owners
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_AxisFAID__c != ''
                       AND CRAS_ICA_ASS_N_Year__c <= :startDate.Year()
                       group by CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c];
        }
        else {
            aResult = [select CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c,
                       SUM(CRAS_ICA_ASS_C_TotalNaturalYear__c) Pres, SUM(CRAS_ICA_ASS_C_TotalPagoPrimas__c) Prim
                       from CRAS_ICA_ASS_ClaimAmountHistory__c 
                       where CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :rentsCode
                       AND CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_AxisFAID__c != ''
                       AND CRAS_ICA_ASS_N_Year__c <= :startDate.Year()
                       group by CRAS_ICA_ASS_L_Role__r.FinServ__FinancialAccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c];
        }
        
        for(AggregateResult ar:aResult){
            List<String> toadd = new List<String>(); 
            
            String productName = (String)ar.get('CRAS_ICA_ASS_T_ProductoPoliza__c');
            if(productName != null && productName != ''){
                
                toadd.add(productName);
                
                Decimal value = 0;
                if((Decimal)ar.get('Prim') > 0)
                {
                    value = ((Decimal)ar.get('Pres') / (Decimal)ar.get('Prim')) * 100;
                }
                
                toadd.add(String.valueOf(value.setScale(2)));      
                
                //benchmark
                List<FinServ__Securities__c> benchmark_green_list = [SELECT id, CRAS_ICA_ASS_P_BenchmarkGreen__c from FinServ__Securities__c  where Name = :productName];
                
                if(benchmark_green_list.size()>0){
                    toadd.add(String.valueOf(benchmark_green_list[0].CRAS_ICA_ASS_P_BenchmarkGreen__c));
                }
                
                List<FinServ__Securities__c> benchmark_yellow_list = [SELECT id, CRAS_ICA_ASS_P_BenchmarkYellow__c from FinServ__Securities__c  where Name = :productName];
                if(benchmark_yellow_list.size()>0){
                    toadd.add(String.valueOf(benchmark_yellow_list[0].CRAS_ICA_ASS_P_BenchmarkYellow__c));
                }
                resultList.add(toadd);
            }
        }  
        
        resultList = CRAS_ICA_ASS_Helpers_CLS.securityFilter(resultList);
        
        for(Integer i = 0; i < resultList.size(); i++)
        {
            for(Integer j = 0; j < resultList.size(); j++)
            {
                if (Decimal.valueOf(resultList[i][1]) > Decimal.valueOf(resultList[j][1])){
                    List<String> variableauxiliar = resultList[i];
                    resultList[i] = resultList[j];
                    resultList[j] = variableauxiliar;
                }
            }
        }
        
        return resultList;
    }
}