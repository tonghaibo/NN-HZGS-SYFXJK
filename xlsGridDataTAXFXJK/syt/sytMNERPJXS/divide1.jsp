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
     if(t==0)  {//����ط�Ҫ��һ���Ƿ��м�¼δ��ִ�еĲ��֣�����û�д�ִ�еļ�¼
     %>
           <script language="javascript">
           alert("�Բ������ݿ���û��δ��ִ�еļ�¼��");
           </script>
       <%
       }  //��û�м�¼��������Ƿ�Ҫ��һ���ض�λ�Ĵ���
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


