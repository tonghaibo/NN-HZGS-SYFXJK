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
// ������urlCodeTrnas(urlstr,str)
// ˵�����������ַ����������URL�����������ͣ��������ļ�����D://AA/����.pdf��
// ������url(URL�ַ���),str(url����Ҫ�����Ĳ���)
// ���أ�String ������URL�����ַ���
// ������
// ���ߣ�
// �������ڣ�08/04/10 13:52:58
// �޸���־��
//================================================================// 
function urlCodeTrnas(urlstr,str,code){

	var nstr = str.substring(0,str.indexOf("."));
	var tmp = net.URLEncoder.encode(nstr,code);
	var urlstr = urlstr.substring(0,urlstr.indexOf(nstr))+tmp+urlstr.substring(urlstr.indexOf("."),urlstr.length());
	return urlstr ;
}

//================================================================// 
// ������parserHtml(htmlstr)
// ˵��������HTML�ַ�������NodeList����
// ������String htmlstr(HTML�ַ���)
// ���أ�NodeList(NodeList����)
// ������
// ���ߣ�
// �������ڣ�08/04/10 14:23:48
// �޸���־��
//================================================================// 
function parserHtml(htmlstr,code){
	
	//�÷��ص�HTML�ĵ��ַ�����ָ���������봴����������
	var ps = new htmlparser.Parser();
	var parser = ps.createParser(htmlstr,code); 
	//����HtmlPage����
	var htmlpage = new visitors.HtmlPage(parser);
	//�������
	parser.visitAllNodesWith(htmlpage);
	//�õ����еĽڵ�
	var nodelist = htmlpage.getBody();	
	return nodelist;
}

//================================================================// 
// ������filterHtml(nodelist,str)
// ˵������NodeList������й��ˣ����磺ֻ����<a>��ǩ��
// ������nodelist,str(�����ַ���)
// ���أ�һ��ֻ����str��ǩ��nodelist
// ������
// ���ߣ�
// �������ڣ�08/04/10 14:27:26
// �޸���־��
//================================================================// 
function filterHtml(nodelist,str){
	
	var filter = new tagFilter.TagNameFilter(str);
	return nodelist.extractAllNodesThatMatch(filter,true);
}

//================================================================// 
// ������downloadFile(url,filepath)
// ˵���������ļ���ָ����·��
// ������url:�����ļ���URL��filepath:���ص�Ŀ����ļ�·��
// ���أ�
// ������
// ���ߣ�
// �������ڣ�08/04/10 14:34:08
// �޸���־��
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
// ������parserTable(nodelist,code,elementIDX,type)
// ˵��������HTML�е�TABLE��ǩ,<tr>--Row,<td>--Colӳ������ݿ������нṹ
// ������һ��TABLE��nodelist�ṹ,�����ж��TABLE��ǩelementIDX(Ҫ����ĵڼ���TABLE),code(������ַ�����),
//	 tabidxArr(Ԫ��IDX������),typ(o,m,om):Oһ��TABLE��M���table,OM ������һ������ϸ�Ƕ��
//	 ��Щ�����ṹ�Ǳ���һ��TABLE��ÿ����ϸ����һ��TABLE����Щ������������ϸ��һ��TABLE������һ��TR����ϸ��һ��TR
// ���أ�DS�ṹ
// ������
// ���ߣ�
// �������ڣ�08/09/10 16:47:52
// �޸���־��
//================================================================// 
function parserTable(nodelist,code,tabidxArr,type)
{
	if (type.equals("O"))	//�����"O"�������֡�0�� �Ǵ�д��ĸ"O"��ʾһ��	
		return parserTableOne(nodelist,code,tabidxArr);
	else if (type.equals("M"))
		return parserTableMore(nodelist,code,tabidxArr);
	else if (type.equals("OM"))
		return parserTableOneMore(nodelist,code,tabidxArr);
	else if (type.equals("T"))
		return parserTableTitle(nodelist,code,tabidxArr);
} 

