({
	Initialize : function(component, event) 
    {
		component.set("v.CurPage", "Home");
	},
    
    NavAcc : function (component, event)
    {
        component.set("v.CurPage", "Account");
    },
    
    NavFran : function (component, event)
    {
        component.set("v.CurPage", "Franchise");
    }
})