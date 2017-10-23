function x_localfile(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
//作为.sp服务时的入口
//预定义变量：request,response
function Response()
{
      var code = request.getParameter("path");
      var db = null;
      var ret= "";
      try {
            db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
            var fileds = getfilelist (pubpack.EAOption.dynaDataRoot + "xmidware/flash/icon/");
            ret +="<table>";
            
            for ( var i=0;i<fileds.getRowCount();i++ ) {
            	if(i%8==0&&i!=0) 
            		ret+="</tr>";

            	if(i%8==0)
            		ret+="<tr>";
            	ret +="<td><table><tr><td align=center onmouseover=\"this.style.backgroundColor='#DBEBFA';this.style.cursor='hand';\" onmouseout=\"this.style.backgroundColor='#EFF7FF';\"  onclick=\"javascript:window.returnValue='"+fileds.getStringAt(i,"RETURL")+"';window.close();\"><img src=\""+fileds.getStringAt(i,"URL")+"\" border=0/><BR>"+fileds.getStringAt(i,"ID")+"</td></tr></table></td>";
		            
            	
            }
            ret+="</tr></table>";
            
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
function getfilelist (fileurl){
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
				if ( index >=0  ) {
					var row= ds.AddRow(ds.getRowCount()-1);
				
					//ds.setValueAt(row,"SEQID",num);
					var layoutid = filename.substring(0,index);
					ds.setValueAt(row,"ID",layoutid );
					ds.setValueAt(row,"RETURL","resource://"+layoutid  );
					ds.setValueAt(row,"URL","xlsgrid/images/flash/icon/"+filename  );

					
				}	
			}
		}
	}
	return ds;
}
}