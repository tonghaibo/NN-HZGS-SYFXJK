function x_L_TOUBLELIST1(){function GetBody(){
	var html = "";
	var sql = "select * from ( select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' "  ;
	if(WHEREBY!="" ) sql+= " AND " +WHEREBY;
	if(SORTBY!="" ) sql+= " "+SORTBY;
	else sql+= " order by crtdat desc ";
	if(LAYCOL !=""&& LAYROW!="" ) sql+=") where  rownum<"+LAYCOL+"*"+LAYROW;
	
	// "+WHEREBY +" "+SORTBY;
	var ds=db.QuerySQL(sql);
	html += "<div style=\"background-color:#E5E5E5;\">";
	var n = 0;
	var val = "";
	
	for (var r=0;r<LAYCOL;r++) {
		html +="<table>";
		for (var i=0;i<LAYROW;i++) {
		html += "<tr><td>";
		html += "<div style=\"height:20px; padding:2px;\">";
			if (n < ds.getRowCount()) {
				val = ds.getStringAt(n,"name");
				var dat = ds.getStringAt(n,"crtdat");
				if (ds.getStringAt(n,"icon") != "") {
					html +="<img src=\""+ds.getStringAt(n,"icon")+"\" width=20 height=20/>";
				}
				var url = ds.getStringAt(n,"url") ;
				if(OPENLAYID!=""){
					url = "L.sp?id="+OPENLAYID+"&layhdrguid="+ds.getStringAt(n,"GUID");
				}
				
				if (ds.getStringAt(n,"url") != "") {
					html +="<a href=\""+url+"\" target=\""+ds.getStringAt(n,"target")+"\">"+val+"</a>";
				} else {
					html +=val;
				}

			} else {
				break;
			}
			n++;
			
		html += "</td></tr></table>";
		}
		html += "</div>";

	}
	html += "</div>";

	
	return html;

}
}