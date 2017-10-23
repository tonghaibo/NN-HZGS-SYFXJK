function TAXFXJK_FX0227(){var pub = new JavaPackage("com.xlsgrid.net.pub");

//替换SQL参数
function replaceParam(mwobj,request,sql)
{
	//return "select * from temp_fx0227";
	var db = null;
	try {
		var db = new pub.EADatabase();
		
		//获取查询参数
		var ym1 = pub.EAFunc.Replace(request.getParameter("YM1"),"-","");
		var ym2 = pub.EAFunc.Replace(request.getParameter("YM2"),"-","");
		var maxje = 10000 * request.getParameter("MAXJE");
		var swjg = request.getParameter("ZGSWJG");

		var jeStr = "";
		var sumStr = "";
		var jeStrCol = "";
		var sumStrCol = "";
		var whereCol = "";
		
		var mysql = "select months_between(to_date('"+ym2+"','yyyymm'),to_date('"+ym1+"','yyyymm'))+1 months from dual";
		var months = 1*db.GetSQL(mysql);
		if (months < 3) {
			return "查询条件的起始年月与截止年月间隔必须大于3个月以上！";
		}
		for (var i=0;i<months;i++) {
			var mm = db.GetSQL("select to_char(add_months(to_date('"+ym1+"','yyyymm'),"+i+"),'yyyymm') months from dual");
			jeStrCol += ",je"+(i+1);
			if (jeStr == "") {
				jeStr += "\nsum(decode(kpyf,'"+mm+"',je,0)) je"+(i+1);
			}
			else {
				jeStr += "\n,sum(decode(kpyf,'"+mm+"',je,0)) je"+(i+1);
			}
		}
		
		for (var i=1;i<=months-2;i++) {
			//(je1+je2+je3) je13,
			var ss = "(je"+i+"+je"+(i+1)+"+je"+(i+2)+") je"+i+""+(i+2)+"\n";
			
			sumStrCol += ",je"+i+""+(i+2);
			
			if (whereCol == "") whereCol += " je"+i+""+(i+2)+">"+maxje;
			else whereCol += " or je"+i+""+(i+2)+">"+maxje;
			
			if (sumStr == "") {
				sumStr += ss;
			}
			else {
				sumStr += "," + ss;
			}

		}
		
		mysql = "select rownum rn,t.* from (
			  select a.* from (
			       select (select name from v_swjg sw where xf_qxswjg_dm=sw.id||'00') xf_qxswjg_dm,
			       xfsbh,xfmc,xfdzdh,xfyhzh" + jeStrCol +"\n"+ sumStrCol + "
			  from (
			    select xf_qxswjg_dm,xfsbh,xfmc,xfdzdh,xfyhzh" + jeStrCol + ",\n" + sumStr + "       
			    from (
			      select xf_qxswjg_dm,xfsbh,max(xfmc) xfmc,max(xfdzdh) xfdzdh,max(xfyhzh) xfyhzh,
			            "+ jeStr +"\n
			      from (    
			        select fpdm,fphm,xfsbh,xfmc,xfdzdh,xfyhzh,kprq,je,se,jshj,kpr,skr,fhr,kpyf,
			               xf_sjswjg_dm, xf_dsswjg_dm,xf_qxswjg_dm,gf_sjswjg_dm,gf_dsswjg_dm,gf_qxswjg_dm
			      from DZDZ_FPXX_PTFP
			        where fpzt_dm='0' 
			          and zfbz='N' 
			          and KJLX_DM='1'
			          and xf_qxswjg_dm like '"+swjg+"%'
			          and kpyf>='"+ym1+"'
			          and kpyf<='"+ym2+"'
			      ) group by xf_qxswjg_dm,xfsbh
			    ) 
			  ) 
			  where "+ whereCol +"			  
			) a,tax_company b,dj_nsrxx n
			where a.xfsbh=b.id(+) 
			  and b.djxh=n.djxh(+)
			  and n.djzclx_dm in (select djzclx_dm from DM_DJ_DJZCLX start with djzclx_dm='400' connect by prior djzclx_dm=sjdjzclx_dm)
			order by xf_qxswjg_dm,xfsbh
			) t ";
		return mysql;
	}
	catch(e) {
		if (db != null) db.Rollback();
		//return "err="+e.toString();
		return "";
	}
	finally {
		if (db != null) db.Close();
	}
}

}