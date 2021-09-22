public class ControllerPlaceOrder {
    public ControllerPlaceOrder() {
        
    }

    public static List<String> getProductNameList(){
        List<Product2> products = [SELECT name, isActive FROM Product2 WHERE isActive = True];
        List<String> productNames = new List<String>();
        for (product2 a : products){
            productNames.add(a.name);
        }
        return productNames;
    }
}
