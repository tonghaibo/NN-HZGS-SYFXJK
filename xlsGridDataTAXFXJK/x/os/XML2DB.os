function x_XML2DB(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
//��Ϊ.sp����ʱ�����
//Ԥ���������request,response
// ����
//	dbname : ���ݿ�ı���,��ISOGRAPH
//      dbtype:  ���ݿ������,��ORACLE/SQLSERVER/ACCESS
//	dbxml:���ݿ�ṹ�����XML����XML��Ҫ�������ֶ��� TABLEID��COLID��COLTYP��COLLEN�� 
//      ������ ÿ��TABLE��XML����ЩTABLE��Ҫ������dbxml��TABLEID��
// ���أ�
//	�������˵��
function Response()
{
      var dbname =pubpack.EAFunc.NVL( request.getParameter("dbname"),"" );
      var dbtype =pubpack.EAFunc.NVL( request.getParameter("dbtype"),"ORACLE" );
      var dbxml =pubpack.EAFunc.NVL( request.getParameter("dbxml"),"" );

      if ( dbxml == "" ) return "����dbxml����";
      var db = null;
      var ret= "";
      var tablename="";
      try {
      		
            db = new pubpack.EADatabase(dbname);	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
	
            var tabds = new pubpack.EAXmlDS(dbxml);
            var oldtablename = "";
            var createsql = "";
            var collistsql = "";
            var inscollist = "";
            var inscoltyplist = "";
            //������ṹ
            var tablelist= "";
            for ( var i=0;i<tabds.getRowCount();i++) {
            	tablename = tabds.getStringAt(i,"TABLEID");
            	var colid = tabds.getStringAt(i,"COLID");
            	var coltyp = tabds.getStringAt(i,"COLTYP");
            	var collen = tabds.getStringAt(i,"COLLEN");

            	if ( tablename!=oldtablename&& oldtablename!= ""){
 
            			createsql = "create table " + oldtablename + "(" + collistsql + ")";
            			try {db.ExcecutSQL("drop table " + oldtablename );}catch( e ) {}
            			db.ExcecutSQL(createsql);
            			if ( tablelist!= "" ) tablelist+=",";
            			tablelist+=oldtablename ;
            			collistsql = "";
            			
            			inscollist +="��";//�ָ�
            			inscoltyplist +="��";
            			
            	}
            	if ( collistsql !="" ) {collistsql += ",";inscollist +=","; inscoltyplist +=",";}
		collistsql += colid +" "+coltyp ;
		if ( collen!="" ) collistsql +="("+collen +")";          
		inscollist += colid ;  
		inscoltyplist += coltyp;   
            	oldtablename=tablename ;
            }

            if ( oldtablename!= "" ) {
		createsql = "create table " + oldtablename+ "(" + collistsql + ")";
		try {db.ExcecutSQL("drop table " + oldtablename);}catch( e ) {}
		db.ExcecutSQL(createsql);
            	if ( tablelist!= "" ) tablelist+=",";
            	tablelist+=oldtablename ;
		
            }
	   
            var stablelist = tablelist.split(",");
            var sinscollist = inscollist.split("��");
            var sinscoltyplist  = inscoltyplist.split("��");

            var nCount = 0;
            for ( var t=0;t<stablelist.length();t++) {
            	var xml =pubpack.EAFunc.NVL( request.getParameter(stablelist [t]),"" );
		if ( xml == "" ) throw new Exception ( "����"+ stablelist [t] + "û�д���" );
            	var ds = new pubpack.EAXmlDS(xml);
            	
            	for ( var i=0;i<ds.getRowCount();i++ ) {
            		var sql = "insert into " + stablelist[t]+ "( " +sinscollist [t] + " ) values( " ;  
            		var ss = sinscollist[t] .split( "," );// �õ�ÿ����	
            		var ss_coltyp = sinscoltyplist[t].split( "," );// �õ�ÿ����	
            		for ( var c= 0;c<ss.length() ;c++ ) {
            			if ( c!= 0 ) sql += ",";
            			try {
            				if ( ss_coltyp[c]=="FLOAT" || ss_coltyp[c]=="INT" || ss_coltyp[c]=="NUMBER" ) {
            					if(ds.getStringAt(i,ss[c])=="")
            						 sql += "null";
            					else sql +=ds.getStringAt(i,ss[c]); 
            				}
					else 
		            			sql += "'"+ds.getStringAt(i,ss[c])+"'"; 
	            		}
	            		catch ( e ) {
	            			throw new pubpack.EAException ( stablelist[t]+"���ֶ�"+ss[c]+"�ڲ���" +stablelist[t]+"������XML�в�����"  );
	            		}
            		
            		}
            		sql += " )";
            		pubpack.EAFunc.Log( sql);

            		nCount += db.ExcecutSQL(sql);
            	}
            	

            }
            
            return "����"+stablelist.length()+"����"+nCount +"�ʼ�¼";
	
      }
      catch ( ee ) {
            db.Rollback();
            ret = ee.toString();
            throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
      return ret ;
}


}