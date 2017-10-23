function x_LAYICONFONT(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var iopack = new JavaPackage ( "java.io" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var utilpack = new JavaPackage ( "java.util");
var basePath = pubpack.EAOption.dynaDataRoot;
//作为.sp服务时的入口
//预定义变量：request,response
//iconbatch.sp?rettyp=WEBPATH&path=
function Response()
{
      var path = pubpack.EAFunc.NVL(request.getParameter("path"),"xlsgrid/images/flash/icon/");//"xmidware/flash/icon/"
      var typ = pubpack.EAFunc.NVL(request.getParameter("typ"),"");// 皮肤的分类
      var issub= pubpack.EAFunc.NVL(request.getParameter("issub"),"0");//是否子页面
      var db = null;
      var ret= "";
      var sql="";
      var ds="";
      try {
            db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
          

            if(issub=="0"){
            	ret+="<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\"><title>图片资源选择</title></head><body>\n";
            	ret+="<style type='text/css'>\n";
		ret+="A { COLOR: #FFFFFF;TEXT-DECORATION: none}\n";
		ret+="A:link { COLOR: #FFFFFF;TEXT-DECORATION: none}\n";
		ret+="A:visited { COLOR: #FFFFFF;TEXT-DECORATION: none}\n";
		ret+="A:hover { COLOR: #FFFF00;TEXT-DECORATION: underline}\n";
		ret+="TD {FONT-SIZE: 10.5pt}\n";
		ret+="BODY {FONT-SIZE: 10.5pt}\n";
		ret+="</style>\n";
		ret+="<body>\n";
	        ret+="<table width=100% height=100% cellspacing=\"0\" cellpadding=\"5\"><tr><td height=30 align=right style=\"border-bottom: 1px solid #C0C0C0; padding-bottom: 1px\"  bgcolor=\"#666666\"><font color=#FFFFFF>当前目录："+path+"&nbsp;</font></td><td height=30 align=right style=\"border-bottom: 1px solid #C0C0C0; padding-bottom: 1px\"  bgcolor=\"#666666\"><font color=#FFFFFF>";
	        sql="select distinct typid typ from layimghdr";
	        ds=db.QuerySQL(sql);
	        if(ds.getRowCount()>0){
	        	if(typ==""){
	            		typ=ds.getStringAt(0,"typ");
	            	}
	        	for(var r=0;r<ds.getRowCount();r++){
	        		ret+="<a href='#' onclick=\"frames[0].location='LAYIMG.sp?path=xlsgrid/images/flash/icon/&issub=1&typ="+ds.getStringAt(r,"typ")+"';\">"+ds.getStringAt(r,"typ")+"</a>&nbsp;";
	        	}
	        }
	     //   ret+="选择其他&nbsp;<a href='#' onclick=\"frames[0].location='iconbatch.sp?path=xlsgrid/images/flash/icon/&issub=1&rettyp="+rettyp+"';\">wp8icon</a>&nbsp;<a href='#' onclick=\"frames[0].location='iconbatch.sp?path=xlsgrid/images/flash/images/&issub=1&rettyp="+rettyp+"';\">background</a>&nbsp;<a href='#' onclick=\"frames[0].location='iconbatch.sp?path=xlsgrid/images/entry/&issub=1&rettyp="+rettyp+"';\">entry</a>&nbsp;<a href='#' onclick=\"frames[0].location='iconbatch.sp?path=xlsgrid/images/button/&issub=1&rettyp="+rettyp+"';\">button</a>&nbsp;<a href='#' onclick=\"frames[0].location='iconbatch.sp?path=xlsgrid/images/file/&issub=1&rettyp="+rettyp+"';\">fileicon</a>&nbsp;<a href='#' onclick=\"frames[0].location='iconbatch.sp?path=xlsgrid/images/icon/&issub=1&rettyp="+rettyp+"';\">smlicon</a>&nbsp;<a href='#' onclick=\"frames[0].location='iconbatch.sp?path=xlsgrid/images/toolbar/&issub=1&rettyp="+rettyp+"';\">toolbar</a>&nbsp;<a href='#' onclick=\"frames[0].location='iconbatch.sp?path=xlsgrid/images/&issub=1&rettyp="+rettyp+"';\">images</a>&nbsp;";    
	       	  ret+="<tr><td colspan=2><iframe width=100% height=100% src=\"LAYIMG.sp?path="+path+"&typ="+typ+"&issub=1\" frameborder=0></td></table></body></html>";
            }
            else {
            	//throw new Exception(typ);
            	var fileds = getfilelist (db,typ);
            	ret +="<table>";
	            for ( var i=0;i<fileds.getRowCount();i++ ) {
	            	if(i%8==0&&i!=0) 
	            		ret+="</tr>";
	            	if(i%8==0)
	            		ret+="<tr>";
	            	ret +="<td><table><tr><td align=center onmouseover=\"this.style.backgroundColor='#DBEBFA';this.style.cursor='hand';\" onmouseout=\"this.style.backgroundColor='#EFF7FF';\"  onclick=\"javascript:window.returnValue='"+fileds.getStringAt(i,"url")+"';window.close();\"><img src=\""+fileds.getStringAt(i,"img")+"\" border=0 width=120 height=120 /><BR>"+fileds.getStringAt(i,"id")+"</td></tr></table></td>";
	            }
	        ret+="</tr></table>";
	    }            
      }
      catch ( ee ) {
            db.Rollback();
            throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
      return ret ;
}
function getfilelist (db,typ){
	var ds="";
	var sql="";
	sql="select 'EAImgBlob.sp?guid='||guid url,typid typ,imgnote id,guid,defimg img from LAYIMGHDR where TYPID='"+typ+"'";
	ds=db.QuerySQL(sql);
	return ds;
}
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
  bodysb.insert(0,"<form id=\"myfilef\"><input type=\"file\" id=\"myfile\" style=\"display:none\"></input></form>");
}

// 复制xlsGridData到web
// 参数 deforg  sysurlid 
function copytoweb()
{
	var srcpath = basePath +"xmidware/flash/iconfont/"+ id +"/" ;//+ "/" +filename
	var destpath = pubpack.EAOption.approot+"/xlsgrid/images/flash/iconfont/"+id+"/"  ;//+ "/"+filename

	pubpack.EAFunc.copyDirectiory(srcpath,destpath,"","CVS",true );
	return "服务端：文件已从"+ srcpath +"同步到"+destpath ;
}


}