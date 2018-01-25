({
  doInit : function(component, event, helper) {
		helper.getResponses(component);
	},
  next : function(component, event, helper) {
    component.set("v.stepDisable","disable");
    var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": "/apex/CRAN_VEC_ADV_CustomForm?id=" + component.get("v.attContact.Id") + "&formId=" + component.get("v.selectedResponse").Id + "&action=edit"
    });
    urlEvent.fire();
  },
  onSelectChange: function(component) {
    var responses = component.get("v.responses");
    var selectCmp = component.find("InputSelectDynamic");
    component.set("v.selectedResponse", responses[selectCmp.get("v.value")]);

    if(selectCmp.get("v.value")=='0')
      component.set("v.stepDisable","disable");
    else if(selectCmp.get("v.value")!='0')
      component.set("v.stepDisable","notDisable");
  },
  cancel : function(component, event, helper) {
    // Close the action panel
		var dismissActionPanel = $A.get("e.force:closeQuickAction");
		dismissActionPanel.fire();
  },
  save : function(component, event, helper) {
    // Close the action panel
		var dismissActionPanel = $A.get("e.force:saveQuickAction");
		dismissActionPanel.fire();
  }  
})