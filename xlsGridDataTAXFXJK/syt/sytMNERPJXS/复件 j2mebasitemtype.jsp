<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>basinputbil</title>
</head>
<body>
<%
         response.addHeader("Pragma","No-cache"); 
         response.addHeader("Cache-Control","no-cache"); 
         response.addDateHeader("Expires", 0);    
         String showpage = EAFunc.NVL(request.getParameter("showpage"),"1");
         String corpid = EAFunc.NVL(request.getParameter("corpid"),"");
         String corpsoid = EAFunc.NVL(request.getParameter("corpsoid"),"");
         String katype = EAFunc.NVL(request.getParameter("katype"),"");
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
          String bascal1 = "";//常温利乐包
          String bascal2 = "";//常温利乐枕

          String extcat1 = "";//低温一类
          String extcat2 = "";//低温二类
           
         try
         {
          //EAUserinfo usrinfo = MobileLogin.CheckIfLogin(request);
		 
            // 得到登陆的USER ID
           sUID  = (String)session.getAttribute("sUID");
		      sUsrnam= EADbTool.GetSQL("SELECT NAME FROM USR WHERE id='"+sUID+"'");
           db = new EADatabase (); 

           curdat = db.GetSQL("select to_char(sysdate,'yyyymmddhh24miss') dat from dual");
           EAXmlDS ds = db.QuerySQL("select id,name from v_brand");
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
			 ds = db.QuerySQL("select distinct bascal4 from item where brand='MN' and refid='1'  and bascal4 is not null");
             int rrr = ds.getRowCount();
             if ( rrr > 0 )
             {
                bascal1 = ds.getStringAt(0,"bascal4");
                bascal2 = ds.getStringAt(1,"bascal4");
                session.setAttribute("bascal1",bascal1);
                session.setAttribute("bascal2",bascal2);
              
             }
 		ds = db.QuerySQL("select distinct extcat8 from item where brand='MN' and refid='2' ");
             rrr = ds.getRowCount();
             if ( rrr > 0 )
             {
                
                extcat1 = ds.getStringAt(0,"extcat8");
                extcat2 = ds.getStringAt(1,"extcat8");
                session.setAttribute("extcat1",extcat1);
                session.setAttribute("extcat2",extcat2);
             
             }


             
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
%>
<p align="center">
当前订单号：<%=corpsoid%>
</p>
<p align="left">
<%
if ( katype.equalsIgnoreCase("A") ){

out.print("<img src=\"resource://pages/1.png\"> <a href=\"j2meenterAll.jsp?itemtype="+itemtype1
+"&corpid="+corpid
+"&brand="+brandid2
+"&bascal="+bascal1
+"&curdat="+curdat
+"&katype="+katype
+">常温"+bascal1+"</a></br>");

out.print("<img src=\"resource://pages/2.png\"> <a href=\"j2meenterAll.jsp?itemtype="+itemtype1
+"&corpid="+corpid
+"&brand="+brandid2
+"&bascal="+bascal2
+"&curdat="+curdat
+"&katype="+katype
+">常温"+bascal2+"</a></br>");

out.print("<img src=\"resource://pages/3.png\"> <a href=\"j2meenterAll.jsp?itemtype="+itemtype2
+"&corpid="+corpid
+"&brand="+brandid2
+"&curdat="+curdat
+"&katype="+katype
+">"+brandname2+"低温</a></br>");

out.print("<img src=\"resource://pages/4.png\"> <a href=\"j2meenterAll.jsp?itemtype="+itemtype2
+"&corpid="+corpid
+"&brand="+brandid2
+"&curdat="+curdat
+"&katype="+katype
+">"+brandname1+"低温</a></br>");

}
else
{   
out.print("<img src=\"resource://pages/1.png\"> <a href=\"j2meenterAll.jsp?itemtype="+itemtype1
+"&corpid="+corpid
+"&brand="+brandid2
+"&bascal="+bascal1
+"&curdat="+curdat
+"&katype="+katype
+">常温"+bascal1+"</a></br>");

out.print("<img src=\"resource://pages/2.png\"> <a href=\"j2meenterAll.jsp?itemtype="+itemtype1
+"&corpid="+corpid
+"&brand="+brandid2
+"&bascal="+bascal2
+"&curdat="+curdat
+"&katype="+katype
+">常温"+bascal2+"</a></br>");

out.print("<img src=\"resource://pages/3.png\"> <a href=\"j2meenterAll.jsp?itemtype="+itemtype1
+"&corpid="+corpid
+"&brand="+brandid2
+"&pageno1=1&curdat="+curdat
+"&katype="+katype
+"&extcat8="+extcat1
+">"+extcat1+"</a></br>");

out.print("<img src=\"resource://pages/4.png\"> <a href=\"j2meenterAll.jsp?itemtype="+itemtype2
+"&corpid="+corpid
+"&brand="+brandid2
+"&pageno1=1&curdat="+curdat
+"&katype="+katype
+"&extcat8="+extcat2
+">"+extcat2+"</a></br>");

out.print("<img src=\"resource://pages/5.png\"> <a href=\"j2meenterAll.jsp?itemtype="+itemtype2
+"&corpid="+corpid
+"&brand="+brandid1
+"&pageno1=1&curdat="+curdat
+"&katype="+katype
+">"+brandname1+"低温</a></br>");

}
%>
</p>
<p align="center">
<a href="j2mesqcorplist.jsp">返回网点</a></br>
<a href="j2memain.jsp">返回主界面</a>
</p>
</body>
</html>