function x_BIMainOld(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var web = new JavaPackage("com.xlsgrid.net.web");
var grd = new JavaPackage("com.xlsgrid.net.grd");
var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var tag = new JavaPackage("com.xlsgrid.net.tag");
var xmldsform = new tag.XmlDSForm();
var EAfunc = new pubpack.EAFunc();

//替换SQL参数
function replaceParam(mwobj,request,sql)
{
	var topic = pub.EAFunc.NVL(request.getParameter("topic"),"");
	var sytid = pub.EAFunc.NVL(request.getParameter("sytid"),"");
//	var accid = pub.EAFunc.NVL(request.getParameter("accid"),"");
//	var orgid = pub.EAFunc.NVL(request.getParameter("orgid"),"");	
	var modguid = pub.EAFunc.NVL(request.getParameter("FORMGUID"),"");
	
	var sql = "";
	var usr = web.EASession.GetLoginInfo(request);
	if (sytid == "" || sytid == null){
		sytid = usr.getSytid();
	}
//	if (accid == "" || accid == null){
//		accid = usr.getAccid();
//	}
//	if (orgid == "" || orgid == null){
//		orgid = usr.getOrgid();
//	}
	if (topic == "" || topic == null){
		throw new pub.EAException("需要传入一个主题号参数");
	}
	var db = null;
	var dim = "";
	var target = "";
	var isCross = false;
	
	try {
		db = new pub.EADatabase();
		var tablename = db.GetSQL("select sourceds from dim_model where guid='"+modguid+"'" );
		isCross = isCrossReport(db,sytid,topic);
		if (!isCross) {
			sql = "  select " 
				+ getVdimWithName(db,sytid,topic,modguid ,tablename) + ","
				+ getTarget(db,sytid,topic,true,modguid,tablename ) 
				+ " ,'双击' 钻取动作"
				+ "\n from "
				+ getSourceName(db,sytid,topic)
				+ "\n where "
				+ getSearchParam(db,sytid,topic,request)
				+ "\n group by  "
				+ getVdim(db,sytid,topic)
				//+ ") \n"
				//+" ) where \n"
				//+ getConditions(db,sytid,topic)
				+ "\n order by "
				+ getVdim(db,sytid,topic);
		}
		else {
			sql = "select " 
				+ getVdimWithName(db,sytid,topic,modguid,tablename ) + "," 
				+ colDate2Char(db,sytid,topic,getTarget(db,sytid,topic,false,modguid,tablename )) 
				+ "\n from "
				+ getSourceName(db,sytid,topic)
				+ "\n where "
				+ getSearchParam(db,sytid,topic,request);
			var r_HCols = getVdim(db,sytid,topic);		//交叉行字段	
			var r_VCols = getCrossCol(db,sytid,topic);	//交叉列字段
			var r_VCol = getCrossTarget(db,sytid,topic);	//交叉值字段
			var colsql = getColSQL(db,sytid,topic,r_VCols);	//交叉列字段SQL
			var orderby = "";				//行排序字段
			sql = pub.EASqlFunc.GetSql2CrossTableSQL(db,sql,colsql,r_HCols,r_VCols,r_VCol,orderby);
		}

		return sql;
	}
	catch(e){
		db.Rollback();
		throw new pub.EAException(e.toString());
	}
	finally {
		if (db != null) db.Close();
	}
}

//取得模型数据分析源   
function getSourceName(db,sytid,topic)
{
	var sql = "select sourceds from dim_model where guid=(select refmod from dim_topic where sytid='%s' and id='%s' )".format([sytid,topic]);
	return db.GetSQL(sql);
}

//根据参数得到真正的URL
function GetURL()
{
	//show.sp?grdid=ShelfItemSoPreview@ssid=[%SSID]@dat=[%DAT]
	url = pub.EAFunc.Replace(url,"@","&");
	var ss = param.split(" " );
	for ( var i=0;i<ss.length();i++ ) {
		var sss = ss[i].split("=") ;
		if ( sss.length()>1 ) {
			url = pub.EAFunc.Replace(url,"[%"+sss[0]+"]",sss[1]);
		}
	}
	return url;
}
//得到模型下面的所有主题
function GetTOPICSTR()
{
	var str = "";
	
	var curtopic = topicid;
	var db = null;
	var ds = null;
	try {
		db = new pub.EADatabase();
		ds = db.QuerySQL("select name,longname,hdim,vdim,hdim||','||vdim hvdim,NVL(PICNOTE,'MSColumn3D-1') PICNOTE,VDIMSHOWCOL from dim_topic where sytid='"+sytid+"' and id='"+topicid+"'" );//refmod='"+modguid+"'
		
		if ( ds.getRowCount()== 0 ) throw new Exception( "主题"+topicid+"没有找到" );
		str = ds.getStringAt(0,"NAME" );
		while ( 1> 0) {
			var sql = "select id,name from dim_topic where sytid='"+sytid+"'  and id=(select refid from dim_topic where sytid='"+sytid+"'  and id='"+curtopic +"')";
			var ds1 = db.QuerySQL(sql);
			if ( ds1.getRowCount()== 0 ) break;	
			curtopic = ds1.getStringAt(0,"ID" );
			str= ds1.getStringAt(0,"NAME" )+"-"+str;
		}
		ds.setValueAt(0,"PATH", str );
	}

	finally {
		if (db != null) db.Close();
	}
	
	return ds.GetXml();
}
//树型递归函数
function _GetTOPICSTR(topicid,modguid)
{
	var xml = "<?xml version='1.0' encoding='GBK'>";
	var refidstr = " and refid is null ";
	if ( topicid!= "" ) 
		refidstr = " and refid='"+topicid+"'";
	var sql = "select id,name,guid from dim_topic where refmod='"+modguid+"' "+refidstr+" and url is null order by id";

	var ds = pubpack.EADbTool.QuerySQL(sql);
	if ( ds == null ) return "";
	for ( var i=0;i<ds.getRowCount() ; i ++ ) {
		var id =ds.getStringAt(i,"ID");
		var name = ds.getStringAt(i,"NAME");
		var guid = ds.getStringAt(i,"GUID");
		xml+="<"+name + " imageid=\"5\" topicid=\""+id+"\"  modguid=\""+modguid+"\" topicguid=\""+guid+"\">";
		//递归，找出下级所有的
		xml+=_GetTOPICSTR(id ,modguid);
		xml+="</"+name+">";

	}
	return xml;
}

//取得维度
function getDimesion(db,sytid,topic)
{
	var sql = "select id from dim_dim where refmod=(select refmod from dim_topic where sytid='%s' and id='%s' ) order by seq".format([sytid,topic]);
	var dimxmlds = db.GetXMLSQL(sql);
	var dim = "";
	for (var i=0;i<dimxmlds.getRowCount();i++){
		if (i == 0) {
			dim = dimxmlds.getStringAt(i,"ID");
		}
		else {
			dim += ","+dimxmlds.getStringAt(i,"ID");
		}
	}
	return dim;
}

//垂直方向维度
function getVdim(db,sytid,topic)
{
	var sql = "select vdim from dim_topic where sytid='%s' and id='%s' ".format([sytid,topic]);
	var vdim = db.GetSQL(sql);
	
	return vdim;
}
//垂直方向维度带中文名
function getVdimWithName(db,sytid,topic,modguid,tablename)
{
	var sql = "select vdim from dim_topic where sytid='%s' and id='%s' ".format([sytid,topic]);
	
	var vdim = db.GetSQL(sql);
	//获取字段名称
	var arr_tar = vdim.split(",");
	var str = "";
	for ( var i=0;i<arr_tar.length();i++) {
		if ( i!=0 ) str+=",";
		var colnam = GetColname(db,arr_tar[i],modguid,tablename);
		str+= arr_tar [i]+ " as \""+colnam +"\" ";
		//else str+= arr_tar [i];
	}
	

	return str ;
}
//日期类型的转为字符型 select dat,itmid from -> select to_char(dat,'yyyy-mm-dd') dat,itmid from 
function colDate2Char(db,sytid,topic,cols)
{
	var retdim = "";
	var arrcols = cols.split(",");
	var incols = pub.EAFunc.SQLIN(cols);
	var sql = "select * from dim_dim where refmod=(select refmod from dim_topic where sytid='%s' and id='%s' ) and id in (%s)".format([sytid,topic,incols]);
	var ds = db.GetXMLSQL(sql);
	var colid = ds.getStringAt(0,"ID");
	var coltyp = ds.getStringAt(0,"DATATYP");
		
	for (var i=0;i<arrcols.length();i++) {
		if (retdim != "") retdim += ",";
		if (colid == arrcols[i] && coltyp == "DATE") {
			retdim += "to_char("+arrcols[i]+",'yyyy-mm-dd') "+arrcols[i];
		}
		else {
			retdim += arrcols[i];
		}
	}
	return retdim;
}
function GetColname(db,colid,modguid,tablename)
{
		var ds = db.QuerySQL("select name from dim_dim where refmod='"+modguid+"' and UPPER(id)=UPPER('"+colid+"') ");
		var ret = "";
		if ( ds.getRowCount()>0 ) {
			ret= ds.getStringAt(0,"NAME");
		}
		else {
			ds = db.QuerySQL("select nvl(supername,'')||'Ｘ'||name||'Ｘ'||nvl(formatstr,'') name from dim_target where refmod='"+modguid+"' and UPPER(id)=UPPER('"+colid+"') ");
			
			if ( ds.getRowCount()>0 ) {
				ret= ds.getStringAt(0,"NAME");
			}
			else {
				ds = db.QuerySQL(" select comments from user_col_comments where  UPPER(column_name)=UPPER('"+colid+"') and UPPER(table_name)=UPPER('"+tablename +"') ");
				if ( ds.getRowCount()>0 ) 
					ret= ds.getStringAt(0,"comments");
			}
		}
		if( ret == "" ) ret= colid;
		return ret;
}
//取得目标值
function getTarget(db,sytid,topic,sumflg,modguid,tablename)
{
	var sql = "select hdim from dim_topic where sytid='%s' and id='%s' ".format([sytid,topic]);
	
	var hdim = db.GetSQL(sql);
	var arr_tar = hdim.split(",");
	var str = "";
	for ( var i=0;i<arr_tar.length();i++) {
		if ( i!=0 ) str+=",";
		str+=GetColname(db,arr_tar[i],modguid,tablename);
		
	}
	
	var arr_nametar = str.split(",");
	if (!sumflg) {
		str = "";
		for ( var i=0;i<arr_tar.length();i++) {
			if ( i!=0 ) str+=",";
			str+= arr_tar [i]+ " as \""+arr_nametar[i]+"\" ";
		}
		return str ;
	}
	else {
		var sumtar = "";
		
		for (var i=0;i<arr_tar.length();i++) {
			var colnam =  arr_tar[i];
			if (arr_nametar[i]!="" ) colnam  = arr_nametar[i];
			if (i == 0) {
				sumtar = "sum(" + arr_tar[i] + ") " + colnam ;
			}
			else {
				if(arr_tar[i].indexOf("毛利率") > -1)
				{
					sumtar += ",decode(sum("+arr_tar[i-8]+"),0,0,round(sum(" + arr_tar[i-4] + ")/sum("+arr_tar[i-8] + "),2)) " + colnam;
				}
				else if(arr_tar[i].indexOf("增减率") > -1)
				{
					sumtar += ",decode(sum("+arr_tar[i-2]+"),0,0,round(sum(" + arr_tar[i-1] + ")/sum("+arr_tar[i-2] + "),2)) " + colnam;
				}
				else
					sumtar += ",sum(" + arr_tar[i] + ") " + colnam;
			}
		}
		return sumtar;
	}
}

//查询条件  
function getSearchParam(db,sytid,topic,request)
{
	var sysdate = db.GetSQL("select to_char(sysdate,'yyyy-mm-dd') from dual");
	var sql = "select * from dim_dim where refmod=(select refmod from dim_topic where sytid='%s' and id='%s' ) order by seq".format([sytid,topic]);
	
//	throw new Exception(sql);
	var dimxmlds = db.GetXMLSQL(sql);
	var where = " 1=1 ";
	
	var row = pub.EAFunc.NVL(request.getParameter("row"),"0");
	row = "";//已取消多个查询条件的组合
//	throw new Exception(_r);
	for (var i=0;i<dimxmlds.getRowCount();i++){
		var id = dimxmlds.getStringAt(i,"ID");
		var name = dimxmlds.getStringAt(i,"NAME");
		var datatyp = dimxmlds.getStringAt(i,"DATATYP");
		var val = pub.EAFunc.NVL(request.getParameter(id+row),"");
		var dat1 = "";
		var dat2 = "";
		if (datatyp == "DATE") {
			dat1 = pub.EAFunc.NVL(request.getParameter("STA"+id+row),sysdate );
			dat2 = pub.EAFunc.NVL(request.getParameter("END"+id+row),sysdate );

			where += " and " + id + ">=to_date(decode('"+dat1+"','','1900-01-01','"+dat1+"'),'yyyy-mm-dd') \n"
				+ " and " + id + "<=to_date(decode('"+dat2+"','','2900-01-01','"+dat2+"'),'yyyy-mm-dd') \n";

		}
		else {
			if (val!="") {
				if (  datatyp.indexOf("CHAR")>=0 ) 
					where += " and nvl("+id+",' ') like '"+val+"%' \n";
				else where += " and nvl(to_char("+id+"),' ') like '"+val+"%' \n";

			}
		}
	}
	return where;
}

//是否交叉
function isCrossReport(db,sytid,topic)
{
	var sql = "select a.hdim,b.id from dim_topic a,dim_dim b where a.refmod=b.refmod and a.id='%s' and a.sytid='%s'  and a.hdim like '%'||b.id||'%'".format([topic,sytid]);
	var rowcnt = db.GetSQLRowCount(sql);
	if (rowcnt > 0) return true;
	return false;
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
	var sql = "select a.hdim,b.id from dim_topic a,dim_dim b where a.refmod=b.refmod and a.id='%s' and a.sytid='%s'  and a.hdim like '%'||b.id||'%'".format([topic,sytid]);
	var ds = db.GetXMLSQL(sql);
	var hdim = ds.getStringAt(0,"HDIM");
	var vdim = ds.getStringAt(0,"ID");
	var arr_hdim = hdim.split(",");
	var r_VCol = "";
	for (var i=0;i<arr_hdim.length();i++) {
		if (arr_hdim[i] != vdim) {
			return arr_hdim[i];
		}
	}
	return "";
}

//交叉列字段SQL
function getColSQL(db,sytid,topic,vcol,orgid,accid)
{
	var sql = "select keyval,wher from dim_dim where refmod=(select refmod from dim_topic where sytid='%s' and id='%s' ) and id='%s'".format([sytid,topic,vcol]);
	var ds = db.GetXMLSQL(sql);
	var view_name = ds.getStringAt(0,"KEYVAL");
	var where = ds.getStringAt(0,"WHER");
	if (view_name == "") {
		return "";
	}
	else {
		if (where != "") where = " and " + where;
		sql = "select name from " + view_name + " where 1>0 " + where;
		return sql;
	}
}

//服务端查询出数据后，给中间件一个加工数据的机会
function filterXmlDS(dataSrcID,dataSrc)
//var dataSrc = new EAXmlDS();
{
	if (dataSrcID == "MAIN") { 
		dataSrc.AddTitleRow();
	}
}
function getQueryString()
//var dataSrc = new EAXmlDS();
{
	return request.getQueryString();
}

//页面BODY处理完毕后事件
//sb里面是body元素及前面的head内容
//bodysb里面是body的innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	var map = request.getParameterMap();
	var corpset = map.keySet();
   	var ite = corpset.iterator();
   	var stadat = "";
   	var enddat = "";
	var ret = "";
	var ret1 = "";
	var ret2 = "";//公共不变的参数
	var ret3 = "";//按实际情况变化的参数
	var db = null;
	var dat = "";
	var hdim  = "";
	var vdim = "";
	var js = "";
	try
	{
		db = new pub.EADatabase();
		var topic = pub.EAFunc.NVL(request.getParameter("topic"),"");
		var sytid = pub.EAFunc.NVL(request.getParameter("sytid"),"");
		var modguid = pub.EAFunc.NVL(request.getParameter("FORMGUID"),"");
		var tablename = db.GetSQL("select sourceds from dim_model where guid='"+modguid+"'" );
		dat = db.GetSQL("select to_char(sysdate,'yyyy-mm-dd') from dual");
		while(ite.hasNext())
		{
			var key = ite.next();
			var value = request.getParameter(key);
			if(key.indexOf("STA") > -1)
			{
				if(value == ""||value == null)
					value = dat;
				stadat = value;
			}
			if(key.indexOf("END") > -1)
			{
				if(value == ""||value == null)
					value = dat;
				enddat = value;
			}
			if(ret != "")
				ret += "&";		
			ret += key+"="+value;	
			if(key.indexOf("row")==-1&&key.indexOf("sytid")==-1&&key.indexOf("FORMGUID")==-1&&key.indexOf("topic")==-1&&key.indexOf("grdid")==-1&&value!=""&& value!=null&&key.indexOf("STA") == -1&&key.indexOf("END") == -1){
				var colid = key.substring(0,key.length());
				colid = GetColname(db,colid,modguid,tablename);
				ret1 += colid +"："+value+"  ";
			}
			if(key.indexOf("sytid")>-1||key.indexOf("FORMGUID")>-1||key.indexOf("grdid")>-1)
				ret2 += key.substring(0,key.length())+"="+value+" ";
			else if(key.indexOf("topic")==-1)
				ret3 += key.substring(0,key.length())+"="+value+" ";
		}
		var noteguid = "";
		var ds =db.QuerySQL("select vdim, hdim, note  from dim_topic where refmod='"+modguid +"'  and id='"+topic +"' and sytid = '"+sytid +"'");
		if ( ds.getRowCount()>0 ) {
			hdim = ds.getStringAt(0,"hdim" );
			vdim = ds.getStringAt(0,"vdim" );
			noteguid  = ds.getStringAt(0,"note" );
			if ( noteguid!="" ) {
				js =  db.getBlob2String("select bdata from formblob where guid='"+noteguid  +"' for update","bdata"); 

			}
		}
		db.Commit();
	}
	catch(e)
	{
		db.Rollback();
		throw new Exception(e);
	}
	finally
	{
		if(db != null)
			db.Close();
	}
	var values = ret +"***"+stadat+"~"+enddat+"  "+ret1+"***"+ret2+"***"+ret3+"***"+pub.EAFunc.NVL(request.getParameter("row"),"0");
	sb.append("<script >var G_PARAMS=\""+values +"\"</script>");
	sb.append("<script >var G_HDIV=\""+hdim +"\"</script>\r\n");
	sb.append("<script >var G_VDIV=\""+vdim +"\"</script>\r\n");
	sb.append("<script >function TopicOnLoad() {\r\n"+js+"\r\n}\r\n </script>");

}

//钻取的函数
function ExtData()
{
	var params1 = "";
	var params = "";
	var db = null;
	var ds = null;
	var value = "";
	var pa = "";
	//定义一个数组arr，用于存放页面的参数
	//如果预先是按照日期查询的话，那就是开始和截止日期，均要为每一行的日期，否则，就是参数的日期数据
	var arr = new Array();
	try
	{
		db = new pub.EADatabase();
		params1 = allparam2.split(" ");
		//_r表示目前报表的row,
		//当前的报表是按照什么来查询的，这样便于判断开始和截止日期是为每一行的日期数据还是参数的日期数据
		ds = db.QuerySQL("select * from v_dimtopic where r = to_number("+_r+")");
		if(ds.getRowCount() > 0)
		{
			var vdim = ds.getStringAt(0,"VDIM");
			if(vdim.indexOf("DAT") > -1||vdim.indexOf("日期") > -1)
			{
				pa =  "STA"+vdim+_row+"="+item+"&END"+vdim+_row+"="+item;	
				arr.push(pa);
				for(var r = 0;r < params1.length();r ++)
				{
					if(params1[r].indexOf("row") > -1)
					{
						var vs = params1[r].split("=");
						pa = vs[0]+"="+_row;
						arr.push(pa);//利用push将参数数据放进arr数组中
					}
					else if(params1[r].indexOf("STA") == -1&&params1[r].indexOf("END") == -1)
					{
						var vs = params1[r].split("=");
						if(vs.length() > 1)
							value = vs[1] ;
						else
							value = "";
						pa = vs[0].substring(0,vs[0].length()-1)+_row+"="+value;
						arr.push(pa);
						
					}	
				}

			}
			else
			{
				for(var r = 0;r < params1.length();r ++)
				{
					if(params1[r].indexOf(vdim) > -1)
					{
						var vs = params1[r].split("=");
						pa = vs[0].substring(0,vs[0].length()-1)+_row+"="+item;
						arr.push(pa);
					}
					else if(params1[r].indexOf("row") > -1)
					{
						var vs = params1[r].split("=");
						pa = vs[0]+"="+_row;
						arr.push(pa);
					}
					else
					{
						var vs = params1[r].split("=");
						if(vs.length() > 1)
							value = vs[1] ;
						else
							value = "";
						pa = vs[0].substring(0,vs[0].length()-1)+_row+"="+value;
						arr.push(pa);
						
					}	
				}
			}
		}
		for(var i = 0;i < arr.length();i ++)
		{
			if(params != "")
				params += "&";
			params += arr[i];
		}
		params += "&topic="+db.GetSQL("select topic from v_dimtopic where r = to_number("+_row+")");
		return pub.EAFunc.Replace(allparam1," ","&")+params ;
		
		db.Commit();
	}
	catch(e)
	{
		db.Rollback();
		throw new Exception(e);
	}
	finally
	{
		if(db != null) db.Close();
	}
}


//作为.sp服务时的入口	
//预定义变量：request,response
function Response()
{
	var db = null;
      var ret= "";
      var sql = "";
      var _sql = "";
      var ds = null;
      var _ds = null;
      var GHtml = "";
	var SYTID = pub.EAFunc.NVL(request.getParameter("sytid"),"");
	var usr = web.EASession.GetLoginInfo(request);
	if (SYTID == "" || SYTID == null){
		SYTID = usr.getSytid();
	}

      var ret= "";
      try {
            db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
            
            
            var toolbarhtml = "";
            _sql = "select rownum seq, a.* from (select rownum seq,id,name,vdim from dim_topic where refmod ='"+FORMGUID+"'  and refid is null order by lvl,id ) a";//and sytid = '"+SYTID+"'
            _ds = db.QuerySQL(_sql);            
            var firsttopic = "";
            for(var r = 0;r < _ds.getRowCount();r ++)
            {	//有多少个主题
            	    var topic = _ds.getStringAt(r,"ID");
            	    var vdim = _ds.getStringAt(r,"vdim");
            	    var name = _ds.getStringAt(r,"name");
            	    var bkimg = "background='xlsgrid/images/xlsgrid/tab.bg.off.grid.gif'";
            	   
            	    if ( r == 0 ) {
            	    	bkimg = "background='xlsgrid/images/xlsgrid/tab.bg.on.grid.gif'";firsttopic  = topic ; 
            	    }

            	    	
	            toolbarhtml+="<td width='150' id='page"+(r+1)+"' bgcolor='#336699' height='31' align='center' "+bkimg +" style=\"border-right: 1px solid #808080; border-top: 1px solid #808080; border-bottom: 1px solid #808080\"><p align='center'>
			<a href='javascript:show_right("+(r+1)+",\""+topic +"\");'>	<font color='#333333'>"+name+"</font></a>　</td>\r";
							              
		
	   }
	   toolbarhtml+="<td  height='31' bgcolor='#EEEEEE' align='center'  style='border-bottom: 1px solid #808080'><p align='left'>
			&nbsp;</td>\r"; //

	   // 生成查询条件
	   sql = "select id ,name ,refmod ,control ,keyval ,defval ,wher ,seq 
            	   from
            		   (
            		select id id,name,refmod ,control ,keyval,defval,wher,seq
			 from dim_dim
			where refmod='"+FORMGUID+"'
			  and NVL(control,' ') <> 'DATEBOX' 
			union all
			select 'STA'||id id,'开始'||name name,refmod ,control ,keyval ,'' defval,'' wher,0 seq 
			 from dim_dim
			where refmod='"+FORMGUID+"'
			  and control = 'DATEBOX' 
			union all
			select 'END'||id id,'截止'||name name, refmod,control, keyval,'' defval,'' wher,1 seq			
		        from dim_dim
			where refmod='"+FORMGUID+"'
			  and control = 'DATEBOX' 
		 )
	         order by seq";

		    ds = db.QuerySQL(sql);
		    
	            ret += "<table border='0' width='100%' cellspacing='0' cellpadding='0' height='100%'>

				<tr>
					<td height=30 align = 'left'  background=\"xlsgrid/images/xlsgrid/tab.bg.on.grid.gif\" style=\"font-size:14px;border-top:1px solid #80B7E0;cursor:pointer;\" > 
					<table cellspacing=0 cellpadding=0 border=\"0\" width=\"100%\">	<tr>		<td width=\"24\" align=center><img src='xlsgrid/images/toolbar/search.gif' border=0></td>		<td align=\"left\"><font size=\"2px\" color = \"#000080\">组合查询条件</font></td>	</tr></table>
					</td>
				</tr>
				<tr> ";
		    ret += "<td valign=top>";
	            ret +="<form name = f1 method='post' action='show.sp?grdid=BIMain' Target='_right'> \n";
	            var resetstr = "";
	            for ( var i=0;i<ds.getRowCount();i++ ) {
	            	resetstr+= "try{document.all('"+ds.getStringAt(i,"ID")+"').value='';}catch(e){}";
	            }
	            GHtml = xmldsform.HtmlForm(request,ds,"NAME","ID","KEYVAL","","Y","Y","DEFVAL","WHER","CONTROL","0","50");
	            ret += GHtml;
	            ret += "<input type = 'hidden' id = 'sytid' name = 'sytid' value = "+SYTID+">
            		    	<input type = 'hidden' id = 'row' name = 'row' value =1>
            		    	<input type = 'hidden' id = 'topic' name = 'topic' value = ''>
            		    	<input type = 'hidden' id = 'FORMGUID' name = 'FORMGUID' value = "+FORMGUID+"> ";
            		    	     				
            		ret+=" 	<table width='100%' border='0' cellpadding='0' cellspacing='1' >
            			<tr>
            		    		<td></td>
            		   		<td align = 'center'>
            		   		<input type = 'submit' value = ' 查 询 ' >&nbsp;<input type = 'button' value = ' 重 置 ' onclick='javascript:f_reset();' ></td>
            		   
            			</tr>
            	    		</table>
	            	
	            	 </td></tr></table>
	            	 ";// </form>
	        
	   ret += "";	//</td></tr></table> 

	  var optionstr = "";
	  var optionds = db.QuerySQL("select * from v_charttype");
            
            for(var r = 0;r <optionds .getRowCount();r ++)
            {	//有多少个主题
            	    var id = optionds .getStringAt(r,"ID");
            	    var typ = optionds .getStringAt(r,"typ");
            	    var name = optionds .getStringAt(r,"name");
            	    optionstr+="<option value='"+id+"-"+typ+"'>"+name+"</option>";
	   }

						
	    var initparam = "";
	    var map = request.getParameterMap();
	    var keys  = map .keySet().iterator();
	    while(keys.hasNext())
	    {
	      var _varNam = ""+keys.next();
	      var _valVal = request.getParameter(_varNam);
	      //过长的参数不自动加入javascript中
	      initparam += "\n f_chgvalue(\""+_varNam+ "\",\"" +_valVal+ "\"); " ;
	    }

	  var lefthtml = ret; ret= "";
	
	    ret="	<html>
	    			<LINK rel=stylesheet type=text/css HREF='xlsgrid/css/main.css'>
	    			<script language='javascript' src='xlsgrid/js/main.js' ></Script>
	    			<script language='javascript' src='xlsgrid/images/flash/FusionCharts.js' ></Script>
				<head>
				<meta http-equiv='Content-Type' content='text/html; charset=gb2312'>
				
				<STYLE>
    						.navPoint {
						COLOR: #225f98; CURSOR: hand; FONT-FAMILY: 'Webdings'; FONT-SIZE: 9pt
						}
				</STYLE>
				<script>
					function switchLBar()
					{
						if (LPoint.innerText==3)
						{
							LPoint.innerText=4;
							leftTd.style.display ='none'; 
    							leftTd.style.width = 10;
						}
						else
						{
							LPoint.innerText=3;
							leftTd.style.display=''; 
   							leftTd.style.width = 220;
						}
					}
					function switchRBar()
					{
						if (RPoint.innerText==4)
						{
							RPoint.innerText=3;
							rightTd.style.display ='none'; 
    							rightTd.style.width = 10;
						}
						else
						{
							RPoint.innerText=4;
							rightTd.style.display=''; 
   							rightTd.style.width = 400;
						}
					}

					function switchLangBar(){
					        if (document.all('w_langbar').style.display!='none'){
					          document.all('w_langbar').style.display='none';
					          langtext.innerHTML = '&nbsp;动态新闻>> &nbsp';
					        }
					        else{
					          document.all('w_langbar').style.display='';
					          langtext.innerHTML = '<<&nbsp;';
					
					        }
					      }
					      function hideLangBar(){
					        if (document.all('w_langbar').style.display!='none'){
					          switchLangBar();
					        }
					      }
					      function showLangBar(){
					        if (document.all('w_langbar').style.display=='none'){
					          switchLangBar();
					        }
					      }
					      function switchScrollTextBar(){
					
					        if (document.all('w_scrolltextbar').style.display!='none'){
					        
					          document.all('w_scrolltextbar').style.display='none';
					          scrolltext.innerHTML = '&nbsp;动态通知>> &nbsp';
					        }
					        else{
					       
					          document.all('w_scrolltextbar').style.display='';
					          scrolltext.innerHTML = '<<&nbsp;';
					
					        }
					      }
					      function hideScrollTextBar(){
					        if (document.all('w_scrolltextbar').style.display!='none'){
					          switchLangBar();
					        }
					      }
					      function showScrollTextBar(){
					        if (document.all('w_scrolltextbar').style.display=='none'){
					          switchLangBar();
					        }
					      }
					      
					      function SetToolbar(url){
					        _toolbar.location=url;
					      }
					      
					      
					      var curPage = 1; 
					       // 切换页面的触发事件
					    function show_right(rnPage,topic){
					      nPage=rnPage;
					      document.all('page'+curPage).background='xlsgrid/images/xlsgrid/tab.bg.off.grid.gif';
					      document.all('page'+nPage).background='xlsgrid/images/xlsgrid/tab.bg.on.grid.gif';
					    

					      document.all.f1.topic.value=topic;
					      document.all.f1.row.value=rnPage;
						
					      f1.submit();
					     
					      document.all('page'+curPage).style.borderBottomStyle ='solid';
					      document.all('page'+nPage).style.borderBottomStyle ='none';
					      curPage = nPage;
					    }	
					    
					    //修改查询条件的值
					    function f_chgvalue(paramid, val ) {
					    	try{document.all(paramid).value = val;}catch ( e ) {alert ( e ) ;}
					    }	
					    function f_submit( ){
					    	 f1.submit();

					    }	
					    function f_reset()
					    {
					    	"+resetstr+"
					    
					    }
//					    var g_chart1 = new FusionCharts('xlsgrid/images/flash/MSColumn3D.swf', 'ChartId1', '400', '300');
//					    var g_chart2 = new FusionCharts('xlsgrid/images/flash/Pie3D.swf', 'ChartId2', '400', '300');
										   //chart1.setDataURL('xlsgrid/images/flash/MSColumn3D.xml');		   
										
										   //chart2.setDataURL('xlsgrid/images/flash/Pie3D.xml');		   
										   //chart2.render('chartdiv2');
										
					    //更新分析图1
					    var chartxml1 = '';
					    var chartxml2 = '';
					    var charttype = 'MSColumn3D';
					    var chartdatatype = '1';
					    function f_setchartxml1(xml){	//多维度的XML格式
					    	chartxml1  = xml;
					    }	 
					    function f_setchartxml2(xml){	//多维度的XML格式
					    	chartxml2  = xml;
					    }	 
					    function f_chgchart()
					    {
   					    	var swf = document.all('chgchart').value;
					    	var ss = swf.split('-');
					    	var chart1 = new FusionCharts('xlsgrid/images/flash/'+ss[0]+'.swf', 'ChartId1', '400', '300'); 
					    	chartdatatype  = ss[1];
					    	if ( ss[1]=='1') 
					            chart1.setDataXML(chartxml1  );
					        else     chart1.setDataXML(chartxml2  );

					        chart1.render('chartdiv1');
					    }
					    function f_getcharttype()
					    {
					    	return document.all('chgchart').value;

					    }
					    function f_getchartxml1()
					    {
					    	return chartxml1  ;

					    }
					    function f_getchartxml2()
					    {
					    	return chartxml2;

					    }
					    function f_showpath(tip){
					    	document.all('pathtip').innerHTML= tip;
					    
					    }
					    //树状结构跳转到某个主题
					    function f_scrolltotopic(topic){
					    	
					    	frames[1].f_scrolltotopic ( topic ) ;
					    
					    }
					    function zoomchart()
					    {
					    	window.open( 'BIPath.sp','','fullscreen=yes,toolbar=no,menubar=no,scrollbars=no,resizable=yes,location=no,status=no');
					    }
					    function win_onload(){
					    	"+initparam+"
					    	
					    	 show_right(1,\""+firsttopic+"\" );
					    
					    }
						

				</script>
				</head> 
				<body  topmargin='0' leftmargin='0' scroll=no onload='javascript:win_onload();'>
				
					<table border='0' width='100%' cellspacing='0' cellpadding='0' height='100%'>
						<tr>
							<td id=leftTd width=220 background=xlsgrid/images/tree_bg.jpg>
			       					"+lefthtml +"	 
			       					 	  
							</td>
			    				<TD  class=navPoint id=LPoint bgColor=#F3FCF6 onclick=switchLBar() style='border:1px solid #CCCCCC;WIDTH: 3pt;vertical-align: middle;'>
			      					3
			    				</TD>
							<td>
								<table border='0'  width='100%' cellspacing='0' cellpadding='0' height='100%'>
								<tr height=25>
								<td bgcolor='#CEDFF2' background=xlsgrid/images/xlsgrid/tab.bg.grid.png>
								   <table border='0'  cellspacing='0' cellpadding='0' height='100%' width='100%'>
								   <tr>"+toolbarhtml+"
							            </tr>
								  </table>
								</td>
								</tr>

								<tr><td>
									<table width=100% height=100% border='0' cellspacing='0' cellpadding='0' >
									<tr><td >
					        			<IFRAME name='_right' id='_right' frameBorder=0 width='100%' height='100%' border='0'
					        				scrolling='yes' style='border: 0px solid #808080' >
					        			</IFRAME>	
					        			</td>
					        			<TD  class=navPoint id=RPoint bgColor=#EEEEEE onclick=switchRBar() style='border-right: 1px solid #CCCCCC; border-left: 1px solid #CCCCCC; WIDTH: 3pt;vertical-align: middle;'>
						      					4
						    				</TD>

					        			<td id=rightTd width=400>
					        				<table width=100% height=100% border='0' cellspacing='0' cellpadding='0' >
					        				<tr><td height=30 align=center background=xlsgrid/images/xlsgrid/tab.bg.off.grid.gif>
					        				更换图型：&nbsp;<select id=chgchart size='1' name='chgchart' onchange='f_chgchart();' style='border: 1px solid #808080'>
					        				"+optionstr+"
					        				</select>
					        				&nbsp;<a href='javascript:zoomchart();'>放大图</a>
					        				</td></tr>

					        				<tr><td height=300 valign=top>

					        				<div id='chartdiv1' align='center'> &nbsp; </div>
								      		
										</td></tr>
										
					        				<tr><td height=30 align=left background=xlsgrid/images/xlsgrid/tab.bg.off.grid.gif>
					        					<div id='pathtip'>&nbsp;</div>
					        				</td></tr>


										<tr><td valign=top>
										<IFRAME name='_grid' id='_grid' frameBorder=0 width='100%' height='100%' border='0' src='show.sp?grdid=BIPath&modguid="+FORMGUID+"'
						        				scrolling='yes' style='border: 0px solid #808080' >
						        			</IFRAME>

					        				
								      		
										</td></tr>

										
					        			</td>
				        			
				        			</td></tr>

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
            throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
      return ret ;
}





}