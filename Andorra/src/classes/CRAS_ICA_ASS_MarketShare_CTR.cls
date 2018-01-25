public class CRAS_ICA_ASS_MarketShare_CTR {

	public static List<List<String>> getReportPrimeCountMarket(){
        
        List<List<String>> resultList = new List<List<String>>();
       
        List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();

        String savingsCode = CRAS_ICA_ASS_Helpers_CLS.savingsMKTCode;
        List<AggregateResult> aResult = null;
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner()){
        	aResult = [select toLabel(CRAN_VEC_ADV_P_PFMMkt__c) pfm ,count(id) cnt, SUM(CRAS_ICA_ASS_C_PrimaAnual__c) prem 
                       from finserv__financialaccount__c 
                       where CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode
                               AND OwnerId in :owners
                               and CRAN_VEC_ADV_P_PFMMkt__c !=''
                               and FinServ__Status__c != '102ASS' 
                               and CRAS_ICA_ASS_T_AxisFAID__c != '' 
                       group by CRAN_VEC_ADV_P_PFMMkt__c ];
        }
        else{
			aResult = [select toLabel(CRAN_VEC_ADV_P_PFMMkt__c) pfm ,count(id) cnt, SUM(CRAS_ICA_ASS_C_PrimaAnual__c) prem 
                       from finserv__financialaccount__c 
                       where CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode
                               and CRAN_VEC_ADV_P_PFMMkt__c !=''
                               and FinServ__Status__c != '102ASS' 
                               and CRAS_ICA_ASS_T_AxisFAID__c != '' 
                       group by CRAN_VEC_ADV_P_PFMMkt__c ];            
        }
        
        
        for(AggregateResult ar:aResult){
           List<String> toadd = new List<String>(); 
            
            toadd.add((String)ar.get('pfm'));
            Decimal prem = (Decimal)ar.get('prem');
            prem = prem.setScale(2);
            toadd.add(String.valueOf(prem));
            toadd.add(String.valueOf((Integer)ar.get('cnt')));            
            resultList.add(toadd);  
        }
 
        
        return resultList;
    }

    public static List<List<String>> getReportInsuredsMarket(){
        List<List<String>> resultList = new List<List<String>>();
        
        List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();        
        String userLanguage = UserInfo.getLanguage();
 		
        //inicializar market maps
        Map<String,String> spanishMKT = new Map<String,String>();
        Map<String,String> englishMKT = new Map<String,String>();
		CRAS_ICA_ASS_Helpers_CLS.initMarketMap(spanishMKT, 'es_ES');
        CRAS_ICA_ASS_Helpers_CLS.initMarketMap(englishMKT, 'EN');
        
        String savingsCode = CRAS_ICA_ASS_Helpers_CLS.savingsMKTCode;

        List<AggregateResult> aResult = null;
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner()){
            aResult   = [select finserv__financialaccount__r.CRAN_VEC_ADV_P_PFMMkt__c pfm, count(finserv__role__c) cnt
                         from FinServ__FinancialAccountRole__c 
                         where finserv__financialaccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode
                                 and finserv__financialaccount__r.OwnerId in :owners
                                 and finserv__role__c = '102ASS'
                                 and finserv__financialaccount__r.FinServ__Status__c != '102ASS'
                                 and finserv__financialaccount__r.CRAS_ICA_ASS_T_AxisFAID__c != '' 
                         group by finserv__financialaccount__r.CRAN_VEC_ADV_P_PFMMkt__c];
        }else{
            aResult   = [select finserv__financialaccount__r.CRAN_VEC_ADV_P_PFMMkt__c pfm, count(finserv__role__c) cnt
                         from FinServ__FinancialAccountRole__c 
                         where finserv__financialaccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode
                                 and finserv__role__c = '102ASS'
                                 and finserv__financialaccount__r.FinServ__Status__c != '102ASS'
                                 and finserv__financialaccount__r.CRAS_ICA_ASS_T_AxisFAID__c != '' 
                         group by finserv__financialaccount__r.CRAN_VEC_ADV_P_PFMMkt__c];
        }
        
        for(AggregateResult ar:aResult){
           List<String> toadd = new List<String>(); 
            
            String market_label = (String)ar.get('pfm');
            
            if(userLanguage.equals('en_US')){
                toadd.add(englishMKT.get(market_label));
            } else if(userLanguage.equals('es')){
                toadd.add(spanishMKT.get(market_label));
            } else {
                toadd.add(market_label);
            }
            //toadd.add((String)ar.get('pfm_label'));
            toadd.add(String.valueOf((Integer)ar.get('cnt')));            
            resultList.add(toadd);  
        }
		
        return CRAS_ICA_ASS_Helpers_CLS.securityFilter(resultList, false);
    }    

    public static List<List<String>> getReportPrimeCountProduct(){

        List<List<String>> resultList = new List<List<String>>();
        
        List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();
        
        String savingsCode = CRAS_ICA_ASS_Helpers_CLS.savingsMKTCode;

		List<AggregateResult> aResult = null;
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner()){
            aResult = [select CRAS_ICA_ASS_T_ProductoPoliza__c name ,count(id) cnt, SUM(CRAS_ICA_ASS_C_PrimaAnual__c) prem 
                       from finserv__financialaccount__c 
                       where CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode
                               AND OwnerId in :owners
                               and FinServ__Status__c != '102ASS' 
                               and CRAS_ICA_ASS_T_AxisFAID__c != '' 
                       group by CRAS_ICA_ASS_T_ProductoPoliza__c];
        } else{
            aResult = [select CRAS_ICA_ASS_T_ProductoPoliza__c name ,count(id) cnt, SUM(CRAS_ICA_ASS_C_PrimaAnual__c) prem 
                       from finserv__financialaccount__c 
                       where CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode
                               and FinServ__Status__c != '102ASS' 
                               and CRAS_ICA_ASS_T_AxisFAID__c != '' 
                       group by CRAS_ICA_ASS_T_ProductoPoliza__c];
        }
        
        for(AggregateResult ar:aResult){
           List<String> toadd = new List<String>(); 
                
            if ((String)ar.get('name') != null && (String)ar.get('name') != ''){
                toadd.add((String)ar.get('name'));
                Decimal prem = (Decimal)ar.get('prem');
                prem = prem.setScale(2);
                toadd.add(String.valueOf(prem));
                toadd.add(String.valueOf((Integer)ar.get('cnt')));            
                resultList.add(toadd);  
            }
        }

        return CRAS_ICA_ASS_Helpers_CLS.securityFilter(resultList, true);
        
    }

    public static List<List<String>> getReportInsuredsProduct(){

        List<List<String>> resultList = new List<List<String>>();
        
        List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();
        
        String savingsCode = CRAS_ICA_ASS_Helpers_CLS.savingsMKTCode;
        
        List<AggregateResult> aResult = null;
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner()){
            aResult = [select finserv__financialaccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c prod,count(finserv__role__c) cnt
                       from FinServ__FinancialAccountRole__c 
                       where finserv__financialaccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode
                               AND finserv__financialaccount__r.OwnerId in :owners
                               and finserv__role__c = '102ASS'
                               and finserv__financialaccount__r.FinServ__Status__c != '102ASS'
                               and finserv__financialaccount__r.CRAS_ICA_ASS_T_AxisFAID__c != '' 
                       group by finserv__financialaccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c];   
        } else {
            aResult = [select finserv__financialaccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c prod,count(finserv__role__c) cnt
                       from FinServ__FinancialAccountRole__c 
                       where finserv__financialaccount__r.CRAN_VEC_ADV_P_PFMMkt__c != :savingsCode
                               and finserv__role__c = '102ASS'
                               and finserv__financialaccount__r.FinServ__Status__c != '102ASS'
                               and finserv__financialaccount__r.CRAS_ICA_ASS_T_AxisFAID__c != '' 
                       group by finserv__financialaccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c];  
        }
                
        for(AggregateResult ar:aResult){
           List<String> toadd = new List<String>(); 

            if ((String)ar.get('prod') != null && (String)ar.get('prod') != ''){            
                toadd.add((String)ar.get('prod'));
                toadd.add(String.valueOf((Integer)ar.get('cnt')));            
                resultList.add(toadd);
            }
        }

        return CRAS_ICA_ASS_Helpers_CLS.securityFilter(resultList, false);
        
    }
    
    public static List<List<String>> getReportPrimeCountSVP(){

        List<List<String>> resultList = new List<List<String>>();
        
        List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();
        
        String savingsCode = CRAS_ICA_ASS_Helpers_CLS.savingsMKTCode;
        List<AggregateResult> aResult = null;
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner()){
        	aResult = [select CRAS_ICA_ASS_T_ProductoPoliza__c name ,count(id) cnt
                       from FinServ__FinancialAccount__c 
                       where CRAN_VEC_ADV_P_PFMMkt__c = :savingsCode
                               AND OwnerId in :owners
                               and FinServ__Status__c != '102ASS' 
                               and CRAS_ICA_ASS_T_AxisFAID__c != '' 
                       group by CRAS_ICA_ASS_T_ProductoPoliza__c];
        }else{
            aResult = [select CRAS_ICA_ASS_T_ProductoPoliza__c name ,count(id) cnt
                       from FinServ__FinancialAccount__c 
                       where CRAN_VEC_ADV_P_PFMMkt__c = :savingsCode
                               and FinServ__Status__c != '102ASS' 
                               and CRAS_ICA_ASS_T_AxisFAID__c != '' 
                       group by CRAS_ICA_ASS_T_ProductoPoliza__c];
        }
        
        for(AggregateResult ar:aResult){
           List<String> toadd = new List<String>();
            
            if ((String)ar.get('name') != null && (String)ar.get('name') != ''){
                toadd.add((String)ar.get('name'));
                toadd.add(String.valueOf((Integer)ar.get('cnt')));            
                resultList.add(toadd);
            }
        }
        
        return CRAS_ICA_ASS_Helpers_CLS.securityFilter(resultList, false);
        
    }
    
    public static List<List<String>> getReportInsuredsSVP(){
        List<List<String>> resultList = new List<List<String>>();
        
        
        List<id> owners = CRAS_ICA_ASS_Helpers_CLS.getSubordinateUsers();
        
        String savingsCode = CRAS_ICA_ASS_Helpers_CLS.savingsMKTCode;
        
        List<AggregateResult> aResult = null;
        if (CRAS_ICA_ASS_Helpers_CLS.filterOwner()){
            aResult = [select finserv__financialaccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c prod,count(finserv__role__c) cnt
                       from FinServ__FinancialAccountRole__c 
                       where finserv__financialaccount__r.CRAN_VEC_ADV_P_PFMMkt__c = :savingsCode
                               AND finserv__financialaccount__r.OwnerId in :owners
                               and finserv__role__c = '102ASS'
                               and finserv__financialaccount__r.FinServ__Status__c != '102ASS'
                               and finserv__financialaccount__r.CRAS_ICA_ASS_T_AxisFAID__c != '' 
                       group by finserv__financialaccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c];
        }
        else{
            aResult = [select finserv__financialaccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c prod,count(finserv__role__c) cnt
                       from FinServ__FinancialAccountRole__c 
                       where finserv__financialaccount__r.CRAN_VEC_ADV_P_PFMMkt__c = :savingsCode
                               and finserv__role__c = '102ASS'
                               and finserv__financialaccount__r.FinServ__Status__c != '102ASS'
                               and finserv__financialaccount__r.CRAS_ICA_ASS_T_AxisFAID__c != '' 
                       group by finserv__financialaccount__r.CRAS_ICA_ASS_T_ProductoPoliza__c];
        }        
                
        for(AggregateResult ar:aResult){
           if ((String)ar.get('prod') != null && (String)ar.get('prod') != ''){
               List<String> toadd = new List<String>(); 
                
                toadd.add((String)ar.get('prod'));
                toadd.add(String.valueOf((Integer)ar.get('cnt')));            
                resultList.add(toadd);
            }   
        }

        return CRAS_ICA_ASS_Helpers_CLS.securityFilter(resultList, false);

        
    }
    
}