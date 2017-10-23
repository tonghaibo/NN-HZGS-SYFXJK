function XLSGRID_JM_MYTRK(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
//作为.sp服务时的入口
//预定义变量：request,response
function Response()
{
      var action = request.getParameter("func");
      response.setContentType("content-type:text/html; charset=UTF-8");
      var out = response.getOutputStream();
      var db = null;
      var ret= "";
      try {
            db = new pubpack.EADatabase();	
            if (action == "modify"){
            	ret = "你点击了修改按钮！";
            }
            else if (action == "delete"){
            	ret = "你点击了删除按钮！";
            }
      }
      catch ( ee ) {
            db.Rollback();
            throw new pubpack.EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
      out.println(ret);
}
}