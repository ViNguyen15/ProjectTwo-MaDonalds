({
    getProductNames : function(component, event, helper) {
        let productNames = compenent.get("c.getProductNameList");
        productNames.setCallback(this, function(resp){
            component.set("v.productNames", resp.getReturnValue());
        })
        $A.enqueaction(productNames);
    }
})
