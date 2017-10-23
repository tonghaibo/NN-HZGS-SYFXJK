function x_WG_EkChor(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var pub = new JavaPackage("com.xlsgrid.net.pub");
var httphtml = new x_httpcallpaser();
var Paser = new JavaPackage("org.htmlparser");
var HtmlParser = new x_WG_HtmlParser();

var hostip = "http://lotusdx.ek-chor-cn.com/LotusDX/";

var sessionId = "";
var pageSize = 1;
var pageNo = 1;

var m_bilds = new pub.EADS();
var m_bilid = "";	//订单编号
var m_owner = "";	//用户编号
var m_docId = "";	//内部编号
var m_bEntryHdr = false;
var m_lastcolnam = "";
var m_colnamlist = new Array("供应商","订货日期","订单编号","取消日期","传真","电话");		//取消日期就相当于订单中的送货日期			//易初莲花可抓取的<TD>info
var t_bilhdr = new pub.EADS();
var t_hdrrow = -1;
var m_colidlist = new Array("BILID","CORPNAM","CORPID","DEPT","订单号","DAT","期望到货日","电话号码","传真号码");	//家乐福格式的HdrDS
var m_bilhdr = new pub.EADS();
var m_hdrrow = -1;
var m_bEntryDtl = false;
var m_bildtlstartflg = "总计金额";
var m_bildtlcolseq = 0;
var m_bildtl = new pub.EADS();		//家乐福格式的DtlDS（可构造不同格式的DS，单独解析，这个调用了家乐福的解析函数，所以格式和家乐福相同）
var m_dtlrow = -1;
var m_dtllist = new Array("seqid","corpitmid","itmid","itmnam","potax","untnum","unit","qty","zpqty","sumqty","price","eprice","summny");	//家乐福格式的HdrDS

function start()
{
	return getOrderStr("JQPX","2012-09-05","0015","jq30002699","b0000000","dept","GB2312");
}

//curdat格式：DD-MM-YYYY
//返回格式：DD-MM-YYYY
function getFromDate(curdat,befdays) 
{
	var sql = "select to_char(to_date('"+curdat+"','DD-MM-YYYY')-"+befdays+",'DD-MM-YYYY') dat from dual";
	return pub.EADbTool.GetSQL(sql);
}

function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code)
{
	//pub.EAFunc.Log("易初莲花WG_EkChor start:"+acc+","+dat+","+kaid+","+userid+","+passwd+","+deptid+","+code);
	var httpcall = "";
	var ret = "";
	try {
		httpcall = new webget.HttpCall();
		ret = httpcall.Get(hostip+"login/Home.action",code);
//		throw new Exception(ret);
		ret = ret.substring(ret.indexOf("sessionId"));
		ret = ret.substring(ret.indexOf("value=\"")+"value=\"".length());
		ret = ret.substring(0,ret.indexOf("\">"));
		sessionId = ret;
		ret =  httpcall.Post(hostip+"login/Login.action","userId="+userid+"&password="+passwd+"&submit=登录 login&sessionId="+sessionId);	//登陆
		ret =  httpcall.Get(hostip+"document/DocumentList.action",code);									//收件箱
		ret = httpcall.Get(hostip+"document/DisplayPOList.action?currentFolder=IN&obsolete=",code);						//订单
		var sdat = dat.split("-");
		dat = sdat[2]+"-"+sdat[1]+"-"+sdat[0];
		var formDate = getFromDate(dat,7);
		var billistparam = "currentFolder=IN&direction=&docId=&docInfo=&docNum=&docStatus=&folder=&fromDate="+formDate+"&fromPage=PO&itemsPerPage=&keepAction="+
				   "&keepValue=&obsolete=&orderBy=createdDate&owner=&pageNo=1&sortType=desc&toDate="+dat+"&vendor=";
		ret = httpcall.Post(hostip+"document/DisplayPOList.action",billistparam,code);
		try {
			ret = ret.substring(ret.indexOf("项, 共")+"项, 共".length());
			ret = ret.substring(1,ret.indexOf("页")-1);
		}
		catch(e) {
			return "";
		}
		pageSize = 1*ret;
		for (pageNo = 1; pageNo <= pageSize; pageNo ++) {
			billistparam = "owner=&folder=&docId=&pageNo="+pageNo+"&itemsPerPage=&docInfo=&fromPage=PO&sortType=desc&orderBy=createdDate&keepValue=&keepAction=&direction=next&obsolete=&currentFolder=IN&docNum=&vendor=&docStatus=&fromDate="+dat+"&toDate="+dat;	
			var node = httpcall.PostAndParse(hostip+"document/DisplayPOList.action",billistparam,code);
			GetBillist(node,pageNo);
		}
		for (var i = 0; i < m_bilds.getRowCount(); i ++) {
			m_owner = m_bilds.getStringAt(i,"OWNER");
			m_docId = m_bilds.getStringAt(i,"DOCID");
			var pagenumber = m_bilds.getStringAt(i,"PAGENO");
			var params = "vendor=&docNum=&docId=&docStatus=&folder=&currentFolder=IN&sortType=desc&orderBy=createdDate&pageNo="+pagenumber+"&itemsPerPage=&fromDate="+dat+"&toDate="+dat+"&fromPage=PO&obsolete=";
			var billparam = "direction=next&docId="+m_docId+"&folder=&fromPage=PO&itemsPerPage=&keepAction=DisplayPOList.action&obsolete=&orderBy=createdDate&owner="+m_owner+"&pageNo="+pagenumber+"&sortType=desc";//&keepValue="+params;
			var node = httpcall.PostAndParse(hostip+"document/DisplayPODetail.action",billparam,code);
			var nodetext = httpcall.Post(hostip+"document/DisplayPODetail.action",billparam,code);			
			m_bEntryHdr = false;
			m_bEntryDtl = false;
			m_lastcolnam= "";
			m_bildtlcolseq = 0;
			GetBildetail(node,nodetext,code);
			while(true)
			{
				if(nodetext.indexOf("<!--") > -1)
					nodetext = nodetext.substring(0,nodetext.indexOf("<!--"))+nodetext.substring(nodetext.indexOf("-->")+3);
				else
					break;	
			}
//			return nodetext;
			GetBildtldetail(nodetext,code);
		}
		var func = new x_WG_Currefour();
		var retStr = func.writeStr(userid,deptid,kaid,m_bilhdr,m_bildtl);		//调用家乐福的解析函数
		//pub.EAFunc.Log("易初莲花WG_EkChor run finsh");

		return retStr;
	} catch ( e ) {
		//pub.EAFunc.Log("易初莲花WG_EkChor error:"+e.toString());
		throw new Exception( e );
	}
}

