function x_newguide(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
// JS传入的参数（yymm）可以直接使用
function SAVE()
{
      var db = null;
      var msg= "";
      var ds = null;
      try {
      
      	        db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
      		
      		ds = new pubpack.EAXmlDS(xml);
      		
      		if(flag == "saveorg"){
      			for ( var i=0;i<ds.getRowCount();i++ ) {
	      			var orgid = ds.getStringAt(i,"ORGID" );
	      			var orgnam = ds.getStringAt(i,"ORGNAM" );
				var orgid = ds.getStringAt(i,"ORGID" );
				//db.ExcecutSQL( "insert into usr(org,id,name) values('" + "')");
				throw new pubpack.EAException("该功能尚未完成..." );
	      		}
      		}
      		if(flag == "saveusr"){
      			for(var i=0;i<ds.getRowCount();i++){
      				var orgid = ds.getStringAt(i,"ORG");
      				var usrid = ds.getStringAt(i,"USRID");
      				var usrnam = ds.getStringAt(i,"USRNAM");
      				var usrpwd = ds.getStringAt(i,"USRPWD");
      				var tel = ds.getStringAt(i,"TELEPHONE");
      				
      				db.ExcecutSQL("insert into usr(org,id,name,passwd,mobile,useflg)values('" 
      					+ orgid + "','" + usrid + "','" + usrnam + "','" + usrpwd + "','" + tel + "','1')");
      			}
      			msg = "用户添加成功！";
      		}
      }
      catch ( ee ) {
            db.Rollback();
            throw new pubpack.EAException ( "Error:" + ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
      return msg;
}

}