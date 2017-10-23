function x_ImportToTmpTable(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var filepack = new JavaPackage ( "java.io" );
function save()
{
      var db = null;
      var msg= "";
      var sql = "";
      try {
      	    if ( dsname == "" ) db = new pubpack.EADatabase();
            else db = new pubpack.EADatabase(dsname);	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
            var ds = new pubpack.EAXmlDS(xmlstr);		// �Ѵ����xml�ŵ�����
            // ������ʱ��
            sql = "CREATE TABLE "+tablename + "(" ;
            for ( var i=0;i<ds.getColumnCount();i++ ) {
            	if ( i!= 0 ) sql+=",";
            	sql+= ds.getColumnName(i)+" varchar(255) ";
            	
            }
            sql+=")";
            db.ExcecutSQL(sql);
//            pubpack.EAFunc.Log(sql);
            // ��������
            var cnt = ds.getRowCount();
            for ( var i=0;i<cnt;i++ ) {
            	sql = "INSERT INTO "+tablename +" values( ";
            	for ( var j=0;j<ds.getColumnCount();j++ ) {
            		if ( j!= 0 ) sql+=",";
            		sql+= "'"+ds.getStringAt(i,j)+"' ";
            	}
            	sql+=")";
            	db.ExcecutSQL(sql);

            }                
            msg="����"+cnt+"�ʼ�¼��"+tablename  ;
	    db.Commit();	
      }
      catch ( ee ) {
            db.Rollback();
            throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
      return msg;
}
// ���ٱ���һ��csv�ļ�
function savetxt()
{
      var db = null;
      var msg= "";
      var sql = "";
      var sscollist ;//�е�����
      var sCollist = "";
      try {
      	    if ( dsname == "" ) db = new pubpack.EADatabase();
            else db = new pubpack.EADatabase(dsname);	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
            // ������ʱ��
            
            if ( useFirstRow == 1 ) {
            
            }
            else {
            	    sql = "CREATE TABLE "+tablename + "(" ;	
	            for ( var i=0;i<50;i++ ) {
	            	if ( i!= 0 ) sql+=",";
	            	sql+="S"+i+" varchar2(1024) ";
	            }
	            sql+=")";
            	    try {db.ExcecutSQL(sql);}catch(  e ) {msg+="��"+tablename+"�Ѵ��ڣ������¼";}
	    }
            
            
            // �ȱ��浽��ʱ�ļ�
            var filename = pubpack.EAOption.dynaDataRoot+"/tmp.txt";
	    pubpack.EAFunc.WriteToFile(filename, txt);
            var fi = new filepack.FileInputStream(filename);
            var ir = new filepack.InputStreamReader(fi,"GBK");
            var reader = new filepack.BufferedReader(ir);
            var lineStr = "";
            var expDiv  = div ;
            var cnt = 0 ;
           
	    while ((lineStr = reader.readLine()) != null)
            {
                    var strval = lineStr.split(expDiv  );
//                    throw new Exception(strval );
                    var collist = "";
                    var vallist = "";
                    if ( useFirstRow == 1 && cnt==0  ) {
                    	 
			    sql = "CREATE TABLE "+tablename + "(" ;	
		            for ( var j=0;j<strval.length();j++ ) {
		            	if ( j!= 0 ) {sql+=",";sCollist +=",";}
		            	sql+=strval[j]+" varchar2(1024) ";
		            	sCollist +=strval[j];
		            }
		            sql+=")";
		            sscollist = sCollist.split(",");
		           	

	            	    try {db.ExcecutSQL(sql);}catch(  e ) {msg+="��"+tablename+"�Ѵ��ڣ������¼";}
                    }
                    else {
//                    GN_TMP_MATCH
	                    // ��������
	               	    sql = "INSERT INTO "+tablename+"(" ;
	            	    for ( var j=0;j<strval.length();j++ ) {
	            		if ( j!= 0 ) {
	            			vallist +=",";
	            			collist += ",";
	            		}
	            		if ( useFirstRow == 1){
	            			//
	            			if ( j>=sscollist .length() ) {
	            				//throw new Exception ( "��ϸ�������"+j+",�������е�����"+sscollist .length()+"��������"+sCollist +",�����˳�" );
	            			}
	            			else 
	            				collist+=sscollist [j];
	            		}
	            		else  
		            		collist+="S"+j;
	            		vallist += "'"+strval[j]+"' ";
	            	    }
	            	    sql+=collist+") values( "+vallist +")";
	            	    
	            	    db.ExcecutSQL(sql);
	            }
		    cnt ++;
            }                
            msg+=" ����"+(cnt-1)+"�ʼ�¼��"+tablename  ;
	    db.Commit();
	    reader.close();
	    fi.close();
      }
      catch ( ee ) {
            db.Rollback();
            throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
      return msg;
}


}