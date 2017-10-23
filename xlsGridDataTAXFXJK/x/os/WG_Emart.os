function x_WG_Emart(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var EAfunc = new pubpack.EAFunc();
var webget = new JavaPackage("com.xlsgrid.net.webget");
var pagesize = 10;

function start()
{
	return getOrderStr("JQPX","2011-06-30","0016","E103343","123456","dept","UTF-8");
}

function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code)
//function start()
{
//	var userid = "E103343";
//	var passwd = "123456";
//	var kaid = "mart";
//	var deptid = "111111";
//	var dat = "2011-03-22";
//	var code = "UTF-8";
	
	
	var str = "";
//	var seq = 1;
	try{
		
		var httpcall = new webget.HttpCall();
		var ret = httpcall.Post("http://emart.powere2e.com/platform/login.htm","loginId=" + userid + "&password=" + passwd,code);	
		ret = httpcall.Get("http://emart.powere2e.com/platform/user/home.htm",code);		
		ret = httpcall.Get("http://emart.powere2e.com/platform/mailbox/openInbox.htm?showAll",code);
		ret = httpcall.Get("http://emart.powere2e.com/platform/mailbox/openInboxPO.htm",code); 
		var params = "searchText=&receivedDateFrom="+dat+"&receivedDateTo="+dat;
		ret = httpcall.Post("http://emart.powere2e.com/platform/mailbox/searchInboxPO.htm",params ,code); 
		ret = "<html><body>"+ret+"</body></html>";
		//总共有多少页
		var totalpage =1 * getPage(ret,code);		
		totalpage = (totalpage+pagesize-1)/pagesize;	
		var guids = ""; 
		for (var i = 1;i<= totalpage;i++)
		{
			var url = "http://emart.powere2e.com/platform/mailbox/navigateInboxPO.htm?gotoPage="+i;
			ret = httpcall.Get(url,code);
			ret = "<html><body>"+ret+"</body></html>";
			guids += getGuid(ret,dat,code);
		}
		//处理订单
		var guidarr = guids.split("~~~");
		for (var i = 0;i<guidarr.length();i++)
		{ 
			var guid = guidarr[i];	
			if (guid !="")//&&guid == "349471-12e559d214c-f528764d624db129b32c21fbca0cb8d6")
			{		
				var HtmlParser = new x_WG_HtmlParser(); 
				var listUri = "http://emart.powere2e.com/platform/mailbox/performDocAction.htm";
				ret = httpcall.Post(listUri,"guid="+guid,code);
				ret =  "<html><body>"+ret+"</body></html>";
				var nodelist = HtmlParser.parserHtml(ret,code);
				var tablist = HtmlParser.filterHtml(nodelist,"table");				
				//表头数据
				var hdrdata = tablist.elementAt(2);
				var hrows = hdrdata.getRows();
//				var hcols = hrows[0].getColumns();
//				var hdrstr = "";
				var ordid = "";
				var orddat = "";
				var arrdat = "";
				var corpnam = "";
				var fax = "";		
				for (var i = 0;i<hrows.length();i++)
				{
					var hcols = hrows[i].getColumns();
					for (var c = 0;c<hcols.length();c++)
					{
						var hk = hcols[c].toPlainTextString();			
						if (c+1<hcols.length())
							var hv = hcols[c+1].toPlainTextString().trim(); 
						if (hk.indexOf("票据编号")>-1)
							ordid = hv;
						if (hk.indexOf("订货日期")>-1)
							orddat = hv.substring(0,10);
						if (hk.indexOf("送货日期")>-1)
							arrdat = hv.substring(0,10);
						if (hk.indexOf("订货门店")>-1)
							corpnam = hv;
						if (hk.indexOf("传真")>-1)
							fax = hv;
						
						
					}	
				}
				//SRFLG~~~USERID~~~DEPTID~~~KAID~~~BILID~~~ECORPNAM~~~ECORPID~~~ITMCLASS~~~
				//ORDID~~~DAT~~~ARRDAT~~~TEL~~~FAX~~~SEQID~~~EITMID~~~CODE~~~SPEC~~~EITMNAM~~~
				//QTYFLG~~~UNTNUM~~~QTY~~~ZPQTY~~~EPRICE~~~CORPADDR~~~NOTE~~~NULL
				var hdrstr = "NR~~~"+userid+"~~~"+deptid+"~~~"+kaid+"~~~"+guid+"~~~"+corpnam+"~~~"+corpnam+"~~~"+" "+"~~~"+ordid+"~~~"+orddat+"~~~"+arrdat+"~~~"+" "+"~~~"+fax+"~~~";						
				//明细数据
				var s = "";
//				return tablist.elementAt(11);
//				for (var i=3;i<nodelist.size()-2;i++)	
//				{
//					if (i!=4) s += i+"~";						
//				}
				for (var i=3;i<tablist.size()-2;i++)	
				{
					if(s != "")	s += "~";
						s += i;						
				}			
				var arr = s.split("~");	
				var liststr = "";
//				throw new Exception(arr);
				var listDS = HtmlParser.parserTable(tablist,code,arr,"M");
				for (var r = 0;r<listDS.getRowCount();r++)
				{
					var eitmid = listDS.getStringAt(r,"_商品编码");
					var spec = listDS.getStringAt(r,"_订货单位");
					var eitmnam = listDS.getStringAt(r,"_商品名称");
					var untnum = listDS.getStringAt(r,"_内装数");
					var qtyflg = listDS.getStringAt(r,"_订货LOT");
					var qty = listDS.getStringAt(r,"_订货数量");
					var eprice = listDS.getStringAt(r,"_订货进价");
					
					//SRFLG~~~USERID~~~DEPTID~~~KAID~~~BILID~~~ECORPNAM~~~ECORPID~~~ITMCLASS~~~
					//ORDID~~~DAT~~~ARRDAT~~~TEL~~~FAX~~~SEQID~~~EITMID~~~CODE~~~SPEC~~~EITMNAM~~~
					//QTYFLG~~~UNTNUM~~~QTY~~~ZPQTY~~~EPRICE~~~CORPADDR~~~NOTE~~~NULL
					liststr = (r+1)+"~~~"+eitmid+"~~~"+" "+"~~~"+spec+"~~~"+eitmnam+"~~~"+qtyflg+"~~~"+untnum+"~~~"+qty+"~~~"+0+"~~~"+eprice+"~~~ ~~~ ~~~NULL";
					if(str != "")
						str += "╃";
					str += hdrstr+liststr;
//					throw new Exception(str);
//					seq++;
				}
			}										
		}		
		return str;
	}catch(e){ 
		throw new Exception(e);  
	}
	
}

//得到共有多少页
function getPage(ret,code)
{
		var HtmlParser = new x_WG_HtmlParser();
		var nodelist = HtmlParser.parserHtml(ret,code);
		var pagelist = HtmlParser.filterHtml(nodelist,"TD");
		var totalpage = 0;
		for (var m = 0;m<pagelist.size();m++)	
		{
			var attr = pagelist.elementAt(m).getAttribute("class");			
			if (attr == "content")
			{
				var tmp = pagelist.elementAt(m).toPlainTextString().trim();
				totalpage = tmp.substring(tmp.indexOf("总共")+"总共".length(),tmp.indexOf("记录"));		
						
				totalpage = ReplaceStr(totalpage);
				break;
			}	
		}
		return totalpage;
}
//得到需要处理的订单的GUID
function getGuid(ret,dat,code) 
{
	//解析HTML字符串
	var HtmlParser = new x_WG_HtmlParser();
	var nodelist = HtmlParser.parserHtml(ret,code);
	nodelist = HtmlParser.filterHtml(nodelist,"TABLE"); 	
	var GUIDS = "";	
	for (var i = 0;i<nodelist.size();i++)
	{			
		var attr = nodelist.elementAt(i).getAttribute("class");
		if (attr == "tbllist")
		{			
			var rows = nodelist.elementAt(i).getRows();//得到该table的所有tr
			//遍历该table的所有tr
			for (var j = 1;j<rows.length();j++)
			{
				var cols = rows[j].getColumns();//得到该tr下所有的td
				//判断订单的日期是不是指定的日期
				var orddat = cols[5].toPlainTextString().trim();
				//如果日期符合，找出相送日期订单的GUID值
				if (orddat == dat)
				{						
					 var inputTag = cols[0].getChild(1);
					 if (inputTag.getAttribute("name") == "msgId")	
					 	GUIDS += inputTag.getAttribute("value")+"~~~";	 
			 	}
			}
		}
//			break;
	}                                                                                                                                                                                                
	return GUIDS; 
}

function ReplaceStr(str)
{
	var strArr = new Array(",");
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

}