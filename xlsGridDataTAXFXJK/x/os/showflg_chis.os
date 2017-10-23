function x_showflg_chis(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var pub = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd" );
var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var langpack = new JavaPackage ( "java.lang" );
var servletpack = new JavaPackage ( "com.xlsgrid.net.servlet");


function getlayout(request,layoutid){
	var db = null;
	var msg= "";
	var objid= pubpack.EAFunc.NVL( request.getParameter("objid"),"") ;
	var skin= pubpack.EAFunc.NVL( request.getParameter("skin"),"") ;
	var hashead = pubpack.EAFunc.NVL( request.getParameter("hashead"),"y") ;
	var deforg =  pubpack.EAFunc.NVL( request.getParameter("thisorgid"),webpack.EAWebDeforg.GetDeforg(request)) ;
	var browsetype = pubpack.EAFunc.getBroswerType( request );
	var sb=new langpack.StringBuffer();
	try{	
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var parent = new x_L();
		parent.GetLayoutHTML(db,request,sb,deforg,layoutid,0,"","");
	}
		catch ( ee ) {
			db.Rollback();
			sb.append(ee.toString());
			//throw new pubpack.EAException ( ee.toString() );
		}
		finally {
			if (db!=null) db.Close();
		}

	return sb.toString();
}
//
// 
//
function SJAPPTYP(){
		
	var typ =DSMOD ;
	var ds=db.QuerySQL("select * from lsysurl where org='"+deforg+"' and refid='"+typ+"' order by id");

	var div="";
	var displaydiv="";
	var rowcnt=ds.getRowCount();
	var st = new Array(); 
	var cdcnt = db.GetSQL("select CDMSSMCNT.Nextval CNT from dual");
	var css="<style>
		    .nav_a"+cdcnt+" {
		        color:#666666;
		        cursor: pointer;
		        float: left;
		        font-size: 14px;
		        height:40px;
		        line-height:40px;
		        padding: 0px 15px;
		        position: relative;
		        border-right:1px solid #CFCFCF;
		    }
		    .nav_a"+cdcnt+"_1{
		        color:#666666;
		        cursor: pointer;
		        float: left;
		        font-size: 14px;
		        height:40px;
		        line-height:40px;
		        padding: 0px 15px;
		        position: relative;
			background:#999999;
			border-right:1px solid #CFCFCF;
		    }
		
		    .nav"+cdcnt+" {
		        height:40px;
		
		    }
		    #dr"+cdcnt+" div:hover{
		        cursor:pointer;
		    }
		    </style>";
	var menulog= MENUID;
	for(var i=0; i<rowcnt;i++){
		var id=ds.getStringAt(i,"id");
		var name=ds.getStringAt(i,"name");
		var url=ds.getStringAt(i,"url");
		url=pub.EAFunc.Replace(url,"#$amp;","&");
		st[i]=id;
		var onmo="";
		var loyhtml="";
		if(url!=""){
			var layoutid=url.split("&")[0];
			layoutid=layoutid.split("=")[1];
	
			loyhtml=getlayout(request,layoutid);
		}
		if(i==0){
			div+="<DIV onclick=\"swithpage"+typ+cdcnt+"(this.id,'"+url+"')\" "+onmo+" id="+id+" class=\"nav_a"+cdcnt+"_1\">"+name+"</DIV>";
			displaydiv+="<div id=\"dsy_"+id+"\"  width=\"100%\" height=\"100%\" frameborder=\"0\" src=\"\" style=\"display:block;\">"+loyhtml+"</div>";
		}
		else{
			div+="<DIV onclick=\"swithpage"+typ+cdcnt+"(this.id,'"+url+"')\" "+onmo+" id="+id+" class=\"nav_a"+cdcnt+"\">"+name+"</DIV>";
			displaydiv+="<div id=\"dsy_"+id+"\"  width=\"100%\" height=\"100%\" frameborder=\"0\" src=\"\" style=\"display:none;\">"+loyhtml+"</div>";
		}
	}
	var html="<div id=\"dsy_menu\" style=\"width:100%; height:100%; float:left;display:none\"></div>";
	
	html+="<div id=\"sjapp_menu\" >"+displaydiv+"</div><div style=\"position:fixed; OVERFLOW: hidden;bottom:0;right: 0px; BACKGROUND-COLOR:#E8E8E8; width:100%\"><DIV id=dr"+cdcnt+" class=nav"+cdcnt+" style=\"FLOAT: left\">"+div+"</div></div>";
	var script="<script>
			var onclickid='"+ds.getStringAt(0,"id")+"';
			var refids = new Array(); 
			function swithpage"+typ+cdcnt+"(frameid,url){
				if(onclickid!=frameid){
					document.getElementById(frameid).style.background=\"#999999\";
					document.getElementById(onclickid).style.background=\"#E8E8E8\";
					var bkdivid=\"dsy_\"+frameid;
					var nodivid=\"dsy_\"+onclickid;
					document.getElementById(bkdivid).style.display=\"block\";
					document.getElementById(nodivid).style.display=\"none\";
					onclickid=frameid;
				}
			}
	</script>";
	
	return css+html+script;
}

function ImgArr(){
	var db = null;
	var ds = null;
	var sql = "";
	var html = "";
	
	sql = SQLTXT;
	sql = pubpack.EAFunc.Replace(sql,"#$amp;lt;","<");
	db = new pubpack.EADatabase();
	ds = db.QuerySQL(sql);
	
	html += "<table width=\"100%\"><tr align=\"center\" >";
	for (var r = 0;r < ds.getRowCount(); r ++) {
		var nam = ds.getStringAt(r,"name");
		var post = ds.getStringAt(r,"postnote");
		var imgguid = ds.getStringAt(r,"imgguid");
		var sr = "EAFormBlob.sp?guid="+imgguid;
		html += "<td><div><img src=\""+sr+"\" width=\"80px\"style=\"margin:15px;border-radius:50%;\" /></div><div>"+nam+"</div><div>"+post+"</div></td>";
	}	
	html +=	"</tr></table>";
	return html;
}
}