/**
 * FinancialAccountRole Trigger Util Class
 *
 * Fecha: 28/11/2016
 * @author  Julian Gonzalez Garcia (Vector ITC)
 * @version 1.0
 *
*/

public class CRAN_VEC_ADV_FinancialAccountRoleUtil {
    
    private static Set<id> validados = new Set<id>();

    public static void createFinancialAccountRoles(List<FinServ__FinancialAccountRole__c> listaNew){

        //SELECT ONLY RECORD TYPE == ContactRole, Use DeveloperName
        List<RecordType> lstRecordsTypesCR = [SELECT Id,Name,BusinessProcessId,DeveloperName,IsActive,NamespacePrefix,SobjectType FROM RecordType WHERE SobjectType = 'FinServ__FinancialAccountRole__c' AND DeveloperName = 'ContactRole' AND IsActive = true];
        String recordTypeCR = lstRecordsTypesCR[0].Id;
        
        //SELECT ONLY RECORD TYPE == Container, Use DeveloperName
        List<RecordType> lstRecordsTypesFA = [SELECT Id,Name,BusinessProcessId,DeveloperName,IsActive,NamespacePrefix,SobjectType FROM RecordType WHERE SobjectType = 'FinServ__FinancialAccount__c' AND DeveloperName = 'CRAN_VEC_ADV_Container' AND IsActive = true];
        String recordTypeFA = lstRecordsTypesFa[0].Id;

        Set<String> setFAids = new Set<String>();
        List<FinServ__FinancialAccountRole__c> lstFARs = new List<FinServ__FinancialAccountRole__c>();

        for(FinServ__FinancialAccountRole__c role : listaNew){
            //Only search containers for FAR Type CRAN_VEC_ADV_Container FinServ__FinancialAccount__c == null 
            if(role.RecordTypeId == recordTypeCR && role.FinServ__FinancialAccount__c == null){
                lstFARs.add(role);
                setFAids.add(role.CRAN_VEC_ADV_T_BPId__c);
            }
        }

        List<FinServ__FinancialAccount__c> lstContainers = [SELECT Id, RecordTypeId,FinServ__PrimaryOwner__c,FinServ__PrimaryOwner__r.CRAN_VEC_ADV_T_BPId__c 
                                                            FROM FinServ__FinancialAccount__c 
                                                            WHERE FinServ__PrimaryOwner__r.CRAN_VEC_ADV_T_BPId__c IN :setFAids
                                                            ORDER BY FinServ__FinancialAccountNumber__c DESC]; //AND RecordTypeId = :recordTypeFA
        List<FinServ__FinancialAccountRole__c> lstRolesToInsert = new List<FinServ__FinancialAccountRole__c>();

        Boolean firstElement;

        for (FinServ__FinancialAccountRole__c role : lstFARs){
            firstElement = true;
            if(role.FinServ__EndDate__c <= system.today())
            {
                role.FinServ__Active__c = false;
            }
            if(role.FinServ__FinancialAccount__c==null){
                for(FinServ__FinancialAccount__c container : lstContainers){
                    if(role.CRAN_VEC_ADV_T_BPId__c == container.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_T_BPId__c){
                        if (firstElement == true){
                            role.FinServ__FinancialAccount__c = container.Id;
                            firstElement = false;
                        }else{
                            FinServ__FinancialAccountRole__c auxRole = role.clone(false,true,false,true);
                            role.FinServ__FinancialAccount__c = container.Id;
                            auxRole.FinServ__SourceSystemId__c = null;
                            auxRole.CRAN_VEC_ADV_T_ParentFARole__c = role.FinServ__SourceSystemId__c;
                            lstRolesToInsert.add(auxRole);
                        }
                    }
                }
            }
        }
        if(lstRolesToInsert.size()>0){
            insert lstRolesToInsert;
        }
    }
    public static void updateCloneFinancialAccountRoles(List<FinServ__FinancialAccountRole__c> listNew, List<FinServ__FinancialAccountRole__c> listOld){

        /*
            Paso 0
            Declaracion de variables a ejecutar 
            Fecha Act: 03/07/2017
            Desarrollador: VASS
        */
        set<String> lstCloneRolesToUpdate = new set<String>();
        Map<Id, FinServ__FinancialAccountRole__c> deleteFAR          = new Map<Id, FinServ__FinancialAccountRole__c>();
        Map<Id, FinServ__FinancialAccountRole__c> ListNewFAR             = new Map<Id, FinServ__FinancialAccountRole__c>();
        //Id          recordTypeCR =  Schema.SObjectType.FinServ__FinancialAccountRole__c.getRecordTypeInfosByName().get('Contact Role').getRecordTypeId();
        Id recordTypeCR = [Select Id from RecordType where DeveloperName = 'ContactRole' and SObjectType = 'FinServ__FinancialAccountRole__c'].get(0).Id;
        
        for(Integer i=0; i < listNew.size();i++)
        {
           FinServ__FinancialAccountRole__c newFar = listNew[i];
           FinServ__FinancialAccountRole__c oldFar = listOld[i];
          if(newFar.FinServ__SourceSystemId__c != null && newFar.RecordTypeId == recordTypeCR && validChange(oldFar, newFar))
            {   
                FinServ__FinancialAccountRole__c farTmp = newFar.clone(false,true,false,false); 
                if(farTmp.FinServ__EndDate__c <= system.today())
                    {  
                            farTmp.FinServ__Active__c = false;
                            farTmp.FinServ__EndDate__c = farTmp.FinServ__EndDate__c;
                            newFar.CRAN_VEC_ADV_T_ParentFARole__c = 'Borrar';
                            listNewFar.put(oldFar.id, farTmp);

                    }else{        
                              
                            if(newFar.Finserv__RelatedContact__c   != oldFar.Finserv__RelatedContact__c ||
                               newFar.FinServ__RelatedAccount__c   != oldFar.FinServ__RelatedAccount__c ||
                               newFar.FinServ__Role__c             != oldFAR.FinServ__Role__c             )
                                {
                                                                                  
                                    ListNewFAR.put(oldFar.Id, farTmp); 
                                    newFar.Finserv__RelatedContact__c   = oldFar.Finserv__RelatedContact__c;
                                    newFar.FinServ__RelatedAccount__c   = oldFar.FinServ__RelatedAccount__c;
                                    newFar.FinServ__Role__c             = oldFAR.FinServ__Role__c;
                                    newFar.FinServ__Active__c = false;
                                    newFar.FinServ__SourceSystemId__c = 'Borrar';                                    

                                }
                    }
            }
        }
        system.debug('Registro Nuevo ' + listNew);
        system.debug('Registro insertar ' + listnewFar);
        if(listnewFar.size() > 0)
        {
            insert listnewFar.values();
        }
    }

