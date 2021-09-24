({

    doInit : function(component, event, helper) 
    {
        helper.getProductNames(component, event);
        helper.createOrder(component);
        setTimeout(() => {helper.updateOrderList2(component, component.get('v.orderID'));}, 1000);
    },

    
    onProdSelect: function (cmp, evt, helper) {
        helper.onProdSelect(cmp, cmp.find('selectProductID').get('v.value'), cmp.find('quantityID').get('v.value'));
    },

    addItem1: function(cmp, evt, helper){
        helper.addItem2(cmp, cmp.find('selectProductID').get('v.value'), cmp.find('quantityID').get('v.value'), cmp.get('v.orderID'));
        helper.updateOrderList2(cmp, cmp.get('v.orderID'));
    }

})
