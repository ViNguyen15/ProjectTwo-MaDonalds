({
	doInit : function(component, event, helper) 
    {
        helper.RetrieveIds(component, event);
        component.set("v.IsEdit", false);
	},
    
    EditMode : function (component, event, helper)
    {
        helper.SetEdit(component, event);
    },
    
    Submitted : function (component, event, helper)
    {
        
        helper.SetView(component, event);
    }
})