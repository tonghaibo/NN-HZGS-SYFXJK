function x_showflg_MENU(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var pub = new JavaPackage ( "com.xlsgrid.net.pub" );
var web = new JavaPackage ( "com.xlsgrid.net.web" );

var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");	
var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb");
var layoutpack = new JavaPackage ( "com.xlsgrid.net.layout");
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd");	
var langpack = new JavaPackage ( "java.lang");


function getlinkage(){

	var sql="";
	var html="";
	if(onmouseovercolor==null)  onmouseovercolor="";
	if(onmouseoverground==null) onmouseoverground="";
	if(clickbackground==null) clickbackground="";
	if(clickcolor==null) clickcolor="";
//	var divli="<div style=\"border:0px solid #CCCCCC;width:100%; height:100%;background-color:#ffffff;\"><ul  id=\"leftmenu0\">";
	var script="";
	var cdcnt = db.GetSQL("select CDMSSMCNT.Nextval CNT from dual");
	if(SQLTXT=="")
		sql="select guid,url,icon2,name,seqid,CONTEXTES,target,id from LSYSURL a where REFID='"+DSMOD+"' order by id";
	else
		sql=SQLTXT;
	var ds=db.QuerySQL(sql);
	var onurl="";
	var onguid="";
	var onid="";
	var st = new Array(); 
	var divli="";
	for(var i=0;i<ds.getRowCount();i++){
		var id=ds.getStringAt(i,"id");
		var url=ds.getStringAt(i,"url");
		url=pub.EAFunc.Replace(url,"#$amp;","&");
		var gusrinfo=web.EASession.GetUserinfo(request);
		if(gusrinfo!=null){
			url=web.EASession.GetSysValue(url,request);//Ìæ»»request ÖÐ[%id]
			url=web.EASession.GetSysValue(url,web.EASession.GetUserinfo(request));
		}
		while((url.indexOf("[%")>-1&&i<1000)){
			var idx1 = url.indexOf("[");
			
			var idx2 = url.indexOf("]")+1;
			
			var val=url.substring(idx1,idx2);
			url=pub.EAFunc.Replace(url,val,"");
		}

	
		var target=ds.getStringAt(i,"target");
		if(onurl==""&&ds.getStringAt(i,"url")!="") {onurl=url; onguid=ds.getStringAt(i,"guid"); onid=ds.getStringAt(i,"id"); }

		st.push(id);
		divli+="<tr><td id=\"td"+id+"\" style=\"cursor:pointer; border:1px #EAEAEA solid;background:#d7d7dc;\"  align='center' width=100% height=30px onMouseOut=\"setoutcolor"+cdcnt+"(this.id)\" onmouseover=\"setovercolor"+cdcnt+"(this.id)\" onclick=\"setTab"+cdcnt+"(this.id,'"+url+"','"+target+"')\" >"+ds.getStringAt(i,"name")+"</td></tr>";
		
	}
	
	script="<script type=\"text/javascript\">
			
			
			function setTab"+cdcnt+"(id,url,target)
			{ 
				var str="+st+";
				for ( var i=0;i<str.length;i++){
					var rid=\"td\"+str[i];
					document.getElementById(rid).style.background='#d7d7dc';
					document.getElementById(rid).style.color='#000000';
				}
				document.getElementById(id).style.background='"+clickbackground+"';
				document.getElementById(id).style.color='"+clickcolor+"';
				if(target==\"_self\"){
					
				}
				else if (target==\"_blank\"){
				
				}
				else if (target==\"_parent\"){
					
				}
				else if (target!=\"\"){
					
				}
				else {
					
					$.get(url,function(data,status){
					document.getElementById(\"divme1"+cdcnt+"\").innerHTML=data;
				});
					
				}			}
			function setovercolor"+cdcnt+"(id){
//				document.getElementById(id).style.color='"+onmouseovercolor+"';
					document.getElementById(id).style.background='"+onmouseoverground+"';
			}
			function setoutcolor"+cdcnt+"(id){
					document.getElementById(id).style.background='#d7d7dc';
//				document.getElementById(id).style.color='#000000';
			}
		</script>";
	script+="<script>(function() { 
				$.get('"+onurl+"',function(data,status){
					document.getElementById(\"divme1"+cdcnt+"\").innerHTML=data;
				}); 
				})();
	</script>";
	var style="<style type='text/css'>


		</style>";
	var loyhtml="";
	html+="<div style=\"position:relative ;width:100%;margin:0px;height:100%;border:1px solid #d7d7dc; \">
			<div style=\"margin:0px;padding:0px;float:left;width:25%;height:100%;\" >
				<table id=tbhower style=\"width:100%;height:100%\">
				 	<tr valign=\"top\">
						<td>"+divli+"</td>
					<tr>	
				 </table>
			 </div>
			 <div  id=\"divme1"+cdcnt+"\" style=\"margin:0px;padding:0px;float:left;width:74%;height:100%;\"></div>
		 </div>";
	return style+script+html;
}


function os()
{
	var eas = new pub.EAScript(null);
	eas.DefineScopeVar("request", request);
	eas.DefineScopeVar("deforg", deforg);
	eas.DefineScopeVar("OSPARAM", OSPARAM);
	
	return eas .CallClassFunc(OSMWID,OSFUNC,null).castToString();
}


}