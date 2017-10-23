function x_httpcallpaser(){var Httpclient = new JavaPackage("org.apache.commons.httpclient");
var parser = new JavaPackage("org.cyberneko.html.parsers");
var DOMFragmentparser = new parser.DOMFragmentParser();
var htmldocument = new JavaPackage("org.apache.html.dom");
var HTMLDocumentimpl = new htmldocument.HTMLDocumentImpl();
var webget = new JavaPackage("com.xlsgrid.net.webget");
var sax = new JavaPackage("org.xml.sax");

function PostAndParse(url, paramlist,code)  
  {

    var sb = new StringBuffer();
    var ssa = "";
    //org.apache.commons.httpclient.methods.PostMethod postMethod= new org.apache.commons.httpclient.methods.PostMethod(url);
    var postMethod= new webget.GBKPostMethod(url,code);
    try {
       sb.append(url + "?");
       //从sParam替代变量
        var ss = paramlist.split("&");
//        throw new Exception(ss);
        for ( var i=0;i<ss.length();i++ ) 
        {
	          var loc = ss[i].indexOf("=");
	          loc = 1.0*loc;
	          var sssid = "";
	          var sssvalue = "";
	          if (loc>0 ) {
	            sssid = ss[i].substring(0,loc);
	            if(ss[i].split("=").length() > 1 )
	           	 sssvalue = ss[i].substring(loc+1);
	          }
          	 postMethod.addParameter(sssid,sssvalue);
               throw new Exception(sssid +","+sssvalue );
          }
       
	var httpclient = new Httpclient.HttpClient();
        httpclient.executeMethod(postMethod);
       //org.apache.xerces.dom.
       var node = HTMLDocumentimpl.createDocumentFragment();
       throw new Exception(node);
       var inputs = postMethod.getResponseBodyAsStream();
         var isr=null;
         if ( code.length()>0 ) 
          isr=new java.io.InputStreamReader(inputs,code);
         else 
          isr=new InputStreamReader(inputs);
         var source=new sax.InputSource(isr);
         DOMFragmentparser.parse(source,node);
         throw new Exception(node);
       return node;
    }
    catch(e)
    {
    	throw new Exception(e);
    }
    finally {
//      if (postMethod!=null && postMethod.getURI()!=null )
//        m_url =postMethod.getURI().getURI();
//      if(postMethod!=null)postMethod.releaseConnection();
    }
}

}