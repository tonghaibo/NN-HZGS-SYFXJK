function x_JM_PlanEnter(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.netf" );
var web = new JavaPackage("com.xlsgrid.net.web");
function Response()
{
//	request.setCharacterEncoding("UTF-8");
	var func = pubpack.EAFunc.NVL(request.getParameter("func"),"");
	var data = pubpack.EAFunc.NVL(request.getParameter("_this"),"");
	var corpid = pubpack.EAFunc.NVL(request.getParameter("CORPID"),"");//门店ID
	var kaid = pubpack.EAFunc.NVL(request.getParameter("KAID"),"");//渠道编号
	var dat1 = pubpack.EAFunc.NVL(request.getParameter("DAT1"),"");//开始时间
	var dat2 = pubpack.EAFunc.NVL(request.getParameter("DAT2"),"");//结束时间
	var itmtyp = pubpack.EAFunc.NVL(request.getParameter("ITMTYP"),"");//商品大类
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
		var datds = new pubpack.EAXmlDS();
		if(func=="save")
		{		
//			out.println(java.net.URLDecoder.decode(data));	
//			return ;
			xml = pubpack.EAJ2meUtil.getMainCellRangeXml(data);
//			out.println(corpid);
//			return;
			var row = xml.getRowCount()-1;
			var col = xml.getColumnCount();
			var datsql = "select to_char(日期,'YYYY-MM-DD')  DAT from 日历 
                                   where 日期>=to_date('"+dat1+"','YYYY-MM-DD') 
 				   and 日期<=to_date('"+dat2+"','YYYY-MM-DD') order by DAT";
			datds = db.QuerySQL(datsql);
			var datcnt = datds.getRowCount();
			if(datcnt>0)
			{
				for(var j=0;j<datcnt;j++)//循环日期段，把计划量分配到每一天
				{
					var dat = datds.getStringAt(j,"DAT");//循环取出计划时间
					for(var i = 0;i<row;i++)//循环行数
					{
						var item = xml.get(i+1,1);
						var qty = xml.get(i+1,3);
						//判断计划表中是否有记录
						sql3 = "select w.guid from a3_wapplan w  
						where w.item = '"+item+"'
						and w.bascat = '"+corpid+"'
						and w.kaid = '"+kaid+"'
						and w.org = '"+orgid+"'
						and w.dat = to_date('"+dat+"','YYYY-MM-DD')";
						var uxml = db.GetXMLSQL(sql3);
						if(uxml.getRowCount()>0)
						{
							var uguid = uxml.getStringAt(0,"guid"); //如果有取出对应的GUID
				//						out.println(uguid);
							if(uguid.length()>0&&qty=="0")//如果存在记录但是QTY为0则删除记录
							{
//								out.println("进入删除！");
//								sql4 = "delete from A3_CURORD where guid ='"+uguid+"'";
//								cnt = db.ExcecutSQL(sql4);
//								cnt2++;
							}else if(uguid.length()>0)//记录存在则更新记录
							{
//								out.println("进入更新！");
								sql5 = "update A3_WAPPLAN set qty="+qty+" where guid='"+uguid+"'";
								cnt = db.ExcecutSQL(sql5);
								cnt2++;
							}
						}else
						{
							if(qty>0) //如果没有记录并且QTY大于0则插入记录
							{		
				//				out.println("进入插入！");
								sql = "insert into A3_WAPPLAN(org,acc,qty,item,bascat,crtusr,kaid,dat) "
								+"values('"+orgid+"','"+accid+"',abs("+qty+"/"+datcnt+"),'"+item+"','"+corpid+"','"
								+usrid+"','"+kaid+"',to_date('"+dat+"','YYYY-MM-DD'))";
								cnt = db.ExcecutSQL(sql);
								cnt2++;
							}
						}
					}
				}
				db.Commit();
			}else 
			{
				throw new Exception("日期格式错误，请重新选择！");
			}
			var arrHreftxt = new Array("返回上一页","返回客户列表","返回主页","重新登录");
               		var arrHref = new Array("show.sp?grdid=JM_PlanEnter&CORPID="+corpid+"&ITMTYP="+itmtyp+
               		"&DAT1="+dat1+"&DAT2="+dat2+"&KAID="+kaid,"show.sp?grdid=JM_CORPList","../j2memydesktop.jsp","../j2melogin.jsp");
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