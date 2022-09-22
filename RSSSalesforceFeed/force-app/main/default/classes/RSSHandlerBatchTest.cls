@IsTest
private class RSSHandlerBatchTest {
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
    
    @isTest
    private static void testBatch(){
        //Execute
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CalloutMock());
        RSSHandlerBatch rssHB = new RSSHandlerBatch();
        Id batchId = Database.executeBatch(rssHB);
        Test.stopTest();
        
        //Assert
        List<News_Feed__c> newsList = [SELECT Id, Name FROM News_Feed__c];
       
        System.assertEquals(21, newsList.size());
    }

}