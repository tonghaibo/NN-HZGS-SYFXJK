function x_WG_Eztrade(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var util = new JavaPackage("java.util");
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var HtmlParser = new x_WG_HtmlParser();
var httpcall = new webget.HttpCall();
function start()
{
	return getOrderStr("JQPX","2010-09-15","0031","W800040","BB000040","5","2710154191018"); 
}

var TotalPageIndex = 4;//��ҳ�����ڵ�TABLE����
var listTableIndex = 3;//��ϸ�������ڵ�TABLE����
var links = new util.ArrayList();
function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code)
{
	var params = "";
	var res = ""; 
	var url = "";
	var host = "https://www.eztrade.org";
	try{

		//��¼ҳ��
		params = "company_code="+code+"&j_username="+userid+"&j_password="+passwd+"&origURL=https://www.eztrade.org/index.jsp&submit=�ύ";
		res = httpcall.Post("https://www.eztrade.org/login/authenticate.jsp?language=zh_CN",params,"utf-8");
		//��¼���Welcomeҳ��
		res = httpcall.Get("https://www.eztrade.org/index.jsp?language=zh_CN","utf-8");		
		//���Welcomeҳ���������[�ռ���]
		res = httpcall.Get("https://www.eztrade.org/pages/pobody.jsp?module_code=PO_INBOX","utf-8");	
		//���[�ռ���]������ĵ�һ������ҳ��
		//�����ѯ������ָ�����ڵĶ���
		url = "https://www.eztrade.org/pages/po_list.jsp?Srch=1&module_code=&action=search&page_action=first&s5=2010/03/01&s6=2010/09/23";		
		//�ܹ�ҳ��
		var totalpage = getPageNumber(url);
		var pageNo = 1;//ҳ��ļ�����	
		links = HtmlParser.SetLinks(httpcall,url,"utf-8","/pages/processing_polist.jsp?",links);
		//ѭ�����[��һҳ],(�������һҳ)
		while(pageNo < totalpage)
		{		
			links = HtmlParser.SetLinks(httpcall,"https://www.eztrade.org/pages/po_list.jsp?page_action=next","utf-8","/pages/processing_polist.jsp?",links);
			pageNo++;			
		}
		//�ж����Ƿ�Ϊ��
		if (links.isEmpty())
			return "û���ҵ���Ҫ���صĶ�����";	
		//ȡ��ArrayList�е�ֵ��������������ϸ����
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
//ȡ����ҳ��
function getPageNumber(url)
{
	var res = httpcall.Get(url,"utf-8");
	var page = HtmlParser.parserHtml(res,"utf-8");
	var form = HtmlParser.filterHtml(page,"form");
	var table = HtmlParser.filterHtml(form,"table");
	var tablist = table.elementAt(4);
	var content = HtmlParser.ReplaceStrToNull(tablist.toPlainTextString().trim(),new Array("&nbsp;"));
	if (content.indexOf ("��һҳ") > -1)		
		return content.substring(content.lastIndexOf("��")+1,content.indexOf("��һҳ"));
	else
		return content.substring(content.lastIndexOf("��")+1,content.length());
}




}