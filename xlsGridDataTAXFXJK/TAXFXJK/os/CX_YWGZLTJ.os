function TAXFXJK_CX_YWGZLTJ(){var pub = new JavaPackage("com.xlsgrid.net.pub");

function GetDataXML()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		
		//登记状态代码
		var sql = "select * from DM_GY_NSRZT where nsrzt_dm in (
			select nsrzt_dm from dj_nsrxx 
		        where zgswj_dm like '14511%'
			  and ((to_char(lrrq,'yyyy-mm-dd')>='[%DAT1]' and to_char(lrrq,'yyyy-mm-dd')<='[%DAT2]')
		          or (to_char(xgrq,'yyyy-mm-dd')>='[%DAT1]' and to_char(xgrq,'yyyy-mm-dd')<='[%DAT2]'))
		          and( zgswskfj_dm='[%ZGSWJG]' 
				  /*包括下级税务机关*/
				  or (zgswskfj_dm in (select swjg_dm from DM_GY_SWJG start with swjg_dm='[%ZGSWJG]' connect by prior swjg_dm=sjswjg_dm)
			  ))
			) order by nsrzt_dm";
		sql = pub.EAFunc.Replace(sql,"[%DAT1]",DAT1);
		sql = pub.EAFunc.Replace(sql,"[%DAT2]",DAT2);
		sql = pub.EAFunc.Replace(sql,"[%ZGSWJG]",ZGSWJG);
		var nsrztds = db.QuerySQL(sql);
		var nsrztsql = "";
		for (var i=0;i<nsrztds.getRowCount();i++) {
			var nsrzt_dm = nsrztds.getStringAt(i,"NSRZT_DM");
			var nsrztmc = nsrztds.getStringAt(i,"NSRZTMC");
			nsrztsql += "sum(decode(typ,'TJ1',decode(tjlb,'"+nsrzt_dm+"',tj_cnt,0),0)) as \"DJ_"+nsrztmc+"\",\n";
		}
		
		//征收项目代码
		sql = "select * from DM_GY_ZSXM where zsxm_dm in (
			select distinct zsxm_dm from (
			select a.djxh,a.pzxh,a.zgswskfj_dm,a.zsxm_dm,a.gzlx_dm_1,a.lrr_dm,a.lrrq,a.xgr_dm,a.xgrq,
			       decode(sign(xgrq-lrrq),1,nvl(xgr_dm,'未知'),lrr_dm) czy_dm 
			from SB_SBXX a 
			where a.zgswskfj_dm like '14511%'
			  and ( (to_char(a.lrrq,'yyyy-mm-dd')>='[%DAT1]' and to_char(a.lrrq,'yyyy-mm-dd')<='[%DAT2]')
			       or (to_char(a.xgrq,'yyyy-mm-dd')>='[%DAT1]' and to_char(a.xgrq,'yyyy-mm-dd')<='[%DAT2]')
			    )
			  and( zgswskfj_dm='[%ZGSWJG]' 
				  /*包括下级税务机关*/
				  or (zgswskfj_dm in (select swjg_dm from DM_GY_SWJG start with swjg_dm='[%ZGSWJG]' connect by prior swjg_dm=sjswjg_dm)
			  ))
			)) order by zsxm_dm";
		sql = pub.EAFunc.Replace(sql,"[%DAT1]",DAT1);
		sql = pub.EAFunc.Replace(sql,"[%DAT2]",DAT2);
		sql = pub.EAFunc.Replace(sql,"[%ZGSWJG]",ZGSWJG);
		var zsxmds = db.QuerySQL(sql);
		var zsxmsql = "";
		for (var i=0;i<zsxmds.getRowCount();i++) {
			var zsxm_dm = zsxmds.getStringAt(i,"ZSXM_DM");
			var zsxmjc = zsxmds.getStringAt(i,"ZSXMJC");
			zsxmsql += "sum(decode(typ,'TJ2',decode(tjlb,'"+zsxm_dm+"',tj_cnt,0),0)) as \"SB_"+zsxmjc+"\",\n";
		}
		
		//代开发票类别代码
		sql = "select * from DM_FP_DKFPLB where dkfplb_dm in (
			select dkfplb_dm from FP_DK_SQ 
		        where slswjg_dm like '14511%'
			  and ((to_char(lrrq,'yyyy-mm-dd')>='[%DAT1]' and to_char(lrrq,'yyyy-mm-dd')<='[%DAT2]')
		          or (to_char(xgrq,'yyyy-mm-dd')>='[%DAT1]' and to_char(xgrq,'yyyy-mm-dd')<='[%DAT2]'))
		          and( slswjg_dm='[%ZGSWJG]' 
				  /*包括下级税务机关*/
				  or (slswjg_dm in (select swjg_dm from DM_GY_SWJG start with swjg_dm='[%ZGSWJG]' connect by prior swjg_dm=sjswjg_dm)
			  ))
			) order by dkfplb_dm";
		sql = pub.EAFunc.Replace(sql,"[%DAT1]",DAT1);
		sql = pub.EAFunc.Replace(sql,"[%DAT2]",DAT2);
		sql = pub.EAFunc.Replace(sql,"[%ZGSWJG]",ZGSWJG);
		var dkfplbds = db.QuerySQL(sql);
		var dkfplbsql = "";
		for (var i=0;i<dkfplbds.getRowCount();i++) {
			var dkfplb_dm = dkfplbds.getStringAt(i,"DKFPLB_DM");
			var dkfplbmc = dkfplbds.getStringAt(i,"DKFPLBMC");
			dkfplbsql += "sum(decode(typ,'TJ4',decode(tjlb,'"+dkfplb_dm+"',tj_cnt,0),0)) as \"DKFP_"+dkfplbmc+"\",\n";
		}
		
		var datasql = "select trim(swjg_dm)||'-'||swjg_mc swjg,
				       czy_dm,swryxm,
				       [%NSRZTSQL]
				       [%ZSXMSQL]
				       [%DKFPLBSQL]
				       sum(decode(typ,'TJ3',decode(tjlb,'FPFX',tj_cnt,0),0)) as \"FPFS_发票发售\"
				from (
				select t.swjg_dm,
				       aa.swjgmc swjg_mc,
				       t.czy_dm,
				       (select swryxm from DM_GY_SWRY s where trim(s.swry_dm)=trim(t.czy_dm)) swryxm,
				       t.tjlb,
				       t.tj_cnt,
				       t.typ
				from 
				(
				/*1.登记信息工作量统计*/
				select zgswj_dm swjg_dm,czy_dm,nsrzt_dm tjlb,count(*) tj_cnt,'TJ1' typ
				from (       
				  select djxh,zgswj_dm,
				         decode(bg_xgr_dm,null,decode(sign(xgrq-lrrq),1,nvl(xgr_dm,'未知'),lrr_dm),bg_xgr_dm) czy_dm,
				         nsrzt_dm,nsrztmc
				  from (       
				  select a.djxh,a.nsrsbh,a.shxydm,a.nsrmc,a.djrq,a.lrr_dm,a.lrrq,a.xgr_dm,a.xgrq,a.sjgsdq,a.zgswj_dm,
				         a.nsrzt_dm,b.nsrztmc,c.bgxm_dm,c.lrr_dm bg_llr_dm,c.lrrq bg_lrrq,c.xgr_dm bg_xgr_dm,c.xgrq bg_xgrq
				  from dj_nsrxx a,dm_gy_nsrzt b,
				       (select * from DJ_BGDJMX
				        where (to_char(lrrq,'yyyy-mm-dd')>='[%DAT1]' and to_char(lrrq,'yyyy-mm-dd')<='[%DAT2]')
				          or (to_char(xgrq,'yyyy-mm-dd')>='[%DAT1]' and to_char(xgrq,'yyyy-mm-dd')<='[%DAT2]')
				       ) c
				  where a.nsrzt_dm=b.nsrzt_dm and a.djxh=c.djxh(+)
				    and a.zgswj_dm like '14511%'
				    and ( (to_char(a.lrrq,'yyyy-mm-dd')>='[%DAT1]' and to_char(a.lrrq,'yyyy-mm-dd')<='[%DAT2]')
				       or (to_char(a.xgrq,'yyyy-mm-dd')>='[%DAT1]' and to_char(a.xgrq,'yyyy-mm-dd')<='[%DAT2]')
				    ) 
				  )  
				) group by zgswj_dm,czy_dm,nsrzt_dm
				
				union all
				
				/*2.申报工作量统计*/
				select slswjg_dm,czy_dm,zsxm_dm,count(distinct djxh) sb_cnt,'TJ2' typ
				from (
				select a.djxh,a.pzxh,b.slswjg_dm,a.zsxm_dm,a.gzlx_dm_1,a.lrr_dm,a.lrrq,a.xgr_dm,a.xgrq,
				       decode(sign(a.xgrq-a.lrrq),1,nvl(a.xgr_dm,'未知'),a.lrr_dm) czy_dm 
				from SB_SBXX a ,SB_SBB b
				where a.sbuuid=b.sbuuid and b.slswjg_dm like '14511%'
				  and ( (to_char(a.lrrq,'yyyy-mm-dd')>='[%DAT1]' and to_char(a.lrrq,'yyyy-mm-dd')<='[%DAT2]')
				       or (to_char(a.xgrq,'yyyy-mm-dd')>='[%DAT1]' and to_char(a.xgrq,'yyyy-mm-dd')<='[%DAT2]')
				    )
				) group by slswjg_dm,czy_dm,zsxm_dm
				
				union all
				
				/*3.发票发售工作量统计*/
				select slswjg_dm,czy_dm,'FPFX' fpfx_dm,count(*) fpfs_cnt,'TJ3' typ
				from (       
				select a.djxh,a.slswjg_dm,a.lrr_dm,a.lrrq,a.xgr_dm,a.xgrq,
				       decode(sign(xgrq-lrrq),1,nvl(xgr_dm,'未知'),lrr_dm) czy_dm  
				from fp_ly a
				where slswjg_dm like '14511%'
				  and ( (to_char(a.lrrq,'yyyy-mm-dd')>='[%DAT1]' and to_char(a.lrrq,'yyyy-mm-dd')<='[%DAT2]')
				       or (to_char(a.xgrq,'yyyy-mm-dd')>='[%DAT1]' and to_char(a.xgrq,'yyyy-mm-dd')<='[%DAT2]')
				    )
				) group by slswjg_dm,czy_dm
				
				union all
				
				/*4.发票代开工作量统计*/
				select slswjg_dm,czy_dm,dkfplb_dm,count(distinct djxh) fpdk_cnt,'TJ4' typ
				from (       
				select a.djxh,a.dkfplb_dm,slswjg_dm,a.lrr_dm,a.lrrq,a.xgr_dm,a.xgrq,
				       decode(sign(xgrq-lrrq),1,nvl(xgr_dm,'未知'),lrr_dm) czy_dm 
				from FP_DK_SQ a
				where slswjg_dm like '14511%'
				  and ( (to_char(a.lrrq,'yyyy-mm-dd')>='[%DAT1]' and to_char(a.lrrq,'yyyy-mm-dd')<='[%DAT2]')
				       or (to_char(a.xgrq,'yyyy-mm-dd')>='[%DAT1]' and to_char(a.xgrq,'yyyy-mm-dd')<='[%DAT2]')
				    )
				) group by slswjg_dm,czy_dm,dkfplb_dm
				
				) t,DM_GY_SWJG aa where t.swjg_dm=aa.swjg_dm
				) 
				where swjg_dm='[%ZGSWJG]' 
				  /*包括下级税务机关*/
				  or (swjg_dm in (select swjg_dm from DM_GY_SWJG 
				     start with swjg_dm='[%ZGSWJG]' connect by prior swjg_dm=sjswjg_dm)
				  )
				group by swjg_dm,swjg_mc,czy_dm,swryxm
				order by swjg_dm,swjg_mc,czy_dm";

		datasql = pub.EAFunc.Replace(datasql,"[%NSRZTSQL]",nsrztsql);
		datasql = pub.EAFunc.Replace(datasql,"[%ZSXMSQL]",zsxmsql);	
		datasql = pub.EAFunc.Replace(datasql,"[%DKFPLBSQL]",dkfplbsql);
		datasql = pub.EAFunc.Replace(datasql,"[%DAT1]",DAT1);
		datasql = pub.EAFunc.Replace(datasql,"[%DAT2]",DAT2);
		datasql = pub.EAFunc.Replace(datasql,"[%ZGSWJG]",ZGSWJG);
		
		//throw new Exception (datasql);
		var ds = db.QuerySQL(datasql);
		return ds.GetXml();
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