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
		var GX_list = new Array("_������","_���̼�","_��߼�","_��ͼ�","_���¼�","_�ɽ���","_�ǵ���","_������");
		//����~~~������~~~���̼�~~~��߼�~~~��ͼ�~~~�����~~~������~~~���¼�~~~�ǵ���~~~�ɽ���~~~������~~~�����~~~����� 
		for(var row = 0;row < ds.getRowCount()-1 ;row ++ )
		{
			if(msg != "")
				msg += "��";
			msg += "����~~~";
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
		var YN_list = new Array("_������","_���м�","_��߼�","_��ͼ�","_���¼�","_�ɽ���","_�ǵ�","_������");
		//����~~~������~~~���м�~~~���~~~����~~~���¼�~~~�ǵ�~~~��ͼ�~~~��߼�~~~�ɽ���~~~������  
		for(var row = 0;row < ds.getRowCount()-1 ;row ++ )
		{
			if(msg != "")
				msg += "��";
			msg += "����~~~";
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
		var ZZ_list = new Array("_��Լ","_����","_��߼�","_��ͼ�","_���¼�","_�ɽ���","_�ǵ�","_������");
		//֣��~~~��Լ~~~�����~~~����~~~��߼�~~~��ͼ�~~~���¼�~~~�ǵ�~~~�����~~~�����~~~�ɽ���~~~�ֲ���~~~�����~~~������~~~������  
		for(var row = 0;row < ds.getRowCount()-1 ;row ++ )
		{	
			if(ds.getStringAt(row,"_��Լ") != "С��")
			{
				if(msg != "")
					msg += "��";
				msg += "֣��~~~";
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
				msg1 += "��";
			msg1 += "��ɰ��~~~";
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
				msg1 += "��";
			msg1 += "�����~~~";
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