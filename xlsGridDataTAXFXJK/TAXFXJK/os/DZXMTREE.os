function TAXFXJK_DZXMTREE(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" ); 

//��Head�����ö���ű�
function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("<link rel=\"stylesheet\" href=\"xlsgrid/zTree/css/zTreeStyle/zTreeStyle.css\" type=\"text/css\">\n"); 
	sb.append("<script type=\"text/javascript\" src=\"xlsgrid/zTree/js/jquery-1.4.4.min.js\"></script>\n"); 
	sb.append("<script type=\"text/javascript\" src=\"xlsgrid/zTree/js/jquery.ztree.core.js\"></script>\n"); 

	sb.append("<table border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" height=\"100%\"><tr><td bgcolor=\"#EFEFEF\" align=center valign=middle>");
	sb.append("<table border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\" ><tr><td  style=\"border: 1px solid #EEEEEE\">	");
	sb.append("<table border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\" ><tr>");
	sb.append("<td width=70% height=100% style=\"border:solid 1px gray\" valign=top;>");
	sb.append("<div style=\"overflow-y:scroll;height:100%;\"><ul id=\"treeZDXM\" class=\"ztree\"></ul></div></td>");
	sb.append("<td width=30% height=100% style=\"border:solid 1px gray\"  valign=top;><div style=\"overflow-y:scroll;height:100%;\">");

}

//��Ӷ���html
//afterBodyHtml�¼��󴥷����ѹ�ʱ��������afterBodyHtml�¼����д���
function addBottomHtml(mwobj,request,sb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("</div></td></tr></table>");	
	sb.append("</td></tr></table></td></tr></table>");
}

//��ȡ����λ�ýڵ�����
function getTreeJson()
{
	var db = null;
	var json = "";
	try {
		db = new pub.EADatabase();
		json = getZdxmTreeJson(db);
		
		return json;
	}
	catch (e) {
		if (db != null) db.Rollback();
		return e.toString();
	}
	finally {
		if (db != null) db.Close();
	}
}


function getZdxmTreeJson(db)
{
	var json = "[";
	var sql = "select * from tax_zdxm_fgwxm order by jhkgsj,xmdm";
	var ds = db.QuerySQL(sql);
	for (var i=0;i<ds.getRowCount();i++) {
		var xmdm = ds.getStringAt(i,"XMDM");
		var xmmc = ds.getStringAt(i,"XMMC");
		var jhkgsj = ds.getStringAt(i,"JHKGSJ");
		var ztzje = ds.getStringAt(i,"ZTZJE");
		var showxmmc = xmmc + " ��Ͷ���ܽ�" + ztzje + "  �ƻ�������" + jhkgsj + "��";
		var node = "{ id:\""+xmdm+"\",open:false,name:\""+showxmmc+"\",ztzje:\""+ztzje+"\",jhkgsj:\""+jhkgsj+"\",typ:\"zdxm\" }\n";
		if (json == "[") {
			node = "{ id:\"9999\",open:false,name:\"�ص���Ŀ\",ztzje:\"\",jhkgsj:\"\",typ:\"root\" }\n";
			json += node;
		}
		else {
			json += "," + node;
		}
	}
	
	json += "]";
	return json;
}



}