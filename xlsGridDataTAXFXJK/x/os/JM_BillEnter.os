function x_JM_BillEnter(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var web = new JavaPackage("com.xlsgrid.net.web");
function Response()
{
//	request.setCharacterEncoding("UTF-8");
	var func = pubpack.EAFunc.NVL(request.getParameter("func"),"");
	var data = pubpack.EAFunc.NVL(request.getParameter("_this"),"");
	var corpid = pubpack.EAFunc.NVL(request.getParameter("CORPID"),"");
	var soid = pubpack.EAFunc.NVL(request.getParameter("SOID"),"");
//	var subtyp = pubpack.EAFunc.NVL(request.getParameter("SUBTYP"),"");
	var usr = web.EASession.GetLoginInfo(request);
	var usrid = usr.getUsrid();
	var accid = usr.getAccid();
	var sytid = usr.getSytid();
	var orgid = usr.getOrgid();
	var db = null;
	var xml = "";
	var sql = "";
	var sql2 = "";
	var sql3 = "";
	var sql4 = "";
	var sql5 = "";
	var msg = "";
	var cnt = 0;
	var cnt2 = 0;
	var out = response.getOutputStream();
	response.setContentType("content-type:text/html; charset=UTF-8");
	try
	{
		db = new pubpack.EADatabase();
		if(func=="save")
		{		
//			out.println(java.net.URLDecoder.decode(data));	
//			return ;
			xml = pubpack.EAJ2meUtil.getMainCellRangeXml(data);
//			out.println(corpid);
//			return;
			var row = xml.getRowCount()-1;
			var col = xml.getColumnCount();
			for(var i = 0;i<row;i++)
			{
				var item = xml.get(i+1,1);
				var cust = xml.get(i+1,2);
				for(var j = 5;j<col;j++)
				{
//					var sctyp = xml.get(0,j);
//					out.println("sctype"+sctyp);
					var scname = xml.get(0,j); //ȡ�ñ���������
					var qty = 1*xml.get(i+1,j); //ȡ��QTY��ת��������
					//������֯�źͱ���������ȡ���������Ͷ�Ӧ��ID
					var sctyp = "1";
					sql2 = "select sc.id from A3_SCTYPE sc,a3_cust c,v_a3_ka ka 
						where sc.org = c.org and sc.name='"+scname+"' 
						and sc.defid = ka.corptyp 
						and ka.guid = c.refguid 
						and c.id = '"+corpid+"'"; 
//					sql2 = "select id from A3_SCTYPE where org='"+orgid+"' and name='"+scname+"'";
					var sctyp = db.GetSQL(sql2);
					//������֯�ţ�ITEM��CUST��USRID��SUBTYP�ж�A3_CURORD�����޼�¼
					sql3 = "select guid from A3_CURORD where org='"+orgid
					+"' and cust='"+cust+"' and item='"+item+"' and crtusr='"+usrid
					+"' and sctyp='"+sctyp+"'";
					var uxml = db.GetXMLSQL(sql3);
					if(uxml.getRowCount()>0)
					{
						var uguid = uxml.getStringAt(0,"guid"); //�����ȡ����Ӧ��GUID
//						out.println(uguid);
						if(uguid.length()>0&&qty=="0")//������ڼ�¼����QTYΪ0��ɾ����¼
						{
//							out.println("����ɾ����");
//							sql4 = "delete from A3_CURORD where guid ='"+uguid+"'";
//							cnt = db.ExcecutSQL(sql4);
//							cnt2++;
						}
						else if(uguid.length()>0)//��¼��������¼�¼
						{
//							out.println("������£�");
							sql5 = "update A3_CURORD set qty="+qty+" where guid='"+uguid+"'";
							cnt = db.ExcecutSQL(sql5);
							cnt2++;
						}
					}
					else
					{
						if(qty>0) //���û�м�¼����QTY����0������¼
						{
//							out.println("������룡");
							sql = "insert into A3_CURORD(org,acc,qty,item,cust,crtusr,sctyp,corpsoid) "
							+"values('"+orgid+"','"+accid+"',abs("+qty+"),'"+item+"','"+cust+"','"
							+usrid+"','"+sctyp+"','"+soid+"')";
							cnt = db.ExcecutSQL(sql);
							cnt2++;
						}
					}
				}
			}
			db.Commit();
			var arrHreftxt = new Array("������һҳ","���ؿͻ��б�","������ҳ","���µ�¼");
               		var arrHref = new Array("show.sp?grdid=JM_BillEnter&CORPID="+corpid+"&SOID="+soid+"&ITMTYP=","show.sp?grdid=JM_CORPList","../j2memydesktop.jsp","../j2melogin.jsp");
               		var ret = pubpack.EAJ2meUtil.returnPage("�ɹ�������:"+cnt2+"����¼��",arrHreftxt,arrHref);
               		out.println(ret);
//			out.println("�ɹ�������:"+cnt2+"����¼��");
		}
	}
	catch ( ee )
	{
		db.Rollback();
		out.println(ee.toString());
	}
	finally
	{
		if (db!=null) db.Close();
	}
}

}