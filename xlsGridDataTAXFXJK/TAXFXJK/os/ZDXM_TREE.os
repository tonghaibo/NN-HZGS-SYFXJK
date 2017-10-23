function TAXFXJK_ZDXM_TREE(){var pub = new JavaPackage("com.xlsgrid.net.pub");
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" ); 

//在Head区引用额外脚本
function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("<link rel=\"stylesheet\" href=\"xlsgrid/zTree/css/zTreeStyle/zTreeStyle.css\" type=\"text/css\">\n"); 
	sb.append("<script type=\"text/javascript\" src=\"xlsgrid/zTree/js/jquery-1.4.4.min.js\"></script>\n"); 
	sb.append("<script type=\"text/javascript\" src=\"xlsgrid/zTree/js/jquery.ztree.core.js\"></script>\n"); 

	sb.append("<table border=\"0\" width=\"100%\" cellspacing=\"0\" cellpadding=\"0\" height=\"100%\"><tr><td bgcolor=\"#EFEFEF\" align=center valign=middle>");
	sb.append("<table border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\" ><tr><td  style=\"border: 1px solid #EEEEEE\">	");
	sb.append("<table border=\"0\" width=\"100%\" height=\"100%\" cellspacing=\"0\" cellpadding=\"0\" ><tr>");
	sb.append("<td width=20% height=100% style=\"border:solid 1px gray\" valign=top;>");
	
	sb.append("<div style=\"height:5%;\">&nbsp;&nbsp;年度：<select id='xmyy1' name='xmyy1'>"+getYYYYOptions()+"</select>");
	sb.append("至<select id='xmyy2' name='xmyy2'>"+getYYYYOptions()+"</select>");
	sb.append("<br>&nbsp;&nbsp;类型：<select id='xmlx' name='xmlx'>"+getXMLXOptions()+"</select>");
	//sb.append("&nbsp;&nbsp;&nbsp;&nbsp;重点项目：<label><input id='zdbz' type='radio' value='1'/>是</label><label><input id='zdbz' type='radio' value='0'/>否</label>");
	sb.append("<br>&nbsp;&nbsp;查找：<input type='text' id='skey'><button type='button' onclick='loadXMTree()'>查找</button></div><hr>");
	
	sb.append("<div style=\"overflow-y:scroll;height:95%;\"><ul id=\"treeZDXM\" class=\"ztree\"></ul></div></td>");
	sb.append("<td width=80% height=100% style=\"border:solid 1px gray\"  valign=top;><div style=\"overflow-y:scroll;height:100%;\">");

}

//添加额外html
//afterBodyHtml事件后触发，已过时，建议用afterBodyHtml事件进行处理
function addBottomHtml(mwobj,request,sb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("</div></td></tr></table>");	
	sb.append("</td></tr></table></td></tr></table>");
}

function getYYYYOptions()
{	
	var optionstr = "";
	var sql = "select to_char(sysdate,'yyyy')-3 yy from dual";
	var yy = pub.EADbTool.GetSQL(sql);
	for (var i=5;i>=0;i--) {
		var year = 1*yy + i;
		optionstr += "<option value='"+year+"'>"+year+"</option>\n";
	}
	return optionstr;
}

function getXMLXOptions()
{	
	var optionstr = "<option value=''>全部</option>\n";
	var sql = "select id,name from v_tax_zdxm_xmlx";
	var ds = pub.EADbTool.QuerySQL(sql);
	for (var i=0;i<ds.getRowCount();i++) {
		var id = ds.getStringAt(i,"ID");
		var name = ds.getStringAt(i,"NAME");
		optionstr += "<option value='"+id+"'>"+name+"</option>\n";
	}
	return optionstr;
}

//获取报表位置节点数据
function getTreeJson()
{
	var db = null;
	var json = "";
	try {
		db = new pub.EADatabase();
		json = getZdxmTreeJson(db,xmyy1,xmyy2,xmlx,skey);
		
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


function getZdxmTreeJson(db,xmyy1,xmyy2,xmlx,skey)
{
	//var sql = "select xmdm,xmmc,jhkgsj,ztzje from tax_zdxm_fgwxm order by jhkgsj,xmdm";
	var sql = "select fgw.fgwxmuuid,fgw.xmdm,fgw.xmmc fgwxmmc,
		        jypt.jyptxmuuid,jypt.xmmc jyptxmmc,b.djxh,nvl(dj.shxydm,dj.nsrsbh) nsrsbh,dj.nsrmc,
		        b.bydjuuid,bydj.wcjyhwyxqxq,bydj.xmje
		from tax_zdxm_fgwxm fgw,tax_zdxm_jyptxm jypt,tax_zdxm_jyptwbbyxm_dzb b,dj_nsrxx dj,
		    (
		    select bydjuuid,djxh,wcjyhwmc xmmc,wcjyhwzz xmje,wcjyhwyxqxq,wcjyhwyxqxz from dj_wbnsrjydbydj_hwxx
		    where to_char(wcjyhwyxqxq,'yyyy')>='"+xmyy1+"' and to_char(wcjyhwyxqxz,'yyyy')<='"+xmyy2+"'
		    union all
		    select bydjuuid,djxh,wcjylwmc xmmc,wcjylwdhtje xmje,wcjylwyxqxq,wcjylwyxqxz from dj_wbnsrjydbydj_lwxx
		    where to_char(wcjylwyxqxq,'yyyy')>='"+xmyy1+"' and to_char(wcjylwyxqxz,'yyyy')<='"+xmyy2+"'
		    ) bydj
		where fgw.xmdm=jypt.fgwxmdm(+) 
		  and jypt.jyptxmuuid=b.jyptxmuuid(+) 
		  and b.djxh=dj.djxh(+)
		  and b.bydjuuid=bydj.bydjuuid(+)
		  and fgw.xmlx like '"+xmlx+"%'
		  and (fgw.xmmc like '%"+skey+"%' or bydj.xmmc like '%"+skey+"%')
		    
		union all
		
		--发改委项目直接与报验项目勾对的
		select fgw.fgwxmuuid xmuuid,fgw.xmdm fgwxmdm,fgw.xmmc fgwxmmc,
		       '' jyptxmuuid,'' jyptxmmc,b.djxh,nvl(dj.shxydm,dj.nsrsbh) nsrsbh,dj.nsrmc,
		        bydj.bydjuuid,bydj.wcjyhwyxqxq,bydj.xmje
		from tax_zdxm_fgwxm fgw,tax_zdxm_fgwbyxm_dzb b,dj_nsrxx dj,
		    (
		    select bydjuuid,djxh,wcjyhwmc xmmc,wcjyhwzz xmje,wcjyhwyxqxq,wcjyhwyxqxz from dj_wbnsrjydbydj_hwxx 
		    where to_char(wcjyhwyxqxq,'yyyy')>='"+xmyy1+"' and to_char(wcjyhwyxqxz,'yyyy')<='"+xmyy2+"'
		    union all
		    select bydjuuid,djxh,wcjylwmc xmmc,wcjylwdhtje xmje,wcjylwyxqxq,wcjylwyxqxz from dj_wbnsrjydbydj_lwxx
		    where to_char(wcjylwyxqxq,'yyyy')>='"+xmyy1+"' and to_char(wcjylwyxqxz,'yyyy')<='"+xmyy2+"'
		    ) bydj
		where fgw.fgwxmuuid=b.fgwxmuuid
		  and b.djxh=dj.djxh
		  and b.bydjuuid=bydj.bydjuuid  
		  and fgw.xmlx like '"+xmlx+"%'
		  and (fgw.xmmc like '%"+skey+"%' or bydj.xmmc like '%"+skey+"%')";
	var xmsql = "select distinct fgwxmuuid,fgwxmmc,wm_concat(trim(bydjuuid)) bydjuuid from ("+sql+") group by fgwxmuuid,fgwxmmc";
	var ds = db.QuerySQL(xmsql);
	var xmcount = ds.getRowCount();
	var json = "[\n{ id:\"9999\",open:true,name:\"项目管理（项目总数"+xmcount+"）\",typ:\"root\",iconOpen:\"xlsgrid/zTree/css/zTreeStyle/img/diy/1_open.png\",iconClose:\"xlsgrid/zTree/css/zTreeStyle/img/diy/1_close.png\" }\n";
	for (var i=0;i<ds.getRowCount();i++) {
		var xmuuid = ds.getStringAt(i,"FGWXMUUID");
		var bydjuuid = ds.getStringAt(i,"BYDJUUID");
		var xmmc = ds.getStringAt(i,"FGWXMMC");
		var node = "{ id:\""+xmuuid+"\",pId:\"9999\",open:false,name:\""+xmmc+"\",bydjuuid:\""+bydjuuid+"\",typ:\"fgwxmNode\"}\n"; // ,icon:\"xlsgrid/zTree/css/zTreeStyle/img/diy/3.png\"
		json += "," + node;
	}
	
	xmsql = "select distinct fgwxmuuid,jyptxmuuid,jyptxmmc,wm_concat(trim(bydjuuid)) bydjuuid from ("+sql+") where jyptxmuuid is not null group by fgwxmuuid,jyptxmuuid,jyptxmmc";
	ds = db.QuerySQL(xmsql);
	for (var i=0;i<ds.getRowCount();i++) {
		var xmuuid = ds.getStringAt(i,"FGWXMUUID");
		var jyptxmuuid = ds.getStringAt(i,"JYPTXMUUID");
		var bydjuuid = ds.getStringAt(i,"BYDJUUID");
		var xmmc = ds.getStringAt(i,"JYPTXMMC");
		var node = "{ id:\""+jyptxmuuid+"\",pId:\""+xmuuid+"\",open:false,name:\""+xmmc+"\",bydjuuid:\""+bydjuuid+"\",typ:\"jyptxmNode\" }\n"; //,icon:\"xlsgrid/zTree/css/zTreeStyle/img/diy/9.png\"
		json += "," + node;
	}
	
	//中标单位
	var dwsql = "select distinct jyptxmuuid,nsrsbh,nsrmc,wm_concat(trim(bydjuuid)) bydjuuid from ("+sql+")  where jyptxmuuid is not null and nsrsbh is not null group by jyptxmuuid,nsrsbh,nsrmc";
	var dwds = db.QuerySQL(dwsql);
	for (var i=0;i<dwds.getRowCount();i++) {
		var jyptxmuuid = dwds.getStringAt(i,"JYPTXMUUID");
		var bydjuuid = dwds.getStringAt(i,"BYDJUUID");
		var nsrsbh = dwds.getStringAt(i,"NSRSBH");
		var nsrmc = dwds.getStringAt(i,"NSRMC");
		var node = "{ id:\""+nsrsbh+"\",pId:\""+jyptxmuuid+"\",open:false,name:\""+nsrmc+"\",bydjuuid:\""+bydjuuid+"\",typ:\"nsrNode\" }\n";
		json += "," + node;
	}
	
	json += "]";
	return json;
}



}