function GetBillist(node,pageNo )
{
	if (node.getNodeName().equals("A")) {
		var attrs  = node.getAttributes();
		var hrefnode = attrs.getNamedItem("href");

		if ( hrefnode != null ) {
			var hrefvalue = hrefnode.getNodeValue();
			if ( hrefvalue != null && hrefvalue.indexOf("viewDocument") >= 0 ) {
				var tmp = hrefvalue;
				tmp = tmp.substring(tmp.indexOf("'")+"'".length());
				var owner = tmp.substring(0,tmp.indexOf("'"));
				tmp = tmp.substring(tmp.indexOf("'")+"'".length());
				tmp = tmp.substring(tmp.indexOf("'")+"'".length());
				var docId = tmp.substring(0,tmp.indexOf("'"));
				var row = m_bilds.AddRow(m_bilds.getRowCount()-1);
				m_bilds.setValueAt(row,"OWNER",owner);
				m_bilds.setValueAt(row,"DOCID",docId);
				m_bilds.setValueAt(row,"PAGENO",pageNo);
			}
		}
	}
	var children = node.getChildNodes();
	if ( children != null ) {
		for ( var i = 0; i < children.getLength(); i ++ ) {
			GetBillist(children.item(i),pageNo );
		}
	}
}

function GetBildetail(node,nodetext,code)
{
	var nodelist = HtmlParser.parserHtml(nodetext,code);	 
	var tablist = HtmlParser.filterHtml(nodelist,"table");
	var list = tablist.elementAt(13);
	var rows = list.getRows();
	var corpid = "";
	if(rows.length() > 0)
	{
		var cols =  rows[4].getColumns();
		if(cols.length() > 0)
			corpid = cols[1].toPlainTextString().trim();
		else
			corpid = "上海配货中心";

	}
	if (node.getNodeName().equals("TD")) {
		if (node.getFirstChild() != null) {
			var eafunc = new pub.EAFunc();
			var firstnode = node.getFirstChild();
			var nodevalue = eafunc.NVL(firstnode.getNodeValue(),"");
			if (firstnode.getNodeName().equals("B") && firstnode.getFirstChild() != null) {
				nodevalue = eafunc.NVL(firstnode.getFirstChild().getNodeValue(),"");
				if (nodevalue.length() >= m_colnamlist[0].length() && nodevalue.substring(0,m_colnamlist[0].length()).equals(m_colnamlist[0])) {
					t_hdrrow = t_bilhdr.AddRow(t_bilhdr.getRowCount()-1);
					t_bilhdr.setValueAt(t_hdrrow,m_colidlist[0],m_docId);
					m_bEntryHdr = true;		//表头开始
				}
			}
			else if (firstnode.getNodeName().equals("DIV") && firstnode.getFirstChild() != null) {
				if (firstnode.getFirstChild().getNodeName().equals("STRONG") && firstnode.getFirstChild().getFirstChild() != null) {
					nodevalue = eafunc.NVL(firstnode.getFirstChild().getFirstChild().getNodeValue(),"");
					if (nodevalue.length() >= m_bildtlstartflg.length() && nodevalue.substring(0,m_bildtlstartflg.length()).equals(m_bildtlstartflg)) {
						m_bEntryDtl = true;	//表体开始
					}
				}
			}
			else if ( m_bEntryHdr ) {					//开始抓取表头
				for ( var i = 0; i < m_colnamlist.length(); i ++ ) {	//"供应商","订货日期","订单编号","取消日期","传真","电话"
					if (m_lastcolnam.length() >= m_colnamlist[i].length()
						&& m_lastcolnam.substring(0,m_colnamlist[i].length()).equals(m_colnamlist[i]))
					{
						if (i == 0) {
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[1],corpid );//nodevalue.substring(10));
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[2],corpid );//nodevalue.substring(0,8));
						}
						else if (i == 1)
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[5],nodevalue);
						else if (i == 2) {
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[4],nodevalue);
							m_bilid = nodevalue;
						}
						else if (i == 3)
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[6],nodevalue);
						else if (i == 4)
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[8],nodevalue);
						else if (i == m_colnamlist.length()-1) {
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[7],nodevalue);
							m_bEntryHdr = false;
						}
						break;
					}
				}
			}
			else if ( ! m_bEntryHdr && t_bilhdr.getRowCount() > 0 ) {	//抓取表头结束(t_bilhdr)，构造家乐福格式HdrDS(m_bilhdr)
				m_hdrrow = m_bilhdr.AddRow(m_bilhdr.getRowCount()-1);
				for (var i = 0; i < m_colidlist.length(); i ++) {
					for (var j = 0; j < t_bilhdr.getColumnCount(); j ++) {
						if (m_colidlist[i] == t_bilhdr.getColumnName(j)) {
							m_bilhdr.setValueAt(m_hdrrow,m_colidlist[i],t_bilhdr.getStringAt(t_hdrrow,j));
							break;
						}
						else if (j == t_bilhdr.getRowCount()-1)
							m_bilhdr.setValueAt(m_hdrrow,m_colidlist[i],"");
					}
				}
				t_bilhdr.clearDS();
			}
