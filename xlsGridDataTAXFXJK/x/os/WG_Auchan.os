function x_WG_Auchan(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var EAfunc = new pubpack.EAFunc();
var HtmlParser = new x_WG_HtmlParser();
var httpcall = new webget.HttpCall();
var mutil = new JavaPackage("java.util");
var text = new JavaPackage("java.text");
var m_bildtl = new pubpack.EADS();	
var m_dtlrow = -1;
var host_url = "http://logistics.auchan.com.cn:8000/logi/";

function start()
{
	return  getOrderStr("JQPX","2013-01-24","0004","su11978","11978","1","utf-8");
}
function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code)
{ 

	var ret = "";
  	var message = "";
  	var param = "";
  	var db = null;
	try{
		db = new pubpack.EADatabase();
//		var enddat = db.GetSQL("select to_char(to_date('"+dat+"','yyyy-mm-dd')+7,'yyyy-mm-dd') from dual");
		var enddat = "2013-02-11";
		ret = httpcall.Get(host_url,code);
		
		param = "userName="+userid+"&userPwd="+passwd+"&method=login";
		ret = httpcall.Post(host_url+"login.do",param,code);
		ret = httpcall.Get(host_url+"sup.do?method=indexSearch&supNo="+userid.substring(2,userid.length()),code);
		
		param = "appStatus=&endDate="+enddat+"&objNo=&rcvNo=&rcvType=&sectionNo=&startDate="+dat+"&status=&stype=1&supNo="+userid.substring(2,userid.length());
		ret = httpcall.Post(host_url+"sup.do?method=indexSearch1",param,code);	

		//解析成ds格式
		SoOrdDs("NR",ret,userid,dat,enddat,code,kaid,deptid);
		
		/**  将js解析成如下的字符串格式
		 *   SRFLG~~~USERID~~~DEPTID~~~KAID~~~BILID~~~ECORPNAM~~~ECORPID~~~ITMCLASS~~~ORDID~~~DAT~~~ARRDAT~~~TEL~~~FAX~~~SEQID~~~EITMID~~~CODE~~~SPEC~~~EITMNAM~~~QTYFLG~~~UNTNUM~~~QTY~~~ZPQTY~~~EPRICE~~~CORPADDR~~~NOTE~~~NULL
		 */
		return HtmlParser.parserDsToString(m_bildtl,"","","");
	}
	catch(e)
	{ 
		throw new Exception(e);  
	}
	finally
	{
		if(db != null)
			db.Close();
	}
}

var PageSize = 15;//目前一页显示的数据是15条
var RowTotal = 0;//获取订单的所有数据记录条数
var PageCount = 0;//获取总共显示多少页
	
