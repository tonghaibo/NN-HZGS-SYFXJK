<%@ page contentType="text/html;charset=GBK" import="com.xlsgrid.net.pub.*,com.syt.serp.mn.SCInterceptor,com.xlsgrid.net.pub.EADatabase"%>
<%
    response.setContentType("application/octet-stream");
    response.setHeader("Content-Disposition","attachment;  filename=exp.txt");
    String dat=request.getParameter("dat");
    int t;
    String str=null;
    try { 
     EADatabase db=null;
     db = new EADatabase();
     SCInterceptor SCI=new SCInterceptor();
     t=SCI.splitOrdIntoSD(db,"");
     db.Close();
     if(t==0)  {//这个地方要加一个是否有记录未被执行的部分，即有没有待执行的记录
     %>
           <script language="javascript">
           alert("对不起，数据库中没有未被执行的记录！");
           </script>
       <%
       }  //在没有记录的情况下是否要加一个重定位的代码
      // out.println(t);
    else{
        str=SCI.exportdate(dat);
        out.println(str);
     }
    }
    catch ( EAException e ) 
    {
      out.print(e.toString());
    }
    finally
    {
     
    }
    
%>