//			else if ( m_bEntryDtl ) {					//开始抓取DtlDS
//				m_bildtlcolseq ++;
//				if (m_bildtlcolseq == 1) {
//					m_dtlrow = m_bildtl.AddRow(m_bildtl.getRowCount()-1);
//					
//					m_bildtl.setValueAt(m_dtlrow,"订单号",m_bilid);
//					m_bildtl.setValueAt(m_dtlrow,"BILID", m_docId);
//					m_bildtl.setValueAt(m_dtlrow,"SEQID", nodevalue);
//				}
//				else if (m_bildtlcolseq == 2) {
//					m_bildtl.setValueAt(m_dtlrow,"ITMID", nodevalue);
//				}
//				else if (m_bildtlcolseq == 3) {
//					var codenode = node.getNextSibling().getNextSibling();
//					var specnode = codenode.getNextSibling().getNextSibling();
//					
//					var code = codenode.getFirstChild().getNodeValue();
//					var spec = specnode.getFirstChild().getNodeValue();
//					
//					m_bildtl.setValueAt(m_dtlrow,"条码", code);
//					m_bildtl.setValueAt(m_dtlrow,"SPEC", spec);
//					m_bildtl.setValueAt(m_dtlrow,"ITMNAM", nodevalue);
//				}
//				else if (m_bildtlcolseq == 6) {
//					var untnum = node.getNextSibling().getNextSibling().getNextSibling().getNextSibling()
//						.getNextSibling().getNextSibling().getNextSibling().getNextSibling().getFirstChild().getNodeValue();
//					
//					m_bildtl.setValueAt(m_dtlrow,"UNTNUM",untnum);	//包装系数
//					m_bildtl.setValueAt(m_dtlrow,"QTY",nodevalue);	//包装订量
//					m_bildtl.setValueAt(m_dtlrow,"赠品数量", "");
//				}
//				else if (m_bildtlcolseq == 11) {
//					m_bildtl.setValueAt(m_dtlrow,"不含税价",nodevalue);
//				}
//			}
			m_lastcolnam = nodevalue;
		}
	}
	var children = node.getChildNodes();
	if ( children != null ) {
		for ( var i = 0; i < children.getLength(); i ++ ) {
			GetBildetail(children.item(i),nodetext,code);
		}
	}
}
				  
