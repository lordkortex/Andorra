public with sharing class CRAS_ICA_ASS_Helpers_CLS {
    
    //CONSTANTES
    public static string healthMKTCode = '804102ASS';
    public static string lifeMKTCode = '804123ASS';
    public static string leaveMKTCode = '804124ASS';
    public static string savingsMKTCode = '804131ASS';
    public static string rentsMKTCode = '804147ASS';
    public static string WSUrlBase = '/services/apexrest/CRAS/';
    public static string AccountOwner = '1';
    public static string SEGUROS_ROL_TOMADOR = '101ASS'; //CRAS_ICA_ASS_Helpers_CLS.SEGUROS_ROL_TOMADOR
    public static string SEGUROS_ESTADO_FA_VIGENTE = '101ASS'; //CRAS_ICA_ASS_Helpers_CLS.SEGUROS_ESTADO_FA_VIGENTE
    public static string OFICINA_SEGUROS_995 = '995';
    public static String IDENTITY_SEGUROS = '102';
    public static String IDENTITY_BANCA_Y_SEGUROS = '103';
    public static String IDENTITY_SEGUROS_CORREDURIAS = '104';
    public static String IDENTITY_SEGUROS_DIRECCION = '105';
    public static String IDENTITY_SEGUROS_DIRECCION_RESTRINGIDO = '106';
    public static String OFICINA_SEGUROS_DEFAULT = '999';
    public static String OFICINA_SEGUROS_TELEMARKETING = '46';
    public static String CAIXABANK = 'CAIXABANK';
    public static String PROD_ASISTENCIA_SANITARIA_ID = '1409';
    public static String PROD_CREDIT_BAIXA_ID = '0292';
    //--
    public static String DUMMY_MANAGER_EMPLOYEE_NUMBER = '0000';
    public static String CREDIT_ANDORRA_EMPLOYEE_NUMBER = '';
    public static String CREDIT_ANDORRA_NAME = 'Crèdit Andorrà';
    
    public static Map<String,String> initMarketMap (Map<String,String> marketMap, String lang){
        
        if(lang == 'es_ES'){
            marketMap.put(healthMKTCode,'Seguros Salud');
            marketMap.put(lifeMKTCode,'Seguros Vida');
            marketMap.put(leaveMKTCode,'Seguros Baja');
            marketMap.put(savingsMKTCode,'Seguros Ahorro');
            marketMap.put(rentsMKTCode,'Rentas');
        } else if(lang == 'EN'){  
            marketMap.put(healthMKTCode,'Health Insurance');
            marketMap.put(lifeMKTCode,'Life Insurance');
            marketMap.put(leaveMKTCode,'Leave Insurance');
            marketMap.put(savingsMKTCode,'Savings Insurance');
            marketMap.put(rentsMKTCode,'Rents');
        }
        
        return marketMap;
    }
    
    public static Map<String, Id> oficinasAssegurances = new Map<String, Id>{
        '993' => null,//seguros
        '999' => null//seguros
    };
                
    public static Map<String, Integer> oficinasAssDireccion = new Map<String, Integer>{
        '994' => 1,//seguros rrhh
        '1001' => 1//seguros
    };
                            
   	public static Map<String, Id> oficinasAssCorredurias = new Map<String, Id>{
        '40' => null,//corredurias
        '41' => null,//corredurias
        '42' => null,//corredurias
        '43' => null,//corredurias
        '44' => null,//corredurias
        '45' => null,//corredurias
        '46' => null,//Telemarketing
        '47' => null,//corredurias
        '48' => null,//corredurias
        '49' => null//corredurias
    };
                                        
    public static Boolean isOficinaASS(String oficina){
        Boolean result = false;
        if (oficinasAssegurances.containsKey(oficina) || 
            oficinasAssCorredurias.containsKey(oficina) ||
            oficinasAssDireccion.containsKey(oficina)){
                result = true;
            }
        return result;
    }
    
    
    public static Map<String, String> viewAllRolesList = new Map <String, String>
    {
        'CRAN_ICA_KER_DireccionGeneralCreditAndorra'=>'Dirección General Crèdit Andorrà',
        'CRAN_ICA_KER_DireccionCreditAndorraBanca'=>'Dirección Crèdit Andorrà-Banca',
        'CRAN_ICA_KER_DIreccionMK'=>'Dirección MK',
        'CRAN_ICA_KER_DireccionGrupoAsegurador'=>'Dirección Grupo Asegurador',
        'CRAN_ICA_KER_DireccionComercialGrupoAsegurador' => 'Dirección Comercial Grupo Asegurador',
        'CRAN_ICA_KER_ResponsableDeSiniestros_Andorra'=>'Responsable de siniestros - Andorra',
        'CRAN_ICA_KER_DireccionCreditAssegurances999'=>'Dirección Crèdit Assegurances 999',
        'CRAN_ICA_KER_Gestoroficina999ASS_Andorra'=>'Gestor oficina 999 ASS - Andorra'
    };
                
    public static Map<String, String> gerenciaSegurosRolesList = new Map <String, String>{
        'CRAN_ICA_KER_DireccionGrupoAsegurador'=>'Dirección Grupo Asegurador',
        'CRAN_ICA_KER_DireccionComercialGrupoAsegurador' => 'Dirección Comercial Grupo Asegurador'
    };
        
    public static Map<String, String> directoresBancaCARolesList = new Map <String, String>{
        'CRAN_ICA_KER_DirectorOficina0BCO_Andorra'=>'Director Oficina 0 BCO - Andorra',
        'CRAN_ICA_KER_DirectorOficina2BCO_Andorra' => 'Director Oficina 2 BCO - Andorra',
        'CRAN_ICA_KER_DirectorOficina3BCO_Andorra'=>'Director Oficina 3 BCO - Andorra',
        'CRAN_ICA_KER_DirectorOficina4BCO_Andorra'=>'Director Oficina 4 BCO - Andorra',
        'CRAN_ICA_KER_DirectorOficina5BCO_Andorra'=>'Director Oficina 5 BCO - Andorra',
        'CRAN_ICA_KER_DirectorOficina6BCO_Andorra'=>'Director Oficina 6 BCO - Andorra',
        'CRAN_ICA_KER_DirectorOficina7BCO_Andorra'=>'Director Oficina 7 BCO - Andorra',
        'CRAN_ICA_KER_DirectorOficina8BCO_Andorra'=>'Director Oficina 8 BCO - Andorra',
        'CRAN_ICA_KER_DirectorOficina9BCO_Andorra'=>'Director Oficina 9 BCO - Andorra',
        'CRAN_ICA_KER_DirectorOficina10BCO_Andorra'=>'Director Oficina 10 BCO - Andorra',
        'CRAN_ICA_KER_DirectorOficina11BCO_Andorra'=>'Director Oficina 11 BCO - Andorra',
        'CRAN_ICA_KER_DirectorOficina12BCO_Andorra'=>'Director Oficina 12 BCO - Andorra',
        'CRAN_ICA_KER_DirectorOficina13BCO_Andorra'=>'Director Oficina 13 BCO - Andorra',
        'CRAN_ICA_KER_DirectorOficina14BCO_Andorra'=>'Director Oficina 14 BCO - Andorra',
        'CRAN_ICA_KER_DirectorOficina15BCO_Andorra'=>'Director Oficina 15 BCO - Andorra',
        'CRAN_ICA_KER_DirectorOficina16BCO_Andorra'=>'Director Oficina 16 BCO - Andorra',
        'CRAN_ICA_KER_DirectorOficina17BCO_Andorra'=>'Director Oficina 17 BCO - Andorra',
        'CRAN_ICA_KER_DirectorOficina18BCO_Andorra'=>'Director Oficina 18 BCO - Andorra',
        'CRAN_ICA_KER_DirectorOficina24BCO_Andorra'=>'Director Oficina 24 BCO - Andorra',
        'CRAN_ICA_KER_DirectorOficina34BCO_Andorra'=>'Director Oficina 34 BCO - Andorra'
    };
                            
    public static String getID18Length(String ID15){
        try {
            Id idval = ID15;
            String idStr = idval;
            return idStr;
        }
        catch(Exception e){
            System.debug('No es un ID válido: ' + ID15);
        }
        return ID15;
    }       
    
    public static string getUserCurrency(){
        return UserInfo.getDefaultCurrency();
    }
    
    public static String getUserRolDevName(){
        Id roleId = UserInfo.getUserRoleId();
        String roleDevName = [select id, DeveloperName from UserRole where id = :roleId].get(0).DeveloperName;
        return (String.isNotEmpty(roleDevName) ? roleDevName : '');
    }
    
    public static ID getRRHHUserID(){
        CRAS_ICA_ASS_InsuranceGlobal_CS__c  gCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
        User u = CRAS_ICA_ASS_Helpers_CLS.getUserByEmployeeNumber(gCS.CRAS_ICA_ASS_RRHHUser_ID__c);
        if (u != null){
            return u.Id;
        }
        return null;
    }
    
    public static ID getCAUserID(){
        User u = CRAS_ICA_ASS_Helpers_CLS.getUserByName(CREDIT_ANDORRA_NAME);
        if (u != null){
            return u.Id;
        }
        return null;
    }
    
    public static ID getDummyManagerUserID(){
        User u = CRAS_ICA_ASS_Helpers_CLS.getUserByEmployeeNumber(DUMMY_MANAGER_EMPLOYEE_NUMBER);
        if (u != null){
            return u.Id;
        }
        return null;
    }
    
    public static User getUserByEmployeeNumber(String employeeNumber){
        List<User> lstUsers = [SELECT Id, IsActive, username FROM User WHERE EmployeeNumber = :employeeNumber];
        if (lstUsers.size() > 0){
            return lstUsers[0];    
        }
        return null;       
    }
    
    public static User getUserByName(String name){
        List<User> lstUsers = [SELECT Id, IsActive, username, Name FROM User WHERE Name = :name];
        if (lstUsers.size() > 0){
            return lstUsers[0];    
        }
        return null;       
    }
    
    public static Boolean filterDirector(){
        Id currentRoleId = UserInfo.getUserRoleId();
        String currentRoleDevName = [select id,DeveloperName from UserRole where id = :currentRoleId limit 1].get(0).DeveloperName;
        Map<String, String> exceptionRolesList = new Map<String, String>();
        exceptionRolesList.putAll(directoresBancaCARolesList);
        
        return exceptionRolesList.containsKey(currentRoleDevName);
    }
    
    public static Boolean filterOwner(){
        Id currentRoleId = UserInfo.getUserRoleId();
        String currentRoleDevName = [select id,DeveloperName from UserRole where id = :currentRoleId limit 1].get(0).DeveloperName;
        Map<String, String> exceptionRolesList = new Map<String, String>();
        exceptionRolesList.putAll(viewAllRolesList);
        exceptionRolesList.putAll(directoresBancaCARolesList);
        
        return !exceptionRolesList.containsKey(currentRoleDevName);
    }
    
    public static String getUserOffice(){
        List<User> lstUsers = [SELECT Id, CRAN_ICA_KER_P_Oficina__c FROM User WHERE Id =: UserInfo.getUserId()];
        if (lstUsers.size() > 0){
            return lstUsers[0].CRAN_ICA_KER_P_Oficina__c;    
        }
        return null;
    }
    
    public static List<String> getOficinasCABancaComercial()
    {
        CRAS_ICA_ASS_InsuranceGlobal_CS__c  gCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
        return gCS.CRAS_ICA_ASS_OficinasBancaComercial__c.split(',');
    }
    
    public static List<String> getOficinasCABancaPrivada()
    {
        CRAS_ICA_ASS_InsuranceGlobal_CS__c  gCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
        return gCS.CRAS_ICA_ASS_OficinasBancaPrivada__c.split(',');
    }
    
    public static void setUsersForOficinasAssCorredurias(Map<String, Id> mapCorredurias){
        CRAS_ICA_ASS_InsuranceGlobal_CS__c  gCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
        mapCorredurias.put('40', CRAS_ICA_ASS_Helpers_CLS.getUserByEmployeeNumber(gCS.CRAS_ICA_ASS_Corr40User_ID__c).Id);
        mapCorredurias.put('41', CRAS_ICA_ASS_Helpers_CLS.getUserByEmployeeNumber(gCS.CRAS_ICA_ASS_Corr41User_ID__c).Id);
        mapCorredurias.put('42', CRAS_ICA_ASS_Helpers_CLS.getUserByEmployeeNumber(gCS.CRAS_ICA_ASS_Corr42User_ID__c).Id);
        mapCorredurias.put('43', CRAS_ICA_ASS_Helpers_CLS.getUserByEmployeeNumber(gCS.CRAS_ICA_ASS_Corr43User_ID__c).Id);
        mapCorredurias.put('44', CRAS_ICA_ASS_Helpers_CLS.getUserByEmployeeNumber(gCS.CRAS_ICA_ASS_Corr44User_ID__c).Id);
        mapCorredurias.put('45', CRAS_ICA_ASS_Helpers_CLS.getUserByEmployeeNumber(gCS.CRAS_ICA_ASS_Corr45User_ID__c).Id);
        mapCorredurias.put('47', CRAS_ICA_ASS_Helpers_CLS.getUserByEmployeeNumber(gCS.CRAS_ICA_ASS_Corr47User_ID__c).Id);
        mapCorredurias.put('48', CRAS_ICA_ASS_Helpers_CLS.getUserByEmployeeNumber(gCS.CRAS_ICA_ASS_Corr48User_ID__c).Id);
        mapCorredurias.put('49', CRAS_ICA_ASS_Helpers_CLS.getUserByEmployeeNumber(gCS.CRAS_ICA_ASS_Corr49User_ID__c).Id);
    }
    
    public static void setUsersForOficinasAssegurances(Map<String, Id> mapOficinas){
        CRAS_ICA_ASS_InsuranceGlobal_CS__c  gCS = CRAS_ICA_ASS_InsuranceGlobal_CS__c.getOrgDefaults();
        mapOficinas.put('46', CRAS_ICA_ASS_Helpers_CLS.getUserByEmployeeNumber(gCS.CRAS_ICA_ASS_Tele46User_ID__c).Id);
    }
    
    public static String getSessionIdFromVFPage(PageReference visualforcePage){
        String content;
        if(!Test.isRunningTest())
        {
            content = visualforcePage.getContent().toString();
        }
        else
        {
            content = 'Start_Of_Session_Id' + UserInfo.getSessionId() + 'End_Of_Session_Id';
        }
        Integer s = content.indexOf('Start_Of_Session_Id') + 'Start_Of_Session_Id'.length(),
            e = content.indexOf('End_Of_Session_Id');
        return content.substring(s, e);
    }
    
    public static String getDataFromWS(String url){
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        
        String instanceUrl = system.URL.getSalesforceBaseUrl().toExternalForm();
        String calloutString = instanceUrl + CRAS_ICA_ASS_Helpers_CLS.WSUrlBase + url;
        req.setEndpoint(calloutString);        
        req.setHeader('Authorization', 'OAuth ' + CRAS_ICA_ASS_Helpers_CLS.getSessionIdFromVFPage(Page.CRAS_ICA_ASS_SessionId));
        
        req.setMethod('GET');
        
        HttpResponse res = h.send(req);
        return res.getBody();  
    }
    
    public static String getFullUrlFromSObjectId(String name, ID objId){
        return '<a href="#/sObject/' + objId + '/view">' + name + '</a>';
    }
    
    
    public static List<CRAS_ICA_ASS_SFField_OBJ> getFieldsLabelForAura(SObjectType sObjectType, Map<String, Integer> compactLayoutFields){
        List<SelectOption> result = getFieldsLabel(sObjectType, compactLayoutFields);
        List<CRAS_ICA_ASS_SFField_OBJ> responseList = new List<CRAS_ICA_ASS_SFField_OBJ>();
        for (SelectOption so : result){
            responseList.add(new CRAS_ICA_ASS_SFField_OBJ(so.getValue(), so.getLabel(), so.getDisabled()));
        }
        return responseList;
    }
    
    public static List<SelectOption> getFieldsLabel(SObjectType sObjectType, Map<String, Integer> filteredFields){
        map<string, schema.sObjectType> so = schema.getGlobalDescribe();
        schema.sObjectType allSelectedObject = so.get('' + sObjectType);
        schema.DescribesObjectResult result = allSelectedObject.getdescribe();
        map<string, schema.sObjectField> f= result.fields.getMap(); 
        List<SelectOption> Fields = new List<SelectOption>();
        for (Integer i = 0; i < filteredFields.size(); i++){
            Fields.add(null);
        }
        if (filteredFields.size() > 0){
            Integer i = -1;
            for(schema.sObjectField SFields: f.values()){
                if (filteredFields.containsKey(SFields.getDescribe().getName())){
                    i = filteredFields.get(SFields.getDescribe().getName());
                    Fields.set(i - 1, new selectoption(SFields.getDescribe().getName(), SFields.getDescribe().getLabel()));
                }
            }
        }
        else{
            for(schema.sObjectField SFields: f.values()){
                Fields.add(new selectoption(SFields.getDescribe().getName(), SFields.getDescribe().getLabel()));
            }
        }
        
        return Fields;
    }
    
    public static Date DateNow() {
        DateTime dT = DateTime.now();
        return Date.newInstance(dT.year(), dT.month(), dT.day());
    }
    
    public static set<Id> getSubordinateRoles(Id roleId) {
        map<Id, set<Id>> parentAndChildren = new map<Id, set<Id>>();
        set<Id> children;
        for(UserRole ur : [select Id, ParentRoleId from UserRole]) {
            children = parentAndChildren.containsKey(ur.ParentRoleId) ? parentAndChildren.get(ur.ParentRoleId) : new set<Id>();
            children.add(ur.Id);
            parentAndChildren.put(ur.ParentRoleId, children);
        }
        return getSubordinateRoles(roleId, parentAndChildren);
    }
    
    public static set<Id> getSubordinateRoles(Id roleId, map<Id, set<Id>> parentAndChildren) {
        set<Id> subordinateRoles = new set<Id>();
        set<Id> remainingSubordinateRoles = new set<Id>();
        if(parentAndChildren.containsKey(roleId)) {
            subordinateRoles.addAll(parentAndChildren.get(roleId));
            for(Id subRoleId : subordinateRoles) {
                remainingSubordinateRoles.addAll(getSubordinateRoles(subRoleId, parentAndChildren));
            }
        }
        subordinateRoles.addAll(remainingSubordinateRoles);
        return subordinateRoles;
    }
    
    //obtener desde lista de roles
    public static set<Id> getSubordinateRoles(List<Id> roleIdList) {
        set<id> finalList = new set<id>();
        for (id roleId : roleIdList){
            finalList.addAll(getSubordinateRoles(roleId));
        }
        return finalList;
    }
    
    public static List<id> getUsersFromRoles(set<Id> roles){
        List<User> ul = [select id from User where userroleid in :roles];
        List<id> uidl = new List<id>();
        for (user u : ul){
            uidl.add(u.id);
        }
        //uidl.add(UserInfo.getUserId()); //añadirse a si mismo
        return uidl;
    }
    
    public static List<id> getAdditionalRoles(Id roleId){
        
        List<id> result = new List<id>();
        Map<String,List<String>> additionalRolesMap = new Map<String,List<String>>();
        
        //get developer name from role id
        String currentRoleDevName = [select id,DeveloperName from UserRole where id = :roleId limit 1].get(0).DeveloperName;
        
        //put on map
        List<String> l1 = new List<String>();
        l1.add('CRAN_ICA_KER_DireccionAreaBCO_Andorra');
        l1.add('CRAN_ICA_KER_DireccionAreaBPR_Andorra');
        additionalRolesMap.put('CRAN_ICA_KER_DireccionGrupoAsegurador',l1);
        additionalRolesMap.put('CRAN_ICA_KER_DireccionComercialGrupoAsegurador',l1);
        additionalRolesMap.put('CRAN_ICA_KER_ResponsableDeSiniestros_Andorra',l1); 
        additionalRolesMap.put('CRAN_ICA_KER_DireccionCreditAssegurances999',l1); 
        additionalRolesMap.put('CRAN_ICA_KER_Gestoroficina999ASS_Andorra',l1); 
        
        if(additionalRolesMap.containsKey(currentRoleDevName)){
            List<String> rolesDevNameList = additionalRolesMap.get(currentRoleDevName);
            //obtener los ids
            List<UserRole> rolesList = [select id from UserRole where developername in :rolesDevNameList];
            
            for(UserRole ur: rolesList){
                result.add(ur.id);
            }
        }
        
        return result; 
    }
    
    public static List<id> getSubordinateUsers(){
        
        //obtenemos el rol del usuario actual
        Id currentRoleId = UserInfo.getUserRoleId();
        if (currentRoleId == null){
            return null;
            System.debug(LoggingLevel.ERROR, 'USUARIO SIN ROL');
        }
        
        //lista de roles a consultar sus users
        List<Id> rolesUserList = new List<Id>();
        
        rolesUserList.add(currentRoleId);
        
        //TODO obtener los roles adicionales a los que también tiene acceso
        rolesUserList.addAll(getAdditionalRoles(currentRoleId));
        
        //Buscar todos sus roles subordinados (contiene el suyo)
        set<id> subordinateRoles =  getSubordinateRoles(rolesUserList);
        
        //obtenemos todos los usuarios de dichos roles
        List<id> subordinateUsers = getUsersFromRoles(subordinateRoles);
        
        subordinateUsers.add(UserInfo.getUserId());
        
        return subordinateUsers;
        
    }
    
    public static List<List<String>> securityFilter(List<List<String>> lstString, Boolean isDecimal)
    {
        List<FinServ__Securities__c> sgLst = [SELECT FinServ__SecuritiesName__c 
                                              FROM FinServ__Securities__c
                                              WHERE CRAS_ICA_ASS_T_Family__c = :CAIXABANK];
        
        List<List<String>> newLstString = new List<List<String>>();
        Map<String, Integer> mapCB = new Map<String, Integer>();
        Decimal cbTotal = 0;
        Integer cbCount = 0;
        
        for(FinServ__Securities__c sg : sgLst)
        {
            mapCB.put(sg.FinServ__SecuritiesName__c, null);
        }
        
        for(List<String> searchLst : lstString)
        {
            if(mapCB.containsKey(searchLst[0]))
            {
                cbTotal += Decimal.valueOf(searchLst[1]);
                if(isDecimal)
                {
                    cbCount += Integer.valueOf(searchLst[2]);
                }
            }
            else
            {
                newLstString.add(searchLst);
            }
        }
        
        if(isDecimal && cbTotal > 0)
        {
            newLstString.add(new List<String>{CAIXABANK, String.valueOf(cbTotal), String.valueOf(cbCount)});
        }
        else if (cbTotal > 0)
        {
            newLstString.add(new List<String>{CAIXABANK, String.valueOf((Integer)cbTotal)});
        }
        
        return newLstString;
    }
    
    /**
* Sobrecarga especial para la siniestralidad 
**/
    public static List<List<String>> securityFilter(List<List<String>> lstString)
    {
        List<FinServ__Securities__c> sgLst = [SELECT FinServ__SecuritiesName__c 
                                              FROM FinServ__Securities__c
                                              WHERE CRAS_ICA_ASS_T_Family__c = :CAIXABANK];
        
        List<List<String>> newLstString = new List<List<String>>();
        Map<String, Integer> mapCB = new Map<String, Integer>();
        Decimal cbTotal = 0;
        String benchRed = '';
        string benchYellow = '';
        
        for(FinServ__Securities__c sg : sgLst)
        {
            mapCB.put(sg.FinServ__SecuritiesName__c, null);
        }
        
        for(List<String> searchLst : lstString)
        {
            if(mapCB.containsKey(searchLst[0]))
            {
                cbTotal += Decimal.valueOf(searchLst[1]);
                benchRed = searchLst[3];
                benchYellow = searchLst[2];
            }
            else
            {
                newLstString.add(searchLst);
            }
        }
        
        if(cbTotal > 0)
        {
            newLstString.add(new List<String>{CAIXABANK, String.valueOf(cbTotal), benchYellow, benchRed});
        }
        
        return newLstString;
    }
    
    public static String getSOQLDate(Date input){
        Datetime output = input;
        return output.formatGmt('yyyy-MM-dd'); 
    }
    
    public static Blob createBlobFile(String content){
        return Blob.valueOf(content);
    }
    
    public static String createBase64File(String content){
        return EncodingUtil.base64Encode(createBlobFile(content));
    }
    
}