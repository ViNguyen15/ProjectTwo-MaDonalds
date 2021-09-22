({

    doInit : function(component, event, helper) 
    {
        helper.getProductNames(component, event);
    },

    
    onProdSelect: function (cmp, evt, helper) {
        helper.onProdSelect(cmp, cmp.find('selectProductID').get('v.value'), cmp.find('quantityID').get('v.value'));
    }

})
