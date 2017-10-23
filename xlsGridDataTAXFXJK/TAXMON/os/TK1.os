function TAXMON_TK1(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var web = new JavaPackage("com.xlsgrid.net.web");

function WorkeFlowAction(request,db,formguid,stat,tostat)
{
	var usrinfo = web.EASession.GetLoginInfo(request);
	var usrid = usrinfo.getUsrid();
   	var accid = usrinfo.getAccid();
   	var orgid = usrinfo.getOrgid();
   	var sytid = usrinfo.getSytid();  
   	
  	var sql = "";
  	//1未分派 2已分派 3已处理 9完成 8分派到股室 0退回
  	if (tostat == 2) {
  		sql = "update tax_trkhdr set chkusr='"+usrid+"',chkdat=sysdate where guid='"+formguid+"'";
  		db.ExcecutSQL(sql);
   	}
   	else if (tostat == 3) {
  		sql = "update tax_trkhdr set redat=sysdate where guid='"+formguid+"'";
  		db.ExcecutSQL(sql);
   	}
   	else if (tostat == 1) {
  		sql = "update tax_trkhdr set tousr=null,chkdat=null,chkusr=null,chkusrnam=null where guid='"+formguid+"'";
  		db.ExcecutSQL(sql);
   	}
   	else if (tostat == 9) {
   		//检查是否还存在异常
   		var ret = checkTrk(formguid);
   		if (ret == "1") {
   			throw new Exception(" 【核实任务还有异常，不能结束任务！】");
   		}
   	}
}   	

//返回单据列表的查询SQL
function getListSql(request,selectsql, where, orderby)
//var request=javax.servlet.http.HttpServletRequest();
{
	var usrinfo = web.EASession.GetLoginInfo(request);
	var usrid = usrinfo.getUsrid();
   	var accid = usrinfo.getAccid();
   	var orgid = usrinfo.getOrgid();
   	var sytid = usrinfo.getSytid();  
	var sql = "";
	//throw new Exception(selectsql);
	sql = selectsql + where + " and (crtusr='"+usrid+"' or tousr=(select name from usr where org='"+orgid+"' and id='"+usrid+"'))";
	
	return sql;
}

function check()
{
	return checkTrk(formguid);
}

function checkTrk(formguid)
{
	var db = null;
	var sql = "";
	try {
		db = new pub.EADatabase();
		var ds = db.QuerySQL("select * from tax_trkhdr where guid='"+formguid+"'");
		var trktyp = ds.getStringAt(0,"SUBTYP");
		var yymm1 = ds.getStringAt(0,"YYMM1");
		var yymm2 = ds.getStringAt(0,"YYMM2");
		var cmid = ds.getStringAt(0,"CMID");
		
		//电力税负异常
		if (trktyp == "3") {
			sql = "select * from (
				select '' flag,'2010-06'||'~'||'2012-07' YYMM,a.id,a.name,sum(eleqty) eleqty,envload,sum(ens) ens,
				       sum(somny) somny,sum(ens-somny) cz,Ytaxman,taxman 
				from (
				select b.id,sum(a.eleqty) eleqty,nvl(round(sum(a.eleqty/c.envload*avgsale),2),0) ens,c.envload,
				   decode(b.Ytaxman,'1','是','否') ytaxman,b.taxman,b.name
				from tax_eledata a,tax_company b,tax_compclass c
				where a.usrid=b.ammno and b.Typclsid=c.id 
				  and a.YYMM between '"+yymm1+"' and '"+yymm2+"'
				  and b.id='"+cmid+"'
				group by b.id,b.name,b.Ytaxman,b.taxman,c.envload 
				) a,(select id,sum(somny) somny from tax_taxdata where YYMM between '"+yymm1+"' and '"+yymm2+"' group by id) d
				where a.id=d.id
				group by a.id,a.name,envload,ytaxman,taxman
				)
				where nvl(somny,0) < ens";
			var retdst = db.QuerySQL(sql);
			return retds.getRowCount();
		}
		//电力税额异常
		else if (trktyp == "7") {
			sql = "select flag,yymm,id,name,eleqty,rate,ens,taxmny,ens-taxmny cx,ytaxman,taxman from (
				select '' flag,'2010-09'||'~'||'2012-07' YYMM,a.ID,a.name,sum(eleqty) eleqty,rate,sum(ens) ens,sum(b.taxmny) taxmny,Ytaxman,taxman 
				from (
				select b.id,b.name,sum(a.eleqty) eleqty,decode(b.ytaxman,'1',e.rate1,e.rate2) rate,
				   case when ytaxman = '1' then round(sum(a.eleqty)*rate1,2)
				     else round(sum(a.eleqty)*rate2,2) end as ens,decode(b.Ytaxman,'1','是','否') ytaxman,b.taxman 
				   from tax_eledata a,tax_company b,tax_compclass c,tax_eletaxdef e
				   where a.usrID=b.ammno 
				   and b.Typclsid=c.id
				   and c.id =e.hyid and b.id='"+cmid+"'
				   and a.YYMM between '"+yymm1+"' and '"+yymm2+"'
				   group by b.taxman,b.name,b.id,b.ytaxman,rate1,rate2
				) a,(select id,sum(taxmny) taxmny from tax_taxdata where YYMM between '"+yymm1+"' and '"+yymm2+"' group by id) b
				where a.id=b.id
				group by a.ID,a.name,rate,Ytaxman,taxman 
				) where taxmny < ens ";
			var retdst = db.QuerySQL(sql);
			return retds.getRowCount();

		}
		
		return "0";
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

}