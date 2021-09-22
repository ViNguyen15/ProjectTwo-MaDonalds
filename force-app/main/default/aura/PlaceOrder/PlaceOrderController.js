({

    doInit : function(component, event, helper) 
    {
        helper.getProductNames(component, event);
        helper.createOrder(component, $A.get("$SObjectType.CurrentUser.Id"));
    },

    
    onProdSelect: function (cmp, evt, helper) {
        helper.onProdSelect(cmp, cmp.find('selectProductID').get('v.value'), cmp.find('quantityID').get('v.value'));
    },

    addItem: function(cmp, evt, helper){
        helper.addItem(cmp, cmp.find('selectProductID').get('v.value'), cmp.find('quantityID').get('v.value'), cmp.get('v.orderID'));
    }

})