//================================================================// 
// ������parserTableOne(nodelist,code,tabidxArr)
// ˵��������������ϸ��������ϸ��������һ��TABLE�Ľṹ
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�09/07/10 09:33:01
// �޸���־��
//================================================================// 
function parserTableOne(nodelist,code,tabidxArr)
{
	var node = null;	//<table>
	var rows = null;	//<tr>
	var cols = null;	//<td>
	var col_first = null;
	var Val = "";
	var xml = "<?xml version='1.0' encoding='"+code+"'?>\n<ROWSET>\n"; 	
	//��������ı�������ϸ��һ��TABLE�Ľṹ
	if (tabidxArr.length() == 1 ) 
	{	
		node = nodelist.elementAt(tabidxArr[0]);
		//�õ����е�<tr>
		rows = node.getRows();
		
		//��һ�б�����Ϊxml�ı�ǩ
		var FirstRowList = rows[0].getColumns();
		//��ϸ������Ϊxml��ֵ	
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
// ������parserTableMore(nodelist,code,tabidxArr)
// ˵����������ÿһ����ϸ����һ��������TABLE
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�09/07/10 09:55:16
// �޸���־��
//================================================================// 
function parserTableMore(nodelist,code,tabidxArr)
{
	var TitleNode = nodelist.elementAt(tabidxArr[0]);
	var TitleRows = TitleNode.getRows();
	var TitleCols = TitleRows[0].getColumns();
	var xml = "<?xml version='1.0' encoding='"+code+"'?>\n<ROWSET>\n"; 	
	for (var i = 1;i<tabidxArr.length();i++)
	{		
		//��ϸ��<table>			
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
					var Val = EAfunc.Replace(ListCols[c].toPlainTextString().trim(),"&deg;","��");
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
// ������parserTableOneMore(nodelist,code,tabidxArr)
// ˵����������һ��TABLE,��ϸ��һ��TABLE
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�09/07/10 10:13:41
// �޸���־��
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
// ������parserTableTitle(nodelist,code,tabidxArr)
// ˵����̧ͷ�Ĳ�����Ϊ���ǹ���Ĳ��ܽ�����XML������Array�����档
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�09/07/10 13:41:06
// �޸���־��
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
// ������ReplaceStrToNull(str)
// ˵�������˵��أ̲ͣ����ϵı�ǩ  
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�09/07/10 10:21:10
// �޸���־��
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
// ������parserDsToString
// ˵������DS����ת�����ַ���,splitext(�ָ),filterCol�������У�,filterStr�����˵����ݣ�
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�09/10/10 15:13:34
// �޸���־��
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
			str += "��";
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
// ������SetLinks(url,encoding,filterStr)
// ˵������ҳ��ȡ�����з���filterStr�ַ���������,�ַ����룺encoding,links:�����������ӵ�ArrayList
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�09/28/10 10:12:11
// �޸���־��
//================================================================// 
function SetLinks(httcall,url,encoding,filterStr,links)
{
	var res = httpcall.Get(url,encoding);
	//����ҳ��Դ��Ϊpage����
	var page = parserHtml(res,encoding);
	//�õ���ǰҳ���е�A��ǩ
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
// ������SetLinksByPost(url,encoding,filterStr)
// ˵������ҳ��ȡ�����з���filterStr�ַ���������,�ַ����룺encoding,links:�����������ӵ�ArrayList
// ������
// ���أ�
// ������
// ���ߣ�
// �������ڣ�09/28/10 10:12:11
// �޸���־��
//================================================================// 
function SetLinksByPost(httcall,url,params,encoding,filterStr,links)
{
	var res = httpcall.Post(url,params,encoding);
	//����ҳ��Դ��Ϊpage����
	var page = parserHtml(res,encoding);
	//�õ���ǰҳ���е�A��ǩ
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
// ������doRequest(httpcall,ka) 
// ˵����ͨ�����ò���ֱ�Ӵӵ�¼��ʼ���뵽�������б����
// ������httpcall(Object),ka(String) 
// ���أ�
// ������
// ���ߣ�
// �������ڣ�10/13/10 13:14:48
// �޸���־��
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
		params = EAfunc.Replace(params,"��̬�û���",userid);
		params = EAfunc.Replace(params,"��̬����",passwd);
		params = EAfunc.Replace(params,"��̬��֤��",vcode);
		var encode = ds.getStringAt(r,"CODE");
		var method = ds.getStringAt(r,"METHOD");
		if (method.equals("POST")) ret = httpcall.Post(url,params,encode);
		if (method.equals("GET"))  ret = httpcall.Get(url,encode);			
	}
	return ret;
		
}

//================================================================// 
// ������parserHtmlforUrl(url,str)
// ˵��������ֱ�Ӷ�url���н�����nodelist
// ������
// ���أ�
// ������
// ���ߣ�XHJ
// �������ڣ�05/25/11 16:17:28
// �޸���־��
//================================================================// 
function parserHtmlforUrl(url,str)
{
	var ps = new htmlparser.Parser(url);
	var filter = new tagFilter.TagNameFilter(str);
	return ps.extractAllNodesThatMatch(filter);
}

/*
	�����б�ҳ�����̬����
	1.�����ڲ�ѯ�����������ڲ���<TABlE>�п�����PAGEҳ�����ͨ��<a href>��ʶ��
	2.û�в�ѯ��������һ��TABLE�������ڵı�ʶ����Ҫ���������б��TABLE���������Ҫ���ڵ�<a href>����	
	3.�¶���ҳ�棬ֻҪץ���ͻ���ʧ��ҳ�棬���Բ������ڣ�ֱ��ȡ�����ж�����<a href>
*/
}