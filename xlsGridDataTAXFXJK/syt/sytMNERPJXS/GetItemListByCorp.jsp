<%@ page contentType="text/html;charset=GBK" import="com.xlsgrid.net.pub.*,com.syt.serp.mn.*"%>
<%
      EADatabase db = null;
      String corpid = EAFunc.NVL(request.getParameter("corpid"),"");
      
      
      String msg= "";
      EAXmlDS ds = null;
      SCInterceptor interceptor = new SCInterceptor();

      try {
            db = new EADatabase();
            // 得到网点的所属KA
            ds = interceptor.GetCorpItemWithCurORD(db,corpid,"","");
   
      }
      catch (EAException ee ) {
            db.Rollback();
            throw new EAException ( ee.toString() );
      }
      finally {
            if (db!=null) db.Close();
      }
      if ( ds!= null ) 
            out.println( ds.GetXml() );
      else 
            out.println( "" );



%>