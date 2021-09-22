({
    getProductNames : function(component, event, helper) {
        let productNames = component.get("c.getProductNameList");
        productNames.setCallback(this, function(resp){
            component.set("v.productNames", resp.getReturnValue());
        })
        $A.enqueueAction(productNames);
    }
})
