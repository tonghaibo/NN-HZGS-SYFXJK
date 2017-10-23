function x_GSMN(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var webget = new JavaPackage("com.xlsgrid.net.webget");
var httpcall = new webget.HttpCall();
var HtmlParser = new x_WG_HtmlParser();
//function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code)

function start()
{
	var ret = "";
	var code = "GBK";
	var nodelist = null;
	var tablist = null;
	var ds = null; 
	var msg = "";
	var msg1 = "";
	try
	{
		ret = httpcall.Get("http://app.gsmn.cn/price.jhtml?pppp=5",code);
		ret = httpcall.Get("http://app.gsmn.cn/price.do?action=real&type=more&pppp=5",code);
		ret = httpcall.Get("http://app.gsmn.cn/price.do?action=real",code);
		ret = httpcall.Get("http://market.gsmn.cn/market/sdk/detail/list.html",code);
		nodelist = HtmlParser.parserHtml(ret,code);
		tablist = HtmlParser.filterHtml(nodelist,"table"); 	
		ds = HtmlParser.parserTable(tablist,code,new Array("1"),"O");	
		var GX_list = new Array("_交货期","_开盘价","_最高价","_最低价","_最新价","_成交量","_涨跌幅","_订货量");
		//广西~~~交货期~~~开盘价~~~最高价~~~最低价~~~申买价~~~申卖价~~~最新价~~~涨跌幅~~~成交量~~~订货量~~~结算价~~~昨结算 
		for(var row = 0;row < ds.getRowCount()-1 ;row ++ )
		{
			if(msg != "")
				msg += "╃";
			msg += "广西~~~";
			for(var r = 0;r < GX_list.length(); r ++)
			{
				for(var col = 0;col < ds.getColumnCount();col ++)
				{
					var colnam = ds.getColumnName(col);
					if( GX_list[r] == colnam)
					{
						msg += ds.getStringDef(row,GX_list[r],"0");
						if(col < ds.getColumnCount()-1 )
							msg += "~~~";
						break;
					}
				}
			}		
		}
		ret = httpcall.Get("http://info.sugarinfo.net/sugarinfo.asp",code);
		nodelist = HtmlParser.parserHtml(ret,code);
		tablist = HtmlParser.filterHtml(nodelist,"table"); 	
		ds = HtmlParser.parserTable(tablist,code,new Array("1"),"O");
		var YN_list = new Array("_交货期","_开市价","_最高价","_最低价","_最新价","_成交量","_涨跌","_订货量");
		//云南~~~交货期~~~开市价~~~买价~~~卖价~~~最新价~~~涨跌~~~最低价~~~最高价~~~成交量~~~订货量  
		for(var row = 0;row < ds.getRowCount()-1 ;row ++ )
		{
			if(msg != "")
				msg += "╃";
			msg += "云南~~~";
			for(var r = 0;r < GX_list.length(); r ++)
			{
				for(var col = 0;col < ds.getColumnCount();col ++)
				{
					var colnam = ds.getColumnName(col);
					if( YN_list[r] == colnam)
					{
						msg += ds.getStringDef(row,YN_list[r],"0");
						if(col < ds.getColumnCount()-1 )
							msg += "~~~";
						break;
					}
				}
			}		
		}
		ret = httpcall.Get("http://www.zce.cn/DelaQuote.htm",code);
		nodelist = HtmlParser.parserHtml(ret,code);
		tablist = HtmlParser.filterHtml(nodelist,"table"); 	
		ds = HtmlParser.parserTable(tablist,code,new Array("0"),"O");
		var ZZ_list = new Array("_合约","_今开盘","_最高价","_最低价","_最新价","_成交量","_涨跌","_订货量");
		//郑州~~~合约~~~昨结算~~~今开盘~~~最高价~~~最低价~~~最新价~~~涨跌~~~最高买~~~最低卖~~~成交量~~~持仓量~~~今结算~~~买盘量~~~卖盘量  
		for(var row = 0;row < ds.getRowCount()-1 ;row ++ )
		{	
			if(ds.getStringAt(row,"_合约") != "小计")
			{
				if(msg != "")
					msg += "╃";
				msg += "郑州~~~";
				for(var r = 0;r < ZZ_list.length()-1;r ++)
				{
					for(var col = 0;col < ds.getColumnCount();col ++)
					{
						var colnam = ds.getColumnName(col);
						if( ZZ_list[r] == colnam)
						{
							msg += ds.getStringDef(row,ZZ_list[r],"0");
							if(col < ds.getColumnCount() )
								msg += "~~~";
							break;
						}
						
					}
				}
				msg += "0~~~";
			}
		}	
		
		ret = httpcall.Get("http://www.sugarinfo.net/front/sugarMarket/cityShow.jsp",code);
		nodelist = HtmlParser.parserHtml(ret,code);
		tablist = HtmlParser.filterHtml(nodelist,"table"); 	
		ds = parserTableOne(tablist,code,new Array("10"));
		for(var row = 0;row < ds.getRowCount(); row ++)
		{
			if(msg1 != "")
				msg1 += "╃";
			msg1 += "白砂糖~~~";
			for(var col = 0;col < ds.getColumnCount();col ++)
			{
				var colnam = ds.getColumnName(col);
				msg1 += ds.getStringAt(row,colnam)+"~~~";
			}
		}
		ds = parserTableOne(tablist,code,new Array("11"));
		for(var row = 0;row < ds.getRowCount(); row ++)
		{
			if(msg1 != "")
				msg1 += "╃";
			msg1 += "绵白糖~~~";
			for(var col = 0;col < ds.getColumnCount();col ++)
			{
				var colnam = ds.getColumnName(col);
				msg1 += ds.getStringAt(row,colnam)+"~~~";
			}
		}
		return msg+"#&#&"+msg1;
	}
	catch(e)
	{
		throw new Exception(e);
	}
}

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
				var TitleVal = HtmlParser.ReplaceStrToNull("_"+FirstRowList[c].toPlainTextString().trim(),new Array("(",")","/"," ","<br>","&nbsp;","-+"));
				if(notes.indexOf(TitleVal) > -1)
					TitleVal = TitleVal+"_"+TitleVal; 
				if( c >= cols.length()) 
					Val = "";	
				else			
					Val = HtmlParser.ReplaceStrToNull(cols[c].toPlainTextString().trim(),new Array("&nbsp;","/"," ","-+"));
				xml += "<"+TitleVal+">"+Val+"</"+TitleVal+">\n";
				notes += TitleVal;
			}
			
			xml += "</ROW>\n";
		}
	}	
	xml += "</ROWSET>\n";
	return new pubpack.EAXmlDS(xml); 	
}
}