function GetBildtldetail(node,code)
{
	var nodelist = HtmlParser.parserHtml(node,code);	 
	var tablist = HtmlParser.filterHtml(nodelist,"table");
	var list = tablist.elementAt(14);
//	throw new Exception( list);
	var rows = list.getRows();
	for(var r = 4;r < rows.length();r ++)
	{
		var cols =  rows[r].getColumns();
		if(cols.length() == 13&&rows[r].toPlainTextString().indexOf("DEPT") == -1)
		{	
//			if(m_bilid == "108437529"&&r > 4)
//				throw new Exception(rows[9]);
			m_dtlrow= m_bildtl.AddRow(m_bildtl.getRowCount()-1);
			m_bildtl.setValueAt(m_dtlrow,"订单号",m_bilid);
			m_bildtl.setValueAt(m_dtlrow,"BILID", m_docId);
			m_bildtl.setValueAt(m_dtlrow,"SEQID",HtmlParser.ReplaceStrToNull(cols[0].toPlainTextString().trim(),new Array("&nbsp;"," ",",")));	
			if((cols[2].toPlainTextString().trim()).indexOf("/") > -1)
				m_bildtl.setValueAt(m_dtlrow,"EITMID",HtmlParser.ReplaceStrToNull((cols[2].toPlainTextString().trim()).split("/")[0],new Array("&nbsp;"," ",",")));
			else
				m_bildtl.setValueAt(m_dtlrow,"EITMID",HtmlParser.ReplaceStrToNull(cols[2].toPlainTextString().trim(),new Array("&nbsp;"," ",",")));
			m_bildtl.setValueAt(m_dtlrow,"CODE","");
			m_bildtl.setValueAt(m_dtlrow,"SPEC",HtmlParser.ReplaceStrToNull(cols[6].toPlainTextString().trim(),new Array("&nbsp;"," ",",")));
			m_bildtl.setValueAt(m_dtlrow,"EITMNAM",HtmlParser.ReplaceStrToNull(cols[3].toPlainTextString().trim(),new Array("&nbsp;"," ",",")));
			m_bildtl.setValueAt(m_dtlrow,"UNTNUM",HtmlParser.ReplaceStrToNull(cols[5].toPlainTextString().trim(),new Array("&nbsp;"," ",",")));
			m_bildtl.setValueAt(m_dtlrow,"QTYFLG","");
			m_bildtl.setValueAt(m_dtlrow,"QTY",HtmlParser.ReplaceStrToNull(cols[8].toPlainTextString().trim(),new Array("&nbsp;"," ",",")));
//			throw new Exception(HtmlParser.ReplaceStrToNull(cols[9].toPlainTextString().trim(),new Array("&nbsp;"," ",",")));
			m_bildtl.setValueAt(m_dtlrow,"ZPQTY",HtmlParser.ReplaceStrToNull(cols[7].toPlainTextString().trim(),new Array("&nbsp;"," ",",")));
			m_bildtl.setValueAt(m_dtlrow,"EPRICE",HtmlParser.ReplaceStrToNull(cols[10].toPlainTextString().trim(),new Array("&nbsp;"," ",",")));																								
		}
	}
//	throw new Exception(m_bildtl.GetXml());
}

}