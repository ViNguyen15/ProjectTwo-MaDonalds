({
    getProductNames : function(component, event, helper) {
        let productNames = component.get("c.getProductNameList");
        productNames.setCallback(this, function(resp){
            component.set("v.productNames", resp.getReturnValue());
        })
        $A.enqueueAction(productNames);
    },

    onProdSelect : function(cmp, prodName, prodQuantity){
        let prodPrice = cmp.get("c.getProductPrice");
        prodPrice.setParams({productName : prodName, quantity: prodQuantity});
        prodPrice.setCallback(this, function(resp){
            cmp.set("v.productPrice", resp.getReturnValue());
        })
        $A.enqueueAction(prodPrice);
    }
})
