function x_WG_EBILL(){function getPaginationXML()
{
   var runsql = getSelSQL(sqltitle);
   var db=new pubpack.EADatabase();
   var xmlID = db.GetXMLSQL(runsql,pageno,pagesize).GetXml();
   var xmlds = new pubpack.EAXmlDS(xmlID);
   xmlds.removeColumn("num");
   xmlds.removeColumn("RID_");
   var xml = xmlds.GetXml();
   return xml;	
}

function getSelSQL(sqltitle)
{
	var sql = "";
	if (sqltitle.equals("Main"))		
		sql = "select ordid,ecorpid,ecorpnam,decode(nvl(stat,'0'),'1','已处理','未处理') stat,dat,arrdat,bilid order by dat,ecorpid,ordid";
	return sql;
}
}