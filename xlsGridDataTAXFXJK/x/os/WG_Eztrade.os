function x_WG_Eztrade(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var util = new JavaPackage("java.util");
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var HtmlParser = new x_WG_HtmlParser();
var httpcall = new webget.HttpCall();
function start()
{
	return getOrderStr("JQPX","2010-09-15","0031","W800040","BB000040","5","2710154191018"); 
}

var TotalPageIndex = 4;//总页数所在的TABLE索引
var listTableIndex = 3;//明细数据所在的TABLE索引
var links = new util.ArrayList();
function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code)
{
	var params = "";
	var res = ""; 
	var url = "";
	var host = "https://www.eztrade.org";
	try{

		//登录页面
		params = "company_code="+code+"&j_username="+userid+"&j_password="+passwd+"&origURL=https://www.eztrade.org/index.jsp&submit=提交";
		res = httpcall.Post("https://www.eztrade.org/login/authenticate.jsp?language=zh_CN",params,"utf-8");
		//登录后的Welcome页面
		res = httpcall.Get("https://www.eztrade.org/index.jsp?language=zh_CN","utf-8");		
		//点击Welcome页面左侧栏的[收件箱]
		res = httpcall.Get("https://www.eztrade.org/pages/pobody.jsp?module_code=PO_INBOX","utf-8");	
		//点击[收件箱]后载入的第一个订单页面
		//输入查询条件查指定日期的订单
		url = "https://www.eztrade.org/pages/po_list.jsp?Srch=1&module_code=&action=search&page_action=first&s5=2010/03/01&s6=2010/09/23";		
		//总共页数
		var totalpage = getPageNumber(url);
		var pageNo = 1;//页面的计数器	
		links = HtmlParser.SetLinks(httpcall,url,"utf-8","/pages/processing_polist.jsp?",links);
		//循环点击[下一页],(包含最后一页)
		while(pageNo < totalpage)
		{		
			links = HtmlParser.SetLinks(httpcall,"https://www.eztrade.org/pages/po_list.jsp?page_action=next","utf-8","/pages/processing_polist.jsp?",links);
			pageNo++;			
		}
		//判断是是否为空
		if (links.isEmpty())
			return "没有找到需要下载的订单！";	
		//取出ArrayList中的值，解析订单的明细数据
		for (var e = 0;e < links.size();e++)
		{
			var link = links.get(e);
			res = httpcall.Get(host+link,"utf-8");
			//https://www.eztrade.org/pages/po_header_detail.jsp?PO_MASTER_SYS_ID=13958961&STS=READ&S=6942074209221&RT=N
			res = httpcall.Get(host+"/pages/po_header_detail.jsp?"+link.substring(link.indexOf("&")+1,link.length()),"utf-8");
			res = httpcall.Get(host+"/pages/","utf-8");
			var page = HtmlParser.parserHtml(res,"utf-8");
			var table = HtmlParser.filterHtml(page,"table");
			
			var arr = HtmlParser.parserTableTitle(table,"utf-8",new Array(3));
			throw new Exception(parserOrderList(table,"utf-8",7));
			
		}
	}catch(e){ 
		throw new Exception(e);
	}

}
function parserOrderList(nodelist,code,tabIndex)
{	
	var node = nodelist.elementAt(tabIndex);
	var rows = node.getRows();
	var title = rows[2].getColumns();
	var xml = "<?xml version='1.0' encoding='"+code+"'?>\n<ROWSET>\n";	
	for (var r = 3;r<rows.length();r++)
	{
		xml += "<ROW>\n";	
		var cols = rows[r].getColumns();
		for (var c = 0;c<title.length();c++)
		{
			var titleVal = HtmlParser.ReplaceStrToNull("_"+title[c].toPlainTextString().trim(),new Array("&nbsp;","&#160;"));
			var Val =  "";
			if( c >= cols.length()) 
				Val = "";	
			else
			{						
				Val = HtmlParser.ReplaceStrToNull(cols[c].toPlainTextString().trim(),new Array("&nbsp;","&#160;"));	
			}				
			if (titleVal!="" && Val!="")
			{

				xml += "<"+titleVal+">"+Val+"</"+titleVal+">\n";
			}
		}
		xml += "</ROW>\n";
	}
	xml += "</ROWSET>\n";	
	return xml;
	//return new pubpack.EAXmlDS(xml);	
}
//取得总页数
function getPageNumber(url)
{
	var res = httpcall.Get(url,"utf-8");
	var page = HtmlParser.parserHtml(res,"utf-8");
	var form = HtmlParser.filterHtml(page,"form");
	var table = HtmlParser.filterHtml(form,"table");
	var tablist = table.elementAt(4);
	var content = HtmlParser.ReplaceStrToNull(tablist.toPlainTextString().trim(),new Array("&nbsp;"));
	if (content.indexOf ("下一页") > -1)		
		return content.substring(content.lastIndexOf("／")+1,content.indexOf("下一页"));
	else
		return content.substring(content.lastIndexOf("／")+1,content.length());
}




}