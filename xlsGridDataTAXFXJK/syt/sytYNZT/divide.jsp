<%@ page contentType="text/html;charset=GBK" import="com.xlsgrid.net.pub.*,com.syt.serp.mn.SCInterceptor,com.xlsgrid.net.pub.EADatabase"%><%
    response.setContentType("application/octet-stream");
    response.setHeader("Content-Disposition","attachment;  filename=exp.txt");
    String dat=request.getParameter("dat");
    String type=request.getParameter("type");
    String str=null;
    try 
    {
     SCInterceptor SCI=new SCInterceptor();
     str=SCI.exportdate(dat,type);
     response.resetBuffer();
     //System.out.print( str );
     out.print(str);
    }    
    catch ( EAException e ) 
    {
      out.print(e.toString());
    }
    finally
    {
    }
%>