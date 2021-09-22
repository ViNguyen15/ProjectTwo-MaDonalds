({
    getProductNames : function(component, event, helper) {
        let productNames = component.get("c.getProductNameList");
        productNames.setCallback(this, function(resp){
            component.set("v.productNames", resp.getReturnValue());
        })
        $A.enqueueAction(productNames);
    },

    onProdSelect : function(cmp, prodName, prodQuantity){
        //This part sets the product price based on the selection and quantity
        let prodPrice = cmp.get("c.getProductPrice");
        prodPrice.setParams({productName : prodName, quantity: prodQuantity});
        prodPrice.setCallback(this, function(resp){
            cmp.set("v.productPrice", resp.getReturnValue());
        })
        $A.enqueueAction(prodPrice);
        //This part sets a boolean telling if a product has been selected or the selected field is the default blank option
        let isValue = cmp.get("c.isSelected");
        isValue.setParams({productName : prodName, quantity: prodQuantity});
        isValue.setCallback(this, function(resp){
            cmp.set("v.itemSelected", resp.getReturnValue());
        })
        $A.enqueueAction(isValue);
    },

    createOrder : function(cmp){
        let action1 = cmp.get("c.createOrder");
        action1.setParams({UserID : $A.get("$SObjectType.CurrentUser.Id")});
        action1.setCallback(this, function(resp){
            cmp.set("v.orderID", resp.getReturnValue());
        })
        $A.enqueueAction(action1);
    }


})