//获取销售订单具体的明细数据
function SoOrdDs(typ,ret,userid,date,enddat,code,kaid,deptid)
{
	var nodelist = HtmlParser.parserHtml(ret,code); 
	var tablist = HtmlParser.filterHtml(nodelist,"table");
	var node = tablist.elementAt(1);
	//得到所有的<tr>
	var rows = node.getRows();
	var rows0 = rows[0].toPlainTextString().trim();
	RowTotal = 1.0 	* rows0.substring(rows0.indexOf("找到")+2,rows0.indexOf("条记录")-1);
	PageCount = (PageSize+RowTotal-1)/PageSize;
	
	for(var r = 1; r <= PageCount ;r ++)
	{
		for(var row = 2;row < rows.length() - 1;row ++)
		{
			var cols = rows[row].getColumns();
			if(cols.length() >= 3)
			{
				var ordid = cols[0].toPlainTextString().trim();//订单编号
				var corpid = cols[1].toPlainTextString().trim(); //门店
				var corpnam = "";
				if(corpid.indexOf("(") > -1&&corpid.indexOf(")") > -1)
				{
					corpnam = corpid.substring(corpid.indexOf(")")+1,corpid.length());
					corpid = corpid.substring(corpid.indexOf("(")+1,corpid.indexOf(")"));
				}
				var deptid = cols[2].toPlainTextString().trim(); //部门
				if(deptid.indexOf("(") > -1&&deptid.indexOf(")") > -1)
					deptid = deptid.substring(deptid.indexOf("(")+1,deptid.indexOf(")"));
				
				ret = httpcall.Get(host_url+"down.do?method=downLoad&orderNo="+ordid+"&storeNo="+corpid+"&supNo="+userid.substring(2,userid.length()),code);
				
				nodelist = HtmlParser.parserHtml(ret,code); 
				tablist = HtmlParser.filterHtml(nodelist,"table");
				var ds = HtmlParser.parserTable(tablist,code,new Array("1"),"O");
				/**
				 *	<?xml version = "1.0" encoding="GBK"?>
				 *	<ROWSET>
				 *		<ROW num="0" >
				 *			<_条目号>6903293500216</_条目号>
				 *			<_货号>60690</_货号>
				 *			<_货品描述>侬好14.5度黄酒500ml</_货品描述>
				 *			<_箱含量>12</_箱含量>
				 *			<_订货数>24</_订货数>
				 *			<_收货数>0</_收货数>
				 *			<_未税进价>7.094</_未税进价>
				 *			<_赠品数>0.0</_赠品数>
				 *			<_收赠品数>0.0</_收赠品数>
				 *		</ROW>
				 *	</ROWSET>
				 */
				 if(ds.getRowCount() > 0)
				 {
				 	for(var r = 0;r < ds.getRowCount();r ++)
				 	{
				 		m_dtlrow = m_bildtl.AddNullRow(m_bildtl.getRowCount()-1);
						m_bildtl.setValueAt(m_dtlrow,"SRFLG",typ);
						m_bildtl.setValueAt(m_dtlrow,"USERID",userid);
						m_bildtl.setValueAt(m_dtlrow,"DEPTID",deptid);
						m_bildtl.setValueAt(m_dtlrow,"KAID",kaid);
						m_bildtl.setValueAt(m_dtlrow,"BILID",ordid);//订单号
						m_bildtl.setValueAt(m_dtlrow,"ECORPNAM",corpnam);//对方客户名称
						m_bildtl.setValueAt(m_dtlrow,"ECORPID",corpid);//对方客户编号
						m_bildtl.setValueAt(m_dtlrow,"ITMCLASS","");
						m_bildtl.setValueAt(m_dtlrow,"ORDID",ordid);
						m_bildtl.setValueAt(m_dtlrow,"DAT",cols[3].toPlainTextString().trim());//订单日期
						m_bildtl.setValueAt(m_dtlrow,"ARRDAT",cols[4].toPlainTextString().trim());//到货日期
						m_bildtl.setValueAt(m_dtlrow,"TEL","");
						m_bildtl.setValueAt(m_dtlrow,"FAX","");
						m_bildtl.setValueAt(m_dtlrow,"SEQID",r+1);//序列号
						m_bildtl.setValueAt(m_dtlrow,"EITMID",ds.getStringAt(r,"_货号"));
						m_bildtl.setValueAt(m_dtlrow,"CODE",ds.getStringAt(r,"_条目号"));
						m_bildtl.setValueAt(m_dtlrow,"SPEC","");
						m_bildtl.setValueAt(m_dtlrow,"EITMNAM",ds.getStringAt(r,"_货品描述"));
						m_bildtl.setValueAt(m_dtlrow,"UNTNUM",ds.getStringAt(r,"_箱含量"));					
						m_bildtl.setValueAt(m_dtlrow,"QTYFLG","");
						m_bildtl.setValueAt(m_dtlrow,"QTY",ds.getStringAt(r,"_订货数"));
						m_bildtl.setValueAt(m_dtlrow,"ZPQTY",ds.getStringAt(r,"_赠品数"));
						m_bildtl.setValueAt(m_dtlrow,"EPRICE",ds.getStringAt(r,"_未税进价"));
						m_bildtl.setValueAt(m_dtlrow,"CORPADDR","");//送货地址
						m_bildtl.setValueAt(m_dtlrow,"NOTE","");	
						m_bildtl.setValueAt(m_dtlrow,"ORDCONTENT","");
				 	}
				 }
			}
		}
		if(r < PageCount)
		{
			param = "appStatus=&ec_crd="+PageSize+"&ec_i=ec&ec_p="+(r+1)+"&ec_rd="+PageSize+"&ec_rd="+PageSize+"&endDate="+enddat+"&method=indexSearch1&objNo=&rcvNo&rcvType
					&sectionNo&startDate="+date+"&status&stype=1&supNo="+userid.substring(2,userid.length());
			ret = httpcall.Post(host_url+"sup.do?method=indexSearch1",param,code);	
			node = tablist.elementAt(1);
			//得到所有的<tr>
			rows = node.getRows();
		}
	}	
	return m_bildtl.GetXml();
}




}