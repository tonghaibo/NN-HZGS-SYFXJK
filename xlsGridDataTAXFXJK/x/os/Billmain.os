function x_Billmain(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );

// ��ҳ�ĵ�¼��Ϣ
function LoginInfo()
{
	var ret= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var usrid = usrinfo.getUsrid();
	var usrorgid = usrinfo.getusrOrg();
	var db = null;
	ret = "��ӭ����"+usrinfo.getUsrnam()+"<BR>";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		var sql = "select * from( select to_char(crtdat,'MM/DD HH24:MI') tim from usrlog where usrid='"+usrid +"' and org='"+usrorgid +"' and action='��¼ϵͳ' order by crtdat desc) where rownum<=2 ";
		var ds =db.QuerySQL(sql);
		if ( ds.getRowCount() > 1 ) {
			ret+="�����һ�ε�¼ʱ����"+ds.getStringAt(1,"TIM") +"<BR>";
		}
		sql = " select count(*) CNT from OALOG where usrid='"+usrid +"' and org='"+usrorgid +"' and ( mwtyp='TRKDTL1' or mwtyp='TRKHDR') and to_char(crtdat,'YYMM')=to_char(sysdate,'YYMM')  ";
		ds =db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			ret+="������������"+ds.getStringAt(0,"CNT") +"�� ";
		}
		sql = " select count(*) CNT from OALOG where usrid='"+usrid +"' and org='"+usrorgid +"' and to_char(crtdat,'YYMM')=to_char(sysdate,'YYMM') ";
		ds =db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			ret+="��Ծ��"+ds.getStringAt(0,"CNT") +"<BR>";
		}
		sql = " select to_char(crtdat,'HH24:MI') TIM from SIGNIN where usrid='"+usrid +"' and org='"+usrorgid +"' and to_char(crtdat,'YYMMDD')=to_char(sysdate,'YYMMDD') order by crtdat asc";
		ds =db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			ret+="����"+ds.getStringAt(0,"TIM")+"��ǩ��<BR>";
		}
		else 
			ret+="<a href=\"show.sp?grdid=TRK_SIGNIN\"  target=_blank><font color='#FF0000'>������ûǩ�������ǩ��</font></a>";
		//ret+="&nbsp;";
		//ret+="<form name='fsearch' action='Layout.sp'>&nbsp;<input id=\"query\" style='COLOR: #aaaaaa;border: 1px solid #0A246A; font-family:����; font-size:9pt' onfocus=\"if(document.all('query').value=='������...')document.all('query').value='';\" size=\"18\" value=\"������...\" onclick=\" if(this.value=='������...')this.value=''\" name=\"query\">&nbsp;<a href=\"#\" onclick=\"fsearch.submit();\">��ʼ����</a>";
		//ret+="<a href=\"#\" onclick=\"fsearch.submit();\">��ʼ����</a><input type='hidden' name ='id' value='SearchTrk'>";
		//ret+="<input type='hidden' name ='encoding' value='UTF-8'></form>";
		//		ret+="<form name='fsearch' action='Layout.sp'>&nbsp;<input id=\"query\" style='COLOR: #aaaaaa;border: 1px solid #0A246A; font-family:����; font-size:9pt' onfocus=\"if(document.all('query').value=='������...')document.all('query').value='';\" size=\"18\" value=\"������...\" onclick=\" if(this.value=='������...')this.value=''\" name=\"query\">&nbsp;<a href=\"#\" onclick=\"fsearch.submit();\">��ʼ����</a><input type='hidden' name ='id' value='SearchTrk'><input type='hidden' name ='ignoreencoding' value='1'><input type='hidden' name ='encoding' value='UTF-8'></form>";

	
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