@IsTest
global class ExistingCalloutMock implements HttpCalloutMock{
	global HttpResponse respond(HTTPRequest req){
    	HttpResponse res = new HttpResponse();
    	res.setStatus('OK');
    	res.setStatusCode(200);
    	res.setBody(
            '<?xml version="1.0" encoding="utf-8" ?>' +
			'<rss version="2.0" xml:base="https://news.un.org/en/">'+
	        	'<channel>'+
            		'<item>'+
						'<title>Title 3</title>'+
						'<link>https://test.feed.com/</link>'+
						'<description>Description 3</description>' +
						'<pubDate>Wed, 21 Sep 2022 16:21:09 -0400</pubDate>'+
            			'</item>'+ 
        		'</channel>'+
			'</rss>');
    	return res;
  	}

}