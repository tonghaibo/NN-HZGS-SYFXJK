function x_Billmain(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );

// 首页的登录信息
function LoginInfo()
{
	var ret= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var usrid = usrinfo.getUsrid();
	var usrorgid = usrinfo.getusrOrg();
	var db = null;
	ret = "欢迎您，"+usrinfo.getUsrnam()+"<BR>";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sql = "select * from( select to_char(crtdat,'MM/DD HH24:MI') tim from usrlog where usrid='"+usrid +"' and org='"+usrorgid +"' and action='登录系统' order by crtdat desc) where rownum<=2 ";
		var ds =db.QuerySQL(sql);
		if ( ds.getRowCount() > 1 ) {
			ret+="您最后一次登录时间是"+ds.getStringAt(1,"TIM") +"<BR>";
		}
		sql = " select count(*) CNT from OALOG where usrid='"+usrid +"' and org='"+usrorgid +"' and ( mwtyp='TRKDTL1' or mwtyp='TRKHDR') and to_char(crtdat,'YYMM')=to_char(sysdate,'YYMM')  ";
		ds =db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			ret+="本月事务处理量"+ds.getStringAt(0,"CNT") +"条 ";
		}
		sql = " select count(*) CNT from OALOG where usrid='"+usrid +"' and org='"+usrorgid +"' and to_char(crtdat,'YYMM')=to_char(sysdate,'YYMM') ";
		ds =db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			ret+="活跃度"+ds.getStringAt(0,"CNT") +"<BR>";
		}
		sql = " select to_char(crtdat,'HH24:MI') TIM from SIGNIN where usrid='"+usrid +"' and org='"+usrorgid +"' and to_char(crtdat,'YYMMDD')=to_char(sysdate,'YYMMDD') order by crtdat asc";
		ds =db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			ret+="今天"+ds.getStringAt(0,"TIM")+"已签到<BR>";
		}
		else 
			ret+="<a href=\"show.sp?grdid=TRK_SIGNIN\"  target=_blank><font color='#FF0000'>您今天没签到，点击签到</font></a>";
		//ret+="&nbsp;";
		//ret+="<form name='fsearch' action='Layout.sp'>&nbsp;<input id=\"query\" style='COLOR: #aaaaaa;border: 1px solid #0A246A; font-family:宋体; font-size:9pt' onfocus=\"if(document.all('query').value=='请输入...')document.all('query').value='';\" size=\"18\" value=\"请输入...\" onclick=\" if(this.value=='请输入...')this.value=''\" name=\"query\">&nbsp;<a href=\"#\" onclick=\"fsearch.submit();\">开始搜索</a>";
		//ret+="<a href=\"#\" onclick=\"fsearch.submit();\">开始搜索</a><input type='hidden' name ='id' value='SearchTrk'>";
		//ret+="<input type='hidden' name ='encoding' value='UTF-8'></form>";
		//		ret+="<form name='fsearch' action='Layout.sp'>&nbsp;<input id=\"query\" style='COLOR: #aaaaaa;border: 1px solid #0A246A; font-family:宋体; font-size:9pt' onfocus=\"if(document.all('query').value=='请输入...')document.all('query').value='';\" size=\"18\" value=\"请输入...\" onclick=\" if(this.value=='请输入...')this.value=''\" name=\"query\">&nbsp;<a href=\"#\" onclick=\"fsearch.submit();\">开始搜索</a><input type='hidden' name ='id' value='SearchTrk'><input type='hidden' name ='ignoreencoding' value='1'><input type='hidden' name ='encoding' value='UTF-8'></form>";

	
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}


	return ret;
}

}