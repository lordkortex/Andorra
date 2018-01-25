/**
* Util class used to wrapper records with additional information to aid the development in Lightning
*
* @author  ZLR
* @version 1.0
*/
public with sharing class CRAN_VAS_KER_LCUtil_CLS {
	
    /**
    * Performs a query enforcing or not the field level security wrapping the results with additional information about the sobject and its fields
    *
    * @param  	sObjectApiName  sobject api name
    * @param  	optionalClause  string contaning any optional clause (e.g.: Where, Order By, Limit)
    * @param  	strFieldNames   string containing the fields to query
    * @param  	enforceSharing  true to enforce sharing settings
    * @return 					a wrapper of an sobject and its information 
    */  	
    public static SObjectWrapper getResults(String sObjectApiName, String optionalClause, String strFieldNames, Boolean enforceSharing) {
        
        List<String> 									queriedFields		= new List<String>();   
        List<List<CRAN_VAS_KER_LCUtil_CLS.FieldModel>> 	results 			= new List<List<CRAN_VAS_KER_LCUtil_CLS.FieldModel>>();
        Map<String, CRAN_VAS_KER_LCUtil_CLS.FieldModel> mappedFieldsModel 	= new Map<String, CRAN_VAS_KER_LCUtil_CLS.FieldModel>();
		SObjectWrapper									sObjectWrapper 		= new SObjectWrapper();
        
		// Checks or not field level security formatting the query in order to return the fields with the proper format
		String fieldsToquery 	= checkFLSAndFormatQuery(sObjectApiName, sObjectWrapper, strFieldNames, mappedFieldsModel, queriedFields, enforceSharing);
        
		// Format the fields with the optional clause
		String query 			= String.format('SELECT {0} {1}', new String[] { fieldsToquery,  optionalClause});
	
        for (sObject record : Database.query(query)) {
            
            if(Limits.getCpuTime()*1.10 >= Limits.getLimitCpuTime()){
                sObjectWrapper.limitReached = true;
                break;
            }
            if(Limits.getHeapSize()*1.10 >= Limits.getLimitHeapSize()){
                sObjectWrapper.limitReached = true;
                break;
            }
	
            List<CRAN_VAS_KER_LCUtil_CLS.FieldModel> fields = new List<CRAN_VAS_KER_LCUtil_CLS.FieldModel>();
			
			// For each record field prepares a model containing its value and additional information
            for (String queriedField : queriedFields) {
				
				// Gets the base model for the field
                CRAN_VAS_KER_LCUtil_CLS.FieldModel 	modelfieldOpt 			= mappedFieldsModel.get(queriedField);
				
				// Sets the model of a the field
                CRAN_VAS_KER_LCUtil_CLS.FieldModel 	newfieldOpt				= new CRAN_VAS_KER_LCUtil_CLS.FieldModel();
													newfieldOpt.apiName 	= modelfieldOpt.apiName;
													newfieldOpt.label 		= modelfieldOpt.label;
													newfieldOpt.fieldType 	= modelfieldOpt.fieldType; 													
                
				// If it's a reference field its value is set with the name of the referenced record
                if (modelfieldOpt.fieldType == 'REFERENCE') {
                    newfieldOpt.recId = String.valueOf(record.get(queriedField));
                    newfieldOpt.value = getSObjectValue(modelfieldOpt.referenceName +'.Name', record);
				
				// If it's a name field adds the id in order to create a link for the record
                } else if (queriedField == 'Name') {
		
					newfieldOpt.value = getSObjectValue(queriedField, record);    
					
                } else {
					
                    newfieldOpt.value =  getSObjectValue(queriedField, record);
					
                }
				
				// Adds the field for the record list
                fields.add(newfieldOpt);
            }
			
			// Adds the record with its fields
            results.add(fields);
        }
		
		// Adds all records to the wrapper of the sobject
		sObjectWrapper.records.addAll(results);
        
        return sObjectWrapper;
    }
	
    /**
    * Performs a query enforcing the field level security wrapping the results with additional information about the sobject and its fields
    *
    * @param  	sObjectApiName  sobject api name
    * @param  	optionalClause  string contaning any optional clause (e.g.: Where, Order By, Limit)
    * @param  	strFieldNames   string containing the fields to query
    * @return 					a wrapper of an sobject and its information 
    */  	
    public static SObjectWrapper getResults(String sObjectApiName, String optionalClause, String strFieldNames) {
        return getResults(sObjectApiName, optionalClause, strFieldNames, true);
    }	
    
    /**
    * Performs a query enforcing or not the field level security wrapping the results with additional information about the sobject and its fields
    *
    * @param  	sObjectApiName  	sobject api name
    * @param  	sObjectWrapper  	wrapper of the sobject to be setted
    * @param  	strFieldNames  		string containing the inputted fields to query
    * @param  	mappedFieldsModel 	map containg a model for each queried field
    * @param  	queriedFields  		list of string containg each queried field
    * @param  	enforceSharing  	true to enforce sharing settings		
    * @return 						a formatted string with the fields to perfom the query
    */  	
    private static String checkFLSAndFormatQuery(String sObjectApiName,SObjectWrapper sObjectWrapper, String strFieldNames, 
												Map<String, CRAN_VAS_KER_LCUtil_CLS.FieldModel> mappedFieldsModel, List<String> queriedFields, Boolean enforceSharing) {
        
		// Gets a list of string with the fields to query
		Set<String> 	uniqueInputtedFieldNames			= new Set<String>();
                        uniqueInputtedFieldNames.addAll(getStringAsList(strFieldNames)); 
                    	uniqueInputtedFieldNames.remove('Id');                                                    
                                                    
        List<String> 	inputtedFieldNames 					= new String[]{'Id'};
            			inputtedFieldNames.addAll(uniqueInputtedFieldNames);
                                                    
        List<String> 	formattedQueryFieldsList 			= new List<String>();
        
		// Gets the describe of the sobject and its fields map
        Schema.SObjectType sObjectType 						= Schema.getGlobalDescribe().get(sObjectApiName); 
        Schema.DescribeSObjectResult describeSObjectResult 	= sObjectType.getDescribe();  
        Map<String, Schema.SObjectField> fieldMap 			= describeSObjectResult.fields.getMap();         
		
		// Sets the values of the sobject wrapper
		sObjectWrapper.label 			= describeSObjectResult.getLabel();
		sObjectWrapper.apiName 			= describeSObjectResult.getName();
		sObjectWrapper.pluralLabel 		= describeSObjectResult.getLabelPlural();
		sObjectWrapper.isCreateable 	= describeSObjectResult.isCreateable();
		sObjectWrapper.isDeletable 		= describeSObjectResult.isDeletable();
		sObjectWrapper.isUpdateable 	= describeSObjectResult.isUpdateable();
		
		
        for (String fieldAPIName : inputtedFieldNames) {
            
			// Gets the describe of the field based on the field path
            DescribeFieldResult describeResult 	= getFieldDescribe(fieldAPIName, describeSObjectResult);     
            Schema.DisplayType displayType 		= describeResult.getType();                
            
			// Checks if the field is available for the current user if required
            if ((enforceSharing && describeResult.isAccessible()) || !enforceSharing) {
                
				// Adds the field that will be queried
                queriedFields.add(fieldAPIName);
                
				// Sets the model of the field with its describe values
                CRAN_VAS_KER_LCUtil_CLS.FieldModel 		myOption 			= new CRAN_VAS_KER_LCUtil_CLS.FieldModel();
                                                        myOption.apiName 	= fieldAPIName;
                                                        myOption.label 		= describeResult.getLabel();
                                                        myOption.fieldType 	= String.valueOf(displayType);                
                
				// Based on the type of the field format the query to get the value in a proper format
                if (displayType == Schema.DisplayType.CURRENCY || displayType == Schema.DisplayType.DATE) {
                   
				   formattedQueryFieldsList.add('FORMAT(' + fieldAPIName + ')');    
				   
                } else if (displayType == Schema.DisplayType.PICKLIST) {
                    
					formattedQueryFieldsList.add('toLabel(' + fieldAPIName + ')');  
					
                } else if (displayType == Schema.DisplayType.REFERENCE) {
                    
					// If it's a reference field gets its relationship name in order to get the name of the record
                    String 	referenceName 			= describeResult.getRelationshipName();                    
                    if(describeResult.getName().endsWith('Id')){
                        myOption.label			= describeResult.getReferenceTo()[0].getDescribe().getLabel();                   
                    }
                    		
                    myOption.referenceName 	= referenceName;
                    
                    formattedQueryFieldsList.add(fieldAPIName);
                    formattedQueryFieldsList.add(referenceName + '.Name');
					
                } else {
					
                    formattedQueryFieldsList.add(fieldAPIName);
					
                }                      
                
				// Maps the model of the field by its api name
                mappedFieldsModel.put(fieldAPIName, myOption);
            }             
        }
        
        return String.join(formattedQueryFieldsList, ',');
    }

    /**
     * Method to retrieve the available values of a picklist field.
     * @param  	sObjectApiName  	sobject api name
     * @param  	fieldApiName  		field api name
     * @return 						wrapper of picklist field with its values
     * */
    public static SObjectWrapper getPicklistFieldValues (String sObjectApiName, String fieldApiName) {
        
        SObjectWrapper result = new SObjectWrapper();
        PicklistFieldModel pfm = new PicklistFieldModel();
            
        Schema.SObjectType sObjectType 						= Schema.getGlobalDescribe().get(sObjectApiName); 
        Schema.DescribeSObjectResult describeSObjectResult 	= sObjectType.getDescribe();  
        Map<String, Schema.SObjectField> fieldMap 			= describeSObjectResult.fields.getMap();
              
        Schema.DescribeFieldResult fieldResult = fieldMap.get(fieldApiName).getDescribe();
        
        pfm.apiName = fieldApiName;
        pfm.label = fieldResult.getLabel();
        pfm.fieldType = String.valueOf(fieldResult.getType());
		pfm.referenceName = fieldResult.getRelationshipName();
            
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
        {
            pfm.values.add(f.getValue());
            pfm.labels.add(f.getLabel());
        }
        result.picklistFields.add(pfm);
        
     	return result;   
    }
    
    /**
    * Recursive method to retrieve the value of a field
    *
    * @param  	path  			path to the field (e.g.: Name, Object__r.Value)
    * @param  	parentSObject  	sobject that holds the field value
    * @return 					value of the field
    */	
    private static String getSObjectValue(String path, SObject parentSObject) {
        
        if (parentSObject == null)
            return '';

		// If there is a cross reference gets the next path using recursion
        if (path.contains('.')) {
            
			// Splits the cross reference path
			String[] paths 	= path.split('\\.');
			String refPath = paths[0];

			// Removes the current path before using the recursion
            paths.remove(0);
            return String.valueOf(getSObjectValue(String.join(paths, '.'), parentSObject.getSObject(refPath)));
            
        } else {
			// Return the value of the field when there is no more cross reference
			Object obj = parentSObject.get(path);
            if (obj != null)
            	return String.valueOf(parentSObject.get(path));
            else
                return '';
        }
		
    }

    /**
    * Recursive method to retrieve the describe of a field
    *
    * @param  	path  					path to the field (e.g.: Name, Object__r.Value)
    * @param  	describeSObjectResult  	describe of a sobject
    * @return 							describe of the field
    */	    
    private static DescribeFieldResult getFieldDescribe(String path, DescribeSObjectResult describeSObjectResult) {
        
        Map<String, Schema.SObjectField> 	fieldMap		= describeSObjectResult.fields.getMap();
        DescribeFieldResult					describeResult 	= null;
        
		// If there is a cross reference uses recursion to find the path describe 
        if (path.contains('.')) {
			
			// Splits the cross reference path
            String[] 	paths 		= path.split('\\.');
            String 		refPath 	= paths[0];
			
			// If it's a custom object cross reference replaces __r to __c in order to get the describe of the field
			// Or if it's a standard cross reference adds the Id suffix in order to get the describe of the field
            if (refPath.contains('__r'))
                refPath = refPath.replace('__r', '__c');
            else
                refPath = refPath + 'Id';

         	DescribeFieldResult fieldDescribe = fieldMap.get(refPath).getDescribe();
            
			// If it's not a polymorfic field (e.g.: WhatId) uses recursion to find the describe of the next field
            if (!fieldDescribe.isNamePointing()) {
				// Removes the current path before using the recursion
                paths.remove(0);
                describeResult = getFieldDescribe(String.join(paths, '.'), fieldDescribe.getReferenceTo()[0].getDescribe());
            }

        } else {
			// Return the describe of the field when there is no more cross reference 
            describeResult = fieldMap.get(path).getDescribe();
        }
        
        return describeResult;
    }
    
    /**
    * Splits a string separated by comma
    *
    * @param  	stringToSplit  	string to split
    * @return 					a list of string
    */  	
    public static List<String> getStringAsList(String stringToSplit) {
		// Remove all whitespaces
		stringToSplit = stringToSplit.replaceAll(' +', '');
        return stringToSplit.split(',');
    }
    
    public static String getOwnerField(String sObjectApiName) {
        
        DescribeSObjectResult describe = Schema.getGlobalDescribe().get(sObjectApiName).getDescribe();
        Map<String, SObjectField> fields = describe.fields.getMap();
        
        if (fields.get('OwnerId') != null) {
            return 'OwnerId';
        } else {
        
            for (String apiName : fields.keySet()) {
            
                DescribeFieldResult field = fields.get(apiName).getDescribe();
        
                if (field.getRelationshipOrder() == 0) {
                    return field.getRelationshipName() + '.OwnerId';
                }
            }
        }

        return null;
    }

    public static List<relAccountBp> getRelationAccountBp(Map<Id ,Id> mAccBp)
    {
        List<relAccountBp>  out          = new List<relAccountBp>();
        Set<Id>             findTmp      = new Set<Id>();
        Map<Id, Set<String>> findFAR = new Map<Id, Set<String>>();
        
         if(!Test.isRunningTest() || (Test.isRunningTest() && runInTest)){  
            for(FinServ__FinancialAccountRole__c fTmp : [Select FinServ__FinancialAccount__r.FinServ__PrimaryOwner__c, 
                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Name,
                FinServ__RelatedAccount__r.Name ,FinServ__RelatedContact__c, Id, FinServ__RelatedContact__r.AccountId 
                                                         from FinServ__FinancialAccountRole__c 
                                                         Where FinServ__RelatedContact__r.AccountId IN :mAccBp.keySet() 
                                                         AND (FinServ__Role__c = '1' OR FinServ__Role__c = '1005')])
            {
                if(mAccBp.containsKey(fTmp.FinServ__RelatedContact__r.AccountId)){
                    if(mAccBp.get(fTmp.FinServ__RelatedContact__r.AccountId) == fTmp.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__c)
                    {
                        findTmp.add(fTmp.FinServ__RelatedContact__r.AccountId);
                    }else
                    {
                        if(findFAR.containsKey(fTmp.FinServ__RelatedContact__r.AccountId)){
                            findFAR.get(fTmp.FinServ__RelatedContact__r.AccountId).add(fTmp.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Name);
                        }else
                        {
                            Set<String> sTmp = new Set<String>();
                            sTmp.add(fTmp.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Name);
                            findFAR.put(fTmp.FinServ__RelatedContact__r.AccountId, sTmp);
                        }
                    }
                }
            }
            
            for(Id tmp : mAccBp.keySet())
            {
                
                  if(findFAR.containsKey(tmp))
                    {  
                        String collegeString = '';
                        for(String s: findFAR.get(tmp)) 
                        {
                            collegeString += (collegeString==''?'':',')+s;
                        } 
                        out.add(new relAccountBp(tmp, mAccBp.get(tmp), true, null, collegeString));
                    }else
                    {
                        out.add( new relAccountBp(tmp, mAccBp.get(tmp), false));
                    }
                    
                
            }
        }
        return out;
    }


    public static List<relAccountBp> getBadRelation(List<String> accountBp)
    {
        List<relAccountBp>  out          = new List<relAccountBp>();
        Set<Id>             sIdAccount   = new Set<Id>();
        Set<Id>             sIdBp        = new Set<Id>();
        Map<Id, Id>         mAccBp       = new Map<Id, Id>();
        Set<Id>             findTmp      = new Set<Id>();
        Map<Id, Set<String>> findFAR = new Map<Id, Set<String>>();
        if(!Test.isRunningTest() || (Test.isRunningTest() && runInTest)){
            for(String tmp : accountBp)
            {
                list<String> sTmp = tmp.split('-');
                sIdAccount.add(sTmp[0]);
                sIdBp.add(sTmp[1]);
                mAccBp.put(sTmp[0],sTmp[1]);

            }
            
            for(FinServ__FinancialAccountRole__c fTmp : [Select FinServ__FinancialAccount__r.FinServ__PrimaryOwner__c, 
                FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Name,
                FinServ__RelatedAccount__r.Name ,FinServ__RelatedContact__c, Id, FinServ__RelatedContact__r.AccountId 
                                                         from FinServ__FinancialAccountRole__c 
                                                         Where FinServ__RelatedContact__r.AccountId IN :sIdAccount 
                                                         AND (FinServ__Role__c = '1' OR FinServ__Role__c = '1005')])
            {
                if(mAccBp.containsKey(fTmp.FinServ__RelatedContact__r.AccountId)){
                    if(mAccBp.get(fTmp.FinServ__RelatedContact__r.AccountId) == fTmp.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__c)
                    {
                        findTmp.add(fTmp.FinServ__RelatedContact__r.AccountId);
                    }else
                    {
                        if(findFAR.containsKey(fTmp.FinServ__RelatedContact__r.AccountId)){
                            findFAR.get(fTmp.FinServ__RelatedContact__r.AccountId).add(fTmp.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Name);
                        }else
                        {
                            Set<String> sTmp = new Set<String>();
                            sTmp.add(fTmp.FinServ__FinancialAccount__r.FinServ__PrimaryOwner__r.Name);
                            findFAR.put(fTmp.FinServ__RelatedContact__r.AccountId, sTmp);
                        }
                    }
                }
            }
            for(Id tmp : mAccBp.keySet())
            {
                if(!findTmp.contains(tmp))
                {   if(findFAR.containsKey(tmp))
                    {  
                        String collegeString = '';
                        for(String s: findFAR.get(tmp)) 
                        {
                            collegeString += (collegeString==''?'':',')+s;
                        } 
                        out.add(new relAccountBp(tmp, mAccBp.get(tmp), false, null, collegeString));
                    }else
                    {
                        out.add( new relAccountBp(tmp, mAccBp.get(tmp), false));
                    }
                    
                }
                
            }
        }
        return out;
    }


 
    /**
    * Validate 
    */
	
	/**
	* Model class to store field values
	*/
    public class FieldModel {
		
        public String apiName;
        public String value;
        public String label;
        public String fieldType;
		public String recId;
		public String referenceName;
		
    }
	
    /**
	* Model class to store field values
	*/
    public class PicklistFieldModel {
		
        public String apiName;
        public List<String> values;
        public List<String> labels;
        public String label;
        public String fieldType;
		public String referenceName;
        
        public PicklistFieldModel() {
            values = new List<String>();
            labels = new List<String>();
        }
    }

    /**
    * Variable control to bypass test
    */

    public static Boolean runInTest = false;
    
    
	/**
	* Model class to store sobject values
	*/	
	public class SObjectWrapper {
		
		public String 						label;
		public String						apiName;		
		public String 						pluralLabel;
		public Boolean 						isCreateable;
		public Boolean 						isDeletable;
		public Boolean 						isUpdateable;
		public List<List<FieldModel>>		records;
        public List<PicklistFieldModel>		picklistFields;
		public Integer						size { get { return records.size(); } }
        public Boolean						limitReached;
		
		public SObjectWrapper () {
			records = new List<List<FieldModel>>();
            picklistFields = new List<PicklistFieldModel>();
            limitReached = false;
		}
		
	}

    /**
    * Model class to store sobject values
    */  

    public class relAccountBp
    {
        public String          key             {get ; set;}
        public Id              idAccount       {get ; set;}
        public Id              idBp            {get ; set;}
        public Boolean         validate        {get ; set;}
        public Id              correctIdBp     {get ; set;}
        public String          correctNameBp   {get ; set;}

        public relAccountBp()
        {
            this.key                = null;
            this.idAccount          = null;
            this.idBp               = null;
            this.validate           = false;
            this.correctIdBp        = null;
            this.correctNameBp      = null;
        }

        public relAccountBp(Id inIdAccount, Id inIdBp, Boolean inValidate, Id inCorrectIdBP, String inCorrectNameBp)
        {
            this.key                = inIdAccount+'-'+inIdBp;
            this.idAccount          = inIdAccount;
            this.idBp               = inIdBp;
            this.validate           = inValidate;
            this.correctIdBp        = inCorrectIdBP;
            this.correctNameBp      = inCorrectNameBp;
        }

        public relAccountBp(Id inIdAccount, Id inIdBp, Boolean inValidate)
        {
            this.key                = inIdAccount+'-'+inIdBp;
            this.idAccount          = inIdAccount;
            this.idBp               = inIdBp;
            this.validate           = inValidate;
            this.correctIdBp        = null;
            this.correctNameBp      = ' ';
        }
    } 
    	
}