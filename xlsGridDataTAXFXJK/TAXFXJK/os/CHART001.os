function TAXFXJK_CHART001(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" ); 
var servletPack = new JavaPackage("com.xlsgrid.net.servlet");

//在Head区引用额外脚本
function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("<script type=\"text/javascript\" src=\"xlsgrid/images/flash/js/jquery-1.7.2.min.js\"></script>\n"); 
	sb.append("<script type=\"text/javascript\" src=\"xlsgrid/js/highcharts-3d.js\"></script>\n"); 
	sb.append("<script type=\"text/javascript\" src=\"xlsgrid/js/highcharts.js\"></script>\n"); 
	//sb.append("<script type=\"text/javascript\" src=\"xlsgrid/js/exporting.js\"></script>\n"); 

	//窗口上下分割，上面显示图表，下面显示中间件数据
	sb.append("<table border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\"><tr><td bgcolor=\"#EFEFEF\" align=center valign=middle>");
	sb.append("<table border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\" ><tr><td  style=\"border: 1px solid #EEEEEE\">");
	sb.append("<table id=\"dataTable\" border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\" ><tr>"); //上面窗口高度占的比例
	sb.append("<td><span style='color:red'>【注：分析前请先生成数据】</span></td><td align=right><button type='button' onclick='genData()'>生成数据</button>&nbsp;&nbsp;<button type='button' onclick='filter()'>统计条件</button></td></tr><tr>");
	sb.append("<td width=50% height=100% style=\"border:solid 1px gray\" valign=top;><div id='chart1' style=\"height=100%\"></div></td>");
	sb.append("<td width=50% height=100% style=\"border:solid 1px gray\" valign=top;><div id='chart2' style=\"height=100%\"></div></td>");
	

}

//添加额外html
//afterBodyHtml事件后触发，已过时，建议用afterBodyHtml事件进行处理
function addBottomHtml(mwobj,request,sb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("</tr></table>");	
	sb.append("</td></tr></table></td></tr></table>");
}

//生成统计分析数据
function genData()
{
	var db = null;
	try {
		db = new pub.EADatabase();
		var mwsql = new servletPack.MWSQL();
		
		//清除数据
		var sql = "delete from TAX_FX_CHART001 where yymm>='"+ym1+"' and yymm<='"+ym2+"'";
		db.ExcecutSQL(sql);
		
		try { sql = mwsql.GetQuerySQL(request,db,"TAXFXJK","CHART001","CREATEDS"); } catch (e1) { }				
		sql = pub.EAFunc.Replace(sql,"[%YM1]",ym1);
		sql = pub.EAFunc.Replace(sql,"[%YM2]",ym2);
		
		var mysql = "insert into TAX_FX_CHART001(cy123,cy123mc,yymm,taxmny,gdp) select * from ("+sql+")";
		db.ExcecutSQL(mysql);
		
		//更新GDP
		mysql = "update tax_fx_chart001 a set gdp=(select ljzl from tax_tjjdata b 
		       where replace(a.yymm,'-','')=b.yymm
		         and a.cy123=to_number(b.zbbh)-1      
		       )";
		db.ExcecutSQL(mysql);
		
		//更新1月份的GDP，用2月份的来更新（GDP是按季度发布）
		mysql = "update tax_fx_chart001 a set gdp=(select ljzl from tax_tjjdata b 
			       where substr(a.yymm,0,4)=substr(b.yymm,0,4)
			         and substr(b.yymm,-2)='02'
			         and a.cy123=to_number(b.zbbh)-1  
			       )
			where substr(yymm,-2)='01'";
		db.ExcecutSQL(mysql);
		
		db.Commit();
		return "生成统计分析数据完成!";
		
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