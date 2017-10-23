function x_jmsync(){
var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var web = new JavaPackage ( "com.xlsgrid.net.web" );

//作为.sp服务时的入口
//预定义变量：request,response
function Response()
{
      var starttime= request.getParameter("starttime");//必须
      var typ= pubpack.EAFunc.NVL(request.getParameter("typ"),"");
      var stat= pubpack.EAFunc.NVL(request.getParameter("stat"),"0");
      
      var usrinfo = web.EASession.GetLoginInfo(request);
      var usrorg= usrinfo.getusrOrg();
      var usrid = usrinfo.getUsrid();
      
      var sql = "select guid,title name,to_char(STRDAT,'YYYY-MM-DD HH24:MI:SS') crtdat,crtusrnam crtusrnam,openurl,printurl,to_char(prtdat,'dd/mm hh24:mi') prtdat "+
		" from jmsync  where to_char(STRDAT,'YYYY-MM-DD HH24:MI:SS') <= to_char(SYSDATE,'YYYY-MM-DD HH24:MI:SS') and "+
		" TYP='"+typ+"' and NVL(stat,'0') = '"+stat+"' "+
		" and accid in (select deptid from usr where org='"+usrorg+"' and id='"+usrid+"' and useflg='1') "+
		" order by STRDAT asc";
//      pubpack.EAFunc.Log(sql);
      var db = null;
      var ret= "";
      try {
            db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
            var ds = db.QuerySQL(sql);
            for ( var i=0;i<ds.getRowCount();i++) {
            	if ( i!=0 ) ret += "~r~n";
	            for ( var j=0;j<ds.getColumnCount();j++) {
	            	if ( j!=0 ) ret+=",";
	            	ret+=ds.getStringAt(i,j);
	            }
            	    var guid = ds.getStringAt(i,"guid");
		    
		    // stat   接受标志~=0 未接受 =1 已接受 =2 已执行（打印）
		    // resdat 接受时间
		    if (stat != "2") {
            	    	//db.ExcecutSQL("update jmsync set stat='1',resdat=sysdate where guid='"+guid +"'");
            	    }
            }
            
            //2.要更改这个用户的最后在线时间
            try {
                    var cnt = db.ExcecutSQL("update jmsyncusr set enddat=sysdate where orgid='"+usrorg+"' and usrid='"+usrid+"'");
                    if (cnt == 0) {
                    	db.ExcecutSQL("insert into jmsyncusr(orgid,usrid,enddat) values('"+usrorg+"','"+usrid+"',sysdate)");
                    }
            } catch (e) {
            	    
            }
            
            db.Commit();
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

//更改状态的函数
function updatestat()
{
	var db = null;
	var msg = "";
	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		// stat   接受标志~=0 未接受 =1 已接受 =2 已执行（打印）
		// prtdat 打印时间
		if (stat == "1") {
			msg = db.ExcecutSQL("update jmsync set stat='"+stat+"',resdat=sysdate where guid='"+guid+"'");
		}
		else if (stat == "2") {
			msg = db.ExcecutSQL("update jmsync set stat='"+stat+"',prtdat=sysdate where guid='"+guid+"'");
		}
		
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

function lastRows()
{
	var db = null;
	var sql = "";
	var ret = "";
		
	try {
		
		var usrinfo = web.EASession.GetLoginInfo(request);
		var usrorg = usrinfo.getusrOrg();
		var thisaccid = usrinfo.getAccid();
		var usrid = usrinfo.getUsrid();
		//return thisaccid ;
		db = new pubpack.EADatabase();	
		sql = "select * from (
			select a.* from jmsync a where accid='"+usrid +"' and stat='2' and nvl(flg,'0')<>'1' order by strdat desc
			) t where rownum <=20";
		var ds = db.QuerySQL(sql);
		for (var i=0;i<ds.getRowCount();i++) {
			var guid = ds.getStringAt(i,"GUID");
			if (ret == "") ret += guid;
			else ret += "~"+guid;
		}
		
		sql = "update jmsync set flg='1' where guid in (select guid from (
			select a.* from jmsync a where accid='"+usrid +"' and stat='2' and nvl(flg,'0')<>'1' order by strdat desc
			) t where rownum <=20)";
		db.ExcecutSQL(sql);
		db.Commit();
		
		return ret;
	}
	catch ( ee ) {
		db.Rollback();
		return ee.toString();
	}
	finally {
		if (db!=null) db.Close();
	}
	
	
}


}