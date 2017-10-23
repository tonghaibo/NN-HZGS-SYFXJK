<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>商品类型</title>
</head>
<body>
<%
  
         //String showpage = EAFunc.NVL(request.getParameter("showpage"),"1");
         String corpid = EAFunc.NVL(request.getParameter("corpid"),"");
         String pageno = EAFunc.NVL(request.getParameter("showpage"),"1");
         String locid = EAFunc.NVL(request.getParameter("locid"),"");
         EADatabase db=null;
          String sUID = "";
          EAXmlDS typds = null;
          //out.print("locid"+locid);
         try
         {
//          EAUserinfo usrinfo = MobileLogin.CheckIfLogin(request);
             EAUserinfo usrinfo = EASession.GetLoginInfo(request);
            // 得到登陆的USER ID
           sUID  = usrinfo.getUsrid();
          } catch ( Exception e )
          {
              e.toString();
          }

%>
<img src="resource://pages/title.png"><hr>
<p align="center">请选择商品大类</p>
<img src="resource://pages/1.png">&nbsp;
<a href="j2mejxsenterAll.jsp?corpid=<%=corpid%>&itemtype=1&brand=MN&showpage=<%=pageno%>&subtyp=1">常温</a><br>
<img src="resource://pages/2.png">&nbsp;
<a href="j2mejxsenterAll.jsp?corpid=<%=corpid%>&itemtype=2&brand=MN&showpage=<%=pageno%>&subtyp=1">低温</a><br>
<hr>
<p align="center">
<a href="j2mejxscorplist.jsp?showpage=<%=pageno%>">选择网点</a><a href="j2memain.jsp">主菜单</a>
</p>

</body>
</html>