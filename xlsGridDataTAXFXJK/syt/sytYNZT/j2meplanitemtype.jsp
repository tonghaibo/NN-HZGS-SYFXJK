<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>录入计划商品大类</title>
</head>
<body>
<%         out.println( "<p align=\"center\"><img  src=\"resource://pages/title.png\" ></P><hr>" );
           String corpid = EAFunc.NVL(request.getParameter("corpid"),"");
           String pageno = EAFunc.NVL(request.getParameter("showpage"),"1");
           String locid = EAFunc.NVL(request.getParameter("locid"),"");
           String bascat = EAFunc.NVL(request.getParameter("bascat"),"");
           String number = EAFunc.NVL(request.getParameter("number"),"");
//         String type = EAFunc.NVL(request.getParameter("type"),"");
           String sUID = "";
           String sNo=(String)session.getAttribute("sNo");
           EAUserinfo usrinfo = EASession.GetLoginInfo(request);
          
           try{
               if ( usrinfo ==null ){
          usrinfo = new EAUserinfo();
          usrinfo.setUsrid(sNo);
             }
          sUID  = usrinfo.getUsrid();
        }catch(Exception e){
              out.print("<p>");		
              out.println(e.toString());
              out.println("<hr><p align=center><a href='../j2melogin.jsp'> 重新登录 </a></p>");
           }
%>
<p align="center">请选择商品大类</p>
<img src="resource://pages/1.png">&nbsp;
<a href="j2meplanbyday0511.jsp?corpid=<%=corpid%>&itemtype=1&brand=MN&mobtyp=11&locid=<%=locid%>&bascat=<%=bascat%>&number=<%=number%>">利乐包</a><br>
<img src="resource://pages/1.png">&nbsp;
<a href="j2meplanbyday0511.jsp?corpid=<%=corpid%>&itemtype=1&brand=MN&mobtyp=12&locid=<%=locid%>&bascat=<%=bascat%>&number=<%=number%>">利乐枕</a><br>
<img src="resource://pages/2.png">&nbsp;
<a href="j2meplanbyday0511.jsp?corpid=<%=corpid%>&itemtype=2&brand=MN&mobtyp=21&locid=<%=locid%>&bascat=<%=bascat%>&number=<%=number%>">保鲜奶</a><br>
<img src="resource://pages/3.png">&nbsp;
<a href="j2meplanbyday0511.jsp?corpid=<%=corpid%>&itemtype=2&brand=MN&mobtyp=22&locid=<%=locid%>&bascat=<%=bascat%>&number=<%=number%>">优益C</a><br>
<img src="resource://pages/3.png">&nbsp;
<a href="j2meplanbyday0511.jsp?corpid=<%=corpid%>&itemtype=2&brand=MN&mobtyp=23&locid=<%=locid%>&bascat=<%=bascat%>&number=<%=number%>">酸奶</a><br>
<hr>
<p align="center">
<a href="j2meplanBascat.jsp?number=<%=number%>">选择网点</a><a href="j2memain.jsp">主菜单</a>
</p>
</body>
</html>