function TAXMON_TS(){var pub = new JavaPackage ( "com.xlsgrid.net.pub" );
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var pubpack = new JavaPackage("com.xlsgrid.net.pub");
var xlsdb = new JavaPackage ( "com.xlsgrid.net.xlsdb" );

function getbilid(){
	var db = new pubpack.EADatabase();
	
	var bilid =db.GetBillid(accids,"TK","TK");
	return bilid;
}	
}