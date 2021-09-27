@isTest
public class CustomerAccountControllerTest 
{
    @future
    public static void CreateAdmin() //This creates an administrator user for our testing; we assign them a role and account ownership so we can create customer portal users. 
    {
        Profile a = [SELECT Id FROM profile WHERE Name = 'System Administrator' LIMIT 1];
        UserRole uRole = [SELECT Id FROM UserRole WHERE Name = 'CEO' LIMIT 1];
        if(uRole == null)
        {
            System.debug('Error');
        }
        User ownerUser = new User
            (
                LastName = 'Owner User',
                Email = 'jdfshdfshdfsh@hdfshdfsh.com',
                Alias = 'Fredeee',
                Username = 'kdh12l8hd87@jdhd.com',
                CommunityNickname = 'test11',
                LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'GMT',
                LanguageLocaleKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                UserRoleId = uRole.id,
                ProfileId = a.id
            );
        Insert ownerUser;
    }
    
    @future
    public static void CreateAccount() //Creating an account for the testing; this must be owned by a user with a role in the org. 
    {
        User ownerUser = [SELECT id FROM User where LastName = 'Owner User' LIMIT 1];
        Account newAccount = new Account(name = 'PortalUserAccount', OwnerId = ownerUser.id);
        Insert newAccount;
    }
    
    @future
    public static void CreateContact() //Creating a contact for the customer user; this is required to create a customer user. 
    {
        Account newAccount = [SELECT id FROM Account WHERE Name = 'PortalUserAccount' LIMIT 1];
        Contact userContact = new Contact(LastName = 'Filbertson', FirstName = 'Phil', AccountID = newAccount.Id);
        Insert userContact;
    }
    
    @future
    public static void CreatePortalUser() //This creates our customer user. 
    {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Madonal Customer' LIMIT 1]; //Our org should already have a profile named "Madonal Customer."
        
        Contact userContact = [SELECT Id FROM Contact WHERE LastName = 'Filbertson' LIMIT 1];
     
        User u = new User
            (
                LastName = 'jdshfshufdshu',
                Email = 'jhdfsuhfhj@jdfshdfsh.com',
                Alias = 'Octagon',
                Username = 'ahditrd@hjdfhd.com',
                CommunityNickname = 'test12',
                LocaleSidKey = 'en_US',
                TimeZoneSidKey = 'GMT',
                LanguageLocaleKey = 'en_US',
                EmailEncodingKey = 'UTF-8');
        
        u.ContactId = userContact.id;
        u.ProfileId = p.Id;
        Insert u;
    }
    
    @future
    public static void CreateOrders() //This creates some orders to associate with our customer user's account. 
    {
        List<Order> toInsert = new List<Order>();  //We'll generate orderItems in our tests. 
        PriceBook2 aPriceBook = new PriceBook2(isActive = true, id = Test.getStandardPricebookId());
        Product2 aProduct = new Product2(name = 'MaDonda Meal', isActive = true, ProductCost__c = 0);
        Update aPriceBook;
        Account theAccount = [SELECT id, name FROM Account WHERE name = 'PortalUserAccount' LIMIT 1];
        
        for(Integer i = 0; i < 5; i++)
        {
            toInsert.add(new Order(Name = 'Order# ' + string.valueof(i), AccountID = theAccount.id, EffectiveDate = System.today(), Status = 'Draft', Pricebook2ID = aPricebook.id));
        }
        
        Insert toInsert;
        Insert aProduct;
    }
    
    @testSetup
    public static void SetupTest() 
    {
        CreateAdmin();
        CreateAccount();
        CreateContact();
        CreatePortalUser();
        CreateOrders();
    }
    
    @isTest
    public static void Pos_TestCustID() //Positive test for retrieving customer-related IDs. 
    {
        test.startTest();
        User pUser = [SELECT Id, ContactId FROM User WHERE Profile.Name = 'Madonal Customer' LIMIT 1];
        Contact pUserContact = [SELECT Id, AccountId FROM Contact WHERE Id = : pUser.ContactId LIMIT 1];
        Account pUserAccount = [SELECT id FROM Account WHERE Id = : pUserContact.AccountId LIMIT 1];
        System.assertEquals(true, (pUser != null));
        System.assertEquals(true, (pUserContact != null));
        System.assertEquals(true, (pUserAccount != null)); //We should've gotten something from each of these queries, otherwise our test should fail. 
        
        System.runas(pUser)
        {
            List<id> idList = CustomerAccountController.CustomerIds();
            System.assertEquals(3, idList.size());
            System.assertEquals(pUser.id, idList.get(0)); //Comparing retrieved IDs in the list to what they should be. 
            System.assertEquals(pUserContact.id, idList.get(1));
            System.assertEquals(pUserAccount.id, idList.get(2)); 
        }
        test.stopTest();
    }
    
    @isTest
    public static void Neg_TestCustID()
    {
        test.startTest();
        
        User admin = [SELECT id FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1];
        System.runas(admin)
        {
            List<id> idList = CustomerAccountController.CustomerIds();
            System.assertEquals(null, idList); //A non-customer user should get null from this class. 
        }
        
        test.stopTest();
    }
    
    @isTest
    public static void Pos_TestOrderWrapping()
    {
        test.startTest();
        
        Account custAccount = [SELECT id FROM Account WHERE name = 'PortalUserAccount' LIMIT 1];
        
        List<Order> orderList = [SELECT status FROM Order];
        Pricebook2 aPriceBook = [SELECT id FROM Pricebook2 LIMIT 1];

        Product2 prod = [SELECT id FROM Product2];
        PricebookEntry anEntry = new PricebookEntry(Product2ID = prod.id, Pricebook2ID = aPriceBook.ID, UnitPrice = 3.95);
        Insert anEntry;
        List<OrderItem> oItems = new List <OrderItem>();
        
        for(Order o : orderList)
        {
            oItems.add(new orderItem(OrderID = o.id, Product2ID = prod.id, PricebookEntryID = anEntry.id, Quantity = 1, UnitPrice = 3.95));
            o.status = 'Activated';
        } //There's a lot of setup to do for testing Orders and OrderItems. 
        
        Insert oItems;
        Update orderList;
        
        User pUser = [SELECT Id FROM User WHERE Profile.Name = 'Madonal Customer' LIMIT 1];
        System.runas(pUser)
        {
            List<CustomerAccountController.WrappedOrders> wrappedOrders = CustomerAccountController.allOrders();
            System.assertEquals(5, wrappedOrders.size());
            for(CustomerAccountController.WrappedOrders wo : wrappedOrders)
            {
                for(CustomerAccountController.WrappedOrderItem woi : wo.Items)
                {
                    System.assertEquals(1, woi.Quantity); //These are the values we'd get if our info was wrapped properly.
                    System.assertEquals(3.95, woi.UnitPrice);
                    System.assertEquals('MaDonda Meal', woi.ProductName);
                    System.assertEquals(3.95, woi.TotalPrice);
                }
                System.assertEquals(1, wo.Items.size()); //We only added one product to each order. 
            }
        }
        
        test.stopTest();
    }
    
    @isTest
    public static void Neg_TestOrderWrapping()
    {
        test.startTest();
        
        System.assertEquals(null, CustomerAccountController.allOrders()); //We should get null from these because we're not running as a customer. 
        System.assertEquals(null, CustomerAccountController.CustomerIds());
        
        test.stopTest();
    }
    
    //Bulk testing shouldn't really be needed here, as we're limiting our order results in the Apex class and we should only have access to this Apex class when
    //we're viewing the Aura components as a single user. 
}