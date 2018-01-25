({
    helperHeader: function(component) {
        var action = component.get("c.showHeader");
        action.setParams({ 
            "recordId"  : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state=='SUCCESS') {
                var respuesta = response.getReturnValue(); 
                if(!$A.util.isEmpty(respuesta) && !$A.util.isUndefined(respuesta)) {
                	component.set("v.nHeader",respuesta);
            	}                    
            }                
        });
        $A.enqueueAction(action);
    },
	
	updateComponentFromDatalist :function(component, returnValue) {

        //STEX
        var recsStex = returnValue.dataListStex.length-1;
        var bScrllStex = ( recsStex >= 8 );
        var colsStex = returnValue.dataListStex[0].length-2;
        var txtStex    = $A.get("$Label.c.CRAN_VEC_ADV_IP_OrderSTEX");
        component.set("v.lstHeaStex", returnValue.dataListStex[0]);
        component.set("v.lstPosStex", returnValue.dataListStex);
        component.set("v.nColsStex", colsStex);
        component.set("v.nRecsStex", recsStex);
        component.set("v.scrolStex", bScrllStex);                    
        component.set("v.nHeadStex", txtStex + " (" + recsStex.toString() + ")" );
                      
        //FOREX
        var recsFxtr = returnValue.dataListForex.length-1;
        var bScrllFxtr = ( recsFxtr >= 8 );
        var colsFxtr = returnValue.dataListForex[0].length-2;
        var txtFxtr = $A.get("$Label.c.CRAN_VEC_ADV_IP_OrderFx");
        component.set("v.lstPosFxtr", returnValue.dataListForex);
        component.set("v.lstHeaFxtr", returnValue.dataListForex[0]);                                                            
        component.set("v.nColsFxtr", colsFxtr);
        component.set("v.nRecsFxtr", recsFxtr);
        component.set("v.scrolFxtr", bScrllFxtr);
        component.set("v.nHeadFxtr", txtFxtr + " (" + recsFxtr.toString() + ")" );
  
    },

	repaintStexForex :function(component,boolInfo) {
        var action = component.get("c.DataListStexForex");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();

            if(component.isValid() && state == "SUCCESS"){
              var returnValue = response.getReturnValue();

              if(returnValue.success && !$A.util.isEmpty(returnValue) && !$A.util.isUndefined(returnValue)) {
                    this.updateComponentFromDatalist(component, returnValue);                      
                    var temp = boolInfo;
                    if(temp == "true"){
                        component.set("v.info",false);
                    }                                        
              } else{
                  component.set("v.errorMessage",returnValue.messageError);
                  component.set("v.error",true);
                  component.set("v.info", false); 
              }
            } else{
                  component.set("v.errorMessage",returnValue.messageError);
                  component.set("v.error",true);
                  component.set("v.info", false); 
            }
        });
        $A.enqueueAction(action);        
    },												
	
    helperGotoListStex : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");        
        evt.setParams({
            componentDef: "c:CRAN_VEC_ADV_OppOrderList",
            componentAttributes: {
            "recordId"     : component.get("v.recordId"),
            "nKey"         : component.get("v.nKey"),
            "objectName"   : component.get("v.objectName"),                
            "v.aFilterStex": component.get("v.aFilterStex"),
            "v.aFilterFxtr": component.get("v.aFilterFxtr"),
            "viewAllStex": true
            }
        });
        evt.fire();
    },

    helperGotoListFxtr : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent"); 
        evt.setParams({
            componentDef: "c:CRAN_VEC_ADV_OppOrderList",
            componentAttributes: {
            "recordId"     : component.get("v.recordId"),
            "nKey"         : component.get("v.nKey"),
            "objectName"   : component.get("v.objectName"),                
            "v.aFilterStex": component.get("v.aFilterStex"),
            "v.aFilterFxtr": component.get("v.aFilterFxtr"),
            "viewAllFxtr"  : true
            }
        });
        evt.fire();
    },

    helperGoBack : function(component, event, helper) {        
        var gotoUrl  = '/one/one.app#/sObject/' + component.get("v.recordId") + '/view?';
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": gotoUrl
        });
        urlEvent.fire();
    },
    
    helperExecServiceGet :function(component,boolInfo) {
        component.set("v.error",false);

        var action = component.get("c.execServiceModeGet");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();

            if(component.isValid() && state == "SUCCESS"){
              var returnValue = response.getReturnValue();

              if(returnValue.success && !$A.util.isEmpty(returnValue) && !$A.util.isUndefined(returnValue)) {
                    this.updateComponentFromDatalist(component, returnValue);

                    var temp = boolInfo;
                    if(temp == "true"){
                       component.set("v.info",false);
                  }

              } else{
                  component.set("v.errorMessage",returnValue.messageError);
                  component.set("v.error",true);
                  component.set("v.info",false);
              }
            } else{
                  component.set("v.errorMessage",returnValue.messageError);
                  component.set("v.error",true);
                    component.set("v.info",false);
            }

        });
        $A.enqueueAction(action);        

  },

  helpercheckOrdersSign :function(component) {
      var actionDataList = component.get("c.DataListStexForex");
        actionDataList.setParams({
            "recordId": component.get("v.recordId")
        });
        actionDataList.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
              var returnValue = response.getReturnValue();
                  if(returnValue.success && !$A.util.isEmpty(returnValue) && !$A.util.isUndefined(returnValue)) {
                      this.updateComponentFromDatalist(component, returnValue);                                    
                  
                      // obtengo valores para las validaciones																												  
					   var listaStex = component.get("v.lstPosStex");
					   var listaForex =  component.get("v.lstPosFxtr");  
					   var validationError = $A.get("$Label.c.CRAN_VEC_ADV_IP_MSG_ERR_WrongStatusSign");
					   var noSelectedOrders = $A.get("$Label.c.CRAN_VEC_ADV_IP_MSG_ERR_NoSelectedOrders");
					   var selectedOrders = false;

					   //Validaciones
					   if(listaStex != null){
						   for(var i = 0; i < listaStex.length; i++){
							   if(selectedOrders == false && listaStex[i][1].fieldLabel == 'true'){
								   selectedOrders = true;
							   }
							   if(listaStex[i][1].fieldLabel == 'true' && (listaStex[i][0].isEdit != true || listaStex[i][15].fieldValue == 'true')){
									   validationError = validationError + ' <br/>- ' + listaStex[i][3].fieldValue;  
							   }                    
						   }
					   }
					   
					   if(listaForex != null){
						   for(var i = 0; i < listaForex.length; i++){
							   if(selectedOrders == false && listaForex[i][1].fieldLabel == 'true'){
								   selectedOrders = true;
							   }
							   if(listaForex[i][1].fieldLabel == 'true' && (listaForex[i][0].isEdit != true || listaForex[i][16].fieldValue == 'true')){
									   validationError = validationError + ' <br/>- ' + listaForex[i][3].fieldValue;  
							   }                    
						   }
					   }
					   if(selectedOrders == false){
							component.set("v.info",false);										   
						   component.set("v.errorMessage",noSelectedOrders);
						   component.set("v.error",true);
					   }else if(validationError != $A.get("$Label.c.CRAN_VEC_ADV_IP_MSG_ERR_WrongStatusSign")){
							component.set("v.info",false);										   
						   component.set("v.errorMessage",validationError);
						   component.set("v.error",true);
					   }else{
							var action = component.get("c.getMobilePhoneInfo");
							action.setParams({ recId : component.get("v.recordId") });
							action.setCallback(this, function(response) {
							var state = response.getState();    
							component.set("v.info",false);
							if (component.isValid() && state === "SUCCESS") {
								var phones = response.getReturnValue();
								var phoneNumberContentEl = component.find("phoneNumberContent").getElement();
								var htmlContent = '';
								for (var key in phones) {
									htmlContent += '<h2 class="slds-text-heading_small">' + key + '</h2><div class="slds-text-body_regular slds-text-color_weak slds-m-bottom_small"> Mobile: ' + phones[key] + '</div>';
								}
								phoneNumberContentEl.innerHTML = htmlContent;
								this.showPopupHelper(component, 'modaldialog', 'slds-fade-in-');
								this.showPopupHelper(component,'backdrop','slds-backdrop--');    
								}
							});
						   $A.enqueueAction(action);
						   }
					} else{  
						component.set("v.errorMessage",returnValue.messageError);
						component.set("v.error",false);
						component.set("v.info", false); 
					 }
            } else{
                  component.set("v.errorMessage",returnValue.messageError);
                  component.set("v.error",false);
                  component.set("v.info", false); 
            }
        });
        $A.enqueueAction(actionDataList); 								   
   },

    helperExecServiceFinal :function(component) {
        component.set("v.error",false);
		component.set("v.info",true);							 
        var action = component.get("c.execServiceModeFinal");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var returnValue = response.getReturnValue();
                if (!returnValue.success) {
                    if(returnValue.personIsValid){
                        this.helperExecServiceGet(component,"true");
                    } else {
                        this.repaintStexForex(component,"true");
                    }
                    component.set("v.errorMessage",returnValue.messageError);
                    component.set("v.error",true);
                } else {
 
                    if(returnValue.isEmpty){
                        component.set("v.ok",true);
                        component.set("v.infoMessage",returnValue.inLineEsignature);
                    }   
                    component.set("v.error",false);
                    
                    this.repaintStexForex(component,"true");
                    
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": returnValue.mergeIDs                
                    });
                    urlEvent.fire();                    
                    
                }
            } else {
                    component.set("v.info",false);
                    component.set("v.errorMessage","error");
                    component.set("v.error",true);
            }

        });
        $A.enqueueAction(action);
    },

    helpercheckOrdersDiscard :function(component) {  
	      var actionDataList = component.get("c.DataListStexForex");
        actionDataList.setParams({
            "recordId": component.get("v.recordId")
        });
        actionDataList.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
              var returnValue = response.getReturnValue();

              if(returnValue.success && !$A.util.isEmpty(returnValue) && !$A.util.isUndefined(returnValue)) {
                   this.updateComponentFromDatalist(component, returnValue);   															
				   var listaStex = component.get("v.lstPosStex");
				   var listaForex =  component.get("v.lstPosFxtr");  
				   var validationErrorStatus = $A.get("$Label.c.CRAN_VEC_ADV_IP_MSG_ERR_WrongStatusDiscard");
				   var validationErrorSign = $A.get("$Label.c.CRAN_VEC_ADV_IP_MSG_ERR_Signed_Orders");
				   var noSelectedOrders = $A.get("$Label.c.CRAN_VEC_ADV_IP_MSG_ERR_NoSelectedOrders");
				   var selectedOrders = false;

				   //Validaciones
				   if(listaStex != null){
					   for(var i = 0; i < listaStex.length; i++){
						   if(selectedOrders == false && listaStex[i][1].fieldLabel == 'true'){
							   selectedOrders = true;
						   }
						   if(listaStex[i][1].fieldLabel == 'true' && listaStex[i][0].isEdit != true){
							   validationErrorStatus = validationErrorStatus + ' <br/>- ' + listaStex[i][3].fieldValue;  
						   }
						   if(listaStex[i][1].fieldLabel == 'true' && listaStex[i][15].fieldValue == 'true'){
							   validationErrorSign = validationErrorSign + ' <br/>- ' + listaStex[i][3].fieldValue;  
						   }
					   }
				   }
				   
				   if(listaForex != null){
					   for(var i = 0; i < listaForex.length; i++){
						   if(selectedOrders == false && listaForex[i][1].fieldLabel == 'true'){
							   selectedOrders = true;
						   }
						   if(listaForex[i][1].fieldLabel == 'true' && listaForex[i][0].isEdit != true){
							   validationErrorStatus = validationErrorStatus + ' <br/>- ' + listaForex[i][3].fieldValue;  
						   }
						   if(listaForex[i][1].fieldLabel == 'true' && listaForex[i][16].fieldValue == 'true'){
							   validationErrorSign = validationErrorSign + ' <br/>- ' + listaForex[i][3].fieldValue;  
						   }
					   }
				   }

				   if(selectedOrders == false){
						component.set("v.errorMessage",noSelectedOrders);
						component.set("v.error",true);
						component.set("v.info", false);											
				   }else if(validationErrorStatus != $A.get("$Label.c.CRAN_VEC_ADV_IP_MSG_ERR_WrongStatusDiscard")
					   && validationErrorSign != $A.get("$Label.c.CRAN_VEC_ADV_IP_MSG_ERR_Signed_Orders")){
						component.set("v.errorMessage",validationErrorStatus + '<br/><br/>' + validationErrorSign);
						component.set("v.error",true);
						component.set("v.info", false);											
				   }else if(validationErrorStatus != $A.get("$Label.c.CRAN_VEC_ADV_IP_MSG_ERR_WrongStatusDiscard")){
						component.set("v.errorMessage",validationErrorStatus);
						component.set("v.error",true);
						component.set("v.info", false);									
				   }else if(validationErrorSign != $A.get("$Label.c.CRAN_VEC_ADV_IP_MSG_ERR_Signed_Orders")){
						component.set("v.errorMessage",validationErrorSign);
						component.set("v.error",true);
						component.set("v.info", false);										
				   }else{
						component.set("v.info", false);							 
						this.showPopupHelper(component, 'modalDiscard', 'slds-fade-in-');
						this.showPopupHelper(component,'backdropDiscard','slds-backdrop--');
				   }  
			} else{
                  component.set("v.errorMessage",returnValue.messageError);
                  component.set("v.error",true);
                  component.set("v.info", false); 
              }
            } else{
                  component.set("v.errorMessage",returnValue.messageError);
                  component.set("v.error",true);
                  component.set("v.info", false); 
            }
        });
        $A.enqueueAction(actionDataList); 							  
   },


    helperExecServiceFinalDiscard :function(component) {
        component.set("v.error",false);
        var action = component.get("c.execServiceModeFinalDiscard");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var returnValue = response.getReturnValue();
                if (!returnValue.success) {
                    component.set("v.errorMessage",returnValue.messageError);
                    component.set("v.error",true);
                    component.set("v.info",false);
                } else { 
					var actionDataList = component.get("c.DataListStexForex");
                        actionDataList.setParams({
                            "recordId": component.get("v.recordId")
                        });
                        actionDataList.setCallback(this, function(response) {
                            var state = response.getState();
                            if(component.isValid() && state == "SUCCESS"){
                              var returnValue = response.getReturnValue();
                              if(returnValue.success) {
                                  if(!$A.util.isEmpty(returnValue) && !$A.util.isUndefined(returnValue)) {
                                      this.updateComponentFromDatalist(component, returnValue);                                         
                                      component.set("v.info",false);
                                  }
                                }
                              }
                        });
                        $A.enqueueAction(actionDataList); 
                }
            } else {
                    component.set("v.info",false);
                    component.set("v.errorMessage","error");
                    component.set("v.error",true);
            }
 
        });
        $A.enqueueAction(action);
    },      

    helperPrintPreview :function(component) {

        var actionDataList = component.get("c.DataListStexForex");
        actionDataList.setParams({
            "recordId": component.get("v.recordId")
        });
        actionDataList.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
              var returnValue = response.getReturnValue();
                if(returnValue.success && !$A.util.isEmpty(returnValue) && !$A.util.isUndefined(returnValue)) {
                      this.updateComponentFromDatalist(component, returnValue);                                                       

                      var recordId = component.get("v.recordId");
                      var listaStex = component.get("v.lstPosStex");
                      var listaForex =  component.get("v.lstPosFxtr"); 
                      var noSelectedOrders = $A.get("$Label.c.CRAN_VEC_ADV_IP_MSG_ERR_NoSelectedOrders");
                      var validationErrorStatus = $A.get("$Label.c.CRAN_VEC_ADV_IP_MSG_ERR_WrongStatusPrintPreview");
                      var selectedOrders = false;

                      //Validaciones CRAN_VEC_ADV_IP_MSG_ERR_WrongStatusPrintPreview
                      if(listaStex != null){
                          for(var i = 0; i < listaStex.length; i++){
                              if(selectedOrders == false && listaStex[i][1].fieldLabel == 'true'){
                                 selectedOrders = true;
                              }
                              if(listaStex[i][1].fieldLabel == 'true' && (listaStex[i][0].isEdit != true || listaStex[i][15].fieldValue == 'true')){
                                 validationErrorStatus = validationErrorStatus + ' <br/>- ' + listaStex[i][3].fieldValue;  
                              }
                          } 
                      }
              
                      if(listaForex != null){
                          for(var i = 0; i < listaForex.length; i++){
                              if(selectedOrders == false && listaForex[i][1].fieldLabel == 'true'){
                                 selectedOrders = true;
                              }
                              if(listaForex[i][1].fieldLabel == 'true' && (listaForex[i][0].isEdit != true || listaForex[i][16].fieldValue == 'true')){
                                 validationErrorStatus = validationErrorStatus + ' <br/>- ' + listaForex[i][3].fieldValue;  
                              }
                          }
                      }

                      if(selectedOrders == false){
                         component.set("v.errorMessage",noSelectedOrders);
                         component.set("v.error",true);
                         component.set("v.info",false);
                      }else if(validationErrorStatus != $A.get("$Label.c.CRAN_VEC_ADV_IP_MSG_ERR_WrongStatusPrintPreview")){
                         component.set("v.errorMessage",validationErrorStatus);
                         component.set("v.error",true);
                         component.set("v.info",false);
                      }else{
                          var actionPrintPrev = component.get("c.printPreviewOrders");
                          actionPrintPrev.setParams({
                              "propId": recordId
                          });
                          actionPrintPrev.setCallback(this, function(response) {
                              var state = response.getState();
                              if(component.isValid() && state == "SUCCESS"){
                                  var returnValue = response.getReturnValue();
                                  if(returnValue.success && !returnValue.isEmpty){
                                      component.set("v.info",false);
                                      var pdfContent = returnValue.mergeIDs;
                                      var navEvt = $A.get("e.force:navigateToSObject");
                                      navEvt.setParams({
                                        "recordId": pdfContent,
                                      });
                                      navEvt.fire();
                                  }else {
                                      if(returnValue.isEmpty){
                                          component.set("v.ok",true);
                                          component.set("v.errorMessage",returnValue.mergeIDs);
                                          component.set("v.info",false);

                                      } else{    
                                          component.set("v.info",false);
                                          component.set("v.errorMessage",returnValue.messageError);
                                          component.set("v.error",true);
                                      }
                                  }
                             } else {
                                      component.set("v.info",false);
                                      component.set("v.errorMessage","error");
                                      component.set("v.error",true);
                             }
                         });
                         $A.enqueueAction(actionPrintPrev);
                     }                
                } else{
                  component.set("v.errorMessage",returnValue.messageError);
                  component.set("v.error",true);
                  component.set("v.info", false); 
                }
            } else{
                  component.set("v.errorMessage",returnValue.messageError);
                  component.set("v.error",true);
                  component.set("v.info", false); 
            }
        });
        $A.enqueueAction(actionDataList); 
    },

    helperOnCheck :function(component) {
        var action = component.get("c.selectAll");
        action.setParams({
            "recordId": component.get("v.recordId"),
            "isSelected": component.get("v.myselectall"),
            "viewAllStex": component.get("v.viewAllStex"),
            "viewAllFxtr": component.get("v.viewAllFxtr")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            component.set("v.info",false);
            if(component.get("v.myselectall")==true)
                component.set("v.myselectall",false);
            else component.set("v.myselectall",true);

            if(component.isValid() && state == "SUCCESS"){
                var returnValue = response.getReturnValue();           

                if (!returnValue.success) {                    
                    component.set("v.errorMessage",returnValue.messageError);
                    component.set("v.error",true);
                    component.set("v.info",false);
                 }
            } else {
                    component.set("v.info",false);
                    component.set("v.errorMessage","error");
                    component.set("v.error",true);
            }
        });
        $A.enqueueAction(action);        
    },

    helperConfirmService :function(component) { 

    var actionDataList = component.get("c.DataListStexForex");
        actionDataList.setParams({
            "recordId": component.get("v.recordId")
        });
        actionDataList.setCallback(this, function(response) {
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
              var returnValue = response.getReturnValue();
                  if(returnValue.success && !$A.util.isEmpty(returnValue) && !$A.util.isUndefined(returnValue)) {
                      this.updateComponentFromDatalist(component, returnValue);                                    

                      var listaStex = component.get("v.lstPosStex");
                      var listaForex =  component.get("v.lstPosFxtr");  
                      var validationError = $A.get("$Label.c.CRAN_VEC_ADV_IP_MSG_ERR_WrongStatus");
                      var noSelectedOrders = $A.get("$Label.c.CRAN_VEC_ADV_IP_MSG_ERR_NoSelectedOrders");
                      var selectedOrders = false;
                      var signedAndPending = component.get("v.signedAndPending");
                      var waitingSig = component.get("v.waitingSig");

                      //Validaciones
                      if(listaStex != null){
                          for(var i = 0; i < listaStex.length; i++){
                              if(selectedOrders == false && listaStex[i][1].fieldLabel == 'true'){
                                 selectedOrders = true;
                              }
                              if(listaStex[i][1].fieldLabel == 'true' && ((listaStex[i][17].fieldValue != signedAndPending 
                                  && listaStex[i][17].fieldValue != waitingSig) || (listaStex[i][17].fieldValue == waitingSig
                                  && listaStex[i][13].fieldLabel == 'false'))){
                                  validationError = validationError + ' <br/>- ' + listaStex[i][3].fieldValue;  
                              }
                          } 
                      }
                      
                      if(listaForex != null){
                          for(var i = 0; i < listaForex.length; i++){
                              if(selectedOrders == false && listaForex[i][1].fieldLabel == 'true'){
                                 selectedOrders = true;
                              }
                              if(listaForex[i][1].fieldLabel == 'true' && ((listaForex[i][18].fieldValue != signedAndPending 
                                  && listaForex[i][18].fieldValue != waitingSig) || (listaForex[i][18].fieldValue == waitingSig 
                                  && listaForex[i][14].fieldLabel == 'false'))){
                                  validationError = validationError + ' <br/>- ' + listaForex[i][3].fieldValue;               
                              }
                          }
                      }

                      if(selectedOrders == false){
                         component.set("v.errorMessage",noSelectedOrders);
                         component.set("v.error",true);
                         component.set("v.info",false);
                      }else if(validationError != $A.get("$Label.c.CRAN_VEC_ADV_IP_MSG_ERR_WrongStatus")){
                          component.set("v.errorMessage",validationError);
                          component.set("v.error",true);
                          component.set("v.info",false);
                      }else{
                          var actionConfirm = component.get("c.execServiceOrderConfirm");
                          actionConfirm.setParams({
                              "recordId": component.get("v.recordId")
                          });
                          actionConfirm.setCallback(this, function(response) {
                              var state = response.getState();

                              if(component.isValid() && state == "SUCCESS"){
                                  var returnValue = response.getReturnValue();
                                             
                                  if (!returnValue.success) {       
                                      this.updateComponentFromDatalist(component, returnValue);             
                                      component.set("v.errorMessage",returnValue.messageError);
                                      component.set("v.error",true);
                                      component.set("v.info",false); 
                                  }else{
                                     this.updateComponentFromDatalist(component, returnValue);
                                     component.set("v.info",false);
                                     component.set("v.ok",true); 
                                     component.set("v.infoMessage",returnValue.msg);
                                  }

                              } else {
                                      component.set("v.errorMessage","error");
                                      component.set("v.error",true);
                                      component.set("v.info",false);
                              }
                          });
                          $A.enqueueAction(actionConfirm);          
                      }    

                  } else{
                    component.set("v.errorMessage",returnValue.messageError);
                    component.set("v.error",false);
                    component.set("v.info", false); 
                  }
            } else{
                  component.set("v.errorMessage",returnValue.messageError);
                  component.set("v.error",false);
                  component.set("v.info", false); 
            }
        });
        $A.enqueueAction(actionDataList);            
    },

    helperCheckboxExec: function(component, event, helper, boolInfo, nameButton) {
        var botonExec  = component.find(nameButton);
        var idLine = event.getSource().get("v.text").split("/");
        var pos = idLine[1]-1;
        var valorExec;        
        
        if (Array.isArray(botonExec)) {
            valorExec = botonExec[pos].get("v.value");
          } else  {
            valorExec = botonExec.get("v.value");
        }
      
        var actionUpdateStex = component.get("c.updateStatusOrderExec");        
        actionUpdateStex.setParams({
            "recordId": component.get("v.recordId"),
            "idOrder": idLine[0], 
            "execute": valorExec
        });
        actionUpdateStex.setCallback(this, function(response) {  
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                  component.set("v.info",false);
            } else {
                    component.set("v.info",false);
                    component.set("v.errorMessage","error");
                    component.set("v.error",true);
            }

        });
        $A.enqueueAction(actionUpdateStex);
    },
    
    helperGotoArchive: function(component, event, helper, numOrder, idOrder  ) {

        var actionGoToArchive = component.get("c.infoToSendArchive");        
        actionGoToArchive.setParams({
            "idOrder": idOrder,
            "idOpportunity": component.get("v.recordId"),
            "numOrder": numOrder
        });
        actionGoToArchive.setCallback(this, function(response) {        

            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
                var returnValue = response.getReturnValue();
                if(returnValue.success){
                    component.set("v.info",false);
                    var pdfContent = returnValue.mergeIDs;
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                      "recordId": pdfContent,
                    });
                    navEvt.fire();
                }else {
                    component.set("v.info",false);
                    component.set("v.errorMessage",returnValue.messageError);
                    component.set("v.error",true);
                }               
            } else {
                    component.set("v.info",false);
                    component.set("v.errorMessage","error");
                    component.set("v.error",true);
            }
        });
        $A.enqueueAction(actionGoToArchive);
    },

    showPopupHelper: function(component, componentId, className){
        var modal = component.find(componentId);
        $A.util.removeClass(modal, className + 'hide');
        $A.util.addClass(modal, className + 'open');
    },

    hidePopupHelper: function(component, componentId, className){
        var modal = component.find(componentId);
        $A.util.addClass(modal, className+'hide');
        $A.util.removeClass(modal, className+'open');
        component.set("v.body", "");
    },

    helperCheckboxManual: function(component, event, helper, boolInfo, nameButton) {
        var botonManual  = component.find(nameButton);
        var idLine = event.getSource().get("v.text").split("/");
        var pos = idLine[1]-1;
        var valorManual;        
        
        if (Array.isArray(botonManual)) {
            valorManual = botonManual[pos].get("v.value");
          } else  {
            valorManual = botonManual.get("v.value");
        }
      
        var actionUpdateStex = component.get("c.updateStatusOrderManual");        
        actionUpdateStex.setParams({
            "recordId": component.get("v.recordId"),
            "idOrder": idLine[0], 
            "manual": valorManual
        });
        actionUpdateStex.setCallback(this, function(response) {  
            var state = response.getState();
            if(component.isValid() && state == "SUCCESS"){
               component.set("v.info",false); 
            } else {
                    component.set("v.info",false);
                    component.set("v.errorMessage","error");
                    component.set("v.error",true);
            }
        });
        $A.enqueueAction(actionUpdateStex);
    }

})