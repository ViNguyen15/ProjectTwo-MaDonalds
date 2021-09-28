@isTest
public class TestControllerPlaceOrder {
    public TestControllerPlaceOrder() {

    }
    @testSetup
    public static void Setup(){
        String pricebkID = test.getStandardPriceBookID();
        Product2 borgar = new product2(name = 'borgar', isActive = true, ProductCost__c = 5);
        insert borgar;
        String borgarid = [SELECT id, name FROM product2 WHERE name = 'borgar'].get(0).id;
        PricebookEntry pbe = new PricebookEntry(product2id = borgarid, pricebook2ID = pricebkID, unitprice = 5);
        insert pbe;
        Pricebook2 standardPricebook = new Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook;

    }

    @isTest
    public static void TestPlaceOrder(){
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
        //Ensures "isSelected" hides the button on the page
        //If and only if the currently selected order item is invalid,
        //i.e negative quantity, 'select a product' should fail
        System.assert(ControllerPlaceOrder.isSelected('borgar', 2));
        System.assert(!ControllerPlaceOrder.isSelected('borgar', 0));
        System.assert(!ControllerPlaceOrder.isSelected('borgar', -5));
        System.assert(!ControllerPlaceOrder.isSelected('Select a Product', 2));
        //Tests if the item is added properly by additem3
        ControllerPlaceOrder.addItem3(orders.get(0).id, 'borgar', 3);
        List<orderItem> orderItems = [SELECT id, totalPrice FROM orderItem];
        System.assertEquals(orderItems.get(0).totalPrice, 15);
        System.assertEquals(orderItems.size(), 1);
        //Tests to ensure that the this order item, which has an invalid name, does not crash the program
        //And is not added to orderItems
        ControllerPlaceOrder.addItem3(orders.get(0).id, 'shake', 2);
        orderItems = [SELECT id, totalPrice FROM orderItem];
        System.assertEquals(orderItems.size(), 1);
        //This part tests to ensure updateOrderList3 wraps the orderitem correctly
        List<ControllerPlaceOrder.WrappedOrderItem> wrapped = ControllerPlaceOrder.updateOrderList3(orders.get(0).id);
        System.assertEquals(wrapped.size(), 1); 
        System.assertEquals(wrapped.get(0).quantity, 3); 
        System.assertEquals(wrapped.get(0).totalAmount, 15); 
        System.assertEquals(wrapped.get(0).productName, 'borgar');
        //This part ensures getOrderPrice returns the proper value for order price
        System.assertEquals(ControllerPlaceOrder.getOrderPrice(orders.get(0).id), 15);
         //This part ensures that orders are submitted properly
        String newOrdId = ControllerPlaceOrder.submitOrder3(orders.get(0).id);
        System.assertNotEquals(newOrdId, orders.get(0).id);
        System.assertEquals(ControllerPlaceOrder.getOrderPrice(newOrdID), 0);
        orders = [SELECT id, totalAmount, ownerID FROM order WHERE OwnerID=: UserInfo.getUserId()];
        System.assertEquals(orders.size(), 2);
        orders = [SELECT id, totalAmount, ownerID, status FROM order WHERE OwnerID=: UserInfo.getUserId() AND status = 'Activated'];
        System.assertEquals(orders.get(0).totalAmount, 15);
        System.assertEquals(orders.size(), 1);
    }
}