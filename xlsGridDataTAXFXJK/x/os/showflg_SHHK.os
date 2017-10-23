function x_showflg_SHHK(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
//字段
// id,name,img,url,type,note,appfile
//

//app应用
function HK_applist()
{
	var sql="";
	var html="";
	var ds="";
	var _APPTYP= pubpack.EAFunc.NVL(request.getParameter("APPTYP"),"") ;
	var _APPNAM= pubpack.EAFunc.NVL(request.getParameter("APPNAM"),"") ;
	
	if(SQLTXT!=""){
		sql=SQLTXT;
		sql=pub.EAFunc.Replace(sql,"#$amp;","&");
		var usrinfo = web.EASession.GetUserinfo(request);
		
		if(usrinfo!=null){
			sql=web.EASession.GetSysValue(sql,request);//替换request 中[%id]
			sql=web.EASession.GetSysValue(sql,web.EASession.GetUserinfo(request));
		}
		if(_APPTYP!=""){
			sql="select * from ("+sql+") where type='"+_APPTYP+"'";
		}
		if(_APPNAM!=""){
			sql="select * from ("+sql+") where name like '%"+_APPNAM+"%'";
		}
		
		ds=db.QuerySQL(sql);
	}
	else{
		throw new Exception("sql请填写sql语句");
	}
	if(ds.getRowCount()<1&&_APPNAM!=""){ return "没找到您搜索的应用！"; }
	
	html+="<style>
		.form1{border:1px solid #CCCCCC;padding:4px; margin:5px 5px 0px 5px;border-radius:10px;z-index:10;}
			
		.anzhuang{width:70px;height:25px;font-size: 13px; border-radius: 10px; margin-right:5px;background:#F0FFFF;color:#87CEEB;border:1px solid #87CEEB;}
	</style>";
		
	for(var i=0;i<ds.getRowCount();i++){
		var id=ds.getStringAt(i,"id");
		var name=ds.getStringAt(i,"name");
		var img=ds.getStringAt(i,"img");
		var url=ds.getStringAt(i,"url");
		var type=ds.getStringDef(i,"type","");
		var note=ds.getStringDef(i,"note","");
		var appfile=ds.getStringDef(i,"appfile","");
		var opurl=pubpack.EAFunc.getAppAccRootUrl(request).split("ROOT")[0];
		if(note.length()>15) note=note.substring(0,15)+".....";
		if(appfile!="") 
			appfile="EAFormBlob.sp?guid="+appfile;
		//onMouseOut=\"tabonmouseup(this.id)\" onMouseOver=\"tabonmousedown(this.id)\" 移动到对象出发事件
		
		html+="<table width=\"98%\"  cellspacing=\"3\" id=\""+id+"\"  class=\"form1\">
			<tr >
				<td width=\"80px\" height=\"80px\"  onclick=\"openWindow('"+url+"')\"  rowspan=\"3\"><img width=\"80px\" height=\"80px\"  src=\""+img+"\"></td>
				<td  height=\"30\"  colspan=\"2\" onclick=\"openWindow('"+url+"')\"  align=\"left\" style=\"font-size: 18px; padding-left:8px;\">"+name+"</td>
				
			</tr>
			<tr>
				<td height=\"19\" onclick=\"openWindow('"+url+"')\"  align=\"left\" style=\"font-size: 14px; padding-left:8px;color:#c0c0c0;\">"+type+"</td>
				<td align=\"right\" rowspan=\"1\" width=\"20%\">
					<div style=\"z-index:100;width:80px;height:30px;margin-right:0px;\">
						<input type=\"button\"  class=\"anzhuang\" onclick=\"window.open('"+opurl+appfile+"');\" value=\"安装\">
					</div>
				</td>
			</tr>
			<tr>
				<td height=\"19\"  colspan=\"2\" onclick=\"openWindow('"+url+"')\"   align=\"left\" style=\"font-size: 14px; padding-left:8px;color:#c0c0c0;\">"+note+"</td>
			</tr>
		</table>";
	}
	var sript="<script>
		function buttonfile(appfile){
			window.open(appfile);
		}
	</script>";
	
	return sript+html;

}

//
// APP主菜单界面
//
function appmenu()
{
	var sql="";
	var ds = "";
	var ds1 = "";
	var html="";
	
	html+="<style type='text/css'>
		.main{width:100px;height:100px;float:left;}
		
		div a:hover{width:100px;height:100px;background-color:rgb(214,214,214);text-decoration:none;border-radius: 10px;}
		a:hover .note{background-color:rgb(214,214,214);}
		li{list-style-type:none;}
			
	    	.note{width:100px;height:25px;font-size:14px;font-family:微软雅黑;color:#000000;background:#eee;max-width:98px;margin-left:15px;}
	    	
		.image{width:60px;height:60px;margin-bottom:25px;margin-top:5px;font-size:10px;微软雅黑;color:#000000;border-radius:50%;}

		.noteOne{width:90px;margin-left:-3px;margin-top:10px;height:20px;font-size:14px;border-radius: 10px;background:#FFFFFF;font-family:微软雅黑;color:#000000;border:1px solid #CCC;}	
		</style>";

	
	sql="select * from shhk_RelApp order by dat desc";
	ds=db.QuerySQL(sql);
	
	for(var i=0;i<9;i++){
		var img=ds.getStringAt(i,"img");
		var name=ds.getStringAt(i,"name");
		var fromid = ds.getStringAt(i,"id");
		
		if(fromid != ""){
			html+="<div class=\"main\">
		        	<a style=\"display:block;\" onclick=\"openWindow('L.sp?id=SHHK_APPINFO&APPID="+fromid+"');\">
		            		<div style=\"width:90px;height:60px;margin-left:15px;\">
		            			<img alt=\"Logo\" src=\"EAFormBlob.sp?guid="+img+"\" class=\"image\">
		            		</div>
					<span style=\"height:7px;display:block;\"></span>
			                <span class=\"note\" align=\"center\">"+name+"</span>
		       		</a> 
	        	</div>";
        	}else{
        		break;
        	}
        }
	return html;
}


function marqueeMenu(){
	
	var style="";
	var ret="";
	var sript="";
	var html="";
	var os = new pubpack.EAScript(null);
	os.DefineScopeVar("request", request);
	var retos = os.CallClassFunc(SYT_MW,FUNID,null);
	html+="<div class=\"container_12\" style=\"background-color:#fff;\">
			<div id=\"sliderA\" class=\"slider\">"+retos.castToString()+"</div>		
	</div>";
	
	return html;
}

}