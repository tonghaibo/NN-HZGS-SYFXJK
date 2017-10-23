function TAXMON_TaxData(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );
var timepack = new JavaPackage( "com.xlsgrid.net.time" );

function insert()
{
	var db = null ;
	var ds = null ;
	var ps = null;
	var sql = "";
	var ret = 0;
	
	try {		
		db = new pubpack.EADatabase();
		
		//加载xmlDS
		var excelgrid = new xlsdb.excelgrid();
		for (var sheet = 0;sheet <= 12;sheet++) {
			var xmlds = excelgrid.GetXmlDS(filename,sheet);	
			if (xmlds.getColumnCount() > 3) {
				var table =  db.GetSQL("select 'PG_'||TAX_NEXTVAL.nextval from dual");
				var params = "";
				var columns = "";

				//创建临时表		
				sql = "create table "+table+" (";
				for (var col = 0;col < xmlds.getColumnCount();col ++) {
					if (col > 0) sql += ",";
					sql += "CO"+col+" varchar2(255) \n";
					if (columns != "") columns += ",";
					columns += "CO"+col;
					if (params != "") params += ",";
					params += "?";
				}
				sql += ") ";
				db.ExcecutSQL(sql);
				
				//导入临时表
				//最后一列日期类型的 导入后变成了数字，如何转成日期？
				//to_char(to_date('19000101','yyyymmdd')+to_number(co5),'yyyy-mm') co5
				var updatesql = "insert into "+table+" ("+columns +") values ("+params+")";
				ps = db.GetConn().prepareStatement(updatesql);
				
				var rowcount = xmlds.getRowCount();
				for(var rows=0;rows<rowcount;rows++) {
					for(var cols=0;cols<xmlds.getColumnCount();cols++) {
						var colname=xmlds.getColumnName(cols);
						var colstr=xmlds.getStringAt(rows,colname);
						ps.setString(cols+1,colstr);
					}
					ps.addBatch();
				}
				ps.executeBatch();
				
				sql = "delete from " +table+ " where co0 is null or co0='纳税人识别号' or co1='纳税人识别号'";
				db.ExcecutSQL(sql);
				
				sql = "update " +table+ " set co5=to_char(to_date('19000101','yyyymmdd')+to_number(co5)-2,'yyyymmdd'),
					co6=to_char(to_date('19000101','yyyymmdd')+to_number(co6)-2,'yyyymmdd')";
				db.ExcecutSQL(sql);
				
				//写入正式目标表
//				sql = "update TAX_TAXDATA a set (SOMNY,TAXMNY,SDTAXMNY)=(
//					SELECT nvl(to_number(trim(co2)),0),nvl(to_number(trim(co3)),0),nvl(to_number(trim(co4)),0)
//					 from "+table+" b where a.id=b.co0 and a.yymm=to_char(to_date('19000101','yyyymmdd')+to_number(b.co5),'yyyy-mm'))
//					where exists (select 1 from "+table+" where a.ID=co0 and a.YYMM=to_char(to_date('19000101','yyyymmdd')+to_number(co5),'yyyy-mm'))";
//				db.ExcecutSQL(sql);
//				sql="INSERT INTO TAX_TAXDATA(YYMM,ID,NAME,SOMNY,TAXMNY,SDTAXMNY)
//					SELECT to_char(to_date('19000101','yyyymmdd')+to_number(co5),'yyyy-mm') co5,trim(co0),trim(co1),nvl(to_number(trim(co2)),0),nvl(to_number(trim(co3)),0),nvl(to_number(trim(co4)),0)
//				 	from "+table+" a where not exists(select 1 from TAX_TAXDATA where TAX_TAXDATA.ID=a.co0 and YYMM=to_char(to_date('19000101','yyyymmdd')+to_number(co5),'yyyy-mm'))";
//				ret += db.ExcecutSQL(sql);

				//先更新中间表tax_tmp_taxdata
				sql = "update tax_tmp_taxdata a set (xssr,sbzzse)=(select sum(nvl(to_number(trim(co2)),0)) somny,sum(nvl(to_number(trim(co3)),0)) taxmny from "+table+" b
						where a.nsrsbh=b.co0 and a.ssdat=to_date(b.co5,'yyyymmdd') and a.pzxh=b.co7 group by co0,co5,co7)
					where (nsrsbh,ssdat,pzxh) in (select co0,to_date(co5,'yyyymmdd'),co7 from "+table+")";
				db.ExcecutSQL(sql);
				sql = "insert into tax_tmp_taxdata(nsrsbh,nsrmc,xssr,ssdat,sbdat,sbzzse,pzxh,czry_mc)
          				select co0,co1,nvl(to_number(trim(co2)),0) somny,to_date(co5,'yyyymmdd') ssdat,to_date(co6,'yyyymmdd') sbdat,
						nvl(to_number(trim(co3)),0) taxmny,co7,co8 from "+table+"  
					where (co0,to_date(co5,'yyyymmdd'),co7) not in (select nsrsbh,ssdat,pzxh from tax_tmp_taxdata)";
				db.ExcecutSQL(sql);
//				db.Commit();
//				db = new pubpack.EADatabase();

				//再更新进正式表tax_taxdata
				ret = updateTaxData(db);

				
				//drop临时表
				sql = "drop table " + table;
				db.ExcecutSQL(sql);
			}
		}
		db.Commit();
		return "导入成功，记录数"+ret;
	}
	catch(e) {
		if(db != null) db.Rollback();
		pub.EAFunc.Log("导入税务数据文件出错"+e.toString());
		return e.toString();
	}
	finally {
		if(db != null) db.Close();
	}

}

