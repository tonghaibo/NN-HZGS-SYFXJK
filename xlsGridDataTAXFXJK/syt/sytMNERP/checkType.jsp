<%@ page contentType="text/vnd.wap.wml;charset=gb2312"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<?xml version="1.0" encoding="gb2312"?> 
<!DOCTYPE wml PUBLIC "-//WAPFORUM//DTD WML 1.3//EN" "http://www.wapforum.org/DTD/wml13.dtd" > 
<%
          response.setHeader("Pragma","No-cache"); 
          response.setHeader("Cache-Control","no-cache"); 
          response.setDateHeader("Expires", 0);    
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
          String flag = "";
          String number = EAFunc.NVL(request.getParameter("number"),"");//条线中心session的number
          String locid = EAFunc.NVL(request.getParameter("locid"),"");
          String bascal1 = "";//利乐包
          String bascal2 = "";//利乐枕

          String extcat1 = "";//低温一类
          String extcat2 = "";//低温二类
          String type = EAFunc.NVL(request.getParameter("type"),"");
         try
         {
            db = new EADatabase (); 
            EAUserinfo usrinfo = MobileLogin.CheckIfLogin(request);
            //flag = EAFunc.NVL(request.getParameter("flag"),"");
            sUID  = usrinfo.getUsrid();
            curdat = db.GetSQL("SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:ss') FROM DUAL");
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
             ds = db.QuerySQL("select distinct bascal4 from item where brand='MN' and refid='1' and bascal4 is not null");
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
         try 
          {
              sUsrnam= EADbTool.GetSQL("SELECT NAME FROM USR WHERE id='"+sUID+"'");
          }
          catch ( Exception e )
          {
              e.toString();
          }

%>
<wml>
<head>
<meta forua="true" http-equiv="Cache-Control" content="max-age=-1"/>
</head>
<card id="card1" title="商品类别">
<p align="center">
选择类别<br/>
<anchor><%=brandname2%>常<%=bascal1%>
<go href="plan.jsp">
<postfield name="itemtype" value="<%=itemtype1%>"/>
<postfield name="brand" value="<%=brandid2%>"/>
<postfield name="number" value="<%=number%>"/>
<postfield name="bascal" value="bascal1"/>
<postfield name="locid" value="<%=locid%>"/>
<postfield name="type" value="<%=type%>"/>
</go>
</anchor>
<br/>
<anchor><%=brandname2%>常<%=bascal2%>
<go href="plan.jsp">
<postfield name="itemtype" value="<%=itemtype1%>"/>
<postfield name="brand" value="<%=brandid2%>"/>
<postfield name="number" value="<%=number%>"/>
<postfield name="bascal" value="bascal2"/>
<postfield name="locid" value="<%=locid%>"/>
<postfield name="type" value="<%=type%>"/>
</go>
</anchor>
<br/>
<anchor><%=extcat1%>
<go href="plan.jsp">
<postfield name="itemtype" value="<%=itemtype2%>"/>
<postfield name="brand" value="<%=brandid2%>"/>
<postfield name="number" value="<%=number%>"/>
<postfield name="locid" value="<%=locid%>"/>
<postfield name="type" value="<%=type%>"/>
<postfield name="extcat8" value="extcat1"/>
</go>
</anchor>
<br/>
<anchor><%=extcat2%>
<go href="plan.jsp">
<postfield name="itemtype" value="<%=itemtype2%>"/>
<postfield name="brand" value="<%=brandid2%>"/>
<postfield name="number" value="<%=number%>"/>
<postfield name="locid" value="<%=locid%>"/>
<postfield name="type" value="<%=type%>"/>
<postfield name="extcat8" value="extcat2"/>
</go>
</anchor>
<br/>

<anchor><%=brandname1%>低温
<go href="plan.jsp">
<postfield name="itemtype" value="<%=itemtype2%>"/>
<postfield name="brand" value="<%=brandid1%>"/>
<postfield name="number" value="<%=number%>"/>
<postfield name="locid" value="<%=locid%>"/>
<postfield name="type" value="<%=type%>"/>
</go>
</anchor>
<br/>
<a href="main.jsp">返回主界面</a>
</p>
</card>
</wml>