<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>updatepwd</title>
</head>
<body>

<%
           out.println( "<p align=\"center\"><img  src=\"resource://pages/title.png\" ></P><hr>" );
           String pwd1 = EAFunc.NVL(request.getParameter("pwd1"),"");
           String pwd2 = EAFunc.NVL(request.getParameter("pwd2"),"");
           String save = EAFunc.NVL(request.getParameter("save"),"");
           EADatabase db = null;
           String sql = "";
           String sUID = "";
           try{
           String sNo=(String)session.getAttribute("sNo");//session保存用户的手机号码
           EAUserinfo usrinfo = EASession.GetLoginInfo(request);
           db = new EADatabase();
              if ( usrinfo ==null ) 
                   {
          usrinfo = new EAUserinfo();
          usrinfo.setUsrid(sNo);
                 }  
          sUID  = usrinfo.getUsrid();
              if(save.equalsIgnoreCase("ok")){
                  if(pwd1.equalsIgnoreCase(pwd2)){
                    sql = "update usr set passwd='"+pwd1+"' where id = '"+sUID+"'";
                    //out.print("pwd1:"+pwd1+"sUID:"+sUID);
                    db.ExcecutSQL(sql);
                    out.print("执行成功，请重新登录！<br>");
                    } else{
                    out.print("两次密码不一致，请重新输入！<br>");
                  }
                    db.Commit();      
              }
           }catch ( Exception e ){ 
          if ( db!= null ) db.Rollback(); 
            out.println( "运行出错："+e.toString());
            
        }finally{ 
           if (db!= null ) db.Close(); 
       } 
           
%>
<form name="form1" action="j2meupdatepwd.jsp" method="post">
  <p align="left">
  输入密码：<br>
  </p>
    <input name="pwd1" type="password" id="pwd1" size="10" maxlength="10" /><br>
  <p align="left">
  确认密码：<br>
  </p>
    <input name="pwd2" type="password" id="pwd2" size="10" maxlength="10" /><br>
<p align="center">
  <input type="submit" name="button" id="button" value="确认" />
</p>
<input type="hidden" name="save" value="ok"/>
</form>
<br><hr><br>
<a href="j2memain.jsp">返回首页</a>
</body>
</html>