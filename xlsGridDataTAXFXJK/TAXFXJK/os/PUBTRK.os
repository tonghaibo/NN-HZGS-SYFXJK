function TAXFXJK_PUBTRK(){var pub = new JavaPackage ( "com.xlsgrid.net.pub" );
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );

//权限检查
function checkGenTask()
{
	//具有税收核算股角色
	var sql = "select * from usrrol where usr=(select guid from usr where id='"+usrid+"' and org='"+thisorgid+"')
		and rol in (select guid from rol where id='02' and org='"+thisorgid+"')";
	return pub.EADbTool.GetSQLRowCount(sql);
}

//权限检查
function checkGenTask2()
{
	//具有税收核算股角色
	var sql = "select * from usrrol where usr=(select guid from usr where id='"+usrid+"' and org='"+thisorgid+"')
		and rol in (select guid from rol where id='04' and org='"+thisorgid+"')";
	return pub.EADbTool.GetSQLRowCount(sql);
}

//二期生成核实任务方法
//param.usrids		//生成任务的用户编号
//param.usrnams 	//用户名称
//param.accids 		//帐套号
//param.orgs	        //组织号
//param.syts            //系统号
//param.typ             //任务类型
//param.yymm1	   	//税款所属期
//param.yymm2		//税款所属期
//param.swjg_dm		//税务机构代码
//param.toswjg		//分派到的股室
//param.enddat		//任务截止日期
//param.tousr		//任务分派到的税管员
//param.note		//任务说明
//param.xmlstr		//任务明细行
//param.typ		//任务类型
//param.subtyp		//风险类型
function createTask()
{
	var db = null;
	var ds = null;
	var sql = "";
	var ret = 0;
	//return xmlstr;
	
	try {		
		db = new pubpack.EADatabase();
		var ds = new pubpack.EAXmlDS(xmlstr);
		for (var i=0;i<ds.getRowCount();i++) {
			var bilid =db.GetBillid(accids,"TK","TK");  //生成单据号
			var nsrsbh = ds.getStringAt(i,"NSRSBH");	
			var nsrmc = ds.getStringAt(i,"NSRMC");
			var fxdj = ds.getStringAt(i,"FXDJ");
			var cyje = ds.getStringAt(i,"CYJE");
			var mynote = ds.getStringAt(i,"NOTE");
			mynote += "\n\n"+note;
			//判断纳税企业是否已生成过核实任务，不重复生成		
			sql = "select * from tax_trkhdr where cmid='"+nsrsbh+"' and nvl(yymm1,' ')=nvl('"+yymm1+"',' ') and nvl(yymm2,' ')=nvl('"+yymm2+"',' ')";
			var count = db.GetSQLRowCount(sql);	
			if (count == 0) {
				if(tousr == ""){
					sql = "select taxman from tax_company where id='"+nsrsbh+"'";
					var tmpds = db.QuerySQL(sql);
					if (tmpds.getRowCount() > 0) {
						tousr = tmpds.getStringAt(0,"TAXMAN");
					}
				}
				
				var newtyp = "";
				var stat = "1";
				sql = "insert into tax_trkhdr(ACC,ORG,SYT,BILID,CRTUSR,CRTUSRNAM,CMID,CMNAM,todept,Tousr,SUBTYP,yymm1,yymm2,dat,stat,enddat,note,newtyp,typ,fxdj,swjg_dm,cyje)
					values('%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s','%s',trunc(sysdate),'%s',to_date('%s','yyyy-mm-dd'),'%s','%s','%s','%s',substr('%s',0,7),'%s')"
					.format([accids,orgs,syts,bilid,usrids,usrnams,nsrsbh,nsrmc,toswjg,tousr,subtyp,yymm1,yymm2,stat,enddat,mynote,newtyp,typ,fxdj,swjg_dm,cyje]); 
				ret += db.ExcecutSQL(sql);
				
			}
		}

		db.Commit();		
		return "成功生成"+ret+"条任务!";


	}
	catch(e){
		if(db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if(db != null)	db.Close();
	}
}




}