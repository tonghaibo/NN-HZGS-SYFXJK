function TAXFXJK_CHART006(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" ); 
var servletPack = new JavaPackage("com.xlsgrid.net.servlet");

//��Head�����ö���ű�
function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery-1.7.2.min.js\"></script>\n"); 
	sb.append("<script type=\"text/javascript\" src=\"xlsgrid/js/highcharts-3d.js\"></script>\n"); 
	sb.append("<script type=\"text/javascript\" src=\"xlsgrid/js/highcharts.js\"></script>\n"); 
	//sb.append("<script type=\"text/javascript\" src=\"xlsgrid/js/exporting.js\"></script>\n"); 

	//�������·ָ������ʾͼ��������ʾ�м������
	sb.append("<table border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\"><tr><td bgcolor=\"#EFEFEF\" align=center valign=middle>");
	sb.append("<table border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\" ><tr><td  style=\"border: 1px solid #EEEEEE\">");
	sb.append("<table id=\"dataTable\" border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\" ><tr>"); //���洰�ڸ߶�ռ�ı���
	sb.append("<td><span style='color:red'>��ע������ǰ�����������ݡ�</span></td><td align=right><button type='button' onclick='genData()'>��������</button>&nbsp;&nbsp;<button type='button' onclick='filter()'>ͳ������</button></td></tr><tr>");
	sb.append("<td width=50% height=100% style=\"border:solid 1px gray\" valign=top;><div id='chart1' style=\"height=100%\"></div></td>");
	sb.append("<td width=50% height=100% style=\"border:solid 1px gray\" valign=top;><div id='chart2' style=\"height=100%\"></div></td>");
	

}

//��Ӷ���html
//afterBodyHtml�¼��󴥷����ѹ�ʱ��������afterBodyHtml�¼����д���
function addBottomHtml(mwobj,request,sb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("</tr></table>");	
	sb.append("</td></tr></table></td></tr></table>");
}

//����ͳ�Ʒ�������
function genData()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var mwsql = new servletPack.MWSQL();
		
		//�������
		var sql = "delete from TAX_FX_CHART006 where yymm>='"+ym1+"' and yymm<='"+ym2+"'";
		db.ExcecutSQL(sql);
		
		try { sql = mwsql.GetQuerySQL(request,db,"TAXFXJK","CHART006","CREATEDS"); } catch (e1) { }				
		sql = pub.EAFunc.Replace(sql,"[%YM1]",ym1);
		sql = pub.EAFunc.Replace(sql,"[%YM2]",ym2);
		
		var mysql = "insert into TAX_FX_CHART006(hy,yymm,sjje,avgdj) select * from ("+sql+")";
		db.ExcecutSQL(mysql);
		
//		mysql = "select sum(sjje) from TAX_FX_CHART006";
//		var sumje = db.GetSQL(mysql);
//		mysql = "update TAX_FX_CHART006 set bl=round(sjje/"+sumje+",4)";
//		db.ExcecutSQL(mysql);
		
		db.Commit();
		return "����ͳ�Ʒ����������!";
		
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