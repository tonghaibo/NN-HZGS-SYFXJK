function x_BIHome(){var pub = new JavaPackage ( "com.xlsgrid.net.pub" );

//作为.sp服务时的入口	
//预定义变量：request,response
function Response()
{
	var db = null;
	var ds = null;
	var _ds = null;
	var sql = "";
	var ret = "";
	var sTitle = "";
	var sRight = "";
	var rCount = 5;
	
	var clienttype = pub.EAFunc.NVL(request.getParameter("clienttype"),"");
	if (clienttype != "") clienttype = "&clienttype=HTML";
	
	try {
		db = new pub.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		
		sql = "select * from dim_model where guid='"+FORMGUID+"'";
		_ds = db.QuerySQL(sql);
		sTitle = _ds.getStringAt(0,"NAME");
		sRight = _ds.getStringAt(0,"NOTE");
		if (_ds.getStringAt(0,"ROWCOUNT") != "") rCount = 1*_ds.getStringAt(0,"ROWCOUNT");
		
		sql = "select rownum seq,a.* from (select id,name from dim_topic where refmod='"+FORMGUID+"' and refid is null order by id) a";
		_ds = db.QuerySQL(sql);
		
		ds = new pub.EADS();
		var r = ds.AddRow(-1);
		ds.setValueAt(r, "ID0", "");ds.setValueAt(r, "NAME0", "");ds.setValueAt(r, "ICON0", "");
		ds.setValueAt(r, "ID1", "");ds.setValueAt(r, "NAME1", "");ds.setValueAt(r, "ICON1", "");
		ds.setValueAt(r, "ID2", "");ds.setValueAt(r, "NAME2", "");ds.setValueAt(r, "ICON2", "");
		ds.setValueAt(r, "ID3", "");ds.setValueAt(r, "NAME3", "");ds.setValueAt(r, "ICON3", "");
		ds.setValueAt(r, "ID4", "");ds.setValueAt(r, "NAME4", "");ds.setValueAt(r, "ICON4", "");
		r = ds.AddRow(-1);
		
		var cnt = 0;
		for (var ii = 0;ii < _ds.getRowCount();ii ++) {
			var id = _ds.getStringAt(ii,"ID");
			var name = _ds.getStringAt(ii,"NAME");
			
			var seq = cnt%rCount;
			if (seq == 0 && cnt >= 2*rCount) {
				r = ds.AddRow(ds.getRowCount()-1);
				ds.setValueAt(r, "ID0", "");ds.setValueAt(r, "NAME0", "");ds.setValueAt(r, "ICON0", "");
				ds.setValueAt(r, "ID1", "");ds.setValueAt(r, "NAME1", "");ds.setValueAt(r, "ICON1", "");
				ds.setValueAt(r, "ID2", "");ds.setValueAt(r, "NAME2", "");ds.setValueAt(r, "ICON2", "");
				ds.setValueAt(r, "ID3", "");ds.setValueAt(r, "NAME3", "");ds.setValueAt(r, "ICON3", "");
				ds.setValueAt(r, "ID4", "");ds.setValueAt(r, "NAME4", "");ds.setValueAt(r, "ICON4", "");
			} else if (seq == 0 && cnt >= rCount) {
				r ++;
			}
			
			ds.setValueAt(r, "ID"+seq, id);ds.setValueAt(r, "NAME"+seq, name);ds.setValueAt(r, "ICON"+seq, "");
			cnt ++;
		}
		
		for (var ii = 0;ii < ds.getRowCount();ii ++) {
			ret += "<tr height=150>\r";
			
			var td_w = 150;
			if (rCount == 3 || _ds.getRowCount() == 3) td_w = 260;
			else if (rCount == 4 || _ds.getRowCount() == 4) td_w = 192.5;
			
			for (var jj = 0;(jj < rCount && jj < _ds.getRowCount()) || ((rCount < 3 || _ds.getRowCount() < 3) && jj < 5);jj ++) {
				var id = ds.getStringAt(ii,"ID"+jj);
				var name = ds.getStringAt(ii,"NAME"+jj);
				
				var icon = "";
				var iconurl = "";
				if (id != "") {
					icon = "xlsgrid/images/entry/"+(ii*5+ii+jj)%10+".png";
					iconurl = "<img border=0 src=\""+icon+"\">";
				}
				
				ret += "<td width="+td_w+" bgcolor='#FFFFFF' ";
				
				if (id != "") {
					ret += "onmouseover=\"this.style.backgroundColor='#DBEBFA';this.style.cursor='hand';title=''\" onmouseout=\"this.style.backgroundColor='#FFFFFF';\" onclick=\"javascript:show_right('"+id+"');\"";
				}
				ret += ">\r";
				
				ret += "<table border='0' cellspacing='0' cellpadding='0' width='100%' height='100%' style='border-collapse: collapse' bordercolor='#E4E4E4'>\r";
				ret += "<tr height=150><td style='border: 1px solid #E4E4E4; padding-left: 4px; padding-right: 4px; padding-top: 1px; padding-bottom: 1px'>\r";
				ret += "	<table border='0' cellspacing='0' cellpadding='0' width='100%' height='100%'>\r";
				ret += "	<tr><td align=center valign=bottom>"+iconurl+"</td></tr>\r";
				ret += "	<tr><td align=center height=50><span style='font-size: 10.5pt'>"+name+"</span></td></tr>\r";
				ret += "	</table>\r";
				ret += "</td></tr>\r";
				ret += "</table>\r";
				ret += "</td>\r";
			}
			
			ret += "</tr>";
		}
	}
	catch ( ee ) {
		db.Rollback();
		throw new pub.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	
	ret = "<html>
	<head>
		<meta http-equiv='Content-Type' content='text/html; charset=GB2312'>
		<script>
			// 主题的触发事件
			function show_right(topic){
				parent.show_right(topic);
			}
			function show_algs(){
				window.open('show.sp?grdid=BIAlgs&FORMGUID="+FORMGUID+clienttype+"');
			}
		</script>
	</head>
	
	<body bgcolor='#F6F6F6' link='#000000' vlink='#000000' alink='#000000'>
		<table border='0' cellspacing='0' cellpadding='0' width='100%' height='100%'>
			<tr><td align='center' valign='middle'>
				<table border='0' cellspacing='0' cellpadding='0' width='860' height='100%'>
					<tr><td height='72'>
						<table border='0' cellspacing='0' cellpadding='0' width='100%' height='0'>
							<tr>
								<td valign='bottom'><font size='5' color='#1188FF'>"+sTitle+"</font></td>
								<td align='right'><a href='javascript:show_algs();'><font size='2' color='#FF0000'>指标说明</font></a></td>
							</tr>
							<tr><td valign='bottom' colspan='2'><hr>&nbsp;&nbsp;&nbsp;<font size='3' color='#696969'>"+sRight+"</font></td></tr>
						</table>
					</td></tr>
					<tr><td valign='top'>
						<table border='0' cellspacing='20' cellpadding='0' width='100%'>
							"+ret+"
						</table>
					</td></tr>
					<tr><td height='60'>
						<table border='0' cellspacing='0' cellpadding='0' width='100%' height='100%'>
							<tr><td><hr><font size='2' color='#363636'>&nbsp;&nbsp;帮助：选择分析主题点击进入分析主页</font></td></tr>
						</table>
					</td></tr>
				</table>
			</td></tr>
		</table>
	</body>\r</html>";
	
	return ret;
}

}