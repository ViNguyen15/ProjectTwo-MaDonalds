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
        action1.setCallback(this, function(resp){
            cmp.set("v.orderID", resp.getReturnValue());
        })
        $A.enqueueAction(action1);
    },

    addItem2 : function(cmp, prodName, prodQuantity, orderID){
        let theAction = cmp.get("c.addItem3");
        theAction.setParams({ordID : orderID, productName : prodName, quant : prodQuantity});
        $A.enqueueAction(theAction);
    },

    updateOrderList2 : function(cmp, orderID){
        let theAction = cmp.get("c.updateOrderList3");
        theAction.setParams({ordID : orderID});
        theAction.setCallback(this, function(resp){
            cmp.set("v.OrderList", resp.getReturnValue());
        })
        $A.enqueueAction(theAction);
        let orderPriceSetter = cmp.get("c.getOrderPrice");
        orderPriceSetter.setParams({ordID : orderID});
        orderPriceSetter.setCallback(this, function(resp){
            cmp.set("v.orderPrice", resp.getReturnValue());
        })
        $A.enqueueAction(orderPriceSetter);

    },

    submitOrder2 : function(cmp, orderID){
        //This part of the code will submit the order, updates orderID to fresh order
        let theAction = cmp.get("c.submitOrder3");
        theAction.setParams({ordID : orderID});
        theAction.setCallback(this, function(resp){
            cmp.set("v.orderID", resp.getReturnValue());
        })
        $A.enqueueAction(theAction);
        //The alert to let the user know their order has been submitted
        alert("Your order has been submitted.");
        cmp.set("v.orderPrice", "");
    }


})