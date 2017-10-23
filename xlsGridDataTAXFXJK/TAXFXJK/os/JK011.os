function TAXFXJK_JK011(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//检查并生成监控数据
function checkAndGenTableData()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var sql = "select count(*) from tax_fxjk_mtkpjedy80w where kprq=to_char(sysdate-1,'yyyy-mm-dd')";
		var cnt = 1*db.GetSQL(sql);
		if (cnt == 0) {
			sql = "insert into tax_fxjk_mtkpjedy80w(xh,djxh,nsrsbh,nsrmc,kprq,ppje,zpje,kpje,nsrzt_dm,nsrzt,
				hy_dm,hy,djzclx_dm,djzclx,SSGLY_DM,ssgly,zgswjg_dm,zgswjg,zgswskfj_dm,zgswskfj)
				select rownum xh,dj.djxh,xfsbh,xfmc,kprq,ppje,zpje,kpje,
				  dj.nsrzt_dm,
				  (select nsrztmc from  DM_GY_NSRZT zt where dj.nsrzt_dm=zt.nsrzt_dm) nsrzt,
				  dj.hy_dm,
				  (select hymc from DM_GY_HY hy where dj.hy_dm=hy.hy_dm and hy.yxbz='Y') hy,
				  dj.djzclx_dm,
				  (select djzclxmc from DM_DJ_DJZCLX zclx where zclx.djzclx_dm=dj.djzclx_dm) djzclx, 
				  dj.SSGLY_DM,
				  (select swryxm from DM_GY_SWRY swry where swry.swry_dm=dj.SSGLY_DM) ssgly,
				  substr(dj.zgswskfj_dm,1,7) zgswjg_dm,
				  (select name from v_swjg sw where sw.id=substr(dj.zgswskfj_dm,1,7)) zgswjg,
				  dj.zgswskfj_dm,
				  (select swjgmc from DM_GY_SWJG jg where dj.zgswskfj_dm=jg.swjg_dm) zgswskfj 
				from (
				  select xfsbh,xfmc,kprq,sum(decode(kplx,'普票',kpje,0)) ppje,sum(decode(kplx,'专票',kpje,0)) zpje,sum(kpje) kpje
				  from (
				  select '专票' kplx, xfsbh,xfmc,to_char(kprq,'YYYY-MM-DD') kprq ,sum(je) kpje
				  from dzdz.dzdz_fpxx_zzsfp@dzdz a 
				  where xf_dsswjg_dm  like '14511%'
				  and to_char(kprq,'yyyy-mm-dd')=to_char(sysdate-1,'yyyy-mm-dd')
				  and  a.ZFBZ!='Y'
				  group by xfsbh,xfmc,kprq
				
				  union all
				
				  select '普票' kplx,xfsbh,xfmc,to_char(kprq,'YYYY-MM-DD') kprq ,sum(je) kpje
				  from dzdz.dzdz_fpxx_ptfp@dzdz a 
				  where xf_dsswjg_dm  like '14511%'
				  and to_char(kprq,'yyyy-mm-dd')=to_char(sysdate-1,'yyyy-mm-dd')
				  and  a.ZFBZ!='Y'
				  group by xfsbh,xfmc,kprq
				  ) 
				  where xfmc not like '%国家税务局%' 
				    and xfmc not like '%地方税务局%' 
				    and xfmc not like '%地税局%' 
				    and xfmc not like '%代开%'
				  group by xfsbh,xfmc,kprq
				  having sum(kpje)>=80*10000
				)kp,tax_company cp,dj_nsrxx dj
				where kp.xfsbh=cp.id(+) and cp.djxh=dj.djxh
				  and kp.xfsbh not in (select nsrsbh from TAX_FPFX_HCB where flag='0')
				  and dj.nsrzt_dm in ('01','02','03','04')";
			db.ExcecutSQL(sql);
			
			//修改为可以在后台任务计划里每天定时自动执行
			var typ = "1";
			var subtyp = "01";
			var accids = "GXHZ";
			var orgs = "GXHZ";
			var syts = "TAXFXJK";
			var toswjg = "";
			var tousr = "";
			var yymm1 = db.GetSQL("select to_char(sysdate,'yyyy-mm') from dual");
			var yymm2 = yymm1;
			
			//同时生成核实任务推送
			sql = "select * from tax_fxjk_mtkpjedy80w where kprq=to_char(sysdate-1,'yyyy-mm-dd')";
			var ds = db.QuerySQL(sql);
			for (var i=0;i<ds.getRowCount();i++) {
				var xh = ds.getStringAt(i,"XH");
				var nsrsbh = ds.getStringAt(i,"NSRSBH");
				var nsrmc = ds.getStringAt(i,"NSRMC");
				var zgswjg = ds.getStringAt(i,"ZGSWJG_DM");	
				toswjg = zgswjg;
				
				//根据推送人员的配置表进行消息推送
				sql = "select usrid from tax_fxjk_msgtouser where typ='01' and swjg='"+zgswjg+"'";
				var usrds = db.QuerySQL(sql);
				if (usrds.getRowCount() > 0) {
					tousr = usrds.getStringAt(0,"USRID");
				}
				
				var bilid =db.GetBillid(accids,"TK","TK");  //生成单据号
				var mynote = "天开票总金额大于80万";
				var newtyp = "SYSTEM";
				var stat = "2"; //直接推送给设置的人员 
				var fxdj = "高";
				var guid = db.GetSQL("select sys_guid() from dual");
				
				sql = "insert into tax_trkhdr(GUID,ACC,ORG,SYT,BILID,CRTUSR,CRTUSRNAM,CMID,CMNAM,todept,Tousr,SUBTYP,yymm1,yymm2,dat,stat,enddat,note,newtyp,typ,swjg_dm,fxdj)
					select '%s','%s','%s','%s','%s','%s','%s',nsrsbh,nsrmc,'%s','%s','%s','%s','%s',trunc(sysdate),'%s',null,'%s','%s','%s',zgswjg_dm,'%s'
					from tax_fxjk_mtkpjedy80w
					where kprq=to_char(sysdate-1,'yyyy-mm-dd')
					  and xh='%s'
					  and nsrsbh not in (select cmid from tax_trkhdr where to_char(dat,'yyyy')=to_char(sysdate,'yyyy') and stat!='9')"
					.format([guid,accids,orgs,syts,bilid,"SYSTEM","系统生成",toswjg,tousr,subtyp,yymm1,yymm2,stat,mynote,newtyp,typ,fxdj,xh]); 
				var rst = db.ExcecutSQL(sql);
				if (rst > 0) {
					//同时生成发票风险提示核查表
					sql = "insert into TAX_FPFX_HCB(NSRSBH,NSRMC,TRKGUID) values('%s','%s','%s')".format([nsrsbh,nsrmc,guid]);	
					db.ExcecutSQL(sql);
				}
			}
			
			db.Commit();
			
			return "执行完成";
		}
		return "ok";
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}

