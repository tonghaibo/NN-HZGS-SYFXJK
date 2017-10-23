<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>计划低温分5类的日期算法090511修改</title>
</head>
<body>
<%
     out.println( "<p align=\"center\"><img  src=\"resource://pages/title.png\" ></P><hr>" );
     String brand = EAFunc.NVL(request.getParameter("brand"),"");//MN
     String mobtyp = EAFunc.NVL(request.getParameter("mobtyp"),"");
     /* mobtyp 20090421修改为5类
      * 11 利乐包
      * 12 利乐枕
      * 21 保鲜奶
      * 22 优益C
      * 23 酸奶
     */
     String itemtype = EAFunc.NVL(request.getParameter("itemtype"),"");//1.常温，2.低温
     String locid = EAFunc.NVL(request.getParameter("locid"),"");//仓库编码
     String number = EAFunc.NVL(request.getParameter("number"),"");//区分session
     String bascat = EAFunc.NVL(request.getParameter("bascat"),"");
     String y1 = "";//默认时间
     String m1 = "";
     String d1 = "";
     String sql = "";
     String sql2 = "";
     String sql3 = "";
     String sql4 = "";
     String dat = "";
     String sOut = "";
     String sOut1 = "";
     String sOut2 = "";
     int c = 0;
     int c2 = 0;
     int c3 = 0;
     EAXmlDS ds = null;
     EAXmlDS ds2 = null;
     EAXmlDS ds3 = null;
    // out.print("locid"+locid);
     String date1 = "";
     String date2 = "";
     
     try{
           sql2 = "select  to_char(sysdate,'yyyy')y1,to_char(sysdate,'mm') m1,to_char(sysdate,'dd') d1,to_char(sysdate,'YYYYMMDD') yymmdd FROM DUAL";
            ds2 = EADbTool.QuerySQL(sql2);
            y1 = ds2.getStringAt(0,"y1");
            m1 = ds2.getStringAt(0,"m1");
            d1 = ds2.getStringAt(0,"d1");
            date1 = ds2.getStringAt(0,"yymmdd");
            date2 = ds2.getStringAt(0,"yymmdd");
            
           //酸奶沿用原来的时间算法保持不变
            sql = "select 日期 from 日历 "
                   +"where to_char(日期,'YYYY-MM-DD')>=to_char((select 7+decode(星期,0,sysdate-3,1,sysdate,2,sysdate-1,3,sysdate-2,"
                   +"4,sysdate,5,sysdate-1,sysdate-2 ) "
                   +"from 日历 a where to_char(日期,'YYYYMMDD')=to_char(sysdate,'YYYYMMDD')) ,'YYYY-MM-DD') "
                   +"and to_char(日期,'YYYY-MM-DD')<=to_char((select 7+decode(星期,0,sysdate,1,sysdate+2,2,sysdate+1,3,sysdate,"
                   +"4,sysdate+3,5,sysdate+2,sysdate+1 ) "
                   +"from 日历 a where to_char(日期,'YYYYMMDD')=to_char(sysdate,'YYYYMMDD')) ,'YYYY-MM-DD') "
                   +"order by 日期	";
         /*
         sql3处理优益C的报计划时间
         当天报后7天的计划，如1号报8号的计划
         */          
            sql3 = "select 日期 from 日历 where to_char(日期,'YYYY-MM-DD') = to_char(sysdate+7,'YYYY-MM-DD')";
          /*
          sql4处理保鲜奶的报计划时间
          当天报后3天的计划，如1号报4号的计划
          */     
            sql4 = "select 日期 from 日历 where to_char(日期,'YYYY-MM-DD') = to_char(sysdate+3,'YYYY-MM-DD')";
       ds = EADbTool.QuerySQL(sql);
       ds2 = EADbTool.QuerySQL(sql3);
       ds3 = EADbTool.QuerySQL(sql4);
       c = ds.getRowCount();
       c2 = ds2.getRowCount();
       c3 = ds3.getRowCount();
      //out.print(c);
      if(c>0){
        if(mobtyp.equalsIgnoreCase("23")){//判断是否为酸奶沿用原来的时间算法
            for(int i = 0;i<c;i++){
                dat = (String)ds.getStringAt(i,"日期");
                sOut += "<img src=\"resource://pages/"+(i%9+1)+".png\">　<a href=\"j2meplanenter.jsp?dat="+dat+"&brand="+brand+"&itemtype="+itemtype+"&locid="+locid+"&mobtyp="+mobtyp+"&bascat="+bascat+"&number="+number+"\">"+dat+"</a><br>";
               // out.print(mobtyp);
           }
        }
    }  if(mobtyp.equalsIgnoreCase("11")||mobtyp.equalsIgnoreCase("12")){
  %>
<form id="form1" name="form1" method="post" action="j2meplanenter.jsp?brand=<%=brand%>&itemtype=<%=itemtype%>&locid=<%=locid%>&mobtyp=11&bascat=<%=bascat%>&number=<%=number%>">
<p align="center">起始日期：格式YYYYMMDD</p>
<input name="date1" type="text" id="date1" size="10" maxlength="10" value="<%=date1%>" />
<p align="center">截至日期：格式YYYYMMDD</p>
<input name="date2" type="text" id="date2" size="10" maxlength="10" value="<%=date2%>" />
<p align="center">
    <input type="submit" name="button" id="button" value="确定" />
</p>
</form>
  <%
        } if(c2>0){
           if(mobtyp.equalsIgnoreCase("22")){//优益C
             for(int i = 0;i<c2;i++){
                dat = (String)ds2.getStringAt(i,"日期");
                sOut += "<img src=\"resource://pages/"+(i%9+1)+".png\">　<a href=\"j2meplanenter.jsp?dat="+dat+"&brand="+brand+"&itemtype="+itemtype+"&locid="+locid+"&mobtyp=22&bascat="+bascat+"&number="+number+"\">"+dat+"</a><br>";
               // out.print(mobtyp);
           }
        }
     }  if(c3>0){
          if(mobtyp.equalsIgnoreCase("21")){//保鲜奶
             for(int i= 0;i<c3;i++){
               dat = (String)ds2.getStringAt(i,"日期");
               sOut += "<img src=\"resource://pages/"+(i%9+1)+".png\">　<a href=\"j2meplanenter.jsp?dat="+dat+"&brand="+brand+"&itemtype="+itemtype+"&locid="+locid+"&mobtyp="+mobtyp+"&bascat="+bascat+"&number="+number+"\">"+dat+"</a><br>";
         }
      }
    }
  }catch(EAException e){
               out.print("操作错误，请重新登录");
               out.print("<a href=\"j2melogin.jsp\"></a>");
                   throw e;
             }
%>
<p align="left">
<%=sOut%>
</p>
<p align="center">
<br><hr><br>
<a href="j2meplanitemtype.jsp?planflag=plan&number=<%=number%>&locid=<%=locid%>">返回常低温</a>
</p>
</body>
</html>
