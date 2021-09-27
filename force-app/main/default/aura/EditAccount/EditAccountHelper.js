({
    RetrieveIds : function (component, event)
    {
        let action = component.get("c.CustomerIds");
        action.setCallback(this, function(resp)
                            {
                                component.set("v.IDList", resp.getReturnValue());
                            })
        $A.enqueueAction(action);
    }
})