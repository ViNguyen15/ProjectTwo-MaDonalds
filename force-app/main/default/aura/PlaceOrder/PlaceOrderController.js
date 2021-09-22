({

    doInit : function(component, event, helper) 
    {
        helper.getProductNames(component, event);
        helper.createOrder(component);
    },

    
    onProdSelect: function (cmp, evt, helper) {
        helper.onProdSelect(cmp, cmp.find('selectProductID').get('v.value'), cmp.find('quantityID').get('v.value'));
    }

})
