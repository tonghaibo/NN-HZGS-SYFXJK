function x_WG_GMS(){var webget = new JavaPackage("com.xlsgrid.net.webget");
var util = new JavaPackage("java.util");
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var EAfunc = new pubpack.EAFunc();
var nodes = new JavaPackage("org.htmlparser.nodes");
function start()
{
	return  getOrderStr("JQPX","2013-12-06","0004","0047918","0047918","1","utf-8");
}
function getOrderStr(acc,dat,kaid,userid,passwd,deptid,code)
{ 
	var ds = null;
	var map = null;	
	var db = null;
//	var dat = "2010-11-19";
//	var acc = "JQPX"; 
//	var kaid = "0004";
//	var userid = "0047602";
//	var passwd = "0047602";
//	var deptid = "";
	try{
		var httpcall = new webget.HttpCall();		
		db = new pubpack.EADatabase();
		//��½
		var params = "eps_id=&errmsg=�޷�����Epass Active���,�밲װEpass��������&Image1.x=27&Image1.y=8&name="+userid+"&Password1="+passwd+"&__EVENTARGUMENT=&__EVENTTARGET=&__VIEWSTATE=dDwtNjIyNTMzMDUxO3Q8O2w8aTwxPjs+O2w8dDw7bDxpPDExPjs+O2w8dDxwPHA8bDxUZXh0Oz47bDxcZTs+Pjs+Ozs+Oz4+Oz4+O2w8SW1hZ2UxOz4+Wi2gHhbHgq30l2tum9eQgnZ6Xug=";	
		var ret = httpcall.Post("http://61.151.247.177/index.aspx",params,"utf-8"); 	

		//��¼���������
		ret = httpcall.Get("http://61.151.247.177/SCM/SCM_Main.htm","gb2312");	
		
		//��λ����ߵ�����
		ret = httpcall.Get("http://61.151.247.177/SCM/Left_Menu.aspx","utf-8");
			
		//�����ߡ���/�˿��ٽ��ܡ� 
		ret = httpcall.Get("http://61.151.247.177/SCM/SCM00200.aspx","UTF-8");

		var HtmlParser = new x_WG_HtmlParser();
		var nodelist = HtmlParser.parserHtml(ret,"UTF-8");	
		var tablist = HtmlParser.filterHtml(nodelist,"table");
//		throw new Exception(tablist );
		//����HTML�ַ����е�<TABLE>��ǩ
		for (var i = 0;i<tablist.size();i++)
		{
			var ltab = tablist.elementAt(i);
			var attr = ltab.getAttribute("id");
			if (attr.equals("DataGrid1"))
			{
				ds = HtmlParser.parserTable(tablist,"UTF-8",new Array("0"),"O");
			}
		}
		if (ds == null)
			return "û����Ҫ���ܵ��¶�����";
		//���������洢��������
		map = new util.HashMap();
		for (var r = 0;r<ds.getRowCount();r++)
		{
			var ordtyp = ds.getStringAt(r,"_��������");
			var ordid = ds.getStringAt(r,"_���ݺ�");
			if (ordid != "" && ordid != null)
				map.put(ordid,ordtyp);
		}

		//�������ӡ׼����
		params = "OpenMode=SHOW&100&100&SelectionMode=0"; 
		ret = httpcall.Post("http://61.151.247.177/SCM/SCM00200_iframe.aspx",params,"utf-8");
		
		//��ʼ����������	
		var order = new pubpack.EAXmlDS();//��������
		var row = -1;
		nodelist = HtmlParser.parserHtml(ret,"utf-8");
		tablist = HtmlParser.filterHtml(nodelist,"table");
		//�������е�TABLE
		for (var i = 0;i<tablist.size();i++)
		{
			//��λ����Ҫ�����TABLE��<TABLE id = 'Table4'>��
			var tableTag = tablist.elementAt(i);
			var attr = tableTag.getAttribute("id");
			if (attr.toUpperCase().equals("TABLE4"))
			{
				//��������
				var rowEndArea = tableTag.getRow(1);
				var endCols = rowEndArea.getColumns();
				var note = "";
				var contentNodelist = endCols[0].getChildren();	
				for (var i = 0;i<contentNodelist.size();i++)
				{
					var tmpNode = contentNodelist.elementAt(i);				
					note += tmpNode.toPlainTextString().trim()+",";			
				}
				note = HtmlParser.ReplaceStrToNull(note,new Array("&nbsp;","showtime();"));
				//̧ͷ����ϸ����				
				var rowDataArea = tableTag.getRow(0);
				var DataAreaNodelist = rowDataArea.getChildren();
				var dataTabNodelist = HtmlParser.filterHtml(DataAreaNodelist,"table");
				var arr = null;
				var listds = null;
				for (var t = 0;t<dataTabNodelist.size();t++)
				{
					var titleTabNode = dataTabNodelist.elementAt(t);					
					var attr = titleTabNode.getAttribute("id");					
					//̧ͷ
					if (attr.toUpperCase().equals("TABLE3"))
						arr = parserTitle(dataTabNodelist,"UTF-8",new Array(t));
					
					//��ϸ
					if (attr.indexOf("DataList1__ctl") > -1)
						listds = HtmlParser.parserTable(dataTabNodelist,"UTF-8",new Array(t),"O");

					if (arr != null && listds != null)
					{
						//���충����					
						for (var r = 0;r< listds.getRowCount();r++)
						{
							var number = listds.getStringDef(r,"_�к�","999999");
							if (number != "999999")
							{
								row = order.AddNullRow(row);														
								for (var a = 0;a<arr.length()-1;a++)
								{
									var val = arr[a];
									var val2 = arr[a+1];
									if (val.indexOf("��������") > -1 || val.indexOf("�˻�����")> -1)
									{
										if (map.containsKey(val2))
										{
											var typ = map.get(val2);
											if (typ .indexOf("�˻�") > -1)
												order.setValueAt(row,"SRFLG","R");
											else
												order.setValueAt(row,"SRFLG","NR");											
										}	
										else 
											order.setValueAt(row,"SRFLG","NR");
										order.setValueAt(row,"ORDID",val2);
										order.setValueAt(row,"ORDCONTENT","");//tableTag.toHtml());
									}
									if (val.indexOf("�ջ���λ") > -1 || val.indexOf("�ŵ�����") > -1)
									{ 
										order.setValueAt(row,"ECORPID",val2);
										order.setValueAt(row,"BILID",val2);
										order.setValueAt(row,"ECORPNAM",val2);						
									}	
									if (val.indexOf("��������") > -1 )
										order.setValueAt(row,"DAT",db.GetSQL("select to_char(to_date('"+val2+"','yyyy/mm/dd'),'dd/mm/yyyy') from dual "));
									if (val.indexOf("�˻�Ԥ����") > -1)
									{
										order.setValueAt(row,"DAT",db.GetSQL("select to_char(to_date('"+val2+"','yyyy/mm/dd'),'dd/mm/yyyy') from dual "));
										order.setValueAt(row,"ARRDAT",db.GetSQL("select to_char(to_date('"+val2+"','yyyy/mm/dd'),'dd/mm/yyyy') from dual "));
									}
									if (val.indexOf("������Ч��") > -1)
										order.setValueAt(row,"ARRDAT",db.GetSQL("select to_char(to_date('"+val2+"','yyyy/mm/dd'),'dd/mm/yyyy') from dual "));	
									if (val.indexOf("�ŵ��ַ") > -1)
										order.setValueAt(row,"CORPADDR",val2);														
								}
								order.setValueAt(row,"USERID",userid);					
								order.setValueAt(row,"KAID",kaid);
								order.setValueAt(row,"DEPTID",deptid);									
								order.setValueAt(row,"SEQID",number);
								order.setValueAt(row,"EITMID",listds.getStringAt(r,"_��Ʒ��"));
								order.setValueAt(row,"EITMNAM",listds.getStringAt(r,"_��Ʒ����"));
								order.setValueAt(row,"CODE",listds.getStringDef(r,"_����",""));
								order.setValueAt(row,"SPEC",listds.getStringAt(r,"_��λ"));
								order.setValueAt(row,"UNTNUM",listds.getStringDef(r,"_ϵ��","1"));
								order.setValueAt(row,"QTY",listds.getStringDef(r,"_��װ��",listds.getStringDef(r,"_Ԥ����","0"))); 
								order.setValueAt(row,"ZPQTY",listds.getStringDef(r,"_��Ʒ����","0"));
								order.setValueAt(row,"EPRICE",listds.getStringDef(r,"_����",listds.getStringDef(r,"�˻���","0"))); 
								order.setValueAt(row,"QTYFLG","N");
								order.setValueAt(row,"NOTE",""); 
							}
							
						
						} 						
						//������һ�Ŷ������̧ͷ��������ϸ���ݱ�����Ϊ�գ���ʼ����Ķ���
						arr = null;
						listds = null;
						
					}
					
				}
			}
		}
		return HtmlParser.parserDsToString(order,"","EITMID","�ϼ�"); 
		
	}catch(e){
		throw new Exception(e);
	}
	finally
	{
		if(db != null)
			db.Close();
	}
}


//����ͷ����
function parserTitle(nodelist,code,tabidxArr)
{
	var str = "";
//	throw new Exception(nodelist);
	var ltab = nodelist.elementAt(tabidxArr[0]);
	var rows = ltab.getRows();
	for (var r = 0;r<rows.length()-1;r++)
	{
		var cols = rows[r].getColumns();
		for (var c = 0;c<cols.length();c++)
		{
			str += cols[c].toPlainTextString().trim()+"~~";			
		}
	}
	var cs = rows[rows.length()-1].getColumns();
	var contentNodelist = cs[0].getChildren();	
	var s = "";
	for (var i = 0;i<contentNodelist.size();i++)
	{
		var tmpNode = contentNodelist.elementAt(i);
		
		s = tmpNode.toPlainTextString().trim();
		if (s != "")
			str += s+"~~";
	}
	return str.split("~~");
	
}












}