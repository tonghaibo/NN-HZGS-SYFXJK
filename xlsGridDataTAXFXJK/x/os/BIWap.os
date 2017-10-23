function x_BIWap(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var web = new JavaPackage("com.xlsgrid.net.web");
var grd = new JavaPackage("com.xlsgrid.net.grd");
var tag = new JavaPackage("com.xlsgrid.net.tag");
var lang = new JavaPackage ( "java.lang" );
var xmldsform = new tag.XmlDSForm();

//替换SQL参数
function replaceParam(mwobj,request,sql)
{
	if (sql.indexOf("---dtl") != -1) {
		var sytid = pub.EAFunc.NVL(request.getParameter("sytid"),"");
		var topic = pub.EAFunc.NVL(request.getParameter("topic"),"");
		var modguid = pub.EAFunc.NVL(request.getParameter("FORMGUID"),"");
		var usr = web.EASession.GetLoginInfo(request);
		if (sytid == "" || sytid == null) sytid = usr.getSytid();
		if (topic == "" || topic == null) throw new pub.EAException("分析主题是必需参数");
		
		var db = null;
		try {
			db = new pub.EADatabase();
			var tablename = db.GetSQL("select sourceds from dim_model where guid='"+modguid+"'");
			var isCross = isCrossReport(db,sytid,topic);
			
			if (!isCross) {
				sql = "select "
					+ getVdimWithName(db,sytid,topic,modguid,tablename) + ","
					+ getTarget(db,sytid,topic,true,modguid,tablename)
					+ ",'双击钻取' 双击钻取"
					+ "\n  from "
					+ tablename
					+ "\n where "
					+ getSearchParam(db,sytid,topic,request)
					+ "\n group by "
					+ getVdim(db,sytid,topic)
					+ "\n order by "
					+ getVdimOrders(db,sytid,topic,modguid,tablename);
			} else {
				sql = "select "
					+ getVdimWithName(db,sytid,topic,modguid,tablename) + ","
					+ colDate2Char(db,sytid,topic,getTarget(db,sytid,topic,false,modguid,tablename))
					+ "\n  from "
					+ tablename
					+ "\n where "
					+ getSearchParam(db,sytid,topic,request);
				var r_HCols = getVdimName(db,sytid,topic,modguid,tablename);		//交叉行字段
				var r_VCols = getCrossCol(db,sytid,topic);	//交叉列字段
				var r_VCol = getCrossTarget(db,sytid,topic);	//交叉值字段
				var colsql = getColSQL(db,sytid,topic,r_VCols);	//交叉列字段SQL
				var orderby = getVdimOrders(db,sytid,topic,modguid,tablename);		//行排序字段
				sql = pub.EASqlFunc.GetSql2CrossTableSQL(db,sql,colsql,r_HCols,r_VCols,r_VCol,orderby);
			}
			
			return sql;
		}
		catch (e) {
			db.Rollback();
			throw new pub.EAException(e.toString());
		}
		finally {
			if (db != null) db.Close();
		}
	}
}

//服务端查询出数据后，给中间件一个加工数据的机会
function filterXmlDS(dataSrcID,dataSrc)
//var dataSrc = new EAXmlDS();
{
	if (dataSrcID == "Detail") dataSrc.AddTitleRow();
}

//是否交叉
function isCrossReport(db,sytid,topic)
{
	var sql = "select a.hdim,b.id from dim_topic a,dim_dim b where a.refmod=b.refmod and a.sytid='%s' and a.id='%s' and a.hdim like '%'||b.id||'%'".format([sytid,topic]);
	var rowcnt = db.GetSQLRowCount(sql);
	if (rowcnt > 0) return true;
	return false;
}

//获取维度（带中文名）
function getVdimWithName(db,sytid,topic,modguid,tablename)
{
	var str = "";
	var sql = "select vdim from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	var vdim = db.GetSQL(sql);
	
	var arr = vdim.split(",");
	for (var i = 0;i < arr.length();i ++) {
		var colnam = GetColname(db,arr[i],modguid,tablename); //获取字段名称
		if (colnam == "") colnam = arr[i];
		if (str != "") str += ",";
		str += arr[i] +" as \""+ colnam +"\"";
	}
	return str;
}

//获取维度（中文名,用于交叉表行字段）
function getVdimName(db,sytid,topic,modguid,tablename)
{
	var str = "";
	var sql = "select vdim from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	var vdim = db.GetSQL(sql);
	
	var arr = vdim.split(",");
	for (var i = 0;i < arr.length();i ++) {
		var colnam = GetColname(db,arr[i],modguid,tablename); //获取字段名称
		if (colnam == "") colnam = arr[i];
		if (str != "") str += ",";
		str += colnam;
	}
	return str;
}

//排序依据（中文名）
function getVdimOrders(db,sytid,topic,modguid,tablename)
{
	var sql = "select orders,vdim from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	var ds = db.GetXMLSQL(sql);
	
	var str = ds.getStringAt(0,"ORDERS");
	var vdim = ds.getStringAt(0,"VDIM");
	
	if (str != null && str != "") return str;
	
	str = "";
	var arr = vdim.split(",");
	for (var i = 0;i < arr.length();i ++) {
		var colnam = GetColname(db,arr[i],modguid,tablename); //获取字段名称
		if (colnam == "") colnam = arr[i];
		if (str != "") str += ",";
		str += colnam;
	}
	return str;
}

//获取目标（带中文名）
function getTarget(db,sytid,topic,sumflg,modguid,tablename)
{
	var str = "";
	var sql = "select hdim from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	var hdim = db.GetSQL(sql);
	
	var arr = hdim.split(",");
	if (!sumflg) {
		for (var i = 0;i < arr.length();i ++) {
			if (str != "") str += ",";
			str += arr[i];
		}
	} else {
		for (var i = 0;i < arr.length();i ++) {
			var colnam = GetColname(db,arr[i],modguid,tablename); //获取字段名称
			if (colnam == "") colnam = arr[i];
			
			if (i == 0) {
				str = "sum("+ arr[i] +") as \""+ colnam +"\"";
			} else {
				str += ",sum("+ arr[i] +") as \""+ colnam +"\"";
			}
		}
	}
	return str;
}

//获取查询条件
function getSearchParam(db,sytid,topic,request)
{
	var where = "1=1";
	
	var sql = "select refmod,lvl,to_char(sysdate,'yyyy-mm-dd') dat from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	var ds = db.GetXMLSQL(sql);
	var refmod = ds.getStringAt(0,"REFMOD");
	var lvl = ds.getStringAt(0,"LVL");
	var sysdate = ds.getStringAt(0,"DAT");
	
	if (lvl != null && lvl != "") {
		where += "\n   and "+lvl;
	}
	
	sql = "select * from dim_dim where refmod='%s' order by seq".format([refmod]);
	var dimxmlds = db.GetXMLSQL(sql);
	
	for (var i = 0;i < dimxmlds.getRowCount();i ++) {
		var id = dimxmlds.getStringAt(i,"ID");
		var name = dimxmlds.getStringAt(i,"NAME");
		var datatyp = dimxmlds.getStringAt(i,"DATATYP");
		var control = dimxmlds.getStringAt(i,"CONTROL");
		var keyval = dimxmlds.getStringAt(i,"KEYVAL");
		var val = pub.EAFunc.NVL(request.getParameter(id),"");
		var dat1 = "";
		var dat2 = "";
		
		if (datatyp == "DATE") {
			dat1 = pub.EAFunc.NVL(request.getParameter("STA_"+id),sysdate);
			dat2 = pub.EAFunc.NVL(request.getParameter("END_"+id),sysdate);
			
			where += "\n   and " + id + ">=to_date(decode('"+dat1+"','','1900-01-01','"+dat1+"'),'yyyy-mm-dd')";
			where += "\n   and " + id + "<=to_date(decode('"+dat2+"','','2900-01-01','"+dat2+"'),'yyyy-mm-dd')";
		} else {
			if (val != "") {
				if (control != "" && keyval != "") {
					if (datatyp.indexOf("CHAR") >= 0) where += "\n   and "+ id +"='"+ val +"'";
					else where += "\n   and to_char("+ id +")='"+ val +"'";
				} else {
					if (datatyp.indexOf("CHAR") >= 0) where += "\n   and nvl("+ id +",' ') like '"+ val +"%'";
					else where += "\n   and nvl(to_char("+ id +"),' ') like '"+ val +"%'";
				}
			}
		}
	}
	return where;
}

//获取溯源条件
function getSearchDtlParam(db,sytid,topic,request)
{
	var where = "1=1";
	
	var sql = "select refmod,lvl,to_char(sysdate,'yyyy-mm-dd') dat from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	var ds = db.GetXMLSQL(sql);
	var refmod = ds.getStringAt(0,"REFMOD");
	var lvl = ds.getStringAt(0,"LVL");
	var sysdate = ds.getStringAt(0,"DAT");
	
	if (lvl != null && lvl != "") {
		where += "\n   and "+lvl;
	}
	
	sql = "select * from dim_dim where refmod='%s' order by seq".format([refmod]);
	var dimxmlds = db.GetXMLSQL(sql);
	
	for (var i = 0;i < dimxmlds.getRowCount();i ++) {
		var id = dimxmlds.getStringAt(i,"ID");
		var name = dimxmlds.getStringAt(i,"NAME");
		var datatyp = dimxmlds.getStringAt(i,"DATATYP");
		var control = dimxmlds.getStringAt(i,"CONTROL");
		var keyval = dimxmlds.getStringAt(i,"KEYVAL");
		var val = pub.EAFunc.NVL(request.getParameter(id),"");
		var dat1 = "";
		var dat2 = "";
		
		if (datatyp == "DATE") {
			dat1 = pub.EAFunc.NVL(request.getParameter("STA_"+id),sysdate);
			dat2 = pub.EAFunc.NVL(request.getParameter("END_"+id),sysdate);
			
			where += "\n   and " + id + ">=to_date(decode('"+dat1+"','','1900-01-01','"+dat1+"'),'yyyy-mm-dd')";
			where += "\n   and " + id + "<=to_date(decode('"+dat2+"','','2900-01-01','"+dat2+"'),'yyyy-mm-dd')";
		} else {
			if (val != "") {
				if (control != "" && keyval != "") {
					if (datatyp.indexOf("CHAR") >= 0) where += "\n   and "+ id +"='"+ val +"'";
					else where += "\n   and to_char("+ id +")='"+ val +"'";
				} else {
					if (datatyp.indexOf("CHAR") >= 0) where += "\n   and nvl("+ id +",' ')='"+ val +"'";
					else where += "\n   and nvl(to_char("+ id +"),' ')='"+ val +"'";
				}
			}
		}
	}
	return where;
}

//获取维度
function getVdim(db,sytid,topic)
{
	var sql = "select vdim from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	return db.GetSQL(sql);
}

//字段名称
function GetColname(db,colid,modguid,tablename)
{
	var ret = "";
	var ds = db.QuerySQL("select name from dim_dim where refmod='"+modguid+"' and upper(id)=upper('"+colid+"')"); //维度
	if ( ds.getRowCount() > 0 ) ret = ds.getStringAt(0,"NAME");
	else {
		ds = db.QuerySQL("select nvl(supername,'')||'Ｘ'||name name from dim_target where refmod='"+modguid+"' and upper(id)=upper('"+colid+"')"); //目标
		if ( ds.getRowCount() > 0 ) ret = ds.getStringAt(0,"NAME");
		else {
			ds = db.QuerySQL(" select comments name from user_col_comments where upper(table_name)=upper('"+tablename+"') and upper(column_name)=upper('"+colid+"')"); //系统
			if ( ds.getRowCount() > 0 ) ret = ds.getStringAt(0,"NAME");
		}
	}
	if ( ret == "" ) ret = colid;
	return ret;
}

//日期类型的转为字符型 select dat,itmid from aaa --> select to_char(dat,'yyyy-mm-dd') dat,itmid from aaa
function colDate2Char(db,sytid,topic,cols)
{
	var ret = "";
	var arrcols = cols.split(",");
	var incols = pub.EAFunc.SQLIN(cols);
	var sql = "select * from dim_dim where refmod=(select refmod from dim_topic where sytid='%s' and id='%s') and id in (%s)".format([sytid,topic,incols]);
	var ds = db.GetXMLSQL(sql);
	var colid = ds.getStringAt(0,"ID");
	var coltyp = ds.getStringAt(0,"DATATYP");
	
	for (var i = 0;i < arrcols.length();i ++) {
		if (ret != "") ret += ",";
		if (colid == arrcols[i] && coltyp == "DATE") ret += "to_char("+arrcols[i]+",'yyyy-mm-dd') "+arrcols[i];
		else ret += arrcols[i];
	}
	return ret;
}

//取得交叉列字段
function getCrossCol(db,sytid,topic)
{
	var sql = "select b.id from dim_topic a,dim_dim b where a.refmod=b.refmod and a.id='%s' and a.sytid='%s' and a.hdim like '%'||b.id||'%'".format([topic,sytid]);
	return db.GetSQL(sql);
}

//交叉值字段
function getCrossTarget(db,sytid,topic)
{
	var sql = "select a.hdim,b.id from dim_topic a,dim_dim b where a.refmod=b.refmod and a.id='%s' and a.sytid='%s' and a.hdim like '%'||b.id||'%'".format([topic,sytid]);
	var ds = db.GetXMLSQL(sql);
	var hdim = ds.getStringAt(0,"HDIM");
	var vdim = ds.getStringAt(0,"ID");
	var arr = hdim.split(",");
	for (var i = 0;i < arr.length();i ++) {
		if (arr[i] != vdim) return arr[i];
	}
	return "";
}

//交叉列字段SQL
function getColSQL(db,sytid,topic,vcol)
{
	var sql = "select keyval,wher from dim_dim where refmod=(select refmod from dim_topic where sytid='%s' and id='%s') and id='%s'".format([sytid,topic,vcol]);
	var ds = db.GetXMLSQL(sql);
	var view_name = ds.getStringAt(0,"KEYVAL");
	var where = ds.getStringAt(0,"WHER");
	if (view_name == "") {
		return "";
	} else {
		if (where != "") where = " and " + where;
		sql = "select name from "+ view_name +" where 1>0 " + where;
		return sql;
	}
}

//得到主题路径
function GetTopic()
{
	var db = null;
	var ds = null;
	var curtopic = topicid;
	try {
		db = new pub.EADatabase();
		ds = db.QuerySQL("select name,longname,hdim,vdim,hdim||','||vdim hvdim,nvl(picnote,'MSColumn3D-1') picnote,vdimshowcol,piclocation,xchart from dim_topic where sytid='"+sytid+"' and id='"+topicid+"'");
		if ( ds.getRowCount() == 0 ) throw new Exception( "主题"+topicid+"没有找到" );
		
		var str = topicid+"::"+ds.getStringAt(0,"NAME");
		while ( 1 > 0 ) {
			var sql = "select id,name from dim_topic where sytid='"+sytid+"' and id=(select refid from dim_topic where sytid='"+sytid+"' and id='"+curtopic+"')";
			var ds1 = db.QuerySQL(sql);
			if (ds1.getRowCount() == 0) break;
			curtopic = ds1.getStringAt(0,"ID");
			str = curtopic+"::"+ds1.getStringAt(0,"NAME")+"》"+str;
		}
		ds.setValueAt(0,"PATH",str);
	}
	finally {
		if (db != null) db.Close();
	}
	return ds.GetXml();
}

//根据参数得到真正的URL show.sp?grdid=ShelfItemSoPreview@ssid=[%SSID]@dat=[%DAT]
function GetURL()
{
	url = pub.EAFunc.Replace(url,"@","&");
	var ss = param.split(" ");
	for (var i = 0;i < ss.length();i ++) {
		var sss = ss[i].split("=");
		if (sss.length() > 1) {
			url = pub.EAFunc.Replace(url,"[%"+sss[0]+"]",sss[1]);
		}
	}
	return url;
}

//溯源
function GetDetail()
{
	var db = null;
	var ds = null;
	var sql = "";
	
	try {
		db = new pub.EADatabase();
		var tablename = db.GetSQL("select sourceds from dim_model where guid='"+FORMGUID+"'");
		var id = "ID";
		var name = "NAME";
		
		if (VDIMDTLCOLS.split(",").length() == 2) {
			id = VDIMDTLCOLS.split(",")[0];
			name = VDIMDTLCOLS.split(",")[1];
		} else if (VDIMDTLCOLS.split(",").length() == 1) {
			id = VDIMDTLCOLS.split(",")[0];
			name = "";
		}
		
		if (isCross) sql = "select "+id+" id,"+name+" name,'' value,'' url from "+tablename+"\n where "+getSearchDtlParam(db,sytid,topic,request)+"\n   and "+columnname+"='"+columnvalue+"'";
		else sql = "select "+id+" id,"+name+" name,"+columnname+" value,'' url from "+tablename+"\n where "+getSearchDtlParam(db,sytid,topic,request);
		sql += "\n order by "+id;
		
		ds = db.QuerySQL(sql);
		db.Commit();
	}
	catch (e) {
		db.Rollback();
		ds = new pub.EAXmlDS();
//		throw new Exception(e);
	}
	finally {
		if (db != null) db.Close();
	}
	
	return ds.GetXml();
}

//页面BODY处理完毕后事件
//sb里面是body元素及前面的head内容
//bodysb里面是body的innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	var db = null;
	var ds = null;
	var map = request.getParameterMap();
	var corpset = map.keySet();
   	var ite = corpset.iterator();
   	var stadat = "";
   	var enddat = "";
   	var par = ""; //所有请求参数
	var ret = ""; //查询条件参数
	var msg = "";
	var hdim = "";
	var vdim = "";
	var js = "";
	
	try {
		db = new pub.EADatabase();
		
		var sytid = pub.EAFunc.NVL(request.getParameter("sytid"),"");
		var topic = pub.EAFunc.NVL(request.getParameter("topic"),"");
		var modguid = pub.EAFunc.NVL(request.getParameter("FORMGUID"),"");
		var tablename = db.GetSQL("select sourceds from dim_model where guid='"+modguid+"'");
		var dat = db.GetSQL("select to_char(sysdate,'yyyy-mm-dd') from dual");
		
		while (ite.hasNext()) {
			var key = ite.next();
			var value = request.getParameter(key);
			
			if (key.indexOf("STA_") > -1) {
				if (value == "" || value == null) value = dat;
				stadat = value;
			}
			if (key.indexOf("END_") > -1) {
				if (value == "" || value == null) value = dat;
				enddat = value;
			}
			
			if(par != "") par += "&";
			par += key+"="+value;
			
			if (key.indexOf("sytid") == -1 && key.indexOf("grdid") == -1 && key.indexOf("FORMGUID") == -1) ret += key.substring(0,key.length())+"="+value+" ";
			
			if (key.indexOf("sytid") == -1 && key.indexOf("grdid") == -1 && key.indexOf("FORMGUID") == -1 && key.indexOf("topic") == -1 && key.indexOf("chgchart") == -1 && key.indexOf("STA_") == -1 && key.indexOf("END_") == -1 && value != "" && value != null) {
				var colid = key.substring(0,key.length());
				colid = GetColname(db,colid,modguid,tablename);
				
				if (msg != "") msg += "　";
				msg += colid +"："+value;
			}
		}
		
		ds = db.QuerySQL("select vdim,hdim,note from dim_topic where refmod='"+modguid+"' and id='"+topic+"' and sytid='"+sytid+"'");
		if (ds.getRowCount() > 0) {
			hdim = ds.getStringAt(0,"HDIM");
			vdim = ds.getStringAt(0,"VDIM");
			
			var note = ds.getStringAt(0,"NOTE");
			if (note != "") js = db.getBlob2String("select bdata from formblob where guid='"+note+"' for update","bdata");
		}
		db.Commit();
	}
	catch (e) {
		db.Rollback();
		throw new pub.EAException(e.toString());
	}
	finally {
		if (db != null) db.Close();
	}
	
	if (stadat != "" && enddat != "") msg = "日期："+stadat+"~"+enddat+"　"+msg;
	if (stadat != "" && enddat == "") msg = "日期："+stadat+"　"+msg;
	if (stadat == "" && enddat != "") msg = "日期："+enddat+"　"+msg;
	if (msg != "") msg = "参数　"+msg;
	
	var values = par+"***"+ret+"***"+msg;
	sb.append("<script>var G_PARAMS=\""+values+"\"</script>");
	sb.append("<script>var G_HDIV=\""+hdim+"\"</script>\r\n");
	sb.append("<script>var G_VDIV=\""+vdim+"\"</script>\r\n");
	sb.append("<script>function TopicOnLoad() {\r\n"+js+"\r\n}\r\n </script>");
}