    public static void updateAfterFinancialclone(List<FinServ__FinancialAccountRole__c> listNew, List<FinServ__FinancialAccountRole__c> listOld)
    {
        /*
            Paso 0
            Declaracion de variables a ejecutar 
            Fecha Act: 03/07/2017
            Desarrollador: VASS
        */
        List<FinServ__FinancialAccountRole__c> lstCloneRolesToUpdate = new List<FinServ__FinancialAccountRole__c>();
        Map<String, FinServ__FinancialAccountRole__c> completeFAR    = new Map<String, FinServ__FinancialAccountRole__c>();
        Map<Id, FinServ__FinancialAccountRole__c> deleteFAR          = new Map<Id, FinServ__FinancialAccountRole__c>();
        List<FinServ__FinancialAccountRole__c> newFAR                = new List<FinServ__FinancialAccountRole__c>();
        Map<Id, FinServ__FinancialAccountRole__c> updateFAR          = new Map<Id, FinServ__FinancialAccountRole__c>();
        Set<String>                                setFAids       = new Set<String>();
        //Id          recordTypeCR =  Schema.SObjectType.FinServ__FinancialAccountRole__c.getRecordTypeInfosByName().get('Contact Role').getRecordTypeId();
        Id recordTypeCR = [Select Id from RecordType where DeveloperName = 'ContactRole' and SObjectType = 'FinServ__FinancialAccountRole__c'].get(0).Id;

        /*
            Paso 0.1
            Seleccion de id a tratar dentro la actualizacion 
            Fecha Act: 03/07/2017
            Desarrollador: VASS
        */
        for(Integer i=0; i< listOld.size();i++)
        {
          FinServ__FinancialAccountRole__c FARold = listOld[i];
          FinServ__FinancialAccountRole__c FARnew = listNew[i];
          
          if(FARold.FinServ__SourceSystemId__c != null && validados.contains(FARold.Id))
            {           
                //indica que tiene FinServ__SourceSystemId__c y se esta actualizando
                completeFAR.put(FARold.FinServ__SourceSystemId__c, FARold);
                setFAids.add(FARold.CRAN_VEC_ADV_T_BPId__c);
            }
        }

        /*
            Paso 1
            Recorre la lista para seleccionar el tratamiento a ejecutarse de cada registro
            Fecha Act: 04/07/2017
            Desarrollador: VASSCRAN_VEC_ADV_T_ParentFARole__c
        */

        for(FinServ__FinancialAccountRole__c role: [SELECT FinServ__SourceSystemId__c,FinServ__FinancialAccount__c,FinServ__RelatedAccount__c, Finserv__RelatedContact__c,
                                                           CRAN_VEC_ADV_T_ParentFARole__c,FinServ__EndDate__c,FinServ__Role__c,FinServ__StartDate__c,Id , FinServ__Active__c
                                                    FROM FinServ__FinancialAccountRole__c 
                                                    WHERE CRAN_VEC_ADV_T_ParentFARole__c IN :completeFAR.keyset() AND FinServ__Role__c != 'Primary Owner' AND FinServ__Active__c = true
                                                          AND FinServ__SourceSystemId__c = null]){
                
                deleteFAR.put(role.id, role);

            }

            if(deleteFar.size() > 0)
            {
             // CRAN_VEC_ADV_FARoleTriggerHandler_CLS.deleteId = deleteFar.keySet();
              deleteAll(deleteFar.keySet());
            }
            
            if(setFAids.size() > 0){
                Boolean firstElement;
                List<FinServ__FinancialAccount__c> lstContainers = [SELECT Id, RecordTypeId,FinServ__PrimaryOwner__c,
                                FinServ__PrimaryOwner__r.CRAN_VEC_ADV_T_BPId__c FROM FinServ__FinancialAccount__c 
                                WHERE FinServ__PrimaryOwner__r.CRAN_VEC_ADV_T_BPId__c IN :setFAids];
    
                for (FinServ__FinancialAccountRole__c role : selectAll(completeFAR.keySet())){
                    if(role.FinServ__EndDate__c <= system.today())
                    {
                        role.FinServ__Active__c = false;
                    }
                        for(FinServ__FinancialAccount__c container : lstContainers){
                            if(role.CRAN_VEC_ADV_T_BPId__c == container.FinServ__PrimaryOwner__r.CRAN_VEC_ADV_T_BPId__c){
                                if (role.FinServ__FinancialAccount__c != container.Id){
                                    FinServ__FinancialAccountRole__c auxRole = role.clone(false,true,false,false);
                                    auxRole.FinServ__FinancialAccount__c = container.Id;
                                    auxRole.FinServ__SourceSystemId__c = null;
                                    auxRole.CRAN_VEC_ADV_T_ParentFARole__c = role.FinServ__SourceSystemId__c;
                                    auxRole.FinServ__EndDate__c = role.FinServ__EndDate__c;
                                    newFar.add(auxRole);
                                }
                            }
                         }
                  }
            }


        system.debug('A borrar: '+deleteFar);
        system.debug('A update: '+updateFar);
        system.debug('A Insertar: '+newFar);

        if(newFar.size() > 0)
        {
            insert newFar;
        }

    }


    
    public static void deleteParent()
    {
        //delete [Select Id From FinServ__FinancialAccountRole__c Where 
          //         (CRAN_VEC_ADV_T_ParentFARole__c = 'Borrar' AND CRAS_ICA_ASS_T_AxisFARoleID__c = null AND RecordType.DeveloperName = 'ContactRole')
            //    OR (CRAN_VEC_ADV_T_ParentFARole__c = null AND FinServ__SourceSystemId__c = null AND CRAS_ICA_ASS_T_AxisFARoleID__c = null AND RecordType.DeveloperName = 'ContactRole')];
       
        RecordType RecordsTypesCR = [SELECT Id,Name,BusinessProcessId,DeveloperName,IsActive,NamespacePrefix,SobjectType FROM RecordType WHERE SobjectType = 'FinServ__FinancialAccountRole__c' AND DeveloperName = 'ContactRole' AND IsActive = true limit 1];
        delete [Select Id From FinServ__FinancialAccountRole__c Where 
                (CRAN_VEC_ADV_T_ParentFARole__c = 'Borrar' OR FinServ__SourceSystemId__c = 'Borrar') 
                AND LastModifiedDate = TODAY AND FinServ__Role__c != 'Primary Owner' AND RecordTypeid = :RecordsTypesCR.Id AND CRAS_ICA_ASS_T_AxisFARoleID__c = null];
        
        //String query = 'Select Id From FinServ__FinancialAccountRole__c Where ';
        //query += '(CRAN_VEC_ADV_T_ParentFARole__c = \'Borrar\' AND CRAS_ICA_ASS_T_AxisFARoleID__c = null AND RecordType.DeveloperName = \'ContactRole\') ';
        //query += 'OR (CRAN_VEC_ADV_T_ParentFARole__c = null AND FinServ__SourceSystemId__c = null AND CRAS_ICA_ASS_T_AxisFARoleID__c = null AND RecordType.DeveloperName = \'ContactRole\')';
        
	        //CRAS_ICA_ASS_Vecna_Batch voice = new CRAS_ICA_ASS_Vecna_Batch(query);
        //Database.executeBatch(voice, 2000);
    }

