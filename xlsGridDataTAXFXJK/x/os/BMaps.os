function x_BMaps(){
//在Head区引用额外脚本
function addHeaderHtml(mwobj,request,sb,usrinfo)
//var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("<script type=\"text/javascript\" src=\"http://api.map.baidu.com/api?v=1.2\"></script>");  
	//sb.append("<script src='http://maps.google.com/maps?file=api&v=2&sensor=true_or_false&key=ABQIAAAADEgO6kqjKx2W3NKoYkXzGhTepiFuMo4rdqjr65BYebADdmCbPBSZRe2SjhGp7UEHeh4Eg90T-LJuxw&sensor=true' type='text/javascript'></script>");
}

//页面BODY处理完毕后事件
//sb里面是body元素及前面的head内容
//bodysb里面是body的innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	sb.append("<div style=\"width:1024px;height:768px;border:1px solid gray\" id=\"container\"></div>");  
}


var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
//作为.sp服务时的入口
//预定义变量：request,response
function Response()
{
      var db = null;
      var ret= "OK";
      var SerialNumber = request.getParameter("SerialNumber");
      var dblLatitude = request.getParameter("dblLatitude");
      var dblLongitude = request.getParameter("dblLongitude");

      try {
            db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
            try {
            	db.ExcecutSQL("create table GPS(guid char(32) default sys_guid() primary key, SerialNumber varchar2(50),dblLatitude number(20,4),dblLongitude number(20,4),crtdat date default sysdate )" );
            }catch ( e ) {}
            db.ExcecutSQL("insert into GPS( SerialNumber ,dblLatitude ,dblLongitude  ) values ( '"+SerialNumber +"',"+dblLatitude +","+dblLongitude +")" );
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
}