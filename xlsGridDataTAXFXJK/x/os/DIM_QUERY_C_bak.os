function x_DIM_QUERY_C_bak(){function SelectDetail()
{
	var sql = "";
	var db = null;
	var dim = "";
	var target = "";
	var isCross = false;

	try {
		db = new pub.EADatabase();
		isCross = isCrossReport(db,sytid,topic);
		if (!isCross) 
		{
			sql = "select " 
				+ getVdim(db,sytid,topic) + ","
				+ getTarget(db,sytid,topic,true) 
				+ "\n from "
				+ getSourceName(db,sytid,topic)
				+ "\n where "
				+ getSearchParam(db,sytid,topic,request)
				+ "\n group by "
				+ getVdim(db,sytid,topic)
				+ "\n order by "
				+ getVdim_orders(db,sytid,topic);
		}
		else {
			sql = "select " 
				+ getVdim(db,sytid,topic) + "," 
				+ colDate2Char(db,sytid,topic,getTarget(db,sytid,topic,false)) 
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
		var ds = db.QuerySQL(sql);
		return ds.GetXml();
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
	var sql = "select sourceds from dim_model where guid=(select refmod from dim_topic where sytid='%s' and id='%s')".format([sytid,topic]);
	return db.GetSQL(sql);
}

//取得维度
function getDimesion(db,sytid,topic)
{
	var sql = "select id from dim_dim where refmod=(select refmod from dim_topic where sytid='%s' and id='%s') order by seq".format([sytid,topic]);
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

//垂直方向维度的排序方式
function getVdim_orders(db,sytid,topic)
{
	var sql = "select vdim,orders from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
//	var vdim = db.GetSQL(sql);
	var vdim = db.QuerySQL(sql);
	var vdims = "";

	var orders = vdim.getStringAt(0,"orders");
	var vdim = vdim.getStringAt(0,"vdim");
	if(orders == "2")
	{
		if(vdim.indexOf(",") > -1)
		{
			vdim = vdim.split(",");
			
			for(var r = 0;r < vdim.length() ;r ++)
			{	
				if(r == 0)
					vdims = vdim[r]+" desc";
				else
					vdims += ","+vdim[r]+" desc";
			}
		}
		else
			vdims = vdim+" desc";
	}
	else
		vdims = vdim;

	return vdims;
}

//垂直方向维度
function getVdim(db,sytid,topic)
{
	var sql = "select vdim from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	var vdim = db.GetSQL(sql);
	return vdim;
}
//日期类型的转为字符型 select dat,itmid from -> select to_char(dat,'yyyy-mm-dd') dat,itmid from 
function colDate2Char(db,sytid,topic,cols)
{
	var retdim = "";
	var arrcols = cols.split(",");
	var incols = pub.EAFunc.SQLIN(cols);
	var sql = "select * from dim_dim where refmod=(select refmod from dim_topic where sytid='%s' and id='%s') and id in (%s)".format([sytid,topic,incols]);
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

//取得目标值
function getTarget(db,sytid,topic,sumflg)
{
	var sql = "select hdim from dim_topic where sytid='%s' and id='%s'".format([sytid,topic]);
	if (!sumflg) {
		return db.GetSQL(sql);
	}
	else {
		var hdim = db.GetSQL(sql);
		var arr_tar = hdim.split(",");
		var sumtar = "";
		for (var i=0;i<arr_tar.length();i++) {
			if (i == 0) {
				sumtar = "sum(" + arr_tar[i] + ") " + arr_tar[i];
			}
			else {
				sumtar += ",sum( " + arr_tar[i] +") " + arr_tar[i];
			}
		}
		return sumtar;
	}
}

//查询条件
function getSearchParam(db,sytid,topic,request)
{
	var sql = "select * from dim_dim where refmod=(select refmod from dim_topic where sytid='%s' and id='%s') order by seq".format([sytid,topic]);
	var dimxmlds = db.GetXMLSQL(sql);
	var where = " 1=1 ";

	for (var i=0;i<dimxmlds.getRowCount();i++){
		var id = dimxmlds.getStringAt(i,"ID");
		var name = dimxmlds.getStringAt(i,"NAME");
		var datatyp = dimxmlds.getStringAt(i,"DATATYP");
		var val = pub.EAFunc.NVL(request.getParameter(id),"");
		var dat1 = "";
		var dat2 = "";

		if (datatyp == "DATE") {
			dat1 = pub.EAFunc.NVL(request.getParameter(id+"1"),"");
			dat2 = pub.EAFunc.NVL(request.getParameter(id+"2"),"");
			
			where += " and " + id + ">=to_date(decode('"+dat1+"','','1900-01-01','"+dat1+"'),'yyyy-mm-dd') \n"
				+ " and " + id + "<=to_date(decode('"+dat2+"','','2900-01-01','"+dat2+"'),'yyyy-mm-dd') \n";
		}
		else {
			where += " and nvl("+id+",' ') like '"+val+"%' \n";
		}
	}
	return where;
}

//是否交叉
function isCrossReport(db,sytid,topic)
{
	var sql = "select a.hdim,b.id from dim_topic a,dim_dim b where a.refmod=b.refmod and a.id='%s' and a.sytid='%s' and a.hdim like '%'||b.id||'%'".format([topic,sytid]);
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
	var sql = "select a.hdim,b.id from dim_topic a,dim_dim b where a.refmod=b.refmod and a.id='%s' and a.sytid='%s' and a.hdim like '%'||b.id||'%'".format([topic,sytid]);
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
function getColSQL(db,sytid,topic,vcol)
{
	var sql = "select keyval,wher from dim_dim where refmod=(select refmod from dim_topic where sytid='%s' and id='%s') and id='%s'".format([sytid,topic,vcol]);
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
}