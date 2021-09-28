({
    doInit : function(component, event, helper) 
    {
        helper.RetrieveOrders(component, event);
    },
    
    IncreaseOffset : function(component, event, helper)
    {
        helper.OffsetPlus(component, event);
    },
    
    DecreaseOffset : function(component, event, helper)
    {
        helper.OffsetMinus(component, event);
    }
})