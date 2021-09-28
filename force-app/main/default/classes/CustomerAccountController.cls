public class CustomerAccountController 
{
    @AuraEnabled
    public static List<id> CustomerIds() //This returns the IDs we'll use to retrieve customer information from the LDS later. 
    {
        List<id> toReturn = new List<id>();
        if(System.UserInfo.getUserId() != null)
        {
            
            User u = [SELECT id, Profile.name, ContactId  FROM User WHERE id = : System.UserInfo.getUserId() LIMIT 1];
            if(u.Profile.name == 'Madonal Customer' && u.ContactId != null)
            {
                Contact uContact = [SELECT id, AccountId FROM Contact WHERE id = : u.ContactId LIMIT 1];
                Account uAccount = [SELECT id FROM Account WHERE id = : uContact.AccountId LIMIT 1];
                toReturn.add(u.id);
                toReturn.add(uContact.id);
                toReturn.add(uAccount.id);
            }
        }
        if(toReturn.size() == 3)
        {
            return toReturn;
        }
        else
        {
            return null;
        }
    }
    
    @AuraEnabled
    public static List<WrappedOrders> allOrders() //This retrieves the most recent orders from a customer, up to a maximum of 50. 
    {
        User u = [SELECT id, Profile.name, ContactId  FROM User WHERE id = : System.UserInfo.getUserId() LIMIT 1]; 
            if(u.Profile.name == 'Madonal Customer' && u.ContactId != null)
            {
                Contact uContact = [SELECT id, AccountId FROM Contact WHERE id = : u.ContactId LIMIT 1];
            
                List<Order> allCustOrders = [SELECT effectiveDate, totalAmount, orderNumber, 
                                        (SELECT id, orderId, Product2ID, Quantity, UnitPrice, TotalPrice FROM OrderItems) 
                                        FROM Order WHERE AccountId = : uContact.AccountId AND Status = 'Activated' ORDER BY LastModifiedDate desc LIMIT 50];
                List<id> prodIds = new List<id>();
                for(Order o : allCustOrders)
                {
                    for(OrderItem OI : o.OrderItems)
                    {
                        prodIds.add(OI.Product2ID);
                    }
                }
              
                List<Product2> allProducts = [SELECT Name, id FROM Product2 WHERE id IN : prodIds];
                List<WrappedOrders> wrapped = new List<WrappedOrders>(); //Orders are wrapped in our subclasses to be more useful later. 
                for(Order o : allCustOrders)
                {
                    List<WrappedOrderItem> oiWrap = new List<WrappedOrderItem>();
                    for(OrderItem OI : o.OrderItems)
                    {
                        String name = null;
                        for(Product2 Prod : allProducts)
                        {
                            if(prod.id == OI.Product2Id)
                            {
                                name = prod.Name;
                            }
                        }
                        oiWrap.add(new WrappedOrderItem(OI.UnitPrice, OI.TotalPrice, OI.Quantity, name));
                    }
                    wrapped.add(new WrappedOrders(oiWrap, o.TotalAmount, o.EffectiveDate, o.OrderNumber));
                }
                return wrapped;
            }
        else{return null;}
    }

    public class WrappedOrders //Order wrapper class. 
    {
        @AuraEnabled
        public decimal TotalAmount{get; set;}
        
        @AuraEnabled
        public List<WrappedOrderItem> Items{get; set;}
        
        @AuraEnabled
        public date EffectiveDate{get; set;}
        
        @AuraEnabled
        public string OrderNumber{get; set;}
        
        WrappedOrders(List<WrappedOrderItem> ite, decimal TotAmount, date EffDate, string ordNum)
        {
            Items = ite;
            TotalAmount = TotAmount;
            EffectiveDate = EffDate;
            OrderNumber = ordNum;
        }
    }

    public class WrappedOrderItem //Wrapped OrderItems because the product name isn't included in the standard object. 
    {
        @AuraEnabled
        public decimal UnitPrice{get; set;}
        
        @AuraEnabled
        public decimal TotalPrice{get; set;}
        
        @AuraEnabled
        public decimal Quantity{get; set;}
        
        @AuraEnabled
        public string ProductName{get; set;}
        
        WrappedOrderItem(decimal unPrice, decimal TotPrice, Decimal Quan, String ProdName)
        {
            UnitPrice = unPrice;
            TotalPrice = TotPrice;
            Quantity = Quan;
            ProductName = ProdName;
        }
    }
}