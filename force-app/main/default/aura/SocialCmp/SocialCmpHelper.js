({
	getData : function(component) {
		var recordID= component.get("v.recordId");
        console.log('Has record Id'+component.get("v.recordId"));
        var action=component.get("c.fetchRecords");
        var result;
        var i;
        action.setParams({
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                result=response.getReturnValue();
                console.log('result length'+result.length);
                for(i=0;i<result.length;i++){
                    console.log('result'+result[i].Channel__c+' and '+result[i].Description__c);
                 	if(result[i].Channel__c=='Facebook'){
                    	result[i].Image='FacebookIcon';
                    }else if(result[i].Channel__c=='Twitter'){
                        result[i].Image='TwitterIcon';
                    }  
                    console.log('result'+result[i].Image);
                    var timeCreated;
                    var today = new Date();
                    var cDate = new Date(result[i].Created_DateTime__c);
                    console.log('dates:'+cDate+' :'+today);
                    
                    var milisecs = Math.abs(cDate - today);
                    console.log('milisecs:'+milisecs);
                    
                    
                    if(milisecs>(1000*60*60)){
                        timeCreated=Math.round(milisecs/(1000*60*60*24));                        
                        result[i].Unit=timeCreated+'d ago';
					}else if(milisecs>(1000*60*60)){
                        timeCreated=Math.round(milisecs/(1000*60*60));
                        result[i].Unit=timeCreated+'h ago';
					}else if(milisecs>60000){
                        timeCreated=Math.round(milisecs/60000);
                        result[i].Unit=timeCreated+'m ago';
                    }else if(milisecs>1000){
                        timeCreated=Math.round(milisecs/1000);
                        result[i].Unit=timeCreated+'s ago';
                    }
                    console.log('created:'+result[i].Unit);
                }    
                component.set("v.recordList", result);
            }
        });
        $A.enqueueAction(action);
	}
})