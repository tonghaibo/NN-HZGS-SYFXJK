function x_WG_Lawson(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var HClient = new JavaPackage("org.apache.commons.httpclient");
var method = new JavaPackage("org.apache.commons.httpclient.methods");
var pubpack = new JavaPackage("com.xlsgrid.net.pub");


function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code) 
{
	var ret = "";
	try{
		var db = new pubpack.EADatabase();
		var httpcall = new webget.HttpCall();
		var httpclient = new HClient.HttpClient();
		//登录罗森的供应商入口
		ret = httpcall.Post("http://edi.lawson.com.cn/login.asp","user=" + userid + "&pwd=" + passwd);
		//返回要抓取网页数据的HTML文档
		ret = httpcall.Get("http://edi.lawson.com.cn/download.asp",code);
		//解析html字符串
		var HtmlParser = new x_WG_HtmlParser();
		var nodelist = HtmlParser.parserHtml(ret,code);
		
		//得到过滤要处理的标签后的nodelist对象
		nodelist = HtmlParser.filterHtml(nodelist,"Form");

		var form = null;
		var formAttr = "";
		var formlist = null;
		//只处理Form中包含<td></td>的部分
		for (var i = 0;i<nodelist.size();i++)
		{
			form = nodelist.elementAt(i);	
			formAttr = form.getAttribute("action");	 
			if (formAttr.indexOf("download") > -1)
			{
				formlist = form.getChildren();
				//只处理TD标签
				var list = HtmlParser.filterHtml(formlist,"TD");
				var edidat = list.elementAt(2).getFirstChild().getText();
				
				//得到From中的日期，判断是不是指定日期
				edidat = edidat.substring(edidat.indexOf("-")-4,edidat.lastIndexOf(":")+3);
				var curdat = db.GetSQL("select to_char(to_date('"+edidat+"','yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd') from dual");

				if (curdat.equals(dat))
				{
					//如果是当天取出对应的<a>标签中的链接地址
					var link = HtmlParser.filterHtml(formlist,"A");
					link = link.elementAt(0);
					var urlpath = "http://edi.lawson.com.cn"+HtmlParser.urlCodeTrnas(link.getAttribute("href"),link.getStringText(),code);
					//下载文件到指定目录
					HtmlParser.downloadFile(urlpath,"d:/EDIDownloads/"+link.getStringText());						
				}
				
			}
		}	
				
	}catch(e){
		throw new Exception(e);
	}
	finally
	{
		if(db != null)
			db.Close();
	}	
}

function Main()
{
	return getOrderStr("","2010-09-04","","003697","003697","","UTF-8"); 	
}

}