function genbatch()
{
	var db = null;
	var jobseqid  = "";
	try {
		db = new pubpack.EADatabase();	
		jobseqid = jobid;
		var tim = new timepack.EARunOSTimer(); 
		tim.init(jobseqid,jobnam,"TAXMON","TaxData","syncTaxData", "jobid="+jobid+"&jobseqid="+jobseqid+"&dat1="+dat1+"&dat2="+dat2);
	}
	catch ( ee ) {
		throw new pub.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return jobseqid  ;// 返回后台分配的作业编号

}

var percent = 0;
//同步税务数据
function syncTaxData()
{
	var db = null ;
	var sql = "";
	var ret = 0;
	var ret1 = 0;
	var ret2 = 0;
	var tmptable1 = "";
	var tmptable2 = "";
	
	try {		
		db = new pubpack.EADatabase();
		tmptable1 = db.GetSQL("select 'TAX_TMPTAXDAT_'||to_char(sysdate,'hh24miss') from dual");
		tmptable2 = tmptable1 + "_2";
		sql = "create table "+tmptable1+" as 
			select bb.nsrsbh,utl_raw.cast_to_varchar2(bb.nsr_name) nsrmc,cc.xssr,cc.sbzzse,cc.sssq_Q,
			TO_DATE(substr(to_char(cc.sbrq,'YYYYMMDD'),1,8),'YYYYMMDD') sbdat,cc.pzxh,
			utl_raw.cast_to_varchar2(bb.czry_name) czry_mc from 
			(
			select a.nsrsbh,a.nsr_name,e.czry_name
			from v_tax_dj_nsrxx@taxdb a,v_tax_dm_czry@taxdb e
			where a.ZG_SWGY_DM=e.CZRY_DM
			and a.NSR_SWJG_DM like '1451101%'
			) bb,
			(
			select aa.nsrsbh,sum(aa.YZHWLWBHSXSE)xssr ,sum(aa.YNSE)sbzzse ,sssq_Q,sbrq,pzxh
			from 
			(select k.NSRSBH,k.YZHWLWBHSXSE,k.YBTSE,k.YNSE,k.SSSQ_Q,k.sbrq,k.pzxh
			from sb_zzs_xgmnsr_2005@taxdb k
			where 
			k.sbbl=1
			and k.bcsblx in('','0') 
			and k.yxbz='Y'
			--and k.sbrq>=to_date('"+dat1+"','YYYYMMDD')
			--and k.sbrq<=to_date('"+dat2+"','YYYYMMDD')
			and to_char(k.sbrq,'yyyy-mm')>='"+dat1+"'
			and to_char(k.sbrq,'yyyy-mm')<='"+dat2+"'
			and not exists 
			(select 1 from  sb_zzs_xgmnsr_2005@taxdb l 
			where l.scsbpzxh=k.pzxh)
			union all
			--2有补充申报
			select k.NSRSBH,k.YZHWLWBHSXSE,k.YBTSE,k.YNSE,k.SSSQ_Q,k.sbrq,k.pzxh
			from sb_zzs_xgmnsr_2005@taxdb k
			where 
			k.sbbl=1
			and k.bcsblx in('1','2')  
			and k.yxbz='Y'
			--and k.sbrq>=to_date('"+dat1+"','YYYYMMDD')
			--and k.sbrq<=to_date('"+dat2+"','YYYYMMDD')
			and to_char(k.sbrq,'yyyy-mm')>='"+dat1+"'
			and to_char(k.sbrq,'yyyy-mm')<='"+dat2+"'
			and not exists 
			(select 1 from  sb_zzs_xgmnsr_2005@taxdb l 
			where l.scsbpzxh=k.pzxh)
			) aa
			group by aa.nsrsbh,aa.SSSQ_Q,aa.sbrq,aa.pzxh
			) cc
			where bb.nsrsbh=cc.nsrsbh";
		
		percent = 20;
		notify(jobid,percent,"正在同步["+dat1+"~"+dat2+"]一般纳税人申报信息...","Run");//后台通知外部
		db.ExcecutSQL(sql);
		
		sql = "create table "+tmptable2+" as 
			select xx.nsrsbh,utl_raw.cast_to_varchar2(xx.nsr_name) nsrmc,qysf.xssr,qysf.sbzzse,qysf.SSSQ_Q,
			 TO_DATE(substr(to_char(qysf.sbrq,'YYYYMMDD'),1,8),'YYYYMMDD') sbdat,qysf.pzxh,
			 utl_raw.cast_to_varchar2(xx.czry_name) czry_mc from 
			(select S.nsrsbh,S.nsr_name,S.nsr_swjg_dm,h.czry_name
			      from v_tax_dj_nsrxx@taxdb S,DJ_NSRXX_KZ@taxdb T,v_tax_dm_czry@taxdb h
			      where  S.NSRSBH=T.NSRSBH
			          and s.ZG_SWGY_DM=h.CZRY_DM       
			) xx,   
			(select nsrsbh sbh,sum(sysl_xse + jyzs_xse)xssr ,sum(jxse) jxse,sum(YNSEHJ)sbzzse ,SSSQ_Q,pzxh,sbrq
			from
			(
			select a.nsrsbh,a.sysl_xse,a.jyzs_xse,a.ynsehj,a.JXSE,a.SSSQ_Q,pzxh,sbrq
			from sb_zzs_2003_ybnsr@taxdb a --正常申报
			where
			  not exists
			  (
			    select 1 from sb_zzs_2003_ybnsr@taxdb b
			    where
			      b.yxbz='Y'
			      and b.sbbl in ('1','3')
			      and b.bcsblx in ('1','2')
			      and b.sssq_q=a.sssq_q
			      and b.sssq_z=a.sssq_z
			      and b.nsrsbh=a.nsrsbh
			  )
			  and a.yxbz='Y'
			  and a.sbbl in ('1','3')
			  and (a.bcsblx='0' or a.bcsblx is null)
			  --and a.sbrq>=to_date('"+dat1+"','YYYYMMDD')
			  --and a.sbrq<=to_date('"+dat2+"','YYYYMMDD')
			  and to_char(a.sbrq,'yyyy-mm')>='"+dat1+"'
			  and to_char(a.sbrq,'yyyy-mm')<='"+dat2+"'			
			union all
			select a.nsrsbh,a.sysl_xse,a.jyzs_xse,a.ynsehj,a.JXSE,a.SSSQ_Q,pzxh,sbrq
			from sb_zzs_2003_ybnsr@taxdb a --补充申报
			where
			  not exists
			  (
			    select 1 from sb_zzs_2003_ybnsr@taxdb b
			    where
			      a.pzxh=b.scsbpzxh
			      and b.yxbz='Y'
			      and b.sbbl in ('1','3')
			      and b.bcsblx in ('1','2')   
			      and b.sssq_q=a.sssq_q
			      and b.sssq_z=a.sssq_z
			      and b.nsrsbh=a.nsrsbh
			  )
			  and a.yxbz='Y'
			  and a.sbbl in ('1','3')
			  and a.bcsblx in ('1','2') 
			  --and a.sbrq>=to_date('"+dat1+"','YYYYMMDD')
			  --and a.sbrq<=to_date('"+dat2+"','YYYYMMDD')
			  and to_char(a.sbrq,'yyyy-mm')>='"+dat1+"'
			  and to_char(a.sbrq,'yyyy-mm')<='"+dat2+"'
			) bb
			group by nsrsbh,SSSQ_Q,pzxh,sbrq
			) qysf
			where xx.nsrsbh=qysf.sbh
			   and xx.nsr_swjg_dm like '%1451101%'";
		percent = 50;
		notify(jobid,percent,"正在同步["+dat1+"~"+dat2+"]小规模纳税人申报信息...","Run");//后台通知外部
		db.ExcecutSQL(sql);

		percent = 60;
		notify(jobid,percent,"正在更新一般纳税人申报数据["+dat1+"~"+dat2+"]...","Run");//后台通知外部
		
		//先更新中间表tax_tmp_taxdata
		sql = "update tax_tmp_taxdata a set (xssr,sbzzse)=(select sum(xssr) somny,sum(sbzzse) taxmny from "+tmptable1+" b
				where a.nsrsbh=b.nsrsbh and a.ssdat=b.sssq_q and a.pzxh=b.pzxh group by nsrsbh,ssdat,pzxh)
			where (nsrsbh,ssdat,pzxh) in (select nsrsbh,sssq_q,pzxh from "+tmptable1+")";
		db.ExcecutSQL(sql);
		sql = "insert into tax_tmp_taxdata(nsrsbh,nsrmc,xssr,ssdat,sbdat,sbzzse,pzxh,czry_mc)
			select nsrsbh,nsrmc,xssr,sssq_q,sbdat,sbzzse,pzxh,czry_mc from "+tmptable1+" 
			where (nsrsbh,sssq_q,pzxh) not in (select nsrsbh,ssdat,pzxh from tax_tmp_taxdata)";
		db.ExcecutSQL(sql);

		percent = 70;
		notify(jobid,percent,"正在更新小规模纳税人申报数据["+dat1+"~"+dat2+"]...","Run");//后台通知外部

		sql = "update tax_tmp_taxdata a set (xssr,sbzzse)=(select sum(xssr) somny,sum(sbzzse) taxmny from "+tmptable2+" b
				where a.nsrsbh=b.nsrsbh and a.ssdat=b.sssq_q and a.pzxh=b.pzxh group by nsrsbh,ssdat,pzxh)
			where (nsrsbh,ssdat,pzxh) in (select nsrsbh,sssq_q,pzxh from "+tmptable2+")";
		db.ExcecutSQL(sql);
		sql = "insert into tax_tmp_taxdata(nsrsbh,nsrmc,xssr,ssdat,sbdat,sbzzse,pzxh,czry_mc)
			select nsrsbh,nsrmc,xssr,sssq_q,sbdat,sbzzse,pzxh,czry_mc from "+tmptable2+" 
			where (nsrsbh,sssq_q,pzxh) not in (select nsrsbh,ssdat,pzxh from tax_tmp_taxdata)";
		db.ExcecutSQL(sql);
		
		db.Commit();
		db = new pubpack.EADatabase();
		
		percent = 90;
		notify(jobid,percent,"正在更新正式库数据["+dat1+"~"+dat2+"]...","Run");//后台通知外部

		//再更新进正式表tax_taxdata
//		sql = "update tax_taxdata a set (somny,taxmny)=(
//		select somny,taxmny from (
//		  select nsrsbh,sum(xssr) somny,sum(sbzzse) taxmny,to_char(ssdat,'yyyy-mm') yymm
//		  from tax_tmp_taxdata group by nsrsbh,to_char(ssdat,'yyyy-mm')
//		) b where a.id=b.nsrsbh and a.yymm=b.yymm
//		) where (a.id,a.yymm) in (select nsrsbh,to_char(ssdat,'yyyy-mm') from tax_tmp_taxdata)";
//		ret1 += db.ExcecutSQL(sql);
//
//		percent = 90;
//		notify(jobid,percent,"正在写入正式库数据["+dat1+"~"+dat2+"]...","Run");//后台通知外部
//		
//		sql = "insert into tax_taxdata(yymm,id,name,somny,taxmny)
//		select to_char(ssdat,'yyyy-mm') yymm,nsrsbh,nsrmc,sum(xssr) somny,sum(sbzzse) taxmny
//		from tax_tmp_taxdata where (nsrsbh,to_char(ssdat,'yyyy-mm')) not in (select id,yymm from tax_taxdata)
//		group by to_char(ssdat,'yyyy-mm'),nsrsbh,nsrmc";
//		ret2 += db.ExcecutSQL(sql);
		
		ret += updateTaxData(db);

		db.Commit();
		percent = 100;
		notify(jobid,percent,"同步["+dat1+"~"+dat2+"]税务数据完成，记录数"+ret,"end");//后台通知外部
		
		return "同步完成，记录数"+ret;
	}
	catch(e) {
		if(db != null) db.Rollback();
		notify(jobid,percent,"同步过程出现异常："+e.toString(),"Run");//后台通知外部
		return e.toString();
	}
	finally {
		if(db != null) db.Close();
		try { if (tmptable1 != "") pub.EADbTool.ExcecutSQL("drop table " + tmptable1); } catch (e1) {}
		try { if (tmptable2 != "") pub.EADbTool.ExcecutSQL("drop table " + tmptable2); } catch (e2) {}
	}
}

