({
	fetchInfluencedCampaigns: function (cmp) {
    	var action = cmp.get("c.getInfluencedCampaigns"); 
        var self = this;
        self.showWaiting(cmp);
        action.setParams({
               opportunityId:cmp.get("v.recordId"),
           });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(cmp.isValid() && state === "SUCCESS"){
                var parsedResponse = JSON.parse(response.getReturnValue());
                cmp.set("v.editable", parsedResponse[0]);
                cmp.set("v.campaign", parsedResponse[1]);                
            }
            self.hideWaiting(cmp);
        });
        $A.enqueueAction(action);
        
	},
    
    createInfluenceHelper: function (cmp){
        var self = this;
        self.showWaiting(cmp);
    	var action = cmp.get("c.createInfluencedCampaign");
        if(cmp.get("v.id")== null || cmp.get("v.id")=== undefined || cmp.get("v.id")=== ""){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": $A.get("$Label.c.CRAN_VAS_MAQ_ErrorTitle"),
                "message": $A.get("$Label.c.CRAN_VAS_MAQ_SelectCampaign")
            });
            toastEvent.fire();
            self.hideWaiting(cmp);
            return;
        }
        
    	action.setParams({
    		opportunityId:cmp.get("v.recordId"),
    		campaignId:cmp.get("v.id"),
		});
        action.setCallback(this,function(response){
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if(cmp.isValid() && state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result){
                 	$A.get('e.force:refreshView').fire();                    
                    toastEvent.setParams({
                        "title": $A.get("$Label.c.CRAN_VAS_MAQ_SuccessTitle"),
                        "message": $A.get("$Label.c.CRAN_VAS_MAQ_AddInfluenceSuccess")
                    });
                    toastEvent.fire();
                } else {
                    toastEvent.setParams({
                        "title": $A.get("$Label.c.CRAN_VAS_MAQ_ErrorTitle"),
                        "message": $A.get("$Label.c.CRAN_VAS_MAQ_AddInfluenceError")
                    });
                    toastEvent.fire();
                }
            } else {
                toastEvent.setParams({
                    "title": $A.get("$Label.c.CRAN_VAS_MAQ_ErrorTitle"),
                    "message": $A.get("$Label.c.CRAN_VAS_MAQ_AddInfluenceError")
                });
                toastEvent.fire();
            }
            cmp.set("v.id", "");
            self.hideWaiting(cmp);
        });
		$A.enqueueAction(action);
        self.hideWaiting(cmp);
	},
    
    deleteInfluenceHelper: function (cmp,evt){
       
       var self = this;
       self.showWaiting(cmp);
       var campaignElement = evt.currentTarget.dataset.campaignid;
      
       var action = cmp.get("c.deleteInfluencedCampaign"); 
        action.setParams({
               opportunityId:cmp.get("v.recordId"),
            campaignId: campaignElement
           });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var toastEvent = $A.get("e.force:showToast");
            if(cmp.isValid() && state === "SUCCESS"){
                var result = response.getReturnValue();
                if(result){
                 	$A.get('e.force:refreshView').fire();
                    
                    toastEvent.setParams({
                        "title": $A.get("$Label.c.CRAN_VAS_MAQ_SuccessTitle"),
                        "message": $A.get("$Label.c.CRAN_VAS_MAQ_DeleteInfluenceSuccess")
                    });
                    toastEvent.fire();
                } else {
                    toastEvent.setParams({
                        "title": $A.get("$Label.c.CRAN_VAS_MAQ_ErrorTitle"),
                        "message": $A.get("$Label.c.CRAN_VAS_MAQ_DeleteInfluenceError")
                    });
                    toastEvent.fire();
                }
            } else {
                toastEvent.setParams({
                    "title": $A.get("$Label.c.CRAN_VAS_MAQ_ErrorTitle"),
                    "message": $A.get("$Label.c.CRAN_VAS_MAQ_DeleteInfluenceError")
                });
                toastEvent.fire();
            }
            self.hideWaiting(cmp);
        });
        $A.enqueueAction(action);
       
       return;
    },
    showWaiting: function (cmp){
        cmp.set("v.spinner","true");
    },
    hideWaiting: function (cmp){
        cmp.set("v.spinner","false");
    },
})