    public static void deleteCloneFinancialAccountRoles(List<FinServ__FinancialAccountRole__c> listOld){
        Set<String> setParentFARIds = new Set<String>();
        
        for(Integer i = 0; i < listOld.size(); i++){
            if(listOld[i].FinServ__SourceSystemId__c != null){
                setParentFARIds.add(listOld[i].FinServ__SourceSystemId__c);
            }
        }

        if(!setParentFARIds.isEmpty()){
            List<FinServ__FinancialAccountRole__c> lstCloneRolesTodelete;
            lstCloneRolesTodelete = [SELECT Id FROM FinServ__FinancialAccountRole__c WHERE CRAN_VEC_ADV_T_ParentFARole__c = :setParentFARIds and CRAS_ICA_ASS_T_AxisFARoleID__c = null and FinServ__Active__c = true];
            if(!lstCloneRolesTodelete.isEmpty()){
                delete lstCloneRolesTodelete;
            }
        }
    }

    public static void undeleteCloneFinancialAccountRoles(List<FinServ__FinancialAccountRole__c> listNew){
        Set<String> setParentFARIds = new Set<String>();

        for(Integer i = 0; i < listNew.size(); i++){
            if(listNew[i].FinServ__SourceSystemId__c != null){
                setParentFARIds.add(listNew[i].FinServ__SourceSystemId__c);
            }
        }

        if(!setParentFARIds.isEmpty()){
            List<FinServ__FinancialAccountRole__c> lstCloneRolesToUndelete;
            lstCloneRolesToUndelete = [SELECT Id FROM FinServ__FinancialAccountRole__c WHERE CRAN_VEC_ADV_T_ParentFARole__c = :setParentFARIds AND CRAS_ICA_ASS_T_AxisFARoleID__c = null AND IsDeleted = true ALL ROWS];
            if(!lstCloneRolesToUndelete.isEmpty()){
                undelete lstCloneRolesToUndelete;
            }
        }
    }

    
    public static void deleteAll(set<id> tmp)
    {
        
       delete [Select id From FinServ__FinancialAccountRole__c Where Id IN :tmp];
    }

