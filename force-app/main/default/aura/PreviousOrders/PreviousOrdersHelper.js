({
    RetrieveOrders : function (component, event)
    {
        
        let action2 = component.get("c.allOrders");
        action2.setCallback(this, function(resp)
                            {
                                component.set("v.OrderList", resp.getReturnValue());
                                component.set("v.Offset", 0);
                            })
        $A.enqueueAction(action2);
    },
    
    OffsetPlus : function (component, event) 
    {
        if(component.get("v.Offset") < component.get("v.OrderList").length - 5)
        {
            let newOff = component.get("v.Offset") + 5;
            component.set("v.Offset", newOff);
        }
    },
    
    OffsetMinus : function (component, event)
    {
        if(component.get("v.Offset") > 0)
        {
            let minusOff = component.get("v.Offset") - 5;
            console.log(minusOff);
            component.set("v.Offset", minusOff);
        }
    }

})