function x_WG_HK(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var pub = new JavaPackage("com.xlsgrid.net.pub");

var hostip = "http://www.ngscvs.com/";
var rblLoginType = 0;	//0、供应商，1、总部用户
var __VIEWSTATE = "dDw5MDk0OTExMTY7dDw7bDxpPDE+Oz47bDx0PDtsPGk8OT47PjtsPHQ8cDw7cDxsPG9uY2xpY2s7PjtsPGphdmFzY3JpcHQ6cmV0dXJuIGRvTG9naW5DaGVjaygpXDs7Pj4+Ozs+Oz4+Oz4+Oz5nvuE5ruGwqsMUQ/GrUd96kFerIQ==";

var txtProviderName = "上海捷强烟草糖酒集团配销中心";	//供应商
var ddlGSFLG = "";	//归属：null、全部，2、好德，4、可的，6、好德可的
var ddlCZ = 0;		//传种：0、全部，311、直送，351、物流进货，353、物流无订单进货
var ddlState = 2;	//状态：2、全部，1、已下载，0、未下载





var selorderstate = 1;	//订单状态：1、发布，2、未查阅，3、已查阅，4、已反馈

var m_bilds = new pub.EADS();
var m_bilid = "";	//订单编号
var m_bilguid = "";	//内部编号
var m_bEntryHdr = false;
var m_lastcolnam = "";
var m_colnamlist = new Array("采购订单编号","供应商编码","供应商名称","订货日期","送货日期");				//表单可抓取<TD>info
var t_bilhdr = new pub.EADS();
var t_hdrrow = -1;
var m_colidlist = new Array("BILID","CORPNAM","CORPID","DEPT","订单号","DAT","期望到货日","电话号码","传真号码");	//标准HDRDS
var m_bilhdr = new pub.EADS();
var m_hdrrow = -1;
var m_bEntryDtl = false;
var m_bildtlstartflg = "金额(";
var m_bildtlcolseq = 0;
var m_bildtl = new pub.EADS();
var m_dtlrow = -1;

function getOrderStr()
{
	var httpcall = "";
	var ret = "";
	try {
		httpcall = new webget.HttpCall();
		
		ret =  httpcall.Post(hostip+"login.aspx","btnLogin= 登 录 &__VIEWSTATE="+__VIEWSTATE
			+"&txtUserName="+userid+"&txtPassword="+passwd+"&rblLoginType="+rblLoginType,"GBK");				//登陆
		
		var billistparam = "txtProviderName="+txtProviderName+"&ddlCZ="+ddlCZ+"&ddlState="+ddlState
			+"&txtFillFormStartDate="+dat+"&txtFillFormEndDate="+dat
			+"";
		
		ret = httpcall.Post(hostip+"WebNet_Orders.aspx?PageId=1",billistparam);return ret;
		var node = httpcall.PostAndParse(hostip+"Supplier_Index.aspx",billistparam,"GBK");					//清单
		GetBillist(node);
		
		for (var i = 0; i < m_bilds.getRowCount(); i ++) {
			m_bilguid = m_bilds.getStringAt(i,"BILGUID");
			var billparam = "chkSelection="+m_bilguid+"&id="+m_bilguid;
			
//			ret = httpcall.Post(hostip+"purchase/BLPOrderModify.jsp",billparam);
			node = httpcall.PostAndParse(hostip+"purchase/BLPOrderModify.jsp",billparam,"GBK");				//表单
			m_bEntryHdr = false;
			m_bEntryDtl = false;
			m_lastcolnam= "";
			m_bildtlcolseq= 0;
			GetBildetail(node);
			if (i == 5) break;
		}
//		throw new Exception(m_bilhdr.GetXml()+"\n"+m_bildtl.GetXml());
		var func = new x_WG_Currefour();
		return func.writeStr(userid,deptid,kaid,m_bilhdr,m_bildtl);
	} catch ( e ) {
		throw new Exception( e );
	}
}

function GetBillist(node)
{
	if (node.getNodeName().equals("INPUT")) {
		var attrs  = node.getAttributes();
		var namnode = attrs.getNamedItem("name");
		if ( namnode != null ) {
			var namvalue = namnode.getNodeValue();
			if ( namvalue != null && namvalue.indexOf("chkSelection") >= 0 ) {
				var valnode = attrs.getNamedItem("value");
				if ( valnode != null ) {
					var valvalue = valnode.getNodeValue();
					var row = m_bilds.AddRow(m_bilds.getRowCount()-1);
					m_bilds.setValueAt(row,"BILGUID",valvalue);
				}
			}
		}
	}
	var children = node.getChildNodes();
	if ( children != null ) {
		for ( var i = 0; i < children.getLength(); i ++ ) {
			GetBillist(children.item(i));
		}
	}
}

function GetBildetail(node)
{
	if (node.getNodeName().equals("TD")) {
		if (node.getFirstChild() != null) {
			var eafunc = new pub.EAFunc();
			var nodevalue = eafunc.NVL(node.getFirstChild().getNodeValue(),"");
			
			if (nodevalue.length() >= m_colnamlist[0].length() && nodevalue.substring(0,m_colnamlist[0].length()).equals(m_colnamlist[0])) {
				t_hdrrow = t_bilhdr.AddRow(t_bilhdr.getRowCount()-1);
				t_bilhdr.setValueAt(t_hdrrow,m_colidlist[0],m_bilguid);
				m_bEntryHdr = true;	//表头开始
			}
			else if (nodevalue.length() >= m_bildtlstartflg.length()
				&& nodevalue.substring(0,m_bildtlstartflg.length()).equals(m_bildtlstartflg))
			{
				m_bEntryDtl = true;	//表体开始
			}
			else if ( m_bEntryHdr ) {					//开始抓取HdrDS
				for ( var i = 0; i < m_colnamlist.length(); i ++ ) {	//"采购订单编号","供应商编码","供应商名称","订货日期","送货日期"
					if (m_lastcolnam.length() >= m_colnamlist[i].length()
						&& m_lastcolnam.substring(0,m_colnamlist[i].length()).equals(m_colnamlist[i]))
					{
						if (i == 0) {
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[4],nodevalue);
							m_bilid = nodevalue;
						}
						else if (i == 1)
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[2],nodevalue);
						else if (i == 2)
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[1],nodevalue);
						else if (i == 3)
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[5],nodevalue);
						else if (i == 4) {
							t_bilhdr.setValueAt(t_hdrrow,m_colidlist[6],nodevalue);
							m_bEntryHdr = false;
						}
						break;
					}
				}
			}
			else if ( ! m_bEntryHdr && t_bilhdr.getRowCount() > 0 ) {	//抓取表头结束(t_bilhdr)，构造标准DS(m_bilhdr)
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
			else if ( m_bEntryDtl ) {
				m_bildtlcolseq ++;
				if (m_bildtlcolseq == 1) {
					m_dtlrow = m_bildtl.AddRow(m_bildtl.getRowCount()-1);
					
					m_bildtl.setValueAt(m_dtlrow,"订单号",m_bilid);
					m_bildtl.setValueAt(m_dtlrow,"BILID", m_bilguid);
					m_bildtl.setValueAt(m_dtlrow,"SEQID", nodevalue);
				}
				else if (m_bildtlcolseq == 2) {
					m_bildtl.setValueAt(m_dtlrow,"ITMID", nodevalue);
				}
				else if (m_bildtlcolseq == 3) {
					var codenode = node.getNextSibling().getNextSibling();
					var specnode = codenode.getNextSibling().getNextSibling();
					
					var code = codenode.getFirstChild().getNodeValue();
					var spec = specnode.getFirstChild().getNodeValue();
					
					m_bildtl.setValueAt(m_dtlrow,"条码", code);
					m_bildtl.setValueAt(m_dtlrow,"SPEC", spec);
					m_bildtl.setValueAt(m_dtlrow,"ITMNAM", nodevalue);
				}
				else if (m_bildtlcolseq == 8) {
					var untnum = node.getNextSibling().getNextSibling()
						.getNextSibling().getNextSibling().getFirstChild().getNodeValue();
					m_bildtl.setValueAt(m_dtlrow,"UNTNUM",untnum);
					m_bildtl.setValueAt(m_dtlrow,"QTY",nodevalue);
					m_bildtl.setValueAt(m_dtlrow,"赠品数量", "");
				}
				else if (m_bildtlcolseq == 11) {
					m_bildtl.setValueAt(m_dtlrow,"不含税价",nodevalue);
				}
			}
			m_lastcolnam = nodevalue;
		}
	}
	var children = node.getChildNodes();
	if ( children != null ) {
		for ( var i = 0; i < children.getLength(); i ++ ) {
			GetBildetail(children.item(i));
		}
	}
}

function GetHdrDS()
{
	return m_bilhdr;
}

function GetDtlDS()
{
	return m_bildtl;
}

}