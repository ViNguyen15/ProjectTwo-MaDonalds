public class ControllerPlaceOrder {
    public ControllerPlaceOrder() {
        
    }

    //Used to create the order at initialization
    //Will use first existing incomplete order instead user owns if they already own one
    @AuraEnabled
    public static string createOrder(String userID){
        List<Order> usersOrders = [SELECT id, status, OwnerID FROM ORDER WHERE OwnerId =: userID AND status = 'Draft'];
        if (usersOrders.size() > 0){
            return usersOrders.get(0).id;
        }
        Order theOrder = new Order(OwnerId = userID, Name = userID + '\'s Order', status = 'Draft');
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
        if (quantity <= 0){
            return 0;
        }
        List<Product2> products = [SELECT name, ProductCost__c FROM Product2];
        for (product2 a : products){
            if (a.name == productName){
                return a.ProductCost__c * quantity;
            }
        }
        return 0;
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
    public static void addItem(String ordID, String productName, Integer quant){
        //This list should always contain exactly one product, corresponding to the name in the function call
        List<Product2> products = [SELECT name, isActive FROM Product2 WHERE isActive = True AND name =: productName];
        if (products.size() == 0){
            System.debug('the add item function failed because the productName was invalid.');
            return;
        }
        OrderItem toAdd = new OrderItem(Product2id = products.get(0).id, OrderId = ordID, Quantity = quant);
        insert toAdd;
    }
}
