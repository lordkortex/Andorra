({
	 selectAsset : function(component, event, helper){      
    // get the selected Asset from list  
      var getSelectAsset = component.get("v.oAsset");
    // call the event   
      var compEvent = component.getEvent("oSelectedAssetEvent");
    // set the Selected Asset to the event attribute.  
         compEvent.setParams({"assetByEvent" : getSelectAsset });  
    // fire the event  
         compEvent.fire();
    },
})