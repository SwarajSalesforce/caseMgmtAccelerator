({
	doInit : function(component, event, helper) {
        var url = $A.get('$Resource.BackgroundAvatar');
        component.set('v.backgroundImageURL', url);
        console.log('URL:'+url);
    }
})