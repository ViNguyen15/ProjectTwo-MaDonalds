public class ControllerPlaceOrder {
    public ControllerPlaceOrder() {
        
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
    //
    @AuraEnabled
    public static decimal getProductPrice(String productName, Integer quantity){
        List<Product2> products = [SELECT name, ProductCost__c FROM Product2];
        for (product2 a : products){
            if (a.name == productName){
                return a.ProductCost__c * quantity;
            }
        }
        return 0;
    }
}
