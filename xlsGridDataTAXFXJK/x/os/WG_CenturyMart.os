function x_WG_CenturyMart(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var EAfunc = new pubpack.EAFunc();
var HtmlParser = new x_WG_HtmlParser();
var httpcall = new webget.HttpCall();
var mutil = new JavaPackage("java.util");
var text = new JavaPackage("java.text");
var m_bildtl = new pubpack.EADS();	
var m_dtlrow = -1;

function start()
{
	return getOrderStr("JQPX","2013-11-28","0010","LH17102001","6969","1","utf-8","138516","2013-11-28");
}
function getOrderStr(acc,dat,kaid,userid,passwd,deptid,unicodes,rock_password,date)
{
	/**
	 *  登陆的时候，会使用host_url_new
	 */
	var host_url_new = "http://b2b.chinalh.com/";
	/**
	 *  获取左边的那颗树形结构（订货单/送货单/收货报告/进货红冲单/退货通知单/价格补偿协议单）的前缀是host_tree_url
	 *  http://edi.chinalh.com/lhscm/framework/mainform/navui/leftmenu.do?id=2b877ed7c1eb4d1c95fa86c827c0f99f
	 */
	var host_tree_url = "http://edi.chinalh.com";
	var ret = "";
  	var message = "";
  	var param = "";
  	if(unicodes == "")
  		unicodes = "UTF-8";
	var code = unicodes;
	
	try{
		ret = httpcall.Get(host_url_new+"login/",code);
		
		param = "username="+userid+"&password="+passwd+"&checkText=&checkCode=&token=&sms="+rock_password;
		ret = httpcall.Post(host_url_new+"login.do",param,code);
		httpcall.FollowRedirects="close";
		var n=0;
		while ( ret.length()==0 && httpcall.m_statusCode!=200 )
		{
			ret = httpcall.Get(httpcall.m_newURL, code);
			n++;
			if( n>10) break;
		}
		var loc = ret.indexOf( "href='" );
		var loc1 = ret.indexOf( "';</",loc+1 );
		if( loc<0 ||loc1<0)		throw new Exception ("格式不对"+ret );
		ret = httpcall.Get( ret.substring(loc+6,loc1), code);
		
		n=0;
		while ( ret.length()==0 && httpcall.m_statusCode!=200 )
		{
			ret = httpcall.Get(httpcall.m_newURL, code);
			n++;
			if( n>10) break;
		}
		var str = "document.getElementById(\"iframe\").src=\"";
		loc = ret.indexOf( str );
		if( loc<0 )		throw new Exception ("格式不对"+ret );
		ret = ret.substring(loc+str.length());
		loc1 = ret.indexOf( "?" );
		if( loc1<0)		throw new Exception ("格式不对"+ret );
		
		ret = httpcall.Get( ret.substring(0,loc1+1)+"height=480&width=1119", code);
		/**
		 *  获取左边的那颗树形结构（订货单/送货单/收货报告/进货红冲单/退货通知单/价格补偿协议单）
		 *  http://edi.chinalh.com/lhscm/framework/mainform/navui/leftmenu.do?id=2b877ed7c1eb4d1c95fa86c827c0f99f
		 */
		ret = httpcall.Get(host_tree_url+ret.substring(ret.indexOf("_t1=\"")+("_t1=\"").length(),ret.indexOf("\" _t2=\"\"")),code);
		var ret_bak = ret;
		/**
		 *  获取订货单的连接
		 *  http://edi.chinalh.com/lhscm/wfquery/Render.do?moduleCode=c1f83f8695cd4d3a845ea1aab2587a95&template=one&url=/cm/business/form/po/po.do
		 */
		ret = httpcall.Get(host_tree_url+ret.substring(ret.indexOf("href=\"javascript:loadPage(false,null,'")+("href=\"javascript:loadPage(false,null,'").length(),ret.indexOf("','订货单','FORM'")),code);
		param = "accid=&bgid=0002&datebegin="+date+"&dateend="+date+"&datetype=1&deptid=&findnew=&limit=100&orderby=bg_org_id&orgid=&pono=&status=-1";
		ret = httpcall.Post(host_tree_url+"/lhscm/cm/business/form/po/po.do?search=true",param,code);
		
		//解析成ds格式
		SoOrdDs("NR",ret,host_tree_url,userid,date,code,kaid,deptid);

		/**
		 *  获取退货货单的连接
		 *  http://edi.chinalh.com/lhscm/wfquery/Render.do?moduleCode=49f4d68f301f475892ac14ffd02f5bb0&template=one&jspPath=/cm/business/form/returns/returns.do
		 */
		 ret_bak = ret_bak.substring(ret_bak.indexOf("<span class=\"li_span\">进货红冲单</span>"));
		 ret = httpcall.Get(host_tree_url+ret_bak.substring(ret_bak.indexOf("href=\"javascript:loadPage(false,null,'")+("href=\"javascript:loadPage(false,null,'").length(),ret_bak.indexOf("','退货通知单','FORM'")),code);
		
		param = "accid=&bgid=0002&datebegin="+date+"&dateend="+date+"&datetype=2&deptid=&findnew=&limit=20&orderby=bg_org_id&orgid=&replyer=&returnno&returnorg=&status=-1";
		ret = httpcall.Post(host_tree_url+"/lhscm/cm/business/form/returns/returns.do?search=true",param,code);
		//解析成ds格式
		SrOrdDs("R",ret,host_tree_url,userid,date,code,kaid,deptid);
		
		/**  将js解析成如下的字符串格式
		 *   SRFLG~~~USERID~~~DEPTID~~~KAID~~~BILID~~~ECORPNAM~~~ECORPID~~~ITMCLASS~~~ORDID~~~DAT~~~ARRDAT~~~TEL~~~FAX~~~SEQID~~~EITMID~~~CODE~~~SPEC~~~EITMNAM~~~QTYFLG~~~UNTNUM~~~QTY~~~ZPQTY~~~EPRICE~~~CORPADDR~~~NOTE~~~NULL
		 */
		
		return HtmlParser.parserDsToString(m_bildtl,"","","");
	}
	catch(e)
	{ 
		throw new Exception(e);  
	}
}

var SoPageSize = 100;//目前一页显示的数据是100条(销售订单)
var SoRowTotal = 0;//获取订单的所有数据记录条数(销售订单)
var SoPagePerSize = 0;//获取总共显示多少页（销售订单）

//获取销售订单具体的明细数据
function SoOrdDs(typ,ret,host_url,userid,date,code,kaid,deptid)
{
	/**  以下是获取订单信息的列表格式
	 *      {"count":"2","rows":[
	 *	{"created_date":"2012-11-14 15:34:35","status":"未收货","rcvno":"","needfax":"否","pono":"5015201211140014","sum":"1","reply_delivery_date":"2012-11-17","faxtime":"","rcvid":"","bg_item_count":"1",
	 *	  "bg_net_amt":"462.8202","id":"","requestdate":"2012-11-17","amt":"541.4996","bgid":"0002(世纪联华)","billdate":"2012-11-14","deptid":"10(饮料)","orgid":"5015(上海成山路店)","lastreferdate":"2012-11-15 10:28:56","sstatus":"1","replydate":""},
	 *	{"created_date":"2012-11-14 15:04:42","status":"未收货","rcvno":"","needfax":"否","pono":"5901201211140023","sum":"1","reply_delivery_date":"2012-11-17","faxtime":"","rcvid":"","bg_item_count":"1",
	 *	 "bg_net_amt":"462.8202","id":"CE6F43157B3602B4E043C009010F02B4","requestdate":"2012-11-17","amt":"541.4996","bgid":"0002(世纪联华)","billdate":"2012-11-14","deptid":"10(饮料)","orgid":"5901(上海顾村店)","lastreferdate":"2012-11-15 10:28:35","sstatus":"1","replydate":""}]}
	 */
	//将以上的格式，用{进行分组，一个"{"代表本次订单的总记录数，其余的均代表每个订单的列表
	var subret = EAfunc.Replace(EAfunc.Replace(ret.substring(1,ret.length()-2),"\"",""),"{","#");
	var splitflg = "#";
	var strsplits = subret.split(splitflg );
	//获取订单的所有数据记录条数
	SoRowTotal = matchMap(strsplits[0].split(",")[0]).get("count");//count:2   
	if(SoRowTotal%SoPageSize == 0)
		SoPagePerSize = SoRowTotal/SoPageSize;
	else
		SoPagePerSize = SoRowTotal/SoPageSize+1;
	
	for(var row = 1;row <= SoPagePerSize ;row ++)
	{
		ret = EAfunc.Replace(EAfunc.Replace(ret.substring(1,ret.length()-2),"\"",""),"{","#");
		var strsplit = ret.split("#");
		for(var r = 1;r < strsplit.length();r ++)
		{
			var map = matchMap(strsplit[r].substring(0,strsplit[r].length()-2));
			/**
			 *	获取具体的商品信息
			 *      url = http://edi.chinalh.com/lhscm/cm/business/form/po/poreportview.do?headerid=CE10D50F5AAC026EE043C009010F026E 
			 */
			/**  具体订单的商品信息  ds格式
			 *	<?xml version = "1.0" encoding="GBK"?> 
			 * 	 <ROWSET> 	
			 *	  <ROW num="0" > 		
			 *	  	<_序号>1</_序号>  		<_条码>6901798138798</_条码> 	<_商品编号>362495</_商品编号> 	    	<_子码>001</_子码> 			<_商品名称>52度泸州老窖红瓷头曲白酒</_商品名称> 		
			 *		<_型号></_型号>   		<_规格>500ml</_规格> 		<_包装>6</_包装> 			<_箱数>1</_箱数> 			<_单位>箱</_单位> 		
			 *	  	<_零数>0</_零数>  		<_数量>6</_数量> 		<_单位__单位>盒</_单位__单位> 		<_赠品>0</_赠品> 			<_税率>17%</_税率> 		
			 *	  	<_未税单价>77.1367</_未税单价> 	<_含税单价>90.2499</_含税单价> 	<_未税金额>462.8202</_未税金额> 	<_含税金额>541.4996</_含税金额> 	<_备注>总部促销</_备注> 		
			 *	  	<_厂商商品编号></_厂商商品编号> 
			 *	  </ROW> </ROWSET>
			 */
			var detailurl = host_url+"/lhscm/cm/business/form/po/poreportview.do?headerid="+map.get("id");
			var detailret = httpcall.Get(detailurl,code);
			var nodelist = HtmlParser.parserHtml(detailret,code); 
			var tablist = HtmlParser.filterHtml(nodelist,"table"); 	
			var ds = HtmlParser.parserTable(tablist,code,new Array("7"),"O");
			if(ds.getRowCount() > 0)
			{
				for(var r = 0;r < ds.getRowCount() ;r ++)
				{
					m_dtlrow = m_bildtl.AddNullRow(m_bildtl.getRowCount()-1);
					m_bildtl.setValueAt(m_dtlrow,"SRFLG",typ);
					m_bildtl.setValueAt(m_dtlrow,"USERID",userid);
					m_bildtl.setValueAt(m_dtlrow,"DEPTID",deptid);
					m_bildtl.setValueAt(m_dtlrow,"KAID",kaid);
					m_bildtl.setValueAt(m_dtlrow,"BILID",map.get("pono"));//订单号
					m_bildtl.setValueAt(m_dtlrow,"ECORPNAM",map.get("orgid").substring(map.get("orgid").indexOf("(")+1,map.get("orgid").indexOf(")")));//对方客户名称
					m_bildtl.setValueAt(m_dtlrow,"ECORPID",map.get("orgid").substring(0,map.get("orgid").indexOf("(")));//对方客户编号
					m_bildtl.setValueAt(m_dtlrow,"ITMCLASS",map.get("deptid"));//10(饮料)
					m_bildtl.setValueAt(m_dtlrow,"ORDID",map.get("pono"));
					m_bildtl.setValueAt(m_dtlrow,"DAT",FormatDataString(map.get("billdate")));//订单日期
					m_bildtl.setValueAt(m_dtlrow,"ARRDAT",FormatDataString(map.get("requestdate")));//到货日期
					m_bildtl.setValueAt(m_dtlrow,"TEL","");
					m_bildtl.setValueAt(m_dtlrow,"FAX","");
					m_bildtl.setValueAt(m_dtlrow,"SEQID",ds.getStringAt(r,"_序号"));//序列号
					m_bildtl.setValueAt(m_dtlrow,"EITMID",ds.getStringAt(r,"_商品编号"));
					m_bildtl.setValueAt(m_dtlrow,"CODE",ds.getStringAt(r,"_条码"));
					m_bildtl.setValueAt(m_dtlrow,"SPEC",ds.getStringAt(r,"_规格"));
					m_bildtl.setValueAt(m_dtlrow,"EITMNAM",ds.getStringAt(r,"_商品名称"));
					m_bildtl.setValueAt(m_dtlrow,"UNTNUM",ds.getStringAt(r,"_包装"));					
					m_bildtl.setValueAt(m_dtlrow,"QTYFLG","");
					m_bildtl.setValueAt(m_dtlrow,"QTY",ds.getStringAt(r,"_数量"));
					m_bildtl.setValueAt(m_dtlrow,"ZPQTY",ds.getStringAt(r,"_赠品"));
					m_bildtl.setValueAt(m_dtlrow,"EPRICE",ds.getStringAt(r,"_未税单价"));
					m_bildtl.setValueAt(m_dtlrow,"CORPADDR","");//送货地址
					m_bildtl.setValueAt(m_dtlrow,"NOTE",ds.getStringAt(r,"_备注"));	
					m_bildtl.setValueAt(m_dtlrow,"ORDCONTENT","");				
				}
			}
		}
		var param = "accid=&bgid=0002&datebegin="+date+"&dateend="+date+"&datetype=1&deptid=&findnew=&limit=100&orderby=bg_org_id&orgid=&pono=&status=-1&start="+row*SoPageSize;
		ret = httpcall.Post(host_url+"/lhscm/cm/business/form/po/po.do?search=true",param,code);
	}
}

var SrPageSize = 20;//目前一页显示的数据是20条(退货订单)
var SrRowTotal = 0;//获取订单的所有数据记录条数(退货订单)
var SrPagePerSize = 0;//获取总共显示多少页（退货订单）

//获取销售订单具体的明细数据
function SrOrdDs(typ,ret,host_url,userid,date,code,kaid,deptid)
{
	/**  以下是获取订单信息的列表格式
	 *      {"count":"3","rows":[
	 *	{"marketcode":"6783","replyby":"LH17102001","status":"不同意","rcvno":"","needfax":"否","faxtime":"","rcvid":"","id":"CD2E271E7653024EE043C009010F024E","orgitemid":"","bgid":"0002(世纪联华)","deptid":"10(饮料)","orgid":"6783(上海奉城店)","returnno":"6783201210290278","recall":"不同意","lastreferdate":"2012-10-30 09:57:10","returndate":"2012-10-29","sstatus":"B","enddate":"2012-11-01 20:00","replydate":"2012-10-30"},
	 *	{"marketcode":"6783","replyby":"LH17102001","status":"不同意","rcvno":"","needfax":"否","faxtime":"","rcvid":"","id":"CD2E271E1C2C024EE043C009010F024E","orgitemid":"","bgid":"0002(世纪联华)","deptid":"10(饮料)","orgid":"6783(上海奉城店)","returnno":"6783201210290260","recall":"不同意","lastreferdate":"2012-10-30 09:58:02","returndate":"2012-10-29","sstatus":"B","enddate":"2012-11-01 20:00","replydate":"2012-10-30"},
	 *	{"marketcode":"6783","replyby":"LH17102001","status":"不同意","rcvno":"","needfax":"否","faxtime":"","rcvid":"","id":"CD2E271E1C36024EE043C009010F024E","orgitemid":"","bgid":"0002(世纪联华)","deptid":"10(饮料)","orgid":"6783(上海奉城店)","returnno":"6783201210290265","recall":"不同意","lastreferdate":"2012-10-30 09:58:25","returndate":"2012-10-29","sstatus":"B","enddate":"2012-11-01 20:00","replydate":"2012-10-30"}]} 
	 */
	//将以上的格式，用{进行分组，一个"{"代表本次订单的总记录数，其余的均代表每个订单的列表
	var subret = EAfunc.Replace(EAfunc.Replace(ret.substring(1,ret.length()-2),"\"",""),"{","#");
	var splitflg = "#";
	var strsplit = subret.split(splitflg );
	//获取订单的所有数据记录条数
	SrRowTotal = matchMap(strsplit[0].split(",")[0]).get("count");//count:2   
	if(SrRowTotal%SrPageSize == 0)
		SrPagePerSize = SrRowTotal/SrPageSize;
	else
		SrPagePerSize = SrRowTotal/SrPageSize+1;
		
	for(var row = 1;row <= SrPagePerSize ;row ++)
	{
		ret = EAfunc.Replace(EAfunc.Replace(ret.substring(1,ret.length()-2),"\"",""),"{","#");
		strsplit = ret.split("#");
		for(var r = 1;r < strsplit.length();r ++)
		{
			var map = matchMap(strsplit[r].substring(0,strsplit[r].length()-2));
			/**
			 *	获取具体的商品信息
			 *      url = 	http://edi.chinalh.com/lhscm/cm/business/form/returns/returnsedit.do?detail=true&headerid=CD402CB717D50224E043C009010F0224
			 */
			 
			var detailurl = host_url+"/lhscm/cm/business/form/returns/returnsedit.do?detail=true&headerid="+map.get("id");
			var detailret = httpcall.Get(detailurl,code);
			var detailsubret = EAfunc.Replace(EAfunc.Replace(detailret.substring(1,detailret.length()-2),"\"",""),"{","#");
			var detailstrsplits = detailsubret.split("#");
			for(var r = 1;r < detailstrsplits.length();r ++)
			{
				var detailmap = matchMap(detailstrsplits[r].substring(0,detailstrsplits[r].length()-2));
				m_dtlrow = m_bildtl.AddNullRow(m_bildtl.getRowCount()-1);
				m_bildtl.setValueAt(m_dtlrow,"SRFLG",typ);
				m_bildtl.setValueAt(m_dtlrow,"USERID",userid);
				m_bildtl.setValueAt(m_dtlrow,"DEPTID",deptid);
				m_bildtl.setValueAt(m_dtlrow,"KAID",kaid);
				m_bildtl.setValueAt(m_dtlrow,"BILID",map.get("returnno"));//订单号
				m_bildtl.setValueAt(m_dtlrow,"ECORPNAM",map.get("orgid").substring(map.get("orgid").indexOf("(")+1,map.get("orgid").indexOf(")")));//对方客户名称
				m_bildtl.setValueAt(m_dtlrow,"ECORPID",map.get("orgid").substring(0,map.get("orgid").indexOf("(")));//对方客户编号
				m_bildtl.setValueAt(m_dtlrow,"ITMCLASS",map.get("deptid"));//10(饮料)
				m_bildtl.setValueAt(m_dtlrow,"ORDID",map.get("returnno"));
				m_bildtl.setValueAt(m_dtlrow,"DAT",FormatDataString(map.get("returndate")));//订单日期
				m_bildtl.setValueAt(m_dtlrow,"ARRDAT",FormatDataString(map.get("enddate")));//退货回复截止日期表示到货日期
				m_bildtl.setValueAt(m_dtlrow,"TEL","");
				m_bildtl.setValueAt(m_dtlrow,"FAX","");
				m_bildtl.setValueAt(m_dtlrow,"SEQID",detailmap.get("seq"));//序列号
				m_bildtl.setValueAt(m_dtlrow,"EITMID",detailmap.get("itemid"));
				m_bildtl.setValueAt(m_dtlrow,"CODE",detailmap.get("barcode"));
				m_bildtl.setValueAt(m_dtlrow,"SPEC",detailmap.get("capacity"));
				m_bildtl.setValueAt(m_dtlrow,"EITMNAM",detailmap.get("itemname"));
				m_bildtl.setValueAt(m_dtlrow,"UNTNUM",detailmap.get("packsize"));
				m_bildtl.setValueAt(m_dtlrow,"QTYFLG","");
				m_bildtl.setValueAt(m_dtlrow,"QTY",Math.abs(detailmap.get("qty")));
				m_bildtl.setValueAt(m_dtlrow,"ZPQTY",0);
				m_bildtl.setValueAt(m_dtlrow,"EPRICE",detailmap.get("netprice"));
				m_bildtl.setValueAt(m_dtlrow,"CORPADDR","");//送货地址
				m_bildtl.setValueAt(m_dtlrow,"NOTE","");
				m_bildtl.setValueAt(m_dtlrow,"ORDCONTENT","");	
			}
		}
		var param = "accid=&bgid=0002&datebegin="+date+"&dateend="+date+"&datetype=2&deptid=&findnew=&limit=20&orderby=bg_org_id&orgid=&replyer=&returnno&returnorg=&status=-1&start="+row*SrPageSize;
		ret = httpcall.Post(host_url+"/lhscm/cm/business/form/returns/returns.do?search=true",param,code);
	}
}

/* 将如下的数据通过key-value，放入到map中   如：status:未收货   map.put("status","未收货")
 * created_date:2012-11-14 15:34:35, status:未收货,  rcvno:,  needfax:否, pono:5015201211140014,  sum:1,  reply_delivery_date:2012-11-17, faxtime:, 
 * rcvid:,  bg_item_count:1, bg_net_amt:462.8202,  id:CE10D50F5AAC026EE043C009010F026E,  requestdate:2012-11-17, amt:541.4996,  bgid:0002(世纪联华), 
 * billdate:2012-11-14,  deptid:10(饮料),  orgid:5015(上海成山路店),  lastreferdate:2012-11-15 10:28:56,  sstatus:1,  replydate:
 */
function matchMap(str)
{
	var map = null;
	try
	{
		map = new mutil.HashMap();
		var splitflg = ",";
		var strsplit = str.split(splitflg);
		for(var r = 0;r < strsplit.length();r ++)
		{
			var str_array = strsplit[r].split(":");
			if(str_array.length() == 1)
				map.put(str_array[0],"");
			else
				map.put(str_array[0],str_array[1].split(" ")[0]);
		}
		return map;
	}
	catch(e)
	{
		throw new Exception(e);
	}
}


function FormatDataString(date)
{
	//先将date（字符串型）解析成日期型的
	var Datetypsdf = new text.SimpleDateFormat("yyyy-MM-dd");
	var Datetyp = Datetypsdf.parse(date);//解析成了日期型的
        var sdf = new text.SimpleDateFormat("dd/MM/yyyy");
        var dat = sdf.format(Datetyp);//解析成了日期型的
        return dat;
}


}