function x_WG_HtmlParser(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var EAfunc = new pubpack.EAFunc();
var net = new JavaPackage("java.net");
var htmlparser = new JavaPackage("org.htmlparser");
var tagFilter = new JavaPackage("org.htmlparser.filters");
var htmlutil = new JavaPackage("org.htmlparser.util");
var visitors = new JavaPackage("org.htmlparser.visitors");
var HClient = new JavaPackage("org.apache.commons.httpclient");
var method = new JavaPackage("org.apache.commons.httpclient.methods");
var io = new JavaPackage("java.io");
var text = new JavaPackage("java.text");
var util = new JavaPackage("java.util");
//================================================================// 
// 函数：urlCodeTrnas(urlstr,str)
// 说明：把中文字符编码解析成URL编码适用类型（当下载文件名：D://AA/汉字.pdf）
// 参数：url(URL字符串),str(url中需要解析的部分)
// 返回：String 解析的URL编码字符串
// 样例：
// 作者：
// 创建日期：08/04/10 13:52:58
// 修改日志：
//================================================================// 
function urlCodeTrnas(urlstr,str,code){

	var nstr = str.substring(0,str.indexOf("."));
	var tmp = net.URLEncoder.encode(nstr,code);
	var urlstr = urlstr.substring(0,urlstr.indexOf(nstr))+tmp+urlstr.substring(urlstr.indexOf("."),urlstr.length());
	return urlstr ;
}

//================================================================// 
// 函数：parserHtml(htmlstr)
// 说明：解析HTML字符串返回NodeList对象
// 参数：String htmlstr(HTML字符串)
// 返回：NodeList(NodeList对象)
// 样例：
// 作者：
// 创建日期：08/04/10 14:23:48
// 修改日志：
//================================================================// 
function parserHtml(htmlstr,code){
	
	//用返回的HTML文档字符串，指定解析编码创建解析对象
	var ps = new htmlparser.Parser();
	var parser = ps.createParser(htmlstr,code); 
	//创建HtmlPage对象
	var htmlpage = new visitors.HtmlPage(parser);
	//遍历结点
	parser.visitAllNodesWith(htmlpage);
	//得到所有的节点
	var nodelist = htmlpage.getBody();	
	return nodelist;
}

//================================================================// 
// 函数：filterHtml(nodelist,str)
// 说明：对NodeList对象进行过滤（例如：只处理<a>标签）
// 参数：nodelist,str(过滤字符串)
// 返回：一个只包含str标签的nodelist
// 样例：
// 作者：
// 创建日期：08/04/10 14:27:26
// 修改日志：
//================================================================// 
function filterHtml(nodelist,str){
	
	var filter = new tagFilter.TagNameFilter(str);
	return nodelist.extractAllNodesThatMatch(filter,true);
}

//================================================================// 
// 函数：downloadFile(url,filepath)
// 说明：下载文件到指定的路径
// 参数：url:下载文件的URL，filepath:下载到目标的文件路径
// 返回：
// 样例：
// 作者：
// 创建日期：08/04/10 14:34:08
// 修改日志：
//================================================================// 
function downloadFile(url,filepath)
{
	var httpclient = new HClient.HttpClient();
	var getMethod = new method.GetMethod(url); 					
	httpclient.executeMethod(getMethod);
	var in = getMethod.getResponseBodyAsStream();
	var fos = new io.FileOutputStream(new io.File(filepath));
	var len = 0;
	while((len = in.read())!=-1){
		fos.write(len);
	}
	in.close();
	fos.close();			
}

//================================================================// 
// 函数：parserTable(nodelist,code,elementIDX,type)
// 说明：解析HTML中的TABLE标签,<tr>--Row,<td>--Col映射成数据库表的行列结构
// 参数：一个TABLE的nodelist结构,可能有多个TABLE标签elementIDX(要处理的第几个TABLE),code(处理的字符编码),
//	 tabidxArr(元素IDX的数组),typ(o,m,om):O一个TABLE，M多个table,OM 标题是一个，明细是多个
//	 有些订单结构是标题一个TABLE，每个明细都是一个TABLE，有些订单是整个明细是一个TABLE标题是一个TR，明细是一个TR
// 返回：DS结构
// 样例：
// 作者：
// 创建日期：08/09/10 16:47:52
// 修改日志：
//================================================================// 
function parserTable(nodelist,code,tabidxArr,type)
{
	if (type.equals("O"))	//这里的"O"不是数字“0” 是大写字母"O"表示一个	
		return parserTableOne(nodelist,code,tabidxArr);
	else if (type.equals("M"))
		return parserTableMore(nodelist,code,tabidxArr);
	else if (type.equals("OM"))
		return parserTableOneMore(nodelist,code,tabidxArr);
	else if (type.equals("T"))
		return parserTableTitle(nodelist,code,tabidxArr);
} 

//================================================================// 
// 函数：parserTableOne(nodelist,code,tabidxArr)
// 说明：处理订单的明细标题与明细数据属于一个TABLE的结构
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：09/07/10 09:33:01
// 修改日志：
//================================================================// 
function parserTableOne(nodelist,code,tabidxArr)
{
	var node = null;	//<table>
	var rows = null;	//<tr>
	var cols = null;	//<td>
	var col_first = null;
	var Val = "";
	var xml = "<?xml version='1.0' encoding='"+code+"'?>\n<ROWSET>\n"; 	
	//如果订单的标题与明细是一个TABLE的结构
	if (tabidxArr.length() == 1 ) 
	{	
		node = nodelist.elementAt(tabidxArr[0]);
		//得到所有的<tr>
		rows = node.getRows();
		
		//第一行标题作为xml的标签
		var FirstRowList = rows[0].getColumns();
		//明细数据作为xml的值	
		for (var r = 1;r < rows.length();r++)
		{
			var notes = "";
			xml += "<ROW>\n";
			cols = rows[r].getColumns();
			for (var c = 0;c < FirstRowList.length();c++)
			{
				if(notes != "")
					notes += ",";	
				var TitleVal = ReplaceStrToNull("_"+FirstRowList[c].toPlainTextString().trim(),new Array("(",")","/"," ","<br>","&nbsp;","+"));
				if(notes.indexOf(TitleVal) > -1)
					TitleVal = TitleVal+"_"+TitleVal; 
				if( c >= cols.length()) 
					Val = "";	
				else			
					Val = ReplaceStrToNull(cols[c].toPlainTextString().trim(),new Array("&nbsp;","/"," ","+"));
				xml += "<"+TitleVal+">"+Val+"</"+TitleVal+">\n";
				notes += TitleVal;
			}
			
			xml += "</ROW>\n";
		}
	}	
	xml += "</ROWSET>\n";
//	throw new Exception(xml);
//	throw new Exception((new pubpack.EAXmlDS(xml)).GetXml());
	return new pubpack.EAXmlDS(xml); 	
}
//================================================================// 
// 函数：parserTableMore(nodelist,code,tabidxArr)
// 说明：标题与每一行明细都是一个单独的TABLE
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：09/07/10 09:55:16
// 修改日志：
//================================================================// 
function parserTableMore(nodelist,code,tabidxArr)
{
	var TitleNode = nodelist.elementAt(tabidxArr[0]);
	var TitleRows = TitleNode.getRows();
	var TitleCols = TitleRows[0].getColumns();
	var xml = "<?xml version='1.0' encoding='"+code+"'?>\n<ROWSET>\n"; 	
	for (var i = 1;i<tabidxArr.length();i++)
	{		
		//明细的<table>			
		var ListNode = nodelist.elementAt(tabidxArr[i]);
		var ListRows = ListNode.getRows();
		for (var r = 0;r<ListRows.length();r++)
		{
			var ListCols = ListRows[r].getColumns();			
			if (ListCols.length()>1)
			{
				xml += "<ROW>\n";
				for (var c = 0;c < ListCols.length();c++)
				{
					var TitleVal = "_"+TitleCols[c].toPlainTextString().trim();
					var Val = EAfunc.Replace(ListCols[c].toPlainTextString().trim(),"&deg;","°");
					xml += "<"+TitleVal+">"+Val+"</"+TitleVal+">\n";				
				}	
				xml += "</ROW>\n";			
			}
		}
	}	
	xml += "</ROWSET>\n";
	return new pubpack.EAXmlDS(xml); 	
}

//================================================================// 
// 函数：parserTableOneMore(nodelist,code,tabidxArr)
// 说明：标题是一个TABLE,明细是一个TABLE
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：09/07/10 10:13:41
// 修改日志：
//================================================================// 
function parserTableOneMore(nodelist,code,tabidxArr)
{
	var cols = null;	//<td>
	var xml = "<?xml version='1.0' encoding='"+code+"'?>\n<ROWSET>\n";
	var TitleNode = nodelist.elementAt(tabidxArr[0]);
	var TitleRows = TitleNode.getRows();
	var TitleCols = TitleRows[0].getColumns();
	var ListRows  = nodelist.elementAt(tabidxArr[1]);
	for (var r = 1;r < ListRows.length();r++)
	{
		xml += "<ROW>\n";
		cols = ListRows[r].getColumns();
		for (var c = 0;c < cols.length();c++)
		{
			var TitleVal = "_"+TitleCols[c].toPlainTextString().trim(); 			
			var Val = cols[c].toPlainTextString().trim();
			xml += "<"+TitleVal+">"+Val+"</"+TitleVal+">";
		}
		xml += "</ROW>";
	}		
	xml += "</ROWSET>\n";
	return new pubpack.EAXmlDS(xml);	
}

//================================================================// 
// 函数：parserTableTitle(nodelist,code,tabidxArr)
// 说明：抬头的部分因为不是规则的不能解析成XML所以用Array来保存。
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：09/07/10 13:41:06
// 修改日志：
//================================================================// 
function parserTableTitle(nodelist,code,tabidxArr)
{
	var str = "";
	var ltab = nodelist.elementAt(tabidxArr[0]);
//	throw new Exception(ltab.toHtml());
	var rows = ltab.getRows();
	for (var r = 0;r<rows.length();r++)
	{
		var cols = rows[r].getColumns();
		for (var c = 0;c<cols.length();c++)
		{
			str += ReplaceStrToNull(cols[c].toPlainTextString().trim(),new Array("&nbsp;"," "))+",";			
		}
	}
	return str.split(",");
}
//================================================================// 
// 函数：ReplaceStrToNull(str)
// 说明：过滤掉ＸＭＬ不符合的标签  
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：09/07/10 10:21:10
// 修改日志：
//================================================================// 
function ReplaceStrToNull(str,strArr)
{
//	var strArr = new Array("(",")","/");
	for (var i = 0;i<strArr.length();i++) 
	{	
		while(true)
		{
			if (str.indexOf(strArr[i])>-1)			
				str = EAfunc.Replace(str,strArr[i],"");	
			else
			     break;
		}
	}
	return str;
}



//================================================================// 
// 函数：parserDsToString
// 说明：把DS数据转换成字符串,splitext(分割串),filterCol（过滤列）,filterStr（过滤的内容）
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：09/10/10 15:13:34
// 修改日志：
//================================================================// 
function parserDsToString(ds,splitext,filterCol,filterStr)
{
	var orderCols = new Array("SRFLG","USERID","DEPTID","KAID","BILID","ECORPNAM","ECORPID","ITMCLASS",
				  "ORDID","DAT","ARRDAT","TEL","FAX","SEQID","EITMID","CODE","SPEC","EITMNAM",
				  "UNTNUM","QTYFLG","QTY","ZPQTY","EPRICE","CORPADDR","NOTE","ORDCONTENT");
	if (splitext == "") splitext = "~~~";
	var str = "";
	for (var row = 0;row < ds.getRowCount();row++)
	{
		if (ds.getStringDef(row,filterCol,"None") != filterStr)
		{
			for (var i = 0;i<orderCols.length();i++)
			{
				str += ds.getStringDef(row,orderCols[i],"None")+splitext;
			}
			str += "╃";
		}	
	}
	return str;
}
function FormatDataString(datestr)
{
        var sdf = new text.SimpleDateFormat("dd/MM/yyyy");
        var dat = sdf.parse(datestr);
        return dat;
}

//================================================================// 
// 函数：SetLinks(url,encoding,filterStr)
// 说明：从页面取出所有符合filterStr字符串的链接,字符编码：encoding,links:返回所有链接的ArrayList
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：09/28/10 10:12:11
// 修改日志：
//================================================================// 
function SetLinks(httcall,url,encoding,filterStr,links)
{
	var res = httpcall.Get(url,encoding);
	//解析页面源码为page对象
	var page = parserHtml(res,encoding);
	//得到当前页所有的A标签
	var atag = filterHtml(page,"a");
	for (var i = 0;i<atag.size();i++)
	{
		var attr = atag.elementAt(i).getAttribute("href");
		if (attr.indexOf(filterStr) > -1)
			links.add(attr);
	} 
	return links;	
}
//================================================================// 
// 函数：SetLinksByPost(url,encoding,filterStr)
// 说明：从页面取出所有符合filterStr字符串的链接,字符编码：encoding,links:返回所有链接的ArrayList
// 参数：
// 返回：
// 样例：
// 作者：
// 创建日期：09/28/10 10:12:11
// 修改日志：
//================================================================// 
function SetLinksByPost(httcall,url,params,encoding,filterStr,links)
{
	var res = httpcall.Post(url,params,encoding);
	//解析页面源码为page对象
	var page = parserHtml(res,encoding);
	//得到当前页所有的A标签
	var atag = filterHtml(page,"a");
	for (var i = 0;i<atag.size();i++)
	{
		var attr = atag.elementAt(i).getAttribute("href");
		if (attr.indexOf(filterStr) > -1)
			links.add(attr);
	} 
	return links;	
}

//================================================================// 
// 函数：doRequest(httpcall,ka) 
// 说明：通过配置参数直接从登录开始进入到订单的列表界面
// 参数：httpcall(Object),ka(String) 
// 返回：
// 样例：
// 作者：
// 创建日期：10/13/10 13:14:48
// 修改日志：
//================================================================// 
function doRequest(httpcall,ka,userid,passwd,vcode)
{
	var ret = "";
	var db = new pubpack.EADatabase();
	var ds = db.QuerySQL("select * from wg_request where ka="+ka+" order by seqid");
	for (var r = 0;r< ds.getRowCount();r++)
	{
		var url = ds.getStringAt(r,"URI");
		var params = ds.getStringDef(r,"PARAMS","");
		params = EAfunc.Replace(params,"动态用户名",userid);
		params = EAfunc.Replace(params,"动态密码",passwd);
		params = EAfunc.Replace(params,"动态验证码",vcode);
		var encode = ds.getStringAt(r,"CODE");
		var method = ds.getStringAt(r,"METHOD");
		if (method.equals("POST")) ret = httpcall.Post(url,params,encode);
		if (method.equals("GET"))  ret = httpcall.Get(url,encode);			
	}
	return ret;
		
}

//================================================================// 
// 函数：parserHtmlforUrl(url,str)
// 说明：可以直接对url进行解析成nodelist
// 参数：
// 返回：
// 样例：
// 作者：XHJ
// 创建日期：05/25/11 16:17:28
// 修改日志：
//================================================================// 
function parserHtmlforUrl(url,str)
{
	var ps = new htmlparser.Parser(url);
	var filter = new tagFilter.TagNameFilter(str);
	return ps.extractAllNodesThatMatch(filter);
}

/*
	订单列表页面的形态分析
	1.有日期查询参数，不管在不在<TABlE>中可以在PAGE页面代码通过<a href>来识别
	2.没有查询参数，在一个TABLE中有日期的标识，需要解析订单列表的TABLE来获得所需要日期的<a href>链接	
	3.新订单页面，只要抓完后就会消失的页面，可以不管日期，直接取得所有订单的<a href>
*/
}