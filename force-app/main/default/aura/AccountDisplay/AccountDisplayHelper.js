({
    RetrieveIds : function (component, event)
    {
        let action = component.get("c.CustomerIds");
        action.setCallback(this, function(resp)
                            {
                                component.set("v.IDList", resp.getReturnValue());
                            })
        $A.enqueueAction(action);
    },
    
    SetEdit : function (component, event)
    {
        component.set("v.IsEdit", true);
    },
    SetView : function (component, event)
    {
        component.find("editForm").find("toSubmit").submit();
        component.set("v.IsEdit", false);
    }
})