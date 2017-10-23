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
         String planflag = EAFunc.NVL(request.getParameter("planflag"),"");
         String bascat = EAFunc.NVL(request.getParameter("bascat"),"");
         String number = EAFunc.NVL(request.getParameter("number"),"");
//         String type = EAFunc.NVL(request.getParameter("type"),"");
         String sUsrnam="";
         EADatabase db=null; 
         String curdat = "";
         String brandname1 = "";
         String brandname2 = "";
         String brandid1 = "";
          String brandid2 = "";
          String itemtype1 = "";
          String itemtype2 = "";
          String sUID = "";
          String bascal1 = "";
          String bascal2 = "";
          EAXmlDS typds = null;
          //out.print("locid"+locid);
         try
         {
//          EAUserinfo usrinfo = MobileLogin.CheckIfLogin(request);
             EAUserinfo usrinfo = EASession.GetLoginInfo(request);
            // 得到登陆的USER ID
           sUID  = usrinfo.getUsrid();
           db = new EADatabase (); 
          // curdat = db.GetSQL("select to_char(sysdate,'yyyymmddhh24miss') dat from dual");
           EAXmlDS ds = db.QuerySQL("select id,name from v_brand");
           typds =    db.QuerySQL("select distinct b.brand,b.refid,a.id,a.name from v_mobtyp a, item b where a.id=b.mobtyp and b.brand<>'DN' order by a.id ");
             int rr = ds.getRowCount();
             if ( rr > 0 )
             {
                 brandname1 = ds.getStringAt(0,"name");//达能
                 brandname2 = ds.getStringAt(1,"name");//蒙牛
                 brandid1 = ds.getStringAt(0,"id");
                 brandid2 = ds.getStringAt(1,"id");
             }
             ds = db.QuerySQL("select distinct refid from v_item ");
             rr = ds.getRowCount();
             if ( rr > 0 )
             {
               itemtype1 = ds.getStringAt(0,"refid");//低温
               itemtype2 = ds.getStringAt(1,"refid");//常温
             }
//             ds = db.QuerySQL("select distinct bascal4 from item where brand='MN' and refid='1'");
//             int rrr = ds.getRowCount();
//             if ( rrr > 0 )
//             {
//                bascal1 = ds.getStringAt(0,"bascal4");
//                bascal2 = ds.getStringAt(1,"bascal4");
//                session.setAttribute("bascal1",bascal1);
//                session.setAttribute("bascal2",bascal2);
//              
//             }
             
         }
         
         catch(EAException e)
         {
                if ( db!= null ) db.Rollback(); 
                    throw e;
         
         }
         finally
         {
             if (db!= null ) db.Close(); 
         }
         try 
          {
              sUsrnam= EADbTool.GetSQL("SELECT NAME FROM USR WHERE id='"+sUID+"'");
          }
          catch ( Exception e )
          {
              e.toString();
          }

%>
<img src="resource://pages/title.png"><hr>
<p align="center">请您选择商品大类</p>

<%
  if(planflag.equalsIgnoreCase("plan")){
%>
<img src="resource://pages/1.png">&nbsp;
<a href="j2mebyday.jsp?corpid=<%=corpid%>&itemtype=1&brand=MN&mobtyp=11&locid=<%=locid%>&bascat=<%=bascat%>&number=<%=number%>">常温</a><br>
<img src="resource://pages/2.png">&nbsp;
<a href="j2mebyday.jsp?corpid=<%=corpid%>&itemtype=2&brand=MN&mobtyp=21&locid=<%=locid%>&bascat=<%=bascat%>&number=<%=number%>">低温一类</a><br>
<img src="resource://pages/3.png">&nbsp;
<a href="j2mebyday.jsp?corpid=<%=corpid%>&itemtype=2&brand=MN&mobtyp=22&locid=<%=locid%>&bascat=<%=bascat%>&number=<%=number%>">低温二类</a><br>
<hr>
<p align="center">
<a href="j2meplanBascat.jsp?number=<%=number%>">选择网点</a><a href="j2memain.jsp">主菜单</a>
</p>
<%
}else {
%>
<img src="resource://pages/1.png">&nbsp;
<a href="j2meenterAll.jsp?corpid=<%=corpid%>&itemtype=1&brand=MN&mobtyp=&showpage=<%=pageno%>&subtyp=1">常温</a><br>
<img src="resource://pages/2.png">&nbsp;
<a href="j2meenterAll.jsp?corpid=<%=corpid%>&itemtype=2&brand=MN&mobtyp=&showpage=<%=pageno%>&subtyp=1">低温</a><br>

<hr>
<p align="center">
<a href="j2menewcorplist.jsp?showpage=<%=pageno%>">选择网点</a><a href="j2memain.jsp">主菜单</a>
</p>
<%  }%>
</body>

</html>