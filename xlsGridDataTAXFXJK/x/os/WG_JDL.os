function x_WG_JDL(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var EAfunc = new pubpack.EAFunc();
var HtmlParser = new x_WG_HtmlParser();
var httpcall = new webget.HttpCall();
var numberVerificationCodeIdentifier = new webget.NumberVerificationCodeIdentifier();
var util = new JavaPackage("java.util");
//function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code)
function start()
{
	var userid = "3280";
	var passwd = "9020596";
	var code = "gb2312";
	var ret = "";
	var param = "";
	var url = "";
	var msg = "";
	try
	{
		httpcall.Download("http://61.129.126.125:8081/B2BJDL/frmTools/ValidaPng.aspx?s=","/JDL.bmp");
		var imagecode = numberVerificationCodeIdentifier.parsefile("/JDL.bmp");
		return imagecode ;
		param = "__LASTFOCUS=&__EVENTTARGET=&__EVENTARGUMENT=&__VIEWSTATE=/wEPDwULLTE0MjkyOTc5MzNkGAEFHl9fQ29udHJvbHNSZXF1aXJlUG9zdEJhY2tLZXlfXxYBBQxJbWFnZUJ1dHRvbjGneLZboP2ZH7g0tLDhWFVCRXxDHQ=="+
			"&TextBox1="+userid+"&TextBox2="+passwd+"&TextBox3=";
		ret = httpcall.Post("http://61.129.126.125:8081/B2BJDL/page_Login.aspx","",code);

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

//½«×Ö·û´®ÖÐµÄÄ³Ð©×Ö·ûÌæ»»³É""
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