//弹出消息提醒框
function showMessage(request)
{
	var usrinfo = web.EASession.GetLoginInfo(request);
	var usrid = usrinfo.getUsrid();
	var swjg = usrinfo.getDeptId();
	var sql = "select count(decode(stat,'1',1,null)) stat1, 
		       count(decode(stat,'2',1,'3',1,'31',1,'32',1,null)) stat2
		from tax_trkhdr 
		where swjg_dm in (select id from v_swjg where id='"+swjg+"' or sjid='"+swjg+"')
		  --and tousr='"+usrid+"'
		  and tousr like (case when '"+swjg+"'!='1451100' then '"+usrid+"' else '%' end)";
	var ds = pub.EADbTool.QuerySQL(sql);
	if (ds.getRowCount() > 0) {
		var stat1 = ds.getStringAt(0,"stat1");
		var stat2 = ds.getStringAt(0,"stat2");
		if (stat1 == 0 && stat2 == 0) return "";
		var msg = "";
		var title = "未推送任务数："+stat1+"<br>应对任务数："+stat2+"<br><br>请到风险管理模块进行处理";	
		var html = "<script language='javascript' src='xlsgrid/js/message.js'></script>";	
		html += "<SCRIPT language=JavaScript>";		
		html += "var MSG1 = new CLASS_MSN_MESSAGE('msg',260,160,'消息提醒','"+title+"','');
		    	     MSG1.rect(null,null,null,screen.height-50);
			     MSG1.speed    = 100; 
			     MSG1.step    = 15; 
			     MSG1.oncommand = function(){ 
				this.hide(); 
				//window.open('show.sp?grdid=TKDTL&STAT=1,8');
			     } 
			     MSG1.show(); ";					     
		html += "</SCRIPT>";
		
			
		return html;
	}
	return "";
}


//在Head区引用额外脚本
function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	var mssage = showMessage(request);
	sb.append(mssage);
}

}