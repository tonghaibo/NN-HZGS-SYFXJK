function x_mymsg(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
//作为.sp服务时的入口
//预定义变量：request,response
function Response()
{
      var code = request.getParameter("CODE");
      var db = null;
      var ret= "10";
      var sql = "";
      try {
            db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
            	// OS 中如何得到登录的信息
		var usr=web.EASession.GetLoginInfo(request);
		var  orgid=usr.getOrgid();
		var accid=usr.getAccid();
		var usrid=usr.getUsrid();
            sql="select count(*) from (select a.title from  
		      trkhdr a,v_usr c ,trktyp e,v_usr cc,trkdtl d,oalog o
		      where 
		        a.dtlusr=c.id  and a.AIMORG=c.orgid and a.crtusr=cc.id  and a.AIMORG=cc.orgid 
      			and a.show =e.id
      			and o.bilid=a.guid
      			and o.usrid=c.id
			and c.id=lower('"+usrid+"')   
			and c.orgid='"+orgid+"'
			and a.guid = d.trkguid(+)
			and a.stat<>'3' /* 0￡oD??¨￡?1￡o′|àí?D￡?2￡oò?′|àí￡?3￡o′|àííê￡?4￡o?′′|àí */
			and a.show not in ('4')
			and nvl(d.dtltyp,'1') <>'2'/*不包含评论*/
			and e.id not in ('4','5','6','7','8','9','10','16','17','13') 
			and a.crtdat<=sysdate
			and a.crtdat>=add_months(sysdate,-3) 
			and o.action not in('结束')
			group by a.title,cc.name,a.crtdat,a.note,a.guid,a.id ,o.action
			union all
			select title from wfmsg where tousrid='"+usrid+"' and endflg='0' and org='"+orgid+"'
			union all
			select title from wfmsg where torolid in (select c.id rolid from usr a,usrrol b,rol c where a.guid=b.usr and b.rol=c.guid and a.org='"+orgid+"' and a.id='"+usrid+"') and endflg='0' and org='"+orgid+"' 
			)";
	    
            ret = db.GetSQL(sql);
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


function upwfmsg(){

	var db = null;
	var sql = "";
	try {
		db = new pubpack.EADatabase();
		sql="update wfmsg set ENDFLG=1 where guid='"+guid+"'";
		db.ExcecutSQL(sql);
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return true ;
}
}