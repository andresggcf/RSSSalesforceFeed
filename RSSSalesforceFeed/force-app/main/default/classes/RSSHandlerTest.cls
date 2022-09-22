@IsTest
private class RSSHandlerTest {
    
    @testSetup
    private static void setup () {
        List<News_Feed__c> newsList = new List<News_Feed__c>();
        
        //Insert 20 feeds
        for (Integer i = 0; i < 20; i++){
            News_Feed__c feed = new News_Feed__c();
            feed.Title__c = 'Title ' + i;
            feed.Link__c = 'www.test' + i + 'url.com';
            feed.Description__c = 'Description ' + i;
            feed.Date_published__c = DateTime.now();
         	
            newsList.add(feed);
        }
        
        insert newsList;
        
    }

    @IsTest
    private static void testInsertItemsWithNonExistingRSSNode(){
        //setup
        List<News_Feed__c> newsList = [SELECT Title__c, Description__c, Link__c, Date_Published__c FROM News_Feed__c];
        
		//Execute
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CalloutMock());
        RSSHandler rh = new RSSHandler();
        List<Dom.XMLNode> testNode = rh.getRSSFeed('https://test.feed.com/');
        rh.insertItems(newsList, testNode);
        Test.stopTest();
        
        //Assert
        List<News_Feed__c> updatedNewsList = [SELECT Title__c, Description__c, Link__c, Date_Published__c FROM News_Feed__c];
        System.AssertEquals(21,updatedNewsList.size());
    }
    
    @IsTest
    private static void testInsertItemsWithExistingRSSNode(){
        //setup
        List<News_Feed__c> newsList = [SELECT Title__c, Description__c, Link__c, Date_Published__c FROM News_Feed__c];
        
		//Execute
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ExistingCalloutMock());
        RSSHandler rh = new RSSHandler();
        List<Dom.XMLNode> testNode = rh.getRSSFeed('https://test.feed.com/');
        rh.insertItems(newsList, testNode);
        Test.stopTest();
        
        //Assert
        List<News_Feed__c> updatedNewsList = [SELECT Title__c, Description__c, Link__c, Date_Published__c FROM News_Feed__c];
        System.AssertEquals(20,updatedNewsList.size());
    }
    
    @IsTest
    private static void testGetRSSFeed(){
        //Execute
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CalloutMock());
        RSSHandler rh = new RSSHandler();
        List<Dom.XMLNode> testNode = rh.getRSSFeed('https://test.feed.com/');
        Test.stopTest();
        
        //Assert
        System.assertEquals(1, testNode.size());
    }
}