//作为.sp服务时的入口	
//预定义变量：request,response
function Response()
{
	var db = null;
	var ds = null;
	var sql = "";
	var ret = "";
	var GHtml = "";
	var SYTID = pub.EAFunc.NVL(request.getParameter("sytid"),"");
	var usr = web.EASession.GetLoginInfo(request);
	if (SYTID == "" || SYTID == null) SYTID = usr.getSytid();
	var clienttype = pub.EAFunc.NVL(request.getParameter("clienttype"),"");
	if (clienttype != "") clienttype = "&clienttype=HTML";
	
	try {
		db = new pub.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		
//		var firsttopic = "";
//		var toolbarstr = "";
//		sql = "select rownum seq,a.* from (select id,name,vdim from dim_topic where refmod='"+FORMGUID+"' and refid is null order by id) a";
//		ds = db.QuerySQL(sql);
//		
//		for (var r = 0;r < ds.getRowCount();r ++) {	//有多少个主题
//			var topic = ds.getStringAt(r,"ID");
//			var name = ds.getStringAt(r,"NAME");
//			var bkimg = "background='xlsgrid/images/xlsgrid/tab.bg.off.grid.gif'";
//			var systr = "style='border-right: 1px solid #abc; border-top: 1px solid #abc; border-bottom: 1px solid #abc;'";
//			
//			if (r == 0) firsttopic = topic;
//			
//			toolbarstr += "<td width='150' align='center' "+bkimg+" "+systr+"><a href=javascript:show_right('"+topic+"');><font color=#333333>"+name+"</font></a></td>";
//		}
//		toolbarstr = "<table border='0' cellspacing='0' cellpadding='0' height='100%'><tr>"+toolbarstr+"</tr></table>";
		
		// 生成查询条件
		sql = "select id,name,refmod,control,keyval,defval,wher,seq,isxs
			 from ( select id id,name,refmod,control,keyval,defval,wher,seq,isxs
			 	  from dim_dim
			 	 where refmod='"+FORMGUID+"' and nvl(control,' ') <> 'DATEBOX'
			 	union all
			 	select 'STA_'||id id,'开始'||name name,refmod,control,keyval,to_char(sysdate,'yyyy-mm-dd') defval,'' wher,0 seq,isxs
			 	  from dim_dim
			 	 where refmod='"+FORMGUID+"' and control='DATEBOX'
			 	union all
			 	select 'END_'||id id,'截止'||name name,refmod,control,keyval,to_char(sysdate,'yyyy-mm-dd') defval,'' wher,1 seq,isxs
			 	  from dim_dim
			 	 where refmod='"+FORMGUID+"' and control='DATEBOX' )
			order by seq";
		ds = db.QuerySQL(sql);
		
		ret = " <table border='0' cellspacing='0' cellpadding='0' width='100%' height='100%'>
				<tr>
					<td height=30 align=left background=\"xlsgrid/images/xlsgrid/tab.bg.off.grid.gif\" style=\"font-size:14px; cursor:default;\" > 
						<table border='0' cellspacing='0' cellpadding='0' width='100%' height='100%'><tr><td width=24 align=center><img src='xlsgrid/images/toolbar/search.gif'></td><td align=left><font size=2px color=#000080>&nbsp;查询条件</font></td></tr></table>
					</td>
				</tr>
				<tr>
					<td valign=top>
					<form name=f1 method='post' action='show.sp?grdid=BIMain"+clienttype+"' Target='_right'>\n
			";
		
		var resetstr = "";
		var rowcount = ds.getRowCount();
		for ( var i=0;i<rowcount;i++ ) {
			var defval = "";
			if (ds.getStringAt(i,"DEFVAL") != null && ds.getStringAt(i,"DEFVAL") != "") {
				try {
					defval = db.GetSQL(web.EASession.GetSysValue(ds.getStringAt(i,"DEFVAL"),usr));	//SQL子句
				} catch ( e1 ) {
					try {
						defval = db.GetSQL("select '"+web.EASession.GetSysValue(ds.getStringAt(i,"DEFVAL"),usr)+"' val from dual");	//全局变量
					} catch ( e2 ) {
						try {
							defval = db.GetSQL("select "+web.EASession.GetSysValue(ds.getStringAt(i,"DEFVAL"),usr)+" val from dual");	//数据库函数
						} catch ( e3 ) {
							defval = web.EASession.GetSysValue(ds.getStringAt(i,"DEFVAL"),usr);	//字符串
						}
					}
				}
			}
			ds.setValueAt(i,"DEFVAL",defval);
			ds.setValueAt(i,"WHER",web.EASession.GetSysValue(ds.getStringAt(i,"WHER"),usr));
			
			resetstr += "try{document.all('"+ds.getStringAt(i,"ID")+"').value='"+ds.getStringAt(i,"DEFVAL")+"';}catch(e){}";
			
			if (ds.getStringAt(i,"ISXS") != "1") { //隐藏参数
				ret += "<input type='hidden' id='"+ds.getStringAt(i,"ID")+"' name='"+ds.getStringAt(i,"ID")+"'>";
				ds.DeleteRow(i);
				rowcount --;
				i --;
			}
		}
		
		GHtml = xmldsform.HtmlForm(request,ds,"NAME","ID","KEYVAL","","Y","Y","DEFVAL","WHER","CONTROL","0","50");
		ret += GHtml;
		ret += "<input type='hidden' id='sytid' name='sytid' value="+SYTID+">
			<input type='hidden' id='topic' name='topic' value=''>
			<input type='hidden' id='FORMGUID' name='FORMGUID' value="+FORMGUID+">
			<table border='0' cellpadding='0' cellspacing='1' width='100%'>
				<tr><td height='10'></td></tr>
				<tr><td align='center'>
					<input type='submit' style='height:24;cursor:pointer;' value=' 查 询 '>&nbsp;&nbsp;
					<input type='button' style='height:24;cursor:pointer;' value=' 重 置 ' onclick='javascript:f_reset();'>
				</td></tr>
			</table>";
		ret += "</td></tr></table>";
		
		var optionstr = "";
		var optionds = db.QuerySQL("select * from V_CHARTTYPE");
		
		for (var r = 0;r < optionds.getRowCount();r ++) {
			var id = optionds.getStringAt(r,"ID");
			var name = optionds.getStringAt(r,"NAME");
			var typ = optionds.getStringAt(r,"TYP");
			optionstr += "<option value='"+id+"-"+typ+"'>"+name+"</option>";
		}
		
		var initparam = "";
		var map = request.getParameterMap();
		var keys = map.keySet().iterator();
		while (keys.hasNext()) {
			var _varNam = ""+keys.next();
			var _valVal = request.getParameter(_varNam);
			//过长的参数不自动加入javascript中
			initparam += "\n f_chgvalue(\""+_varNam+ "\",\"" +_valVal+ "\"); ";
		}
		
		//附加脚本
		var headjsstr = "";
		var b = null;
		try{b = db.getBlob2Byte("select b.bdata from DIM_MODEL a,FORMBLOB b where a.jsguid=b.guid and a.guid='"+FORMGUID+"' for update","bdata");}catch(e){ }
		if (b != null) headjsstr = new lang.String(b,"GB2312");
		
		var lefthtml = ret;
		ret = "	<html>
				<link rel='stylesheet' type='text/css' href='xlsgrid/css/main.css'>
				<script language='javascript' src='xlsgrid/js/main.js' ></script>
				<script language='javascript' src='xlsgrid/images/flash/FusionCharts.js' ></script>
				<script type='text/javascript' src='xlsgrid/js/jquery-1.3.2.min.js'></script>
				<head>
				<meta http-equiv='Content-Type' content='text/html; charset=gb2312'>
				<STYLE>
					.navPoint {
						COLOR: #225f98; CURSOR: hand; FONT-FAMILY: 'Webdings'; FONT-SIZE: 9pt
					}
				</STYLE>
				<script>
					function switchLBar(){
						if (LPoint.innerText==3) {
							LPoint.innerText=4;
							leftTd.style.display='none';
							leftTd.style.width=10;
						}
						else {
							LPoint.innerText=3;
							leftTd.style.display='';
							leftTd.style.width=220;
						}
					}
					function switchRBar(){
						if (RPoint.innerText==4) {
							RPoint.innerText=3;
							rightTd.style.display='none';
							topTd.style.width=10;
						}
						else {
							RPoint.innerText=4;
							rightTd.style.display='';
							topTd.style.width=420;
						}
					}
					
					// 主题的触发事件
					function show_right(topic){
						document.all.f1.topic.value=topic;
						"+resetstr+"
						
						f1.submit();
					}
					// 首页的触发事件
					function show_home(){
						document.all.pathtip.innerHTML=\"当前位置：&nbsp;<a href=javascript:show_home();>首页</a>\";
						document.all.lefttip.innerHTML=\"<a href=javascript:show_left();>打开条件</a>\";
						document.all._right.src='BIHome.sp?FORMGUID="+FORMGUID+clienttype+"';
						
						f_reset();
						leftTd.style.display='none';
						LPoint.style.display='none';
						topTd.style.display='none';
					}
					// 条件的触发事件
					function show_left(){
						if (lefttip.innerHTML.indexOf(\"打开条件\")!=-1) {
							LPoint.innerText=3;
							LPoint.style.display='';
							leftTd.style.display='';
							leftTd.style.width=220;
							lefttip.innerHTML=\"<a href=javascript:show_left();>关闭条件</a>\";
						}
						else {
							LPoint.innerText=4;
							LPoint.style.display='none';
							leftTd.style.display='none';
							lefttip.innerHTML=\"<a href=javascript:show_left();>打开条件</a>\";
						}
					}
					// 显示当前位置
					function show_path(tip){
						var str = \"\";
						if (tip != \"\") {
							var arr = tip.split(\"》\");
							
							for (var i=0;i<arr.length;i++) {
								var id = arr[i].split(\"::\")[0];
								var name = arr[i].split(\"::\")[1];
								
								if (str != \"\") str += \"<font color=#333333>&nbsp;》&nbsp;</font>\";
								str += \"<a href=javascript:show_right('\"+id+\"');>\"+name+\"</a>\";
							}
						}
						
						if (str != \"\") str = \"&nbsp;》&nbsp;\"+str;
						str = \"当前位置：&nbsp;<a href=javascript:show_home();>首页</a>\"+str;
						document.all.pathtip.innerHTML=str;
					}
					
					//修改查询条件的值
					function f_chgvalue(paramid,val){
						try {document.all(paramid).value=val;} catch (e) {}
					}
					function f_submit(){
						f1.submit();
					}
					function f_reset(){
						"+resetstr+"
					}
					
					//更新分析图
					var chartxml1 = '';
					var chartxml2 = '';
					var chartdatatype = '1';
					function f_setchartxml1(xml){	//多维度的XML格式
						chartxml1 = xml;
					}
					function f_setchartxml2(xml){	//多维度的XML格式
						chartxml2 = xml;
					}
					function f_chgchart(){
						var swf = document.all('chgchart').value;
						var ss = swf.split('-');
						var chart1 = new FusionCharts('xlsgrid/images/flash/'+ss[0]+'.swf', 'ChartId1', '400', '100%');
						chartdatatype = ss[1];
						if ( ss[1]=='1') chart1.setDataXML(chartxml1);
						else chart1.setDataXML(chartxml2);
						
						chart1.render('chartdiv1');
					}
					function f_getcharttype(){
						return document.all('chgchart').value;
					}
					function f_getchartxml1(){
						return chartxml1;
					}
					function f_getchartxml2(){
						return chartxml2;
					}
					
					function zoomchart(){
						window.open( 'BIPath.sp','','fullscreen=yes,toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,status=no' );
					}
					function win_onload(){
						"+initparam+"
						show_path(\"\");
						show_home();
					}
					
					"+headjsstr+"
				</script>
				</head>
				
				<body topmargin='0' leftmargin='0' scroll='no' onload='javascript:win_onload();'>
					<table border='0' cellspacing='0' cellpadding='0' width='100%' height='100%'>
					<tr>
					<td id=leftTd background=xlsgrid/images/tree_bg.jpg style='display: none;width: 10;'>
						"+lefthtml+"
					</td>
					<td id=LPoint class=navPoint bgColor=#EEEEEE onclick=switchLBar() style='border-left: 1px solid #CCC; border-right: 1px solid #CCC; width: 3pt; vertical-align: middle;'>
						4
					</td>
					<td>
						<table border='0' cellspacing='0' cellpadding='0' width='100%' height='100%'>
						<tr>
						<td>
							<table border='0' cellspacing='0' cellpadding='0' width='100%' height='100%'>
							<tr><td height=30 background=xlsgrid/images/xlsgrid/tab.bg.off.grid.gif>
								<table border='0' cellspacing='0' cellpadding='0' width='100%' height='100%'>
									<tr>
										<td><div id='pathtip' align='left'>&nbsp;</div></td>
										<td width='62'><div id='lefttip' align='center'><a href=javascript:show_left();>打开条件</a></div></td>
									</tr>
								</table>
							</td></tr>
							<tr><td>
								<IFRAME id='_right' name='_right' border='0' frameBorder='0' width='100%' height='100%' scrolling='yes' style='border: 0px solid #808080;'>
								</IFRAME>
							</td></tr>
							</table>
						</td>
						<td id=topTd width=420 align='center'>
							<table border='0' cellspacing='0' cellpadding='0' width='100%' height='100%'>
							<tr>
							<td id=RPoint class=navPoint bgColor=#EEEEEE onclick=switchRBar() style='border-left: 1px solid #CCC; border-right: 1px solid #CCC; width: 3pt; vertical-align: middle;'>
								4
							</td>
							<td id=rightTd width=100%>
								<table border='0' cellspacing='0' cellpadding='0' width='100%' height='100%'>
								<tr><td height=30 align=center background=xlsgrid/images/xlsgrid/tab.bg.off.grid.gif>
									更换图型：
									<select id='chgchart' size='1' onchange='f_chgchart();' style='border: 1px solid #808080'>
										"+optionstr+"
									</select>
									&nbsp;
									<a href='javascript:zoomchart();'>放大图</a>
								</td></tr>
								<tr><td height=50% valign=top>
									<div id='chartdiv1' align='center'> &nbsp;</div>
								</td></tr>
								<tr><td height=50% valign=top>
									<hr>
									<div id='detail' align='center' style='height:95%;padding:5px;overflow:auto;'>&nbsp;</div>
								</td></tr>
								</table>
							</td>
							</tr>
							</table>
						</td>
						</tr>
						</table>
					</td>
					</tr>
					</table>
				</body>
			</html>
		";
	}
	catch ( ee ) {
		db.Rollback();
		throw new pub.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return ret;
}

}