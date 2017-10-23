function XLSGRID_JM_TRKDTL(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var web = new JavaPackage("com.xlsgrid.net.web");

//作为.sp服务时的入口
//预定义变量：request,response
function Response()
{
      var func = pubpack.EAFunc.NVL(request.getParameter("func"),"");
      var data = pubpack.EAFunc.NVL(request.getParameter("_this"),"");
      var usr = web.EASession.GetLoginInfo(request);
      var usrid = usr.getUsrid();
      var accid = usr.getAccid();
      var sytid = usr.getSytid();
      var orgid = usr.getOrgid();
      var db = null;
      var sql = "";
      var ret= "";
      var out = response.getOutputStream();
      response.setContentType("content-type:text/html; charset=UTF-8");
      try {
            db = new pubpack.EADatabase();	
            
            if (func == "save"){
		var title = pubpack.EAJ2meUtil.getDataByCellid(data,"title");
		var pro_note = pubpack.EAJ2meUtil.getDataByCellid(data,"pro_note");
		var guid = pubpack.EAJ2meUtil.getDataByCellid(data,"guid");
		//插入事务处理意见表
		sql = "insert into trkdtl(trkguid,pro_note,tousr,style,crtusrorg,crtusr,result,project,id,title,syt,selforg,acc,aimorg)
			select guid,'%s',crtusr,'2','%s','%s','1',project,id,title,syt,'%s',acc,aimorg 
			from trkhdr where guid='%s'".format([pro_note,orgid,usrid,orgid,guid]);
//               	ret = data + "###" + sql;
               	db.ExcecutSQL(sql);
               	//更新事务状态
               	sql = "update trkhdr set stat='2' where guid='"+guid+"'";
               	db.ExcecutSQL(sql);
               	ret = "事务处理意见已提交！";
		db.Commit();
            }
      }
      catch ( ee ) {
            db.Rollback();
            return "保存出错："+ee.toString();
      }
      finally {
            if (db!=null) db.Close();
      }
      out.println( ret );      
}


}