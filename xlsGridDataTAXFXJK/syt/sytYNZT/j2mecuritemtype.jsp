<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>curitemquery</title>
</head>
<body>
<%       
         out.println( "<p align=\"center\"><img border=\"0\" src=\"resource://pages/title.png\" ></P><line>" );
         response.addHeader("Pragma","No-cache"); 
         response.addHeader("Cache-Control","no-cache"); 
         response.addDateHeader("Expires", 0);    
         String showpage = EAFunc.NVL(request.getParameter("showpage"),"1");
         String sUsrnam="";
         EADatabase db=null; 
         String curdat = "";
         String sUID = "";
         String sql = "";   
         String itemtype = "";//商品类型（已分类）
         String refid = "";//常低温
         String refidname = "";
         String note = "";
         String brand = "";
         String brandname = "";
         String itemtypid = "";
         String corpsoid = "";
         try
         {
                sUID  = (String)session.getAttribute("sUID");
                db = new EADatabase (); 
                sql = " select * from itemtypclass where typ='MC'";  //默认是MC，全部分类
                EAXmlDS ds = db.QuerySQL(sql);     
                //判断KA类型 A对应sql1，B对应sql2
                int rr = ds.getRowCount();
                if ( rr > 0 )
                {        
                        out.println("<p align=\"center\">请选择商品分类</p></br></br>");
                        for ( int i=0;i<rr;i++ )
                        {   
                               
                               brandname = ds.getStringAt(i,"brandname");//蒙牛达能
                               brand = ds.getStringAt(i,"brand");//蒙牛达能的标示
                               refidname = ds.getStringAt(i,"refidname");//常低温
                               refid = ds.getStringAt(i,"refid");//1为常温2为低温
                               note = ds.getStringAt(i,"note");//大类
                               itemtypid = ds.getStringAt(i,"id");//ID
                               out.print("<img src=\"resource://pages/"+(i+1)+".png\"> <a href=\"j2mealllist.jsp?refid="+refid+"&itemtypid="+itemtypid+"&brand="+brand+"\">"+note+"</a></br>");    
                                 
                        } 
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
<a href="j2memain.jsp">返回</a>
</p>
</body>
</html>