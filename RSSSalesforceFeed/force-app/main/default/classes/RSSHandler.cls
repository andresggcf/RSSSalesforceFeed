public class RSSHandler {
    
    /* This method fetchs xml items from an RSS feed and deletes 
     * object records that are not found in the RSS feed list. 
     */
    public void insertItems(List<News_Feed__c> currentNews, List<Dom.XmlNode> rssList){
        
        List<News_Feed__c> itemsToAdd = new List<News_Feed__c>();
        
        for(Dom.XmlNode item : rssList){
            if(!dbContainsItem(item.getChildElement('title',null).getText(), currentNews)){
            	News_Feed__c newsFeedItem = new News_Feed__c();
            	newsFeedItem.Title__c = item.getChildElement('title',null).getText();
            	newsFeedItem.Description__c = item.getChildElement('description',null).getText();
            	newsFeedItem.Link__c = item.getChildElement('link',null).getText();
                String dateStr = changeDateFormat(item.getChildElement('pubDate',null).getText().right(26).left(21));
                DateTime dt = Datetime.valueOf(dateStr);
            	newsFeedItem.Date_published__c = dt;
                
                itemsToAdd.add(newsFeedItem);
            }
        }
 
        System.debug('RSS Feed List Size: ' + rssList.size());
        System.debug('Items To add to DB: ' + itemsToAdd.size());
        
        if(itemsToAdd.size() > 0) {
            insert itemsToAdd;
        }
        
    }
    
    /*Changes string date format from DD MMM YYYY to YYYY-MM-DD*/
    private String changeDateFormat(String dateStr){
        String year = dateStr.left(11).right(4);
        String month = dateStr.left(6).right(3);
        String day = dateStr.left(2);
        String timeStr = dateStr.right(9).left(8);
        
        switch on month {
            when 'Jan'{
                month = '01';
            }
            when 'Feb'{
                month = '02';
            }
            when 'Mar'{
                month = '03';
            }
            when 'Apr'{
                month = '04';
            }
            when 'May'{
                month = '05';
            }
            when 'Jun'{
                month = '06';
            }
            when 'Jul'{
                month = '07';
            }
            when 'Aug'{
                month = '08';
            }
            when 'Sep'{
                month = '09';
            }
            when 'Oct'{
                month = '10';
            }
            when 'Nov'{
                month = '11';
            }
            when 'Dec'{
                month = '12';
            }
        }
        String newDateFormat = year + '-' + month + '-' + day + ' ' + timeStr;
        Return newDateFormat;
    }
     

	/* Checks if news item exists by comparing the titles of the RSS feed item and
	 * the titles from elements in the query*/    
    private boolean dbContainsItem (String title, List<News_Feed__c> currentNews){
        for (News_Feed__c currentItem : currentNews){
            if(title.left(20) == currentItem.Title__c.left(20)){
                return true;
            }
        }
        return false;
    }
    
    /* Returns a list of xml nodes (items) from an RSS Feed
     * given a url.
     */
    public List<Dom.XMLNode> getRSSFeed (String url) {
       	Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint(url);
		request.setMethod('GET');
		HttpResponse response = http.send(request);

		//CDATA was not letting the description be shown on the Dom.Document
		//So it had to be removed.        
        String newXml = response.getBody().replaceAll( '<!\\[CDATA\\[', '' ).replaceAll( ']]>', '' );
        
        Dom.Document document = new Dom.Document();
        document.load(newXml);
        Dom.XmlNode node = document.getRootElement();
        
        List<Dom.XMLNode> rssList = new List<Dom.XMLNode>();
        for(Dom.XMLNode child : node.getChildren()) {
            for(Dom.XMLNode item : child.getChildren()) {
                if(item.getName() == 'item') {
                   rssList.add(item);
               }
           }
        }
       return rssList;
    }
}