//更新进正式表tax_taxdata
function updateTaxData(db)
{
	var ret = 0;
	var sql = "update tax_taxdata a set (somny,taxmny)=(
	select somny,taxmny from (
	  select nsrsbh,sum(xssr) somny,sum(sbzzse) taxmny,to_char(ssdat,'yyyy-mm') yymm
	  from tax_tmp_taxdata group by nsrsbh,to_char(ssdat,'yyyy-mm')
	) b where a.id=b.nsrsbh and a.yymm=b.yymm
	) where --(a.id,a.yymm) in (select nsrsbh,to_char(ssdat,'yyyy-mm') from tax_tmp_taxdata)
	exists (select 1 from tax_tmp_taxdata b where a.id=b.nsrsbh and a.yymm=to_char(b.ssdat,'yyyy-mm'))";
	ret += db.ExcecutSQL(sql);
	
	sql = "insert into tax_taxdata(yymm,id,name,somny,taxmny)
	select to_char(ssdat,'yyyy-mm') yymm,nsrsbh,nsrmc,sum(xssr) somny,sum(sbzzse) taxmny
	from tax_tmp_taxdata a
	where --(nsrsbh,to_char(ssdat,'yyyy-mm')) not in (select id,yymm from tax_taxdata)
	not exists (select 1 from tax_taxdata b where a.nsrsbh=b.id and to_char(a.ssdat,'yyyy-mm')=b.yymm)
	group by to_char(ssdat,'yyyy-mm'),nsrsbh,nsrmc";
	ret += db.ExcecutSQL(sql);
	return ret;
}


// 通知外部当前的运行情况
function notify(jobseqid,percent,note,stat)
{
	var db = null;
	if ( percent < 0 ) return "";
	try{
		db = new pubpack.EADatabase();
		note = pubpack.EAFunc.Replace( note, "'","‘" );
		var str = stat+" "+percent+"% "+note;
		db.ExcecutSQL("insert into log(str)values('"+str+"')");
		if(note==""){
			db.ExcecutSQL("update RunOSTimer set percent="+(percent) +",stat='"+stat+"' where id='"+jobseqid+"'");
		}
		else {
			db.ExcecutSQL("update RunOSTimer set percent="+(percent) +",percentnote='"+note+"',stat='"+stat+"' where id='"+jobseqid+"'");
			db.ExcecutSQL("insert into RunOSTimerDTL(id,name ) values('"+jobseqid+"','"+note+"')" );
		}
		db.Commit();
	}
	catch ( e ) {
		//pubpack.EAFunc.Log( e.toString() );
		db.Rollback();
		return "ERROR" ;
	}
	finally {
		if (db!=null) db.Close();
	}
	return "OK";
}
}