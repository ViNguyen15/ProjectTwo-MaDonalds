({
	doInit : function(component, event, helper) 
    {
        helper.Initialize(component, event);
	},
    
    navAccount : function(component, event, helper)
    {
        helper.NavAcc(component, event);
    },
    
    LogOut : function(component, event, helper)
    {
       window.location.href = "https://madonalland-developer-edition.na163.force.com/MaDonalLand/secur/logout.jsp";
    },
    
    navFranchise : function (component, event, helper)
    {
        helper.NavFran(component, event);
    },
    
    navOrder : function (component, event, helper)
    {
        helper.NavOrd(component, event);
    },
    
    navSupport : function (component, event, helper)
    {
        helper.NavSup(component, event);
    }
})