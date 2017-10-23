function TAXFXJK_SQJK02(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var pub = new JavaPackage("com.xlsgrid.net.pub");
var httphtml = new x_httpcallpaser();
var Paser = new JavaPackage("org.htmlparser");
var HtmlParser = new x_WG_HtmlParser();

var hostip = "http://87.16.17.217:8080/taxafism/";
var code = "utf-8";

function getSMBS()
{
	var httpcall = "";
	var ret = "";
	try {
		httpcall = new webget.HttpCall();
		ret = httpcall.Get(hostip+"",code);
//		throw new Exception(ret);
		ret = ret.substring(ret.indexOf("_t"));
//		ret = ret.substring(ret.indexOf("value=\"")+"value=\"".length());
//		ret = ret.substring(0,ret.indexOf("\">"));
//		sessionId = ret;
		var _t = 1501719550153;
		var username = "14511000102";
		var userpwd = "Lin5136017";
		ret =  httpcall.Post(hostip+"userinfo.do?method=login","_t="+_t+"&username="+username+"&userpwd="+userpwd);	//µÇÂ½
		return ret;
		
		return ret;
	} catch ( e ) {
		//pub.EAFunc.Log("Ò×³õÁ«»¨WG_EkChor error:"+e.toString());
		throw new Exception( e );
	}
}

}