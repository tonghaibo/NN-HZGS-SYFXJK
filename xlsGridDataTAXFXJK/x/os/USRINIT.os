function x_USRINIT(){var pubpack = new JavaPackage("com.xlsgrid.net.pub");
function InitUK()
{
  var newNo = "";
  var db = null;
//  var USBKEY_APPNAME = pubpack.EAOption.get("USBKEY_APPNAME");
  try
  {  
    db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)	
    var sql = "";
    var ds = db.QuerySQL("select * from usrkey where usrid='"+usrname+"'  and SERNUM='"+sernum+"'");
    if ( ds.getRowCount()>0 ) {
    	db.ExcecutSQL("delete from usrkey where usrid='"+usrname+"' and SERNUM='"+sernum+"'" );
    }
    try{
    	sql=" insert into usrkey(usrid,usbkeytyp,keyval,sernum,username,appname ) values ('"+usrname+"','"+keytyp+"','"+key2+"','"+sernum+"','"+myusername+"','"+appname +"') ";
    	
    	db.ExcecutSQL(sql);
    }
    catch( e )
    {
            //try{db.ExcecutSQL("drop table usrkey");}catch( e1 ){       }
            try{
            	db.ExcecutSQL("create table usrkey(guid char(32) default sys_guid() primary key ,usrid varchar2(20) not null,usbkeytyp varchar2(20), keyval varchar2(256), sernum varchar2(32),username varchar2(20),appname varchar2(20) )");
            }
            catch( ee1 ){
              
            }
            db.ExcecutSQL(sql);

    }
    
//    throw new Exception(sql);
 

  }
  catch ( ee ) {
		db.Rollback();
		throw new Exception ( ee.toString() );
  }
  finally {
		if (db!=null) db.Close();
 }
 return "sucess";
}

function UnInitUK()
{
  var newNo = "";
  var db = null;
//  var USBKEY_APPNAME = pubpack.EAOption.get("USBKEY_APPNAME");
  try
  {  
    db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)	
    var sql = " delete from  usrkey where usrid='"+usrname+"' and sernum='"+sernum+"' ";
    if( sernum=="" ) 
    	sql = " delete from  usrkey where usrid='"+usrname+"' ";
	
//    throw new Exception(sql);
    var cnt = db.ExcecutSQL(sql);
	return "操作成功，操作了"+cnt + "笔记录" ; 
  }
  catch ( ee ) {
		db.Rollback();
		throw new Exception ( ee.toString() );
		
  }
  finally {
		if (db!=null) db.Close();
 }
 return "";
}
//查询用户的登记情况
function QueryUser()
{
	var newNo = "";
	var db = null;
	var ret = "NULL";


	  try
	  {  
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)	
	    var sql = " select * from  usrkey where usrid='"+usrid+"' and nvl(sernum,' ') like '"+sernum+"%' ";
	    var ds = db.QuerySQL(sql);
//	    
		if ( ds.getRowCount()>0 ) ret = "";
		
	    for ( var i=0;i<ds.getRowCount();i++ ) {
	   	ret += ""+(i+1)+"."+ds.getStringAt(i,"USERNAME")+"("+ds.getStringAt(i,"APPNAME")+")\r\n";
	    }
  }
	  catch ( ee ) {
		throw new Exception ( ee.toString() );
			
	  }
	  finally {
			if (db!=null) db.Close();
	 }
	 return ret;
}
function GetUsername()
{
	var newNo = "";
	var db = null;
	var ret = usrid;


	  try
	  {  
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)	
	    var sql = " select * from  usr where id='"+usrid+"'  ";
	    var ds = db.QuerySQL(sql);
//	    
		if ( ds.getRowCount()>0 ) return ds.getStringAt(0,"NAME");

  }
	  catch ( ee ) {
		throw new Exception ( ee.toString() );
			
	  }
	  finally {
			if (db!=null) db.Close();
	 }
	 return ret;
}
//暂停一天
function PauseUser()
{
	var newNo = "";
	var db = null;
	var ret = usrid;


	  try
	  {  
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)	
		    var sql = " select * from  usrkeypause where usrid='"+usrid+"' and to_char(crtdat,'YYYY-MM-DD')=to_char(sysdate,'YYYY-MM-DD') ";
		    var ds = null;
		    try{
			    ds = db.QuerySQL(sql);
		    }
		    catch ( ee ) {
		    	db.ExcecutSQL("create table usrkeypause (guid char(32) default sys_guid() primary key ,usrid varchar2(20),crtdat date default sysdate)");
		    	ds = db.QuerySQL(sql);

		    }
		    if ( action=="delete" ) {
		    	db.ExcecutSQL("delete from usrkeypause where usrid='"+usrid+"' and to_char(crtdat,'YYYY-MM-DD')=to_char(sysdate,'YYYY-MM-DD') ");
		    	ret = "取消暂停成功";
		    }
		    else {
			    if (ds.getRowCount()>0 )
			    	ret = "该用户当天的暂停操作已经做过了" ;  
			    else {
				    db.ExcecutSQL("insert into usrkeypause ( usrid ) values('"+usrid+"')");
				    ret = "操作成功";
			    }
		    }
		    db.Commit();
		    
			

	  }
	  catch ( ee ) {
		throw new Exception ( ee.toString() );
			
	  }
	  finally {
			if (db!=null) db.Close();
	 }
	 return ret;
}
function GetAppname()
{
	return pubpack.EAOption.get("USBKEY_APPNAME");
}

}