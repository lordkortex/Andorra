({
    doInit : function(component, event, helper) {
        helper.toggleSpinner(component, event);
    },    
    loadBPs : function(component, event, helper) {
        
        if (window.$lBpDrill == undefined)
            window.$lBpDrill = jQuery.noConflict();		
        
        var action = component.get("c.getRecords");
        
        action.setParams({
            recIdStr: component.get("v.recordId")
        });        
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                
                
                var mapOfValues = JSON.parse(response.getReturnValue());
                
                var counterFirstLevel = 0;
                var bpKey;
                var $mockContainer = $lBpDrill($lBpDrill.parseHTML("<div></div>"));
                for (bpKey in mapOfValues.bps) {
                    
                    var $accordionTemplate 	= $lBpDrill($lBpDrill.parseHTML(helper.getAccordionTemplate(1)));
                    
                    var $panelTitleHeading 	= $lBpDrill(".panel-heading", $accordionTemplate);                    
                    var $headerTitle 		= $lBpDrill(".title-block a", $accordionTemplate);
                    var $panelCollapse		= $lBpDrill(".panel-collapse", $accordionTemplate);                    
                    var $body 				= $lBpDrill(".panel-body", $accordionTemplate);                    
                    
                    $panelTitleHeading.attr("id", "headingFirstLevel" + counterFirstLevel);
                    
                    $headerTitle.attr({
                        "aria-controls" : "collapseFirstLevel" + counterFirstLevel,
                        "href": "#collapseFirstLevel" + counterFirstLevel });
                    $headerTitle.find(".collapse-text").text("BP: " + mapOfValues.bps[bpKey].Name);
                    $headerTitle.find(".collapse-amount").text(mapOfValues.bps[bpKey].Amount);
                    
                    $panelCollapse.attr({
                        "aria-labelledby" : "headingFirstLevel" + counterFirstLevel,
                        "id": "collapseFirstLevel" + counterFirstLevel });
                    
                    var counterSecondLevel = 0;
                    var faKey;
                    for (faKey in mapOfValues.fas[bpKey]) {
                        var secondLevelKey = counterFirstLevel + "" + counterSecondLevel;
                        var $secondLevelBody;
                        
                        if (counterSecondLevel == 0) {
                            $body.append("<div class=\"second-level-" + secondLevelKey + "\" id=\"accordion2\" role=\"tablist\" aria-multiselectable=\"true\"></div>");
                            $secondLevelBody = $body.find(".second-level-" + secondLevelKey, $body);
                        }
                        
                        var $accordionTemplateLevel2 	= $lBpDrill($lBpDrill.parseHTML(helper.getAccordionTemplate(secondLevelKey)));
                        var $panelTitleHeadingLevel2	= $lBpDrill(".panel-heading", $accordionTemplateLevel2);
                        var $headerTitleLevel2 			= $lBpDrill(".title-block a", $accordionTemplateLevel2);
                        var $panelCollapseLevel2		= $lBpDrill(".panel-collapse", $accordionTemplateLevel2);
                        var $bodyLevel2 				= $lBpDrill(".panel-body", $accordionTemplateLevel2);                           
                        
                        
                        $accordionTemplateLevel2.removeClass("slds-box");
                        $panelTitleHeadingLevel2.attr("id", "headingSecondLevel" + secondLevelKey);
                        
                        $headerTitleLevel2.attr({
                            "aria-controls" : "collapseSecondLevel" + secondLevelKey,
                            "href": "#collapseSecondLevel" + secondLevelKey});
                        $headerTitleLevel2.find(".collapse-text").text("FA: " + mapOfValues.fas[bpKey][faKey].Name);
                        $headerTitleLevel2.find(".collapse-amount").text(mapOfValues.fas[bpKey][faKey].Amount);
                        
                        $panelCollapseLevel2.attr({
                            "aria-labelledby" : "headingSecondLevel" + secondLevelKey,
                            "aria-expanded": false,
                            "id": "collapseSecondLevel" + secondLevelKey,
                            "class" : "panel-collapse accordion-panel slds-theme--shade collapse in" });                       
                        
                        if (mapOfValues.fas[bpKey][faKey].objects.length != 0) {
                            
                            var fahs = mapOfValues.fas[bpKey][faKey].objects;
                            
                            var i = 0;
                            for (i=0; i < fahs.length; i++) {
                                var $labelTemplate 	= $lBpDrill($lBpDrill.parseHTML(helper.getLabelTemplate()));
                                var $labelName 		= $lBpDrill("h3", $labelTemplate);
                                var $category 		= $lBpDrill(".category", $labelTemplate);
                                var $cashAndMoney 	= $lBpDrill(".cash-and-money", $labelTemplate);
                                $labelName.text("FAH: " + fahs[i].Name);
                                $category.text(fahs[i].Category);
                                $cashAndMoney.text(fahs[i].Amount);
                                $bodyLevel2.append($labelTemplate);
                            }
                        } else {
                            $bodyLevel2.text($A.get("$Label.c.CRAN_VAS_KER_NoRecordsToDisplay"));
                        }
                        
                        $accordionTemplateLevel2.find(".panel-body").removeClass().addClass("slds-box slds-panel slds-clearfix");
                        $secondLevelBody.append($accordionTemplateLevel2);
                        
                        counterSecondLevel++;
                    }
                    
                    counterFirstLevel++;
                    $mockContainer.append($accordionTemplate);
                }   
                
                var accordion1 = document.getElementById('accordion1');
                accordion1.innerHTML =  $mockContainer.prepend(accordion1.innerHTML).html();                    
                
                $lBpDrill('.collapse').collapse();
                var bpContainer = component.find("bpContainer");
                helper.toggleSpinner(component);
                $A.util.toggleClass(bpContainer, "slds-hidden");
                
            }
            
        });
        $A.enqueueAction(action);
        
    },
    forceReload : function (component, event, helper) {
        component.destroy();
    }
})