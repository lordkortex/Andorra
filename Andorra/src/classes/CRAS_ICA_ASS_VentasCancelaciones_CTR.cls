public class CRAS_ICA_ASS_VentasCancelaciones_CTR {

	private static CRAS_ICA_ASS_InsuranceGlobal_CS__c  gCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
    
    public static String getVentasCancelacionesYear1(){
        
        List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();
        
        String savingsCode = CRAS_ICA_ASS_Helpers_CLS.savingsMKTCode;
        
        String productType = 'risk';
        String period = 'month';
        
        //intervalo de fechas
        Date today = Date.today();
        
        Date startDate;
        Date endDate;
        
        if(period=='month'){
            if (!gCS.CRAS_ICA_ASS_CH_DeveloperMode__c){
                startDate = date.newInstance(today.year(), today.month(), 1);
                endDate = date.newInstance(today.year(), today.month(), Date.daysInMonth(today.year(), today.month()));
        	}
            else {
                startDate = date.newInstance(2017, 8, 1);
                endDate = date.newInstance(2017, 8, Date.daysInMonth(2017, 8));
            }
        } 
        
        Datetime startDateDT =  Datetime.newInstance(startDate, Time.newInstance(0, 0, 0, 0));
        Datetime endDateDT = Datetime.newInstance(endDate, Time.newInstance(0, 0, 0, 0));
        
        String startDateFormatted = startDateDT.format('yyyy-MM-dd');
        String endDateFormatted = endDateDT.format('yyyy-MM-dd');
        
        List<List<String>> resultList = new List<List<String>>();
        //new object result list
        List<CRAS_ICA_ASS_VCResponse_OBJ> objectResultList = new List<CRAS_ICA_ASS_VCResponse_OBJ>();
        List<AggregateResult> aResult = null;
        List<AggregateResult> aResult2 = null;
        
        
        
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner())
        {
            aResult = [SELECT count(id) cnt,sum(CRAS_ICA_ASS_C_PrimaTotal__c) prime
                       FROM CRAN_ICA_KER_FinancialMovement__c
                       WHERE CRAN_ICA_KER_MD_FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_L_MainMngr__r.Id in :owners AND 
                       CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode AND
                       CRAN_ICA_KER_P_Type__c IN ('101ASS') AND
                       CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                       CRAN_ICA_KER_MovementDate__c <= :endDate];
            
            aResult2 = [SELECT count(id) cnt,sum(CRAS_ICA_ASS_C_PrimaTotal__c) prime
                        FROM CRAN_ICA_KER_FinancialMovement__c
                        WHERE CRAN_ICA_KER_MD_FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_L_MainMngr__r.Id in :owners AND 
                        CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode AND
                        CRAN_ICA_KER_P_Type__c = '102ASS' AND
                        CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                        CRAN_ICA_KER_MovementDate__c <= :endDate];    
        }
        else
        {
            aResult = [SELECT count(id) cnt,sum(CRAS_ICA_ASS_C_PrimaTotal__c) prime
                       FROM CRAN_ICA_KER_FinancialMovement__c
                       WHERE CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode AND
                       CRAN_ICA_KER_P_Type__c IN ('101ASS') AND
                       CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                       CRAN_ICA_KER_MovementDate__c <= :endDate];
            
            aResult2 = [SELECT count(id) cnt,sum(CRAS_ICA_ASS_C_PrimaTotal__c) prime
                        FROM CRAN_ICA_KER_FinancialMovement__c
                        WHERE CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode AND
                        CRAN_ICA_KER_P_Type__c = '102ASS' AND
                        CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                        CRAN_ICA_KER_MovementDate__c <= :endDate]; 
        }
        
        for(AggregateResult ar:aResult)
        {
            //llenar el objeto CRAS_ICA_ASS_VCResponse_OBJ
            CRAS_ICA_ASS_VCResponse_OBJ objectToAdd = new CRAS_ICA_ASS_VCResponse_OBJ();
            objectToAdd.queryType = 'pol';
            objectToAdd.status = 'valid';
            objectToAdd.periodicity = 'month';
            objectToAdd.grouping = 'risk';
            objectToAdd.polCount = (Integer)ar.get('cnt');
            objectToAdd.polAmount = (Decimal)ar.get('prime');
            
            //añadir en la lista de objetos CRAS_ICA_ASS_VCResponse_OBJ 
            objectResultList.add(objectToAdd);
        }
        
        for(AggregateResult ar2:aResult2)
        {
            //llenar el objeto CRAS_ICA_ASS_VCResponse_OBJ
            CRAS_ICA_ASS_VCResponse_OBJ objectToAdd = new CRAS_ICA_ASS_VCResponse_OBJ();
            objectToAdd.queryType = 'pol';
            objectToAdd.status = 'cancelled';
            objectToAdd.periodicity = 'month';
            objectToAdd.grouping = 'risk';
            objectToAdd.polCount = (Integer)ar2.get('cnt');
            objectToAdd.polAmount = (Decimal)ar2.get('prime');
            
            //añadir en la lista de objetos CRAS_ICA_ASS_VCResponse_OBJ 
            objectResultList.add(objectToAdd);
        }
        
        //return resultList;
        return JSON.serialize(objectResultList);
    }
    
    public static String getVentasCancelacionesYear2(){
        
        List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();
        
        String savingsCode = CRAS_ICA_ASS_Helpers_CLS.savingsMKTCode;
        
        String productType = 'risk';
        String period = 'year';
        
        //intervalo de fechas
        Date today = Date.today();
        
        Date startDate;
        Date endDate;
        
        if (period=='year'){
            startDate = date.newInstance(today.year(), 1, 1);
            endDate = date.newInstance(today.year(), 12, 31);
        }
        
        Datetime startDateDT =  Datetime.newInstance(startDate, Time.newInstance(0, 0, 0, 0));
        Datetime endDateDT = Datetime.newInstance(endDate, Time.newInstance(0, 0, 0, 0));
        
        String startDateFormatted = startDateDT.format('yyyy-MM-dd');
        String endDateFormatted = endDateDT.format('yyyy-MM-dd');
        
        
        List<List<String>> resultList = new List<List<String>>();
        //new object result list
        List<CRAS_ICA_ASS_VCResponse_OBJ> objectResultList = new List<CRAS_ICA_ASS_VCResponse_OBJ>();
        
        List<AggregateResult> aResult = new List<AggregateResult>();
        List<AggregateResult> aResult2 = new List<AggregateResult>();
        
        if(productType=='risk')
        {
            if (CRAS_ICA_ASS_Helpers_CLS.filterOwner())
            {
                aResult = [SELECT count(id) cnt,sum(CRAS_ICA_ASS_C_PrimaTotal__c) prime
                           FROM CRAN_ICA_KER_FinancialMovement__c
                           WHERE CRAN_ICA_KER_MD_FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_L_MainMngr__r.Id in :owners AND 
                           CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode AND
                           CRAN_ICA_KER_P_Type__c IN ('101ASS') AND
                           CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                           CRAN_ICA_KER_MovementDate__c <= :endDate];
                
                aResult2 = [SELECT count(id) cnt,sum(CRAS_ICA_ASS_C_PrimaTotal__c) prime
                            FROM CRAN_ICA_KER_FinancialMovement__c
                            WHERE CRAN_ICA_KER_MD_FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_L_MainMngr__r.Id in :owners AND 
                            CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode AND
                            CRAN_ICA_KER_P_Type__c = '102ASS' AND
                            CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                            CRAN_ICA_KER_MovementDate__c <= :endDate];
            }
            else
            {
                aResult = [SELECT count(id) cnt,sum(CRAS_ICA_ASS_C_PrimaTotal__c) prime
                           FROM CRAN_ICA_KER_FinancialMovement__c
                           WHERE CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode AND
                           CRAN_ICA_KER_P_Type__c IN ('101ASS') AND
                           CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                           CRAN_ICA_KER_MovementDate__c <= :endDate];
                
                aResult2 = [SELECT count(id) cnt,sum(CRAS_ICA_ASS_C_PrimaTotal__c) prime
                            FROM CRAN_ICA_KER_FinancialMovement__c
                            WHERE CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode AND
                            CRAN_ICA_KER_P_Type__c = '102ASS' AND
                            CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                            CRAN_ICA_KER_MovementDate__c <= :endDate];
            }
        } 
        
        for(AggregateResult ar:aResult)
        { 
            //llenar el objeto CRAS_ICA_ASS_VCResponse_OBJ
            CRAS_ICA_ASS_VCResponse_OBJ objectToAdd = new CRAS_ICA_ASS_VCResponse_OBJ();
            objectToAdd.queryType = 'pol';
            objectToAdd.status = 'valid';
            objectToAdd.periodicity = 'year';
            objectToAdd.grouping = 'risk';
            objectToAdd.polCount = (Integer)ar.get('cnt');
            objectToAdd.polAmount = (Decimal)ar.get('prime');
            
            //añadir en la lista de objetos CRAS_ICA_ASS_VCResponse_OBJ 
            objectResultList.add(objectToAdd);
            
        }
        
        for(AggregateResult ar2:aResult2)
        {
            //llenar el objeto CRAS_ICA_ASS_VCResponse_OBJ
            CRAS_ICA_ASS_VCResponse_OBJ objectToAdd = new CRAS_ICA_ASS_VCResponse_OBJ();
            objectToAdd.queryType = 'pol';
            objectToAdd.status = 'cancelled';
            objectToAdd.periodicity = 'year';
            objectToAdd.grouping = 'risk';
            objectToAdd.polCount = (Integer)ar2.get('cnt');
            objectToAdd.polAmount = (Decimal)ar2.get('prime');
            
            //añadir en la lista de objetos CRAS_ICA_ASS_VCResponse_OBJ 
            objectResultList.add(objectToAdd);
        }
        
        //return resultList;
        return JSON.serialize(objectResultList);
    }
    
    public static String getVentasCancelacionesYear3()
    {
        List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();
        
        String savingsCode = CRAS_ICA_ASS_Helpers_CLS.savingsMKTCode;
        
        String productType = 'savings';
        String period = 'month';
        
        //intervalo de fechas
        Date today = Date.today();
        
        Date startDate;
        Date endDate;
        
        if(period=='month'){
            if (!gCS.CRAS_ICA_ASS_CH_DeveloperMode__c){
                startDate = date.newInstance(today.year(), today.month(), 1);
                endDate = date.newInstance(today.year(), today.month(), Date.daysInMonth(today.year(), today.month()));
        	}
            else {
                startDate = date.newInstance(2017, 8, 1);
                endDate = date.newInstance(2017, 8, Date.daysInMonth(2017, 8));
            }
        } 
        
        Datetime startDateDT =  Datetime.newInstance(startDate, Time.newInstance(0, 0, 0, 0));
        Datetime endDateDT = Datetime.newInstance(endDate, Time.newInstance(0, 0, 0, 0));
        
        String startDateFormatted = startDateDT.format('yyyy-MM-dd');
        String endDateFormatted = endDateDT.format('yyyy-MM-dd');
        
        List<List<String>> resultList = new List<List<String>>();
        //new object result list
        List<CRAS_ICA_ASS_VCResponse_OBJ> objectResultList = new List<CRAS_ICA_ASS_VCResponse_OBJ>();
        
        List<AggregateResult> aResult = new List<AggregateResult>();
        List<AggregateResult> aResult2 = new List<AggregateResult>();
        
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner())
        {
            aResult = [SELECT count(id) cnt,sum(CRAS_ICA_ASS_C_Aportaciones__c) prime
                       FROM CRAN_ICA_KER_FinancialMovement__c
                       WHERE CRAN_ICA_KER_MD_FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_L_MainMngr__r.Id in :owners AND 
                       CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c = :savingsCode AND
                       CRAN_ICA_KER_P_Type__c IN ('101ASS') AND
                       CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                       CRAN_ICA_KER_MovementDate__c <= :endDate];
            
            aResult2 = [SELECT count(id) cnt,sum(CRAS_ICA_ASS_C_Aportaciones__c) prime
                        FROM CRAN_ICA_KER_FinancialMovement__c
                        WHERE CRAN_ICA_KER_MD_FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_L_MainMngr__r.Id in :owners AND 
                        CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c = :savingsCode AND
                        CRAN_ICA_KER_P_Type__c = '102ASS' AND
                        CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                        CRAN_ICA_KER_MovementDate__c <= :endDate];
            
        }
        else
        {
            aResult = [SELECT count(id) cnt,sum(CRAS_ICA_ASS_C_Aportaciones__c) prime
                       FROM CRAN_ICA_KER_FinancialMovement__c
                       WHERE CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c = :savingsCode AND
                       CRAN_ICA_KER_P_Type__c IN ('101ASS') AND
                       CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                       CRAN_ICA_KER_MovementDate__c <= :endDate];
            
            aResult2 = [SELECT count(id) cnt,sum(CRAS_ICA_ASS_C_Aportaciones__c) prime
                        FROM CRAN_ICA_KER_FinancialMovement__c
                        WHERE CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c = :savingsCode AND
                        CRAN_ICA_KER_P_Type__c = '102ASS' AND
                        CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                        CRAN_ICA_KER_MovementDate__c <= :endDate];
        }
        
        for(AggregateResult ar:aResult)
        {
            //llenar el objeto CRAS_ICA_ASS_VCResponse_OBJ
            CRAS_ICA_ASS_VCResponse_OBJ objectToAdd = new CRAS_ICA_ASS_VCResponse_OBJ();
            objectToAdd.queryType = 'pol';
            objectToAdd.status = 'valid';
            objectToAdd.periodicity = 'month';
            objectToAdd.grouping = 'savings';
            objectToAdd.polCount = (Integer)ar.get('cnt');
            objectToAdd.polAmount = (Decimal)ar.get('prime');
            
            //añadir en la lista de objetos CRAS_ICA_ASS_VCResponse_OBJ 
            objectResultList.add(objectToAdd);
        }
        
        for(AggregateResult ar2:aResult2)
        {
            //llenar el objeto CRAS_ICA_ASS_VCResponse_OBJ
            CRAS_ICA_ASS_VCResponse_OBJ objectToAdd = new CRAS_ICA_ASS_VCResponse_OBJ();
            objectToAdd.queryType = 'pol';
            objectToAdd.status = 'cancelled';
            objectToAdd.periodicity = 'month';
            objectToAdd.grouping = 'savings';
            objectToAdd.polCount = (Integer)ar2.get('cnt');
            objectToAdd.polAmount = (Decimal)ar2.get('prime');
            
            //añadir en la lista de objetos CRAS_ICA_ASS_VCResponse_OBJ 
            objectResultList.add(objectToAdd);
        }
        //return resultList;
        return JSON.serialize(objectResultList);
    }
    
    public static String getVentasCancelacionesYear4()
    {
        List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();
        
        String savingsCode = CRAS_ICA_ASS_Helpers_CLS.savingsMKTCode;
        
        String productType = 'savings';
        String period = 'year';
        
        //intervalo de fechas
        Date today = Date.today();
        
        Date startDate;
        Date endDate;
        
        startDate = date.newInstance(today.year(), 1, 1);
        endDate = date.newInstance(today.year(), 12, 31);
        
        Datetime startDateDT =  Datetime.newInstance(startDate, Time.newInstance(0, 0, 0, 0));
        Datetime endDateDT = Datetime.newInstance(endDate, Time.newInstance(0, 0, 0, 0));
        
        String startDateFormatted = startDateDT.format('yyyy-MM-dd');
        String endDateFormatted = endDateDT.format('yyyy-MM-dd');
        
        
        List<List<String>> resultList = new List<List<String>>();
        //new object result list
        List<CRAS_ICA_ASS_VCResponse_OBJ> objectResultList = new List<CRAS_ICA_ASS_VCResponse_OBJ>();
        
        List<AggregateResult> aResult = new List<AggregateResult>();
        List<AggregateResult> aResult2 = new List<AggregateResult>();
        
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner())
        {
            aResult = [SELECT count(id) cnt,sum(CRAS_ICA_ASS_C_Aportaciones__c) prime
                       FROM CRAN_ICA_KER_FinancialMovement__c
                       WHERE CRAN_ICA_KER_MD_FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_L_MainMngr__r.Id in :owners AND 
                       CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c = :savingsCode AND
                       CRAN_ICA_KER_P_Type__c IN ('101ASS') AND
                       CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                       CRAN_ICA_KER_MovementDate__c <= :endDate];
            
            aResult2 = [SELECT count(id) cnt,sum(CRAS_ICA_ASS_C_Aportaciones__c) prime
                        FROM CRAN_ICA_KER_FinancialMovement__c
                        WHERE CRAN_ICA_KER_MD_FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_L_MainMngr__r.Id in :owners AND 
                        CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c = :savingsCode AND
                        CRAN_ICA_KER_P_Type__c = '102ASS' AND
                        CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                        CRAN_ICA_KER_MovementDate__c <= :endDate];  				   
        }
        else
        {
            aResult = [SELECT count(id) cnt,sum(CRAS_ICA_ASS_C_Aportaciones__c) prime
                       FROM CRAN_ICA_KER_FinancialMovement__c
                       WHERE CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c = :savingsCode AND
                       CRAN_ICA_KER_P_Type__c IN ('101ASS') AND
                       CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                       CRAN_ICA_KER_MovementDate__c <= :endDate];
            
            aResult2 = [SELECT count(id) cnt,sum(CRAS_ICA_ASS_C_Aportaciones__c) prime
                        FROM CRAN_ICA_KER_FinancialMovement__c
                        WHERE CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c = :savingsCode AND
                        CRAN_ICA_KER_P_Type__c = '102ASS' AND
                        CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                        CRAN_ICA_KER_MovementDate__c <= :endDate];  
        }
        
        for(AggregateResult ar:aResult)
        {
            //llenar el objeto CRAS_ICA_ASS_VCResponse_OBJ
            CRAS_ICA_ASS_VCResponse_OBJ objectToAdd = new CRAS_ICA_ASS_VCResponse_OBJ();
            objectToAdd.queryType = 'pol';
            objectToAdd.status = 'valid';
            objectToAdd.periodicity = 'year';
            objectToAdd.grouping = 'savings';
            objectToAdd.polCount = (Integer)ar.get('cnt');
            objectToAdd.polAmount = (Decimal)ar.get('prime');
            
            //añadir en la lista de objetos CRAS_ICA_ASS_VCResponse_OBJ 
            objectResultList.add(objectToAdd);
            
        }
        
        for(AggregateResult ar2:aResult2)
        {
            //llenar el objeto CRAS_ICA_ASS_VCResponse_OBJ
            CRAS_ICA_ASS_VCResponse_OBJ objectToAdd = new CRAS_ICA_ASS_VCResponse_OBJ();
            objectToAdd.queryType = 'pol';
            objectToAdd.status = 'cancelled';
            objectToAdd.periodicity = 'year';
            objectToAdd.grouping = 'savings';
            objectToAdd.polCount = (Integer)ar2.get('cnt');
            objectToAdd.polAmount = (Decimal)ar2.get('prime');
            
            //añadir en la lista de objetos CRAS_ICA_ASS_VCResponse_OBJ 
            objectResultList.add(objectToAdd);
            
        }
        
        System.debug('Hola: ' + objectResultList);
        
        //return resultList;
        return JSON.serialize(objectResultList);
    }    
    
    public static String getVentasCancelacionesYearIns1(){
        
        List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();
        
        String savingsCode = CRAS_ICA_ASS_Helpers_CLS.savingsMKTCode;
        
        String period = 'month';
        
        //intervalo de fechas
        Date today = Date.today();
        
        Date startDate;
        Date endDate;
        
        if(period=='month'){
            if (!gCS.CRAS_ICA_ASS_CH_DeveloperMode__c){
                startDate = date.newInstance(today.year(), today.month(), 1);
                endDate = date.newInstance(today.year(), today.month(), Date.daysInMonth(today.year(), today.month()));
        	}
            else {
                startDate = date.newInstance(2017, 8, 1);
                endDate = date.newInstance(2017, 8, Date.daysInMonth(2017, 8));
            }
        } 
        
        List<List<String>> resultList = new List<List<String>>();
        //new object result list
        List<CRAS_ICA_ASS_VCResponse_OBJ> objectResultList = new List<CRAS_ICA_ASS_VCResponse_OBJ>();
        
        List<AggregateResult> aResult = new List<AggregateResult>();
        List<AggregateResult> aResult2 = new List<AggregateResult>();
        
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner())
        {          
            aResult = [SELECT SUM(CRAS_ICA_ASS_N_NumAsegurados__c) cnt
                       FROM CRAN_ICA_KER_FinancialMovement__c
                       WHERE CRAN_ICA_KER_MD_FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_L_MainMngr__r.Id in :owners AND 
                       CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode AND
                       CRAN_ICA_KER_P_Type__c IN ('101ASS') AND
                       CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                       CRAN_ICA_KER_MovementDate__c <= :endDate];
            
            aResult2 = [SELECT SUM(CRAS_ICA_ASS_N_NumAsegurados__c) cnt
                         FROM CRAN_ICA_KER_FinancialMovement__c
                         WHERE CRAN_ICA_KER_MD_FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_L_MainMngr__r.Id in :owners AND 
                         CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode AND
                         CRAN_ICA_KER_P_Type__c = '102ASS' AND
                         CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                         CRAN_ICA_KER_MovementDate__c <= :endDate];
        }
        else 
        {   
            aResult = [SELECT SUM(CRAS_ICA_ASS_N_NumAsegurados__c) cnt
                     FROM CRAN_ICA_KER_FinancialMovement__c
                     WHERE CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode AND
                     CRAN_ICA_KER_P_Type__c IN ('101ASS') AND
                     CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                     CRAN_ICA_KER_MovementDate__c <= :endDate];
            
            aResult2 = [SELECT SUM(CRAS_ICA_ASS_N_NumAsegurados__c) cnt
                        FROM CRAN_ICA_KER_FinancialMovement__c
                        WHERE CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode AND
                        CRAN_ICA_KER_P_Type__c = '102ASS' AND
                        CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                        CRAN_ICA_KER_MovementDate__c <= :endDate];
        }
        
        for(AggregateResult ar:aResult){
            
            //llenar el objeto CRAS_ICA_ASS_VCResponse_OBJ
            CRAS_ICA_ASS_VCResponse_OBJ objectToAdd = new CRAS_ICA_ASS_VCResponse_OBJ();
            objectToAdd.queryType = 'ins';
            objectToAdd.status = 'valid';
            objectToAdd.periodicity = 'month';
            objectToAdd.grouping = 'risk';
            objectToAdd.insCount = Integer.valueOf((Decimal)ar.get('cnt'));
            
            //añadir en la lista de objetos CRAS_ICA_ASS_VCResponse_OBJ 
            objectResultList.add(objectToAdd);
            
        }
        
        for(AggregateResult ar2:aResult2){
            
            //llenar el objeto CRAS_ICA_ASS_VCResponse_OBJ
            CRAS_ICA_ASS_VCResponse_OBJ objectToAdd = new CRAS_ICA_ASS_VCResponse_OBJ();
            objectToAdd.queryType = 'ins';
            objectToAdd.status = 'cancelled';
            objectToAdd.periodicity = 'month';
            objectToAdd.grouping = 'risk';
            objectToAdd.insCount = Integer.valueOf((Decimal)ar2.get('cnt'));
            
            //añadir en la lista de objetos CRAS_ICA_ASS_VCResponse_OBJ 
            objectResultList.add(objectToAdd);
            
        }
        
        //return resultList;
        
        return JSON.serialize(objectResultList);
    }
    
    public static String getVentasCancelacionesYearIns2(){
        
        List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();
        
        String savingsCode = CRAS_ICA_ASS_Helpers_CLS.savingsMKTCode;
        
        String period = 'year';
        
        //intervalo de fechas
        Date today = Date.today();
        
        Date startDate;
        Date endDate;
        
        if (period=='year'){
            startDate = date.newInstance(today.year(), 1, 1);
            endDate = date.newInstance(today.year(), 12, 31);
        }
        
        List<List<String>> resultList = new List<List<String>>();
        //new object result list
        List<CRAS_ICA_ASS_VCResponse_OBJ> objectResultList = new List<CRAS_ICA_ASS_VCResponse_OBJ>();
        
        List<AggregateResult> aResult = new List<AggregateResult>();
        List<AggregateResult> aResult2 = new List<AggregateResult>();
        
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner())
        {
            aResult = [SELECT SUM(CRAS_ICA_ASS_N_NumAsegurados__c) cnt
                         FROM CRAN_ICA_KER_FinancialMovement__c
                         WHERE CRAN_ICA_KER_MD_FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_L_MainMngr__r.Id in :owners AND 
                         CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode AND
                         CRAN_ICA_KER_P_Type__c IN ('101ASS') AND
                         CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                         CRAN_ICA_KER_MovementDate__c <= :endDate];
            
            aResult2 = [SELECT SUM(CRAS_ICA_ASS_N_NumAsegurados__c) cnt
                        FROM CRAN_ICA_KER_FinancialMovement__c
                        WHERE CRAN_ICA_KER_MD_FinancialAccount__r.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_L_MainMngr__r.Id in :owners AND 
                        CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode AND
                        CRAN_ICA_KER_P_Type__c = '102ASS' AND
                        CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                        CRAN_ICA_KER_MovementDate__c <= :endDate];					
            
        }
        else 
        {
            aResult = [SELECT SUM(CRAS_ICA_ASS_N_NumAsegurados__c) cnt
                       FROM CRAN_ICA_KER_FinancialMovement__c
                       WHERE CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode AND
                       CRAN_ICA_KER_P_Type__c IN ('101ASS') AND
                       CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                       CRAN_ICA_KER_MovementDate__c <= :endDate];
            
            aResult2 = [SELECT SUM(CRAS_ICA_ASS_N_NumAsegurados__c) cnt
                         FROM CRAN_ICA_KER_FinancialMovement__c
                         WHERE CRAN_ICA_KER_MD_FinancialAccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode AND
                         CRAN_ICA_KER_P_Type__c = '102ASS' AND
                         CRAN_ICA_KER_MovementDate__c >= :startDate AND 
                         CRAN_ICA_KER_MovementDate__c <= :endDate];	
        }
        
        for(AggregateResult ar:aResult){
            
            //llenar el objeto CRAS_ICA_ASS_VCResponse_OBJ
            CRAS_ICA_ASS_VCResponse_OBJ objectToAdd = new CRAS_ICA_ASS_VCResponse_OBJ();
            objectToAdd.queryType = 'ins';
            objectToAdd.status = 'valid';
            objectToAdd.periodicity = 'year';
            objectToAdd.grouping = 'risk';
            objectToAdd.insCount = Integer.valueOf((Decimal)ar.get('cnt'));
            
            //añadir en la lista de objetos CRAS_ICA_ASS_VCResponse_OBJ 
            objectResultList.add(objectToAdd);
            
        }
        
        for(AggregateResult ar2:aResult2){
            
            //llenar el objeto CRAS_ICA_ASS_VCResponse_OBJ
            CRAS_ICA_ASS_VCResponse_OBJ objectToAdd = new CRAS_ICA_ASS_VCResponse_OBJ();
            objectToAdd.queryType = 'ins';
            objectToAdd.status = 'cancelled';
            objectToAdd.periodicity = 'year';
            objectToAdd.grouping = 'risk';
            objectToAdd.insCount = Integer.valueOf((Decimal)ar2.get('cnt'));
            
            //añadir en la lista de objetos CRAS_ICA_ASS_VCResponse_OBJ 
            objectResultList.add(objectToAdd);
        }
        //return resultList;
        return JSON.serialize(objectResultList);
    }    
    
}