    public static List<FinServ__FinancialAccountRole__c> selectAll(set<String> tmp)
    {
        
       return [select CRAN_VAS_ADV_F_BP_Number_Code__c, CRAN_VEC_ADV_P_Bunit__c, CRAN_VEC_ADV_T_Account_Number__c, 
                CRAN_VEC_ADV_T_BPId__c, CRAN_VEC_ADV_T_BPNumber__c, CRAN_VEC_ADV_T_Business_Partner__c, 
                CRAN_VEC_ADV_T_ParentFARole__c, CRAN_VEC_ADV_T_PersonId__c, CRAS_ICA_ASS_P_BenchmarkGreen__c, 
                CRAS_ICA_ASS_P_BenchmarkStatus__c, CRAS_ICA_ASS_P_BenchmarkYellow__c, CRAS_ICA_ASS_PctSiniestralidad__c, 
                CRAS_ICA_ASS_PE_PorcentajeCopago__c, CRAS_ICA_ASS_T_AxisFARoleID__c, CurrencyIsoCode, FinServ__Active__c, 
                FinServ__Editable__c, FinServ__EndDate__c, FinServ__FinancialAccount__c, FinServ__RelatedAccount__c, 
                FinServ__RelatedContact__c, FinServ__Role__c, FinServ__SourceSystemId__c, FinServ__StartDate__c, 
                RecordTypeId from FinServ__FinancialAccountRole__c Where FinServ__SourceSystemId__c IN :tmp AND CRAN_VEC_ADV_T_ParentFARole__c != 'Borrar'];
    }
    
    public static boolean validChange(FinServ__FinancialAccountRole__c InOld, FinServ__FinancialAccountRole__c inNew)
    {
        boolean resp = false;
        
        if(inNew.Finserv__RelatedContact__c   != InOld.Finserv__RelatedContact__c ||
           inNew.FinServ__RelatedAccount__c   != InOld.FinServ__RelatedAccount__c ||
           inNew.FinServ__Role__c             != InOld.FinServ__Role__c ||
           inNew.CRAN_VEC_ADV_P_Bunit__c      != InOld.CRAN_VEC_ADV_P_Bunit__c ||
           inNew.FinServ__StartDate__c        != InOld.FinServ__StartDate__c ||
           inNew.FinServ__EndDate__c          != InOld.FinServ__EndDate__c
           )
        {
           system.debug('Registro Nuevo ' + inNew);
           system.debug('Registro Viejo ' + InOld);
           validados.add(InOld.id);
           resp = true; 
        }
        
        return resp;
    }
}