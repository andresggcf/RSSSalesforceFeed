global class RSSHandlerBatch implements Database.Batchable<sObject>,Database.AllowsCallouts{
	global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        String currentNews = 'SELECT Title__c, Description__c, Link__c, Date_Published__c FROM News_Feed__c WHERE CreatedDate = LAST_N_DAYS:5';
        return Database.getQueryLocator(currentNews);
    }
    
    global void execute(Database.BatchableContext bc, List<News_Feed__c> newsFeed) {
        RSSHandler rssH = new RSSHandler();
        List<Dom.XmlNode> rssList = rssH.getRSSFeed('https://news.un.org/feed/subscribe/en/news/all/rss.xml');
 
        rssH.insertItems(newsFeed, rssList); 
    }   
     
    global void finish(Database.BatchableContext bc) {
        System.debug('Finished Batch');
    }
}