({	
	getAccordionTemplate : function(level) {
		return "<div class=\"slds-box collapse-container\">" +
                                        "<div class=\"slds-box slds-theme--default panel-heading title-container\" role=\"tab\" id=\"headingOne\">" +
                                            "<h4 class=\"title-block slds-clearfix\">" +
                                                "<a role=\"button\" data-toggle=\"collapse\" data-parent=\"#accordion" + level +"\" href=\"#collapseOne\" aria-expanded=\"false\" aria-controls=\"collapseOne\" class=\"slds-card__header-link slds-truncate slds-text-heading--small collapsed\">" +
        											"<span class=\"utility utility-collapse\"></span>" +
                                                    "<span class=\"collapse-text\"></span>" +
            										"<span class=\"collapse-amount slds-float--right slds-m-right--medium\"></span>" +
        										"</a>" +
                                            "</h4>" +
                                        "</div>" +
                                        "<div id=\"collapseOne\" class=\"panel-collapse collapse in\" role=\"tabpanel\" aria-labelledby=\"headingOne\">" +
                                            "<div class=\"panel-body\"></div>" +
                                        "</div>" +
                                    "</div>";
	},
    getLabelTemplate : function() {
        return"<div class=\"slds-box slds-panel slds-clearfix\">" + 
		"  <div class=\"slds-tile slds-float--left\">" + 
		"	<h3 class=\"slds-truncate\" title=\"Financial Holding Name\"></h3>" + 
		"	<div class=\"slds-tile__detail slds-text-body--small\">" + 
		"	  <dl class=\"slds-wrap\">" + 
		"		<dt class=\"slds-item--label slds-text-color--weak slds-truncate\" title=\"" +  $A.get("$Label.c.CRAN_VAS_ADV_CF_LBL_Amount") + "\">" +  $A.get("$Label.c.CRAN_VAS_ADV_CF_LBL_Amount") + ":</dt>" + 
		"		<dd class=\"slds-item--detail slds-truncate cash-and-money\"></dd>" + 
        "		<dt class=\"slds-item--label slds-text-color--weak slds-truncate\" title=\"" +  $A.get("$Label.c.CRAN_VAS_ADV_CF_LBL_Category") + "\">" +  $A.get("$Label.c.CRAN_VAS_ADV_CF_LBL_Category") + ":</dt>" +             
		"		<dd class=\"slds-item--detail slds-truncate category\"></dd>" + 
		"	  </dl>" + 
		"	</div>" + 
		"  </div>" + 
		"</div>	";
    },
    toggleSpinner: function (component) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        
        if(!$A.util.hasClass(spinner, 'hideEl')){
            evt.setParams({ isVisible : false });
        }		
        else {
            evt.setParams({ isVisible : true });
        }
        evt.fire();
    }    
})