function x_L_TOUBLELIST(){

function GetBody(){
	var html = "";
	var sql = "select * from ( select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' "  ;
	if(WHEREBY!="" ) sql+= " AND " +WHEREBY;
	if(SORTBY!="" ) sql+= " "+SORTBY;
	else sql+= " order by crtdat desc ";
	if(LAYCOL !=""&& LAYROW!="" ) sql+=") where  rownum<"+LAYCOL+"*"+LAYROW;
	
	// "+WHEREBY +" "+SORTBY;
	var ds=db.QuerySQL(sql);
	html += "<table valign=\"top\">";
	html += "<tr>";
	var n = 0;
	var val = "";
	
	for (var r=0;r<LAYCOL;r++) {
		html += "<td valign=\"top\"  >";
		html +="<table>";
		for (var i=0;i<LAYROW;i++) {
			if (n < ds.getRowCount()) {
				val = ds.getStringAt(n,"name");
				var dat = ds.getStringAt(n,"crtdat");
				html +="<tr height=\"20\">";
				html +="<td>";
				html +="<table cellpadding=\"2\" cellspacing=\"0\">";
				html +="<tr>";
				if (ds.getStringAt(n,"icon") != "") {
					html +="<td width=\"30\">";
					html +="<img src=\""+ds.getStringAt(n,"icon")+"\" width=20 height=20/>";
					html +="</td>";
				}
				html +="<td style=\"border-bottom: 1px dotted #C0C0C0;\" >";
				var url = ds.getStringAt(n,"url") ;
				if(OPENLAYID!=""){
					url = "L.sp?id="+OPENLAYID+"&layhdrguid="+ds.getStringAt(n,"GUID");
				}
				
				if (ds.getStringAt(n,"url") != "") {
					html +="<a href=\""+url+"\" target=\""+ds.getStringAt(n,"target")+"\">"+val+"</a>";
				} else {
					html +=val;
				}
				html +="</td>";
				html +="</tr>";
				html +="</table>";
				html +="</td>";
				html +="</tr>";
			} else {
				break;
			}
			n++;
		}
		
		html +="</table>";
		html +="</td>";
	}
	html += "</tr>";
	html += "</table>";
	
	return html;

}

}