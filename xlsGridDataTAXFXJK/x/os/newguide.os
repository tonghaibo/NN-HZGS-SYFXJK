function x_newguide(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
// JS����Ĳ�����yymm������ֱ��ʹ��
function SAVE()
{
      var db = null;
      var msg= "";
      var ds = null;
      try {
      
      	        db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
      		
      		ds = new pubpack.EAXmlDS(xml);
      		
      		if(flag == "saveorg"){
      			for ( var i=0;i<ds.getRowCount();i++ ) {
	      			var orgid = ds.getStringAt(i,"ORGID" );
	      			var orgnam = ds.getStringAt(i,"ORGNAM" );
				var orgid = ds.getStringAt(i,"ORGID" );
				//db.ExcecutSQL( "insert into usr(org,id,name) values('" + "')");
				throw new pubpack.EAException("�ù�����δ���..." );
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
      			msg = "�û���ӳɹ���";
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