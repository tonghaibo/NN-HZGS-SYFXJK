function x_L_MENU(){function GetBody(){

//EAImgBlob.sp?guid=AF00638627EB46608EABEFC53FC0164A 
//style=\"border: solid thin #FF8C69\" 
//onclick=\"window.location='"+url+"';\" 
var layid="L.sp?id="+id;//id是全局变量这里可以直接使用
	var parent = new x_LHTML1();
	var html = "";
	var ds=db.QuerySQL("select * from ( select * from LSYSURL where org='"+deforg+"' and REFID='"+DSMOD+"' order by seqid)");
	html = 
	"<script >function showbgc(ids){document.getElementById(ids).background=\"EAImgBlob.sp?guid=D29CA9F07F7A45EE85790D9251472274\";}</script>"+
	"<script >function showbgc2(ids){document.getElementById(ids).background=\"\";}</script>"+
	"<table border=\"0\" width=\"100%\" height=\"50\"  style=\"border-collapse:collapse\" background=EAImgBlob.sp?guid=AF00638627EB46608EABEFC53FC0164A><tr>";
	for(var c = 0; c < ds.getRowCount(); c ++){
		var a=ds.getStringAt(c,"name");
		var url=ds.getStringAt(c,"url");
		var id ="mnu"+c;
		
		if(url!=layid){
		
		html += "<a href=\""+url+"\" style=\"text-decoration:none; \"><td valign=center align=center  onmouseout=\"showbgc2('"+id+"')\" onmouseover=\"showbgc('"+id+"');\"  id="+id+" ><a href=\""+url+"\" style=\"text-decoration:none; \"><font color=#FFFFFF size=\"3\" font-family=\"宋体\">"+a+"</font></a></td></a>";
		}
		else{
		html += "<a href=\""+url+"\" style=\"text-decoration:none; \"><td valign=center align=center  id="+id+"   background=EAImgBlob.sp?guid=D29CA9F07F7A45EE85790D9251472274><a href=\""+url+"\" style=\"text-decoration:none; \"><font color=#FFFFFF size=\"3\" font-family=\"宋体\">"+a+"</font></a></td></a>";
		
		}
	}
	html += "</tr></table>";
	return html;

}
}