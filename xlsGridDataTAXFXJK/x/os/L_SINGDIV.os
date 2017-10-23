function x_L_SINGDIV(){function GetBody(){
	var html = "";
	var sql = "select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' order by crtdat desc ";
	var ds=db.QuerySQL(sql);
	
	html += "<table>";
	html += "<tr>";
	html += "<td align=\"center\">";
	html += "<table cellpadding=\"10\">";
	for (var r=3;r<ds.getRowCount(); r ++) {
		var img = ds.getStringAt(r,"icon");
		var name = ds.getStringAt(r,"name");
		var url = ds.getStringAt(r,"url");
		if (url != "") {
			url += "&layhdrguid="+ds.getStringAt(r,"GUID");
		}
		html += "<tr>";
		html += "<td align=\"center\">";
		html += "<div style=\"position: relative;\" >";
		html += "<a href=\""+url+"\"><img src=\""+img+"\" width=\"200\" height=\"200\"/></a>";
		html += "<div style=\"left: 0px; top: 150px; width: 200px; height: 50px; position: absolute; z-index: 100; opacity: 0.5; background-color: rgb(0, 0, 0); -moz-opacity: 0.5;\"><font color=\"#FFFFFF\" size=\"3\">"+name+"</font></div>";
		html += "</div>";
		html += "</td>";
		html += "</tr>";
	}
	html += "</table>";
	html += "</td>";
	html += "</tr>";
	html += "</table>";
	
	return html;

}
}