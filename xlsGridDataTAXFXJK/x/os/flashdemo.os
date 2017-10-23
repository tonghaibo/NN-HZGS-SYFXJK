function x_flashdemo(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// 客户端param传入的参数可以直接使用
function GetSWFMain()
{
	var db = null;
	var ret= "<html><head><meta http-equiv='Content-Type' content='text/html; charset=gb2312'><title></title></head><body bgcolor='#F6F6F6' topmargin='0' leftmargin='0' rightmargin='0' bottommargin='0' >";
	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var docid = pubpack.EAFunc.NVL(request.getParameter("docid"),"");
		if(docid!=""){
			var ds = db.QuerySQL("select icon from sysurl where id='"+docid+"'");	// 客户端可以传入一个xml
			if (ds.getRowCount()>0){
				ret = "<script src=\"xlsgrid/images/flash/js/swfobject.js\"></script>
					<div id=\"login_div\" style=\"width:100%; height:100%\"></div>
					<script>
					var params={};
					swfobject.embedSWF(\""+ds.getStringAt(0,"ICON")+"\", \"login_div\", \"100%\", \"100%\", \"9.0.0\",\"swfloadjs/expressInstall.swf\", params, {menu:\"false\"}, {id:\"login\",name:\"mylogin\"});
					</script>";
			
			}
		}
		else {
			var refid = pubpack.EAFunc.NVL(request.getParameter("refid"),"");
			if(refid!="" ) {
				ret += "<table border='0' height='100%' width='100%' cellspacing='0' cellpadding='0'><tr><td width=50 height=80>　</td><td  height=80 align='center' ><img border='0' src='../选用的WP8图标/imgout/icon_6.png' width='50' height='50' ></td><td  height=80 align='left' width='519'>		<font color='#0099CC' face='微软雅黑' style='font-size: 30pt'>视频教学</font></td>		<td  width=50  height=80>　</td>	</tr><tr><td  width=50 >　</td>	<td width='1041' colspan='2' style='border: 1px solid #CCCCCC; padding-left: 4px; padding-right: 4px; padding-top: 1px; padding-bottom: 1px' bgcolor='#FFFFFF'>		<table border='0' width='1031' cellspacing='20' cellpadding='5' height='100%'>";
				var ds = db.QuerySQL("select * from sysurl where refid='"+refid+"'");	// 客户端可以传入一个xml
				if (ds.getRowCount()>0){
					ret = "<script src=\"xlsgrid/images/flash/js/swfobject.js\"></script>
						<div id=\"login_div\" style=\"width:100%; height:100%\"></div>
						<script>
						var params={};
						swfobject.embedSWF(\""+ds.getStringAt(0,"ICON")+"\", \"login_div\", \"100%\", \"100%\", \"9.0.0\",\"swfloadjs/expressInstall.swf\", params, {menu:\"false\"}, {id:\"login\",name:\"mylogin\"});
						</script>";
				
				}
				
				ret+="</table><p>　</td>	<td  width=50>　</td></tr></table>";
			}

		}
			
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	ret+="</body></html>";
	
	return ret;
}

var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
//作为.sp服务时的入口
//预定义变量：request,response
function Response()
{
	var db = null;
	var ret= "<html><head><meta http-equiv='Content-Type' content='text/html; charset=gb2312 '><title>视频教学入口和显示</title></head><body bgcolor='#F6F6F6' topmargin='0' leftmargin='0' rightmargin='0' bottommargin='0' >";
	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var docid = pubpack.EAFunc.NVL(request.getParameter("docid"),"");
		var orgid = pubpack.EAFunc.NVL(request.getParameter("orgid"),"");

		var screenwidth = pubpack.EAFunc.NVL(request.getParameter("swfwidth"),"1366");
		var screenheight = "768";
		if(screenwidth =="800")screenheight="600";
		
		if(docid!=""){
			var ds = db.QuerySQL("select icon from sysurl where id='"+docid+"'");	// 客户端可以传入一个xml
			if (ds.getRowCount()>0){//style=\"width:100%; height:100%\"
				ret += "<script src=\"xlsgrid/images/flash/js/swfobject.js\"></script>
					<div id=\"login_div\" ></div>
					<script>
					var params={};
					swfobject.embedSWF(\""+ds.getStringAt(0,"ICON")+"\", \"login_div\", \""+screenwidth +"\", \""+screenheight +"\", \"9.0.0\",\"swfloadjs/expressInstall.swf\", params, {menu:\"false\"}, {id:\"login\",name:\"mylogin\"});
					</script>";
			
			}
		}
		else {
			
			var refid = pubpack.EAFunc.NVL(request.getParameter("refid"),"");
			var iconid= pubpack.EAFunc.NVL(request.getParameter("iconid"),"");
			if(iconid=="" ) 
				iconid= "6";
			
			if(refid!="" ) {
				ret += "<table border='0' height='100%' width='100%' cellspacing='0' cellpadding='0'><tr><td width=50 height=80>　</td><td  height=80 align='center' width=5% ><img border='0' src='xlsgrid/images/flash/icon/icon_"+iconid+".png' width='50' height='50' ></td><td  height=80 align='left' >		<font color='#0099CC' face='微软雅黑' style='font-size: 30pt'>视频教学</font></td>		<td  width=50  height=80>　</td>	</tr><tr><td  width=50 >　</td>	<td  colspan='2' style='border: 1px solid #CCCCCC; padding-left: 4px; padding-right: 4px; padding-top: 1px; padding-bottom: 1px' bgcolor='#FFFFFF'>		<table border='0' width='100%' cellspacing='20' cellpadding='20' height='100%'>";
				var sql = "select id,name,note,url,icon,supperid from sysurl where refid='"+refid+"'";
				if(orgid!="") sql+=" and org='"+orgid+"'";
				sql+=" order by seqid";
				var ds = db.QuerySQL(sql);	// 客户端可以传入一个xml
				var groupid= "";//当前分组编号
				var groupseq = -1;//当前分组序号

				for ( var i=0;i<ds.getRowCount();i++){
					var supperid = ds.getStringAt(i,"supperid");
					var id = ds.getStringAt(i,"id");
					var name = ds.getStringAt(i,"name");
					var note = ds.getStringAt(i,"note");
					var url = ds.getStringAt(i,"url");
					var icon= ds.getStringAt(i,"icon");
					var myurl = "javascript:window.open('flashdemo.sp?docid="+id+"&swfwidth="+screenwidth +"','','fullscreen=yes');";
					if(supperid == "" ){
						groupseq  ++;
						groupid= id;
						if(groupseq!=0 ) {
							ret+="</td>";
						}
						if(groupseq%2==0){
							if(groupseq!=0 ) ret+="</tr>";
							ret+="<tr>";
						}
						else {
						
						
						}
						ret+="<td align='left' valign='top' width='50%'><font size='4'>&nbsp;"+name+"</font></span><hr size='1' noshade color='#CCCCCC'>";
					}
					else {
						ret+="<p><font size='2'>"+name+"&nbsp; 【<a href=\"#\" onclick=\""+myurl +"\">在线演示</a>】 【<a href='"+icon+"'>下载本地</a>】</font></p>";
						if(note!="" )
							ret+="<font size='2' color='#808080'><blockquote>"+note +"</blockquote></font>";
					}
				
				}
				if(groupseq>=0&&groupseq%2==0){
					ret+="<td align='left' valign='top' width='50%'>&nbsp;</td>";

				}
				if( groupseq>=0 )ret+="</td></tr>";

				
				ret+="</table><p>　</td>	<td  width=50>　</td></tr></table>";
			}
			else ret+="refid is need";

		}
			
	}
	catch ( ee ) {
		ret+=ee.toString();
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	ret+="</body></html>";
	
	return ret;

}

}