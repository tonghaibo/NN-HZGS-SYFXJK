function x_vapp_usr(){var pub= new JavaPackage("com.xlsgrid.net.pub");
var pubpack= new JavaPackage("com.xlsgrid.net.pub");
var xmldb= new JavaPackage("com.xlsgrid.net.xmldb");
var xmldbpack = new JavaPackage ( "com.xlsgrid.net.xmldb" );
var iopack = new JavaPackage ( "java.io" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );
var utilpack = new JavaPackage ( "java.util");
var basePath = pubpack.EAOption.dynaDataRoot;

var langpack = new JavaPackage("java.lang");

var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

// �ͻ���param����Ĳ�������ֱ��ʹ��
function savehost()
{
	var db = null;
	var msg= "";
	var sql= "";
	try {
		db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
		//sql = "update usr set hostip='"+hostip+"',usrid='"+usrid1+"',userpwd='"+userpwd+"' where id = '"+id+"'";
		sql ="delete from vapp_user where usrguid=(select guid from usr where id='"+usrid+"')";
		db.ExcecutSQL(sql);
		sql = "insert into vapp_user(usrguid,hostip,usrid,userpwd,useflg) 
				select guid,'"+hostip+"','"+usrid+"','"+userpwd+"','"+useflg+"'  from usr 
				where id='"+usrid+"'";
		//				throw new Exception(sql);
	
		exec( "net user "+usrid+" /delete ");
		exec( "net user "+usrid+" 0 /add ");
		exec( "net localgroup \"Remote Desktop Users\" "+usrid+" /add ");
//		exec( pubpack.AppStartListener.approot +"cmd/netuser "+usrid+" /pwnexp:y ");
		db.ExcecutSQL(sql);
				
	}catch ( e){
		throw new pubpack.EAException ( "����ʧ��" +e.toString() );

	}
	db.Commit();
	return("���³ɹ�");		
}
//ִ��һ��������
function exec( command ) {
	var proc = langpack.Runtime.getRuntime().exec(command);
	return proc.waitFor();
}
}