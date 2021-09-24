@isTest
public class TestControllerPlaceOrder {
    public TestControllerPlaceOrder() {

    }
    @testSetup
    public Setup(){
        String pricebkID = test.getStandardPriceBookID();
        Product2 borgar = new product2(name = 'borgar', isActive = true);
        insert borgar;
        String borgarid = [SELECT id, name FROM product2 WHERE name = 'borgar'].get(0).id;
        PricebookEntry pbe = new PricebookEntry(product2id = borgarid, pricebook2ID = pricebkID, unitprice = 5);
        insert pbe;
    }

    @isTest
    public TestPlaceOrder(){
        ControllerPlaceOrder.createOrder();
        List<Order> orders = [SELECT id, ownerID FROM Order WHERE ownerID =: UserInfo.getUserId()];
        //This line makes sure that create order creates an order properly the first time
        System.assertEquals(orders.size(), 1);
        list<string> productNames = ControllerPlaceOrder.getProductNameList();
        //Ensures "getProductNameList()" is working properly
        System.assertEquals(productNames.size(), 2);
        System.assertEquals(productNames.get(0), 'Select a Product');
        System.assertEquals(productNames.get(1), 'borgar');
        //Ensures "Get Product Price" is working properly
        //Negative values for quantity should return 0
        //'Select a Product' should always return 0
        System.AssertEquals(ControllerPlaceOrder.getProductPrice('borgar', 1), 5);
        System.AssertEquals(ControllerPlaceOrder.getProductPrice('Select a Product', 1), 0);
        System.AssertEquals(ControllerPlaceOrder.getProductPrice('borgar', -5), 0);
        System.AssertEquals(ControllerPlaceOrder.getProductPrice('borgar', 3), 15);
        
    }
}
