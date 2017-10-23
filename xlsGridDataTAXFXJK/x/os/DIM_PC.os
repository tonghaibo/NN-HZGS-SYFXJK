function x_DIM_PC(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var web = new JavaPackage("com.xlsgrid.net.web");

//作为.sp服务时的入口
//预定义变量：request,response
function Response()
{
      var func = pubpack.EAFunc.NVL(request.getParameter("func"),"");
      var data = pubpack.EAFunc.NVL(request.getParameter("_this"),"");
      var topic = pubpack.EAFunc.NVL(request.getParameter("topic"),"");
      var sytid = pubpack.EAFunc.NVL(request.getParameter("sytid"),"");
      var ret = "";
      var out = response.getOutputStream();
      response.setContentType("content-type:text/html; charset=UTF-8");
      try {
            if (func == "search"){
            	out.println("show.sp?grdid=DIMREP&topic="+topic+"&sytid="+sytid+"&_this="+data);
		response.sendRedirect("show.sp?grdid=DIMREP&topic="+topic+"&sytid="+sytid+"&_this="+data);
            }
      }
      catch ( ee ) {
            ret = pubpack.EAJ2meUtil.returnErrPage(ee.toString());
            out.println( ret ); 
      }
      //out.println( ret );      
}


}