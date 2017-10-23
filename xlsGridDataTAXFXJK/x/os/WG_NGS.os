function x_WG_NGS(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var util = new JavaPackage("java.util");
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var HtmlParser = new x_WG_HtmlParser();
var httpcall = new webget.HttpCall();
var pageSize = 15;
function start()
{
	return getOrderStr("JQPX","2010-08-31","0022","jq02","25987323","5",""); 
}
var order = new pubpack.EAXmlDS();
var links = new util.ArrayList();
function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code)
{ 
	var db = null;
	try{
		db = new pubpack.EADatabase();
		var map = new util.HashMap();
		var ret = HtmlParser.doRequest(httpcall,kaid,userid,passwd,code);
		//得到总页数
		var totalSize = 1 * getPageNumber(ret);
		var totalPage = (totalSize+pageSize)/pageSize;
		var pageNo = 0;
		//得有所有订单号的列表
		while( pageNo < totalPage )
		{
			var select_page = pageSize * pageNo +1;
			links = getOrderList("http://61.129.104.202/b2b/numerous/order/listOrderAction.do","startIndex="+select_page+"&pageSize="+pageSize+"&select_page="+select_page,"GBK",dat);
			pageNo++;
		}
		//取订单明细
		var order = new pubpack.EAXmlDS();//订单对象
		var row = -1;		
		for (var e = 0;e < links.size();e++)
		{
 			ret = httpcall.Get(links.get(e),"GBK");
 			var base  = HtmlParser.parserHtml(ret,"GBK");
 			var tablist = HtmlParser.filterHtml(base,"table");
 			var header = HtmlParser.parserTableTitle(tablist,"GBK",new Array(0));
 			var ordlist = HtmlParser.parserTable(tablist,"GBK",new Array(1),"O");
 			var footer = HtmlParser.parserTableTitle(tablist,"GBK",new Array(2));
			for (var i = 0;i<ordlist.getRowCount();i++)
			{
				
				var itmid = ordlist.getStringAt(i,"_商品编码");
				if (itmid != "合计")
				{
					row = order.AddNullRow(row);					
					for (var j = 0;j<header.length();j++)
					{
						var key = header[j];
						if (key.indexOf("订单编号") > -1) 
						{
							order.setValueAt(row,"ORDID",key.substring(key.indexOf("订货单号")+6,key.length()));
							order.setValueAt(row,"BILID",key.substring(key.indexOf("订货单号")+6,key.length()));
						}	
						if (key.indexOf("开单日期") > -1) 
							order.setValueAt(row,"DAT",key.substring(key.indexOf("订货日期")+6,key.length()));
						if (key.indexOf("送货日期") > -1)
							 order.setValueAt(row,"ARRDAT",key.substring(key.indexOf("送货日期")+6,key.indexOf("送货日期")+16));	
					}
					order.setValueAt(row,"ECORPID","农工商");
					order.setValueAt(row,"ECORPNAM","农工商");
					order.setValueAt(row,"EITMID",itmid);	
					order.setValueAt(row,"EITMNAM",ordlist.getStringAt(i,"_商品名称"));
					var spec = ordlist.getStringAt(i,"_规格");	
					order.setValueAt(row,"SPEC",spec);
					var untnum = spec.substring(spec.indexOf("*")+1,spec.length());
					order.setValueAt(row,"UNTNUM",untnum);					
					order.setValueAt(row,"QTY",1 * ordlist.getStringAt(i,"_数量") * untnum);	
					order.setValueAt(row,"ZPQTY","0");
					order.setValueAt(row,"EPRICE",1.0 * ordlist.getStringAt(i,"_进价（含税）")/untnum);	
					order.setValueAt(row,"QTYFLG","N");
					order.setValueAt(row,"NOTE","None");																													
					order.setValueAt(row,"CODE","");	
					order.setValueAt(row,"USERID",userid);					
					order.setValueAt(row,"KAID",kaid);
					order.setValueAt(row,"DEPTID",deptid);									
					order.setValueAt(row,"SEQID",i+1);	
					order.setValueAt(row,"SRFLG","NR");
	//				order.setValueAt(row,"CONTENT",tablist.toHtml());
					for (var k = 0;k<footer.length()-1;k++)
					{
						var key = footer[k];
						var val = footer[k+1];
						if (key.indexOf("仓库地址") > -1) 
							order.setValueAt(row,"CORPADDR",key.substring(key.indexOf("仓库地址")+5,key.length()));
											
					}														
				}
			}			
		}
		return order.GetXml();
		return HtmlParser.parserDsToString(order,"","EITMID","合计");			 	
	}catch(e){
		throw new Exception(e);
	}
	finally
	{
		if(db != null)
			db.Close();
	}
}
//得到总共的记录数
function getPageNumber(ret)
{
	var page = HtmlParser.parserHtml(ret,"GBK");
	var form = HtmlParser.filterHtml(page,"form");
	var table = HtmlParser.filterHtml(form,"table");	
	var tablist = table.elementAt(1);
	var content = HtmlParser.ReplaceStrToNull(tablist.toPlainTextString().trim(),new Array("&nbsp;"));
	if (content.indexOf ("共") > -1)		
		return content.substring(content.lastIndexOf("共")+1,content.indexOf("条，列"));
}

//取得符合日期的订单链接 
function getOrderList(url,params,encode,dat)
{
	var ret = httpcall.Post(url,params,encode);
	var page = HtmlParser.parserHtml(ret,"GBK");
	var tablist = HtmlParser.filterHtml(page,"table");
	var No = 0;
	for (var t = 0;t<tablist.size();t++)
	{
		var attr = tablist.elementAt(t).getAttribute("class");
		if ( attr != null && attr.equals("list"))
		{
			var TR = tablist.elementAt(t).getRows();
			for (var i = 0;i<TR.length();i++)
			{
				var TD = TR[i].getColumns();
				for (var j = 0;j<TD.length();j++)
				{
					if (j == 4)
					{
						if (TD[j].toPlainTextString().trim() == dat)
						{
							links.add("http://61.129.104.202/b2b/numerous/order/listOrderDtlAction.do?proc=searchFixedDtl&orderNo="+TD[0].toPlainTextString().trim());
						}
					}
				}
			}
		}			
	}
	return links;
}
}