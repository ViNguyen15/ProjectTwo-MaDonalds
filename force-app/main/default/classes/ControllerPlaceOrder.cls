public class ControllerPlaceOrder {
    public ControllerPlaceOrder() {
        
    }

    //Used to create the order at initialization
    //Will use first existing incomplete order instead user owns if they already own one
    @AuraEnabled
    public static String createOrder(){
        String userID = UserInfo.getUserId();
        List<Order> usersOrders = [SELECT ID, status, OwnerID FROM ORDER WHERE OwnerId =: userID AND status = 'Draft'];
        if (usersOrders.size() > 0){
            return usersOrders.get(0).id;
        }
        list<PriceBook2> pricebooks = [SELECT id, isStandard FROM Pricebook2 WHERE isStandard = true];
        Order theOrder = new Order(OwnerId = userID, Name = userID + '\'s Order', status = 'Draft', AccountId = getAccount(),
                                   EffectiveDate = system.today(), recordTypeID = Schema.SObjectType.Order.GetRecordTypeInfosByDeveloperName().get('Customer_Order').getRecordTypeID(),
                                   Pricebook2ID = pricebooks.get(0).id);
        insert theOrder;
        usersOrders = [SELECT id, status, OwnerID FROM ORDER WHERE OwnerId =: UserID AND status = 'Draft'];
        return usersOrders.get(0).id;
    }

    //Used to get the list of product names
    @AuraEnabled
    public static List<String> getProductNameList(){
        List<Product2> products = [SELECT name, isActive FROM Product2 WHERE isActive = True];
        List<String> productNames = new List<String>();
        productNames.add('Select a Product');
        for (product2 a : products){
            productNames.add(a.name);
        }
        System.debug(productNames);
        return productNames;
    }
    //Used to determine the product price for display
    @AuraEnabled
    public static decimal getProductPrice(String productName, Integer quantity){
        if (quantity <= 0 || productName == 'Select a Product'){
            return 0;
        }
        List<Product2> products = [SELECT name, id FROM Product2 WHERE name =: productName];
        List<PricebookEntry> PBentries = [SELECT id, product2id, unitprice FROM PricebookEntry WHERE product2id =: products.get(0).id];
        return (PBentries.get(0).unitprice * quantity);
    }
    // used to check whether or not the add item to order button should be displayed (depends on if the selections are valid)
    @AuraEnabled
    public static Boolean isSelected(String productName, Integer quantity){
        if (quantity <= 0){
            return false;
        }
        return !(productName == 'Select a Product');
    }
    
    // Adds an OrderItem to the Order associated with the user
    @AuraEnabled
    public static void addItem3(String ordID, String productName, Integer quant){
        //This list should always contain exactly one product, corresponding to the name in the function call
        List<Product2> products = [SELECT name, id, isActive FROM Product2 WHERE isActive = True AND name =: productName];
        if (products.size() == 0){
            System.debug('the add item function failed because the productName was invalid.');
            return;
        }
        List<PricebookEntry> PBentries = [SELECT id, product2id, unitprice FROM PricebookEntry WHERE product2id =: products.get(0).id];
        OrderItem toAdd = new OrderItem(Product2id = products.get(0).id, OrderId = ordID, Quantity = quant, PriceBookEntryId = PBentries.get(0).id, UnitPrice = PBentries.get(0).unitprice);
        insert toAdd;
    }

    // Gets the current account that is accessing the component
    @AuraEnabled
    public static String getAccount(){
        List<User> users = [SELECT id, contactID FROM User WHERE id =: UserInfo.getUserId()];
        //ContactID for current user is null when using preview through dev console, should ALWAYS be not null when using experience site
        if (users.get(0).contactID == null){
            System.debug('You should not see this on the experience site, only during previews in dev console');
            return '0015f000005jh63AAA';
        }
        List<Contact> contacts = [SELECT id, accountID FROM contact WHERE id =: users.get(0).contactID];
        return contacts.get(0).accountID;
    }
    //This is necessary to get wrapped order items into a list for display on the component
    @AuraEnabled
    public static List<WrappedOrderItem> updateOrderList3(String ordID){
        List<OrderItem> orderItems = [SELECT id, product2id, Quantity, listPrice FROM OrderItem WHERE OrderID =: ordID];
        list<WrappedOrderItem> toReturn = new list<WrappedOrderItem>();
        List<Product2> products = [SELECT id, name FROM Product2];
        for (orderItem a : orderItems){
            for (product2 b : products){
                if (b.id == a.product2id){
                    toReturn.add(new WrappedOrderItem(a.totalPrice, a.Quantity, b.name));
                }
            }
        }
        return toReturn;
    }
    //We wrap order items in this wrapper class so that they have a product name associated with them
    //This is the easiest way to display them on the component that I could think of
    //If this is needlessly complicated, I apologize
    public class WrappedOrderItem{
        @AuraEnabled
        public decimal totalAmount{get; set;}
        
        @AuraEnabled
        public decimal quantity{get; set;}
        
        @AuraEnabled
        public string productName{get; set;}
        
        WrappedOrderItem(decimal totam, decimal quant, String name)
        {
            totalAmount = totam;
            quantity = quant;
            productName = name;
        }
    }

}
