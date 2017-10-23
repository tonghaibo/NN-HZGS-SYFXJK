function x_WG_Chinalh(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var EAfunc = new pubpack.EAFunc();
var HtmlParser = new x_WG_HtmlParser();
var httpcall = new webget.HttpCall();
var numberVerificationCodeIdentifier = new webget.NumberVerificationCodeIdentifier();
//function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code)
function start()
{
	var userid = "15099";
	var passwd = "99051";
	var code = "UTF-8";
	var ret = "";
	var param = "";
	var url = "";
	var msg = "";
	try
	{
	
//	      ret = httpcall.Get("http://supplierweb.carrefour.com.cn/","gbk");// 登录
//	        var sessionstr = "login.do;jsessionid=";
//	        var sessionstr1 = "action=doLogin";
//       var loc1= ret.indexOf(sessionstr);
//        var loc2= ret.indexOf(sessionstr1);
//        if ( loc1==-1 || loc2==-1 ) 
//          throw new Exception ("无法定位首页的jsessionid" );
//        var sessionid= ret.substring(loc1+sessionstr.length(),loc2-1);
//        httpcall.Download("http://supplierweb.carrefour.com.cn/includes/image.jsp","/first.bmp");// 登录 B634EF082435740B3433C3D367AC7648
//        // 分析图片
//        var imagecode = numberVerificationCodeIdentifier.parsefile("/first.bmp");
        
//        //login.do;jsessionid=
//        ret = httpcall.Post("http://supplierweb.carrefour.com.cn/login.do;jsessionid="+sessionid,"action=doLogin&login=X852&password=111111&validate="+imagecode,"GBK");

// 	return ret;
		ret = httpcall.Get("http://edi.chinalh.com/asp/index.asp",code);
		var str = "jsessionid=";
		var indexStart = ret.indexOf(str);
		var indexEnd = ret.indexOf("?service=");
		var jsessionid = ret.substring(indexStart+str.length(),indexEnd);
		str = "<input type=\"hidden\" name=\"lt\" value=\"";
		indexStart = ret.indexOf(str);
		indexEnd = ret.indexOf("\" />");
		var token = ret.substring(indexStart+str.length(),indexEnd);
		url = "http://cas.chinalh.com:90/casscm/login;jsessionid="+jsessionid;
		param = "service=http%3A%2F%2Fedi2.chinalh.com%3A80%2Flhscm%2F&_eventId=submit&lt="+token+"&password="+passwd+"&Submit=%E7%99%BB++%E5%BD%95&usercode="+userid+"&username=CODE000715099";
		ret = httpcall.Post(url,param,code);
		ret = httpcall.Get("http://edi2.chinalh.com/lhscm/",code);
		return ret;

				//SRFLG~~~USERID~~~DEPTID~~~KAID~~~BILID~~~ECORPNAM~~~ECORPID~~~ITMCLASS~~~
				//ORDID~~~DAT~~~ARRDAT~~~TEL~~~FAX~~~SEQID~~~EITMID~~~CODE~~~SPEC~~~EITMNAM~~~
				//QTYFLG~~~UNTNUM~~~QTY~~~ZPQTY~~~EPRICE~~~CORPADDR~~~NOTE~~~NULL
//				msg += "NR ~~~"+userid+"~~~1~~~1~~~"+bilid+"~~~"+corpnam+"~~~ ~~~ ~~~"+bilid+"~~~"+_date+"~~~"+_addrdate+"~~~"+
//					tel+"~~~"+fax+"~~~"+(row+1)+"~~~"+_detail.split("&")[1]+"~~~ ~~~"+_detail.split("&")[3]+"~~~"+_detail.split("&")[2];
//				if(_detail.split("&").length() == 12)
//					msg += ""+_detail.split("&")[11];
//				msg += ""+"~~~ ~~~_detail.split("&")[5]~~~"+_detail.split("&")[8]+"~~~"+_detail.split("&")[7]+"~~~0~~~"+addr+"~~~ ~~~ ";

	}
	catch(e)
	{
		throw new Exception(e);
	}
}

//将字符串中的某些字符替换成""
function ReploaceStatment(str,array)
{
	
	for(var r = 0;r < array.length() ;r ++)
	{
		var replacestatment = array[r];
		while(true)
		{

			if (str.indexOf(replacestatment)>-1)			
				str = EAfunc.Replace(str,replacestatment,"");	
			else
			     break;
		}
	}
	return str;
}

function DeleteSameStatment(str,replacement1,replacement2)
{
	var strs = str.split(replacement1);
	var strs_1 = strs[1];
	for(var r = 2;r < strs.length()-1;r ++)
	{
		if(strs[r+1] == replacement2&&strs[r] == strs[r+1])
		{
			strs[r] = EAfunc.Replace(strs[r],replacement2,"");
			strs_1 += strs[r];
		}
		else
			strs_1 += strs[r];
	}
	return strs_1;
}




}