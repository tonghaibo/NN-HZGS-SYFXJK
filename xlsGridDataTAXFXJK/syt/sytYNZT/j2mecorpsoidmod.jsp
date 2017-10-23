<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>修改订单界面</title>
</head>
<body>
<p align="center"><img border="0" src="resource://pages/title.png" ></P><hr></br>
<p align = "left">请输入要修改的订单号</p></br>
<%
        String katype = "";
        String pageno = "";
        String corpid = "";
        String corpguid = "";
        String corpsoid = "";
        String corpsoidnew = "";
        String sql = "";
        EAXmlDS ds = null;
        EADatabase db = null;
        String sUID  = (String)session.getAttribute("sUID");
    try{
         db = new EADatabase();
         katype = EAFunc.NVL(request.getParameter("katype"),"");
         pageno = EAFunc.NVL(request.getParameter("showpage"),"1");
         corpid = EAFunc.NVL(request.getParameter("corpid"),"1");
         corpsoid = EAFunc.NVL(request.getParameter("corpsoid"),"1");
         corpsoidnew = EAFunc.NVL(request.getParameter("corpsoidnew"),"1");
         corpguid = db.GetSQL("SELECT GUID FROM CORP WHERE ID='"+corpid+"'");
        
         sql = "update curord set corpsoid = '"+corpsoidnew+"' where crtusr = '"+sUID+"'"
              +" and corp = '"+corpguid+"' and subtyp ='2' and corpsoid = '"+corpsoid+"'";
//         out.print("SQL"+sql);
          db.ExcecutSQL(sql);
          out.println("执行成功！");
          out.println("<a href=\"j2mebasinputbil.jsp?corpsoid="+corpsoidnew+"&corpid="+corpid+"&showpage="+pageno+"&katype="+katype+"\">返回</a> ");
          db.Commit();         
    }catch ( Exception e ){ 
            if ( db!= null ) db.Rollback(); 
            out.println( "运行出错："+e.toString());//
            
    }finally{ 
           if (db!= null ) db.Close(); 
    } 
%>
</body>
</html>