({
    doInit: function(cmp,evt,helper) {      
        helper.fetchInfluencedCampaigns(cmp);
    },
    createInfluence :  function(cmp,evt,helper) {
        helper.createInfluenceHelper(cmp);
        /*var createRecordEvent = $A.get("e.force:createRecord");
        
        createRecordEvent.setParams({
            "entityApiName": "CampaignInfluence",
            "Opportunity": cmp.get("v.recordId")
        });
    	createRecordEvent.fire();*/
    },
    
    deleteInfluence : function (cmp,evt,helper){
        helper.deleteInfluenceHelper(cmp,evt);
    }    
})