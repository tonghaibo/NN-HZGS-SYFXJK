<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>main</title>
</head>
<body>

<%      
        out.println( "<p align=\"center\"><img  src=\"resource://pages/title.png\" ></P><line>" );
        response.addHeader("Pragma","No-cache"); 
        response.addHeader("Cache-Control","no-cache"); 
        response.addDateHeader("Expires", 0);  
        String sMsg = "";
        //String sNo = (String)session.getAttribute("sNo");//session保存用户的手机号码
        String sUsrnam = "";
        String bascal = "";
        String num = "";//商品类别（利乐包，等等）
        String type = EAFunc.NVL(request.getParameter("type"),"");
        String itemtype = EAFunc.NVL(request.getParameter("itemtype"),"");
        String brand = EAFunc.NVL(request.getParameter("sBrand"),"");
        String number = EAFunc.NVL(request.getParameter("number"),"");//条线中心session的number
        String locid =  EAFunc.NVL(request.getParameter("locid"),"");
        //String extcat8 = "";
        try
        {
              //bascal = EAFunc.NVL(request.getParameter("bascal"),"");
               type = EAFunc.NVL(request.getParameter("type"),"");
               itemtype = EAFunc.NVL(request.getParameter("itemtype"),"");
               brand = EAFunc.NVL(request.getParameter("sBrand"),"");
               number = EAFunc.NVL(request.getParameter("number"),"");//条线中心session的number
               locid =  EAFunc.NVL(request.getParameter("locid"),"");
              //extcat8 = EAFunc.NVL(request.getParameter("extcat8"),"");
             // num = EAFunc.NVL(request.getParameter("num"),"");
        }
        catch ( Exception e ){
              sMsg = e.toString();
        }
//        Calendar cal = Calendar.getInstance();
//        cal.add(Calendar.DATE,+1);//默认是明天
      
        %>

<p align="center">
请选择<br/>
<p align="left">
<%
if ( type.equalsIgnoreCase("b") ){
 if (itemtype.equalsIgnoreCase("1")){
%>

<img src="resource://pages/1.png">　<a href="j2meplanByDay.jsp?flag=day&itemtype=<%=itemtype%>&brand=<%=brand%>&locid=<%=locid%>&number=<%=number%>&type=<%=type%>">按天录入</a><br>
<br/>
<img src="resource://pages/2.png">　<a href="j2meplanByDay.jsp?flag=time&itemtype=<%=itemtype%>&brand=<%=brand%>&locid=<%=locid%>&number=<%=number%>&type=<%=type%>">按旬录入</a><br>
<br/>
<%
}
else
{%>
<img src="resource://pages/1.png">　<a href="j2meplanByDay.jsp?type=<%=type%>&flag=day&itemtype=<%=itemtype%>&brand=<%=brand%>&locid=<%=locid%>&number=<%=number%>&type=<%=type%>">按天录入</a><br>
<br/>
<img src="resource://pages/2.png">　<a href="j2meplanByDay.jsp?type=<%=type%>&flag=time&itemtype=<%=itemtype%>&brand=<%=brand%>&locid=<%=locid%>&number=<%=number%>&type=<%=type%>">按周录入</a><br>
<br/>
<%
}
}
else
{ 
if(itemtype.equalsIgnoreCase("1")){%>
<img src="resource://pages/1.png">　<a href="j2meplanByDay.jsp?type=<%=type%>&flag=day&itemtype=<%=itemtype%>&brand=<%=brand%>&locid=<%=locid%>&number=<%=number%>&type=<%=type%>">按天录入</a><br>
<br/>
<img src="resource://pages/2.png">　<a href="j2meplanByDay.jsp?type=<%=type%>&flag=month&itemtype=<%=itemtype%>&brand=<%=brand%>&locid=<%=locid%>&number=<%=number%>&type=<%=type%>">按月录入</a><br>
<br/>
<%
}
else
{
%>
<img src="resource://pages/1.png">　<a href="j2meplanByDay.jsp?type=<%=type%>&flag=day&itemtype=<%=itemtype%>&brand=<%=brand%>&locid=<%=locid%>&number=<%=number%>&type=<%=type%>">按天录入</a><br>
<br/>
<img src="resource://pages/2.png">　<a href="j2meplanByDay.jsp?type=<%=type%>&flag=time&itemtype=<%=itemtype%>&brand=<%=brand%>&locid=<%=locid%>&number=<%=number%>&type=<%=type%>">按周录入</a><br>
<br/>
<%
}
}
%>
</p>
<p align="center">
<a href="j2meitemtype.jsp?number=<%=number%>&locid=<%=locid%>&type=<%=type%>&planflag=plan">返回常低温</a>
</p>
</body>
</html>