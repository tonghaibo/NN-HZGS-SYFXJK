function x_DIMREP_PC(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var web = new JavaPackage("com.xlsgrid.net.web");
var grd = new JavaPackage("com.xlsgrid.net.grd");
//�滻SQL����
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
		throw new pub.EAException("��Ҫ����һ������Ų���");
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
				+ " ,'˫��' ��ȡ����"
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
			var r_HCols = getVdim(db,sytid,topic);		//�������ֶ�	
			var r_VCols = getCrossCol(db,sytid,topic);	//�������ֶ�
			var r_VCol = getCrossTarget(db,sytid,topic);	//����ֵ�ֶ�
			var colsql = getColSQL(db,sytid,topic,r_VCols);	//�������ֶ�SQL
			var orderby = "";				//�������ֶ�
			sql = pub.EASqlFunc.GetSql2CrossTableSQL(db,sql,colsql,r_HCols,r_VCols,r_VCol,orderby);
		}

		pub.EAFunc.Log("BI SQL="+sql);

		return sql;
	}
	catch(e){
		pub.EAFunc.Log(e.toString() );
		db.Rollback();
		throw new pub.EAException(e.toString());
	}
	finally {
		if (db != null) db.Close();
	}
}

//ȡ��ģ�����ݷ���Դ   
function getSourceName(db,sytid,topic)
{
	var sql = "select sourceds from dim_model where guid=(select refmod from dim_topic where sytid='%s' and id='%s' )".format([sytid,topic]);
	return db.GetSQL(sql);
}

//ȡ��ά��
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

//��ֱ����ά��
function getVdim(db,sytid,topic)
{
	var sql = "select vdim from dim_topic where sytid='%s' and id='%s' ".format([sytid,topic]);
	var vdim = db.GetSQL(sql);
	
	return vdim;
}
//��ֱ����ά�ȴ�������
function getVdimWithName(db,sytid,topic,modguid,tablename)
{
	var sql = "select vdim from dim_topic where sytid='%s' and id='%s' ".format([sytid,topic]);
	
	var vdim = db.GetSQL(sql);
	//��ȡ�ֶ�����
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
//�������͵�תΪ�ַ��� select dat,itmid from -> select to_char(dat,'yyyy-mm-dd') dat,itmid from 
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
			ds = db.QuerySQL("select name from dim_target where refmod='"+modguid+"' and UPPER(id)=UPPER('"+colid+"') ");
			
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
//ȡ��Ŀ��ֵ
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
	pub.EAFunc.Log( str );
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
				if(arr_tar[i].indexOf("ë����") > -1)
				{
					sumtar += ",decode(sum("+arr_tar[i-8]+"),0,0,round(sum(" + arr_tar[i-4] + ")/sum("+arr_tar[i-8] + "),2)) " + colnam;
				}
				else if(arr_tar[i].indexOf("������") > -1)
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

//��ѯ����  
function getSearchParam(db,sytid,topic,request)
{
	var sysdate = db.GetSQL("select to_char(sysdate,'yyyy-mm-dd') from dual");
	var sql = "select * from dim_dim where refmod=(select refmod from dim_topic where sytid='%s' and id='%s' ) order by seq".format([sytid,topic]);
	
//	throw new Exception(sql);
	var dimxmlds = db.GetXMLSQL(sql);
	var where = " 1=1 ";
	
	var row = pub.EAFunc.NVL(request.getParameter("row"),"0");
	row = "";//��ȡ�������ѯ���������
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

//�Ƿ񽻲�
function isCrossReport(db,sytid,topic)
{
	var sql = "select a.hdim,b.id from dim_topic a,dim_dim b where a.refmod=b.refmod and a.id='%s' and a.sytid='%s'  and a.hdim like '%'||b.id||'%'".format([topic,sytid]);
	var rowcnt = db.GetSQLRowCount(sql);
	if (rowcnt > 0) return true;
	return false;
}

//ȡ�ý������ֶ�
function getCrossCol(db,sytid,topic)
{
	var sql = "select b.id from dim_topic a,dim_dim b where a.refmod=b.refmod and a.id='%s' and a.sytid='%s' and a.hdim like '%'||b.id||'%'".format([topic,sytid]);
	return db.GetSQL(sql);
}

//����ֵ�ֶ�
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

//�������ֶ�SQL
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

//����˲�ѯ�����ݺ󣬸��м��һ���ӹ����ݵĻ���
function filterXmlDS(dataSrcID,dataSrc)
//var dataSrc = new EAXmlDS();
{


	if (dataSrcID == "MAIN") { 
		dataSrc.AddTitleRow();
		//pub.EAFunc.Log(dataSrc.GetXml());
	}
}
function getQueryString()
//var dataSrc = new EAXmlDS();
{
	return request.getQueryString();
}

//ҳ��BODY������Ϻ��¼�
//sb������bodyԪ�ؼ�ǰ���head����
//bodysb������body��innerHTML
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
	var ret2 = "";//��������Ĳ���
	var ret3 = "";//��ʵ������仯�Ĳ���
	var db = null;
	var dat = "";
	var hdim  = "";
	var vdim = "";
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
				ret1 += colid +"��"+value+"  ";
			}
			if(key.indexOf("sytid")>-1||key.indexOf("FORMGUID")>-1||key.indexOf("grdid")>-1)
				ret2 += key.substring(0,key.length())+"="+value+" ";
			else if(key.indexOf("topic")==-1)
				ret3 += key.substring(0,key.length())+"="+value+" ";
		}
		
		var ds =db.QuerySQL("select vdim, hdim from dim_topic where refmod='"+modguid +"'  and id='"+topic +"' and sytid = '"+sytid +"'");
		if ( ds.getRowCount()>0 ) {
			hdim = ds.getStringAt(0,"hdim" );
			vdim = ds.getStringAt(0,"vdim" );			
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
	sb.append("<script >var G_HDIV=\""+hdim +"\"</script>");
	sb.append("<script >var G_VDIV=\""+vdim +"\";</script>");

}

//��ȡ�ĺ���
function ExtData()
{
	var params1 = "";
	var params = "";
	var db = null;
	var ds = null;
	var value = "";
	var pa = "";
	//����һ������arr�����ڴ��ҳ��Ĳ���
	//���Ԥ���ǰ������ڲ�ѯ�Ļ����Ǿ��ǿ�ʼ�ͽ�ֹ���ڣ���ҪΪÿһ�е����ڣ����򣬾��ǲ�������������
	var arr = new Array();
	try
	{
		db = new pub.EADatabase();
		params1 = allparam2.split(" ");
		//_r��ʾĿǰ�����row,
		//��ǰ�ı����ǰ���ʲô����ѯ�ģ����������жϿ�ʼ�ͽ�ֹ������Ϊÿһ�е��������ݻ��ǲ�������������
		ds = db.QuerySQL("select * from v_dimtopic where r = to_number("+_r+")");
		if(ds.getRowCount() > 0)
		{
			var vdim = ds.getStringAt(0,"VDIM");
			if(vdim.indexOf("DAT") > -1||vdim.indexOf("����") > -1)
			{
				pa =  "STA"+vdim+_row+"="+item+"&END"+vdim+_row+"="+item;	
				arr.push(pa);
				for(var r = 0;r < params1.length();r ++)
				{
					if(params1[r].indexOf("row") > -1)
					{
						var vs = params1[r].split("=");
						pa = vs[0]+"="+_row;
						arr.push(pa);//����push���������ݷŽ�arr������
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
}