function x_iconbatch(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var pub = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
//作为.sp服务时的入口
//预定义变量：request,response
//iconbatch.sp?rettyp=WEBPATH&path=
function Response()
{
      var path = pubpack.EAFunc.NVL(request.getParameter("path"),"xlsgrid/images/flash/icon/");//"xmidware/flash/icon/"
      var rettyp = pubpack.EAFunc.NVL(request.getParameter("rettyp"),"RESPATH");// 默认时候返回资源编号,如果=WEBPATH 返回路径
      var issub= pubpack.EAFunc.NVL(request.getParameter("issub"),"0");//是否子页面
      var db = null;
      var ret= "";
      var sql="";
      var ds="";
      try {
            db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
          
            
            
            if(issub=="0"){
            	ret+="<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=gb2312\"><title>图片资源选择</title></head><body >\n";
            	ret+="<style type='text/css'>\n";
		ret+="A { COLOR: #FFFFFF;TEXT-DECORATION: none}\n";
		ret+="A:link { COLOR: #FFFFFF;TEXT-DECORATION: none}\n";
		ret+="A:visited { COLOR: #FFFFFF;TEXT-DECORATION: none}\n";
		ret+="A:hover { COLOR: #FFFF00;TEXT-DECORATION: underline}\n";
		ret+="TD {FONT-SIZE: 10.5pt}\n";
		ret+="BODY {FONT-SIZE: 10.5pt}\n";
		ret+="</style>\n";
		ret+="<body>\n";
	        ret+="<table width=100% height=100% cellspacing=\"0\" cellpadding=\"2\"><tr><td height=30 align=left style=\"border-bottom: 1px solid #C0C0C0; padding-bottom: 1px\" bgcolor=\"#666666\"><font color=#FFFFFF>当前目录："+path+"&nbsp;</font></td><td height=30 align=right style=\"border-bottom: 1px solid #C0C0C0; padding-bottom: 1px\"  bgcolor=\"#666666\"><font color=#FFFFFF>";
	        
	        ret+="选择其他&nbsp;<a href='#' onclick=\"frames[0].location='iconbatch.sp?path=xlsgrid/images/flash/icon/&issub=1&rettyp="+rettyp+"';\">wp8icon</a>&nbsp;<a href='#' onclick=\"frames[0].location='iconbatch.sp?path=xlsgrid/images/flash/appicon/&issub=1&rettyp="+rettyp+"';\">白色透明图标</a>&nbsp;<a href='#' onclick=\"frames[0].location='iconbatch.sp?path=xlsgrid/images/flash/images/&issub=1&rettyp="+rettyp+"';\">background</a>&nbsp;<a href='#' onclick=\"frames[0].location='iconbatch.sp?path=xlsgrid/images/entry/&issub=1&rettyp="+rettyp+"';\">entry</a>&nbsp;<a href='#' onclick=\"frames[0].location='iconbatch.sp?path=xlsgrid/images/button/&issub=1&rettyp="+rettyp+"';\">button</a>&nbsp;<a href='#' onclick=\"frames[0].location='iconbatch.sp?path=xlsgrid/images/file/&issub=1&rettyp="+rettyp+"';\">fileicon</a>&nbsp;<a href='#' onclick=\"frames[0].location='iconbatch.sp?path=xlsgrid/images/icon/&issub=1&rettyp="+rettyp+"';\">smlicon</a>&nbsp;<a href='#' onclick=\"frames[0].location='iconbatch.sp?path=xlsgrid/images/toolbar/&issub=1&rettyp="+rettyp+"';\">toolbar</a>&nbsp;<a href='#' onclick=\"frames[0].location='iconbatch.sp?path=xlsgrid/images/&issub=1&rettyp="+rettyp+"';\">images</a>&nbsp;";    
	       	        ret+="<tr><td colspan=2><iframe width=100% height=100% src=\"iconbatch.sp?path="+path+"&rettyp="+rettyp+"&issub=1\" frameborder=0></td></table></body></html>";
            	
            }
            else {
            	var fileds = getfilelist (pub.AppStartListener.approot + path,path);
            	ret +="<table>";
	            for ( var i=0;i<fileds.getRowCount();i++ ) {
	            	if(i%8==0&&i!=0) 
	            		ret+="</tr>";
	
	            	if(i%8==0)
	            		ret+="<tr>";
	            	//DBEBFA  EFF7FF
	            	ret +="<td><table><tr><td bgcolor='#808080' align=center onmouseover=\"this.style.backgroundColor='#0000FF';this.style.cursor='hand';\" onmouseout=\"this.style.backgroundColor='#808080';\"  onclick=\"javascript:window.returnValue='"+fileds.getStringAt(i,rettyp)+"';window.close();\"><img src=\""+fileds.getStringAt(i,"URL")+"\" border=0 width=120 height=120 /><BR><font color=#FFFFFF>"+fileds.getStringAt(i,"ID")+"</font></td></tr></table></td>";
			            
	            	
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
function getfilelist (fileurl,path){
	var folds = (new java.io.File(fileurl)).listFiles();
	var ds = new pubpack.EAXmlDS();
	if ( folds != null ) {
		folds=pub.EAFunc.sort(folds);
		var c = folds.length();
		for(var i=0;i<c;i++) {
			var f=folds[i];
			if(!f.isDirectory() ) {
				var filename = f.getName();
            			var index = filename.indexOf(".png");
            			if(index<0)index =filename.indexOf(".jpg");
            			if(index<0)index =filename.indexOf(".gif");
            			if(index<0)index =filename.indexOf(".bmp");
				if ( index >=0 ) {
					var row= ds.AddRow(ds.getRowCount()-1);
				
					//ds.setValueAt(row,"SEQID",num);
					var layoutid = filename.substring(0,index);
					ds.setValueAt(row,"ID",layoutid );
					ds.setValueAt(row,"RESPATH","resource://"+layoutid  );
					ds.setValueAt(row,"WEBPATH",path+filename );

					ds.setValueAt(row,"URL",path+filename  );

					
				}	
			}
		}
	}
	return ds;
}
}