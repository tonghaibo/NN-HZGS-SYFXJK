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
					var scname = xml.get(0,j); //取得标题行内容
					var qty = 1*xml.get(i+1,j); //取出QTY并转化成数字
					//根据组织号和标题行内容取出销售类型对应的ID
					var sctyp = "1";
					sql2 = "select sc.id from A3_SCTYPE sc,a3_cust c,v_a3_ka ka 
						where sc.org = c.org and sc.name='"+scname+"' 
						and sc.defid = ka.corptyp 
						and ka.guid = c.refguid 
						and c.id = '"+corpid+"'"; 
//					sql2 = "select id from A3_SCTYPE where org='"+orgid+"' and name='"+scname+"'";
					var sctyp = db.GetSQL(sql2);
					//根据组织号，ITEM，CUST，USRID，SUBTYP判断A3_CURORD中有无记录
					sql3 = "select guid from A3_CURORD where org='"+orgid
					+"' and cust='"+cust+"' and item='"+item+"' and crtusr='"+usrid
					+"' and sctyp='"+sctyp+"'";
					var uxml = db.GetXMLSQL(sql3);
					if(uxml.getRowCount()>0)
					{
						var uguid = uxml.getStringAt(0,"guid"); //如果有取出对应的GUID
//						out.println(uguid);
						if(uguid.length()>0&&qty=="0")//如果存在记录但是QTY为0则删除记录
						{
//							out.println("进入删除！");
//							sql4 = "delete from A3_CURORD where guid ='"+uguid+"'";
//							cnt = db.ExcecutSQL(sql4);
//							cnt2++;
						}
						else if(uguid.length()>0)//记录存在则更新记录
						{
//							out.println("进入更新！");
							sql5 = "update A3_CURORD set qty="+qty+" where guid='"+uguid+"'";
							cnt = db.ExcecutSQL(sql5);
							cnt2++;
						}
					}
					else
					{
						if(qty>0) //如果没有记录并且QTY大于0则插入记录
						{
//							out.println("进入插入！");
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
			var arrHreftxt = new Array("返回上一页","返回客户列表","返回主页","重新登录");
               		var arrHref = new Array("show.sp?grdid=JM_BillEnter&CORPID="+corpid+"&SOID="+soid+"&ITMTYP=","show.sp?grdid=JM_CORPList","../j2memydesktop.jsp","../j2melogin.jsp");
               		var ret = pubpack.EAJ2meUtil.returnPage("成功操作了:"+cnt2+"条记录！",arrHreftxt,arrHref);
               		out.println(ret);
//			out.println("成功操作了:"+cnt2+"条记录！");
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