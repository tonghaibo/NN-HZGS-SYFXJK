function x_L_texscoll(){function GetBody(){
	var html = "";
	var sql = "select * from ( select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' order by  seqid)"  ;
	var ds=db.QuerySQL(sql);
	//html +="<div id=\"colee_bottom\" style=\"overflow:hidden;height:200px;width:400px;\">";

	html +="<div id=\"colee_bottom\" style=\"overflow:hidden;height:100%;width:100%;\">";
	html += "<div id=\"colee_bottom1\">";
	
	for (var r = 0; (r < ds.getRowCount()&&r<LAYROW)||(LAYROW==""&&r < ds.getRowCount()); r ++) {
		var icon = ds.getStringAt(r,"icon");
		var name = ds.getStringAt(r,"name");
		var url = ds.getStringAt(r,"url");
		if (OPENLAYID != "") {
			url = "L.sp?id="+OPENLAYID+"&layhdrguid="+ds.getStringAt(r,"GUID");
		}
		if (url != "") {
			html += "<a target=\""+ds.getStringAt(r,"target")+"\" href=\""+url+"\">"+name+"</a><BR/>";
		} else {
			html += name;
		}
	}
	html += " <div id=\"colee_bottom2\"></div> ";
	html += "</div>";
	html += "<script>marqueeStart(2, \"up\");</script>";
	
	html += "<script>
			var speed=30
			var colee_bottom2=document.getElementById(\"colee_bottom2\");
			var colee_bottom1=document.getElementById(\"colee_bottom1\");
			var colee_bottom=document.getElementById(\"colee_bottom\");
//			colee_bottom2.innerHTML=colee_bottom1.innerHTML
			colee_bottom.scrollTop=colee_bottom.scrollHeight
			function Marquee2(){
			if(colee_bottom1.offsetTop-colee_bottom.scrollTop>=0)
			colee_bottom.scrollTop+=colee_bottom2.offsetHeight
			else{
			colee_bottom.scrollTop--
			}
			}
			var MyMar2=setInterval(Marquee2,speed)
			colee_bottom.onmouseover=function() {clearInterval(MyMar2)}
			colee_bottom.onmouseout=function() {MyMar2=setInterval(Marquee2,speed)}
		</script>";
	return html;



}
}