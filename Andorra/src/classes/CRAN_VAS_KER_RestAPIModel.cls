/**
* Class that represents the SFDC REST API objects
*
* @author  ZLR
* @version 1.0
*/
public with sharing class CRAN_VAS_KER_RestAPIModel {

    /**
    * List View's describe model
    */
    public class ListViewDescribe {
        
        public Id						id;
        public String					query;
        public String					scope;
        public String					sobjectType;
        public List<ListViewOrderBy>	orderBy;
        public List<ListViewColumns> 	columns;
        public ListViewWhereClause		whereCondition;
        
        public ListViewDescribe (){
            orderBy = new List<ListViewOrderBy>();
            columns = new List<ListViewColumns>();
            whereCondition = new ListViewWhereClause();
        }
	        
    }
    
    /**
    * List View describe's Column model
    */  
    public class ListViewColumns {
        
        public String 	ascendingLabel;
        public String 	descendingLabel;
        public String 	fieldNameOrPath;
        public Boolean 	hidden;
        public String 	label;
        public String 	selectListItem;
        public String 	sortDirection;
        public Integer 	sortIndex;
        public Boolean	sortable;
        public String  	type;    
            
    }
    
    /**
    * List View describe's Order By model
    */     
    public class ListViewOrderBy {
        
        public String  fieldNameOrPath;
        public String  nullsPosition;
        public String  sortDirection;
        
    }

    /**
    * List View describe's Where Clause model
    */      
    public class ListViewWhereClause {
        
        public List<ListViewWhereClauseCondition> 	conditions;
        public String  								conjunction;
        
    }    
    
    /**
    * List View describe's Where Clause Condition model
    */          
    public class ListViewWhereClauseCondition {
        
        public String  		field;
        public String  		operator;
        public List<String> values;
        
    } 

    /**
    * Api Version model
    */     
    public class ApiVersion {
        public String label;
        public String url;
        public String version;
    }
    
}