({

    doInit : function(component, event, helper) 
    {
        helper.getProductNames(component, event);
        helper.createOrder(component);
    },

    
    onProdSelect: function (cmp, evt, helper) {
        helper.onProdSelect(cmp, cmp.find('selectProductID').get('v.value'), cmp.find('quantityID').get('v.value'));
    },

    addItem1: function(cmp, evt, helper){
        helper.addItem2(cmp, cmp.find('selectProductID').get('v.value'), cmp.find('quantityID').get('v.value'), cmp.get('v.orderID'));
    }

})
