package postdata;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;

public class PostData {

	public String post( String url, String[] vars, String[] vals ) {
		String postURL = url;
		
		if( vars.length > 0 ) {
			postURL += "?=";
		}
	
		if( vars.length == vals.length ) {
			// not really needed, but good for returns
			for( int i = 0; i < vars.length; i++ ) {
				postURL += vars[i] + "=" + vals[i];
			
				if( i < vars.length - 1 ) {
					postURL += "&";
				}
			}
	
			try {
				DefaultHttpClient httpClient = new DefaultHttpClient();

				HttpPost          httpPost   = new HttpPost( url );
				List nameValuePairs = new ArrayList(vars.length);
				for( int i = 0; i < vars.length; i++ ) {
					nameValuePairs.add(new BasicNameValuePair(vars[i], vals[i]));
				}

				httpPost.setEntity(new UrlEncodedFormEntity(nameValuePairs));
				
				System.out.println( "executing request: " + httpPost.getRequestLine() );
				HttpResponse response = httpClient.execute( httpPost );
				HttpEntity   entity   = response.getEntity();
				
				System.out.println("----------------------------------------");
				System.out.println( response.getStatusLine() );
				System.out.println("----------------------------------------");
				
				if( entity != null ) entity.writeTo( System.out );
				if( entity != null ) entity.consumeContent();
				
				httpClient.getConnectionManager().shutdown();
    
			} catch( Exception e ) { e.printStackTrace(); }
	
			// return the string we created
			return postURL;
		} else {
			return "number of variables does not match number of values!";
		}
	
	}
}
