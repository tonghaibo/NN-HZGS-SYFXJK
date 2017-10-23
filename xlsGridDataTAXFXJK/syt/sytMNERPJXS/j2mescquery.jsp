<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*,java.util.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>main</title>
</head>
<body>

<%      
            out.println( "<p align=\"center\"><img  src=\"resource://pages/title.png\" ></P><line>" );
            String y1="";
            String y2="";
            String m1="";
            String m2="";
            String d1="";
            String d2="";
            y1 = EAFunc.NVL(request.getParameter("y1"),"");
            m1 = EAFunc.NVL(request.getParameter("m1"),"");
            d1 = EAFunc.NVL(request.getParameter("d1"),"");
            y2 = EAFunc.NVL(request.getParameter("y2"),"");
            m2 = EAFunc.NVL(request.getParameter("m2"),"");
            d2 = EAFunc.NVL(request.getParameter("d2"),"");
            String kaflag = EAFunc.NVL(request.getParameter("kaflag"),"");
            String itemname = "";
            String corpid = "";
            String itemtype = "";
            String itemid = "";
            String sNo = (String)session.getAttribute("sNo");//session保存用户的手机号码
            String sUsrnam = "";
            String corpname = "";
            EAUserinfo usrinfo = EASession.GetLoginInfo(request); 
              sNo = usrinfo.getUsrid();
          // 得到登陆的USER ID
          String sUID  = usrinfo.getUsrid();
           
            
          
            try 
          {
             sUsrnam = EADbTool.GetSQL("SELECT NAME FROM USR WHERE id='"+sNo+"'");
            
          }
          catch ( Exception e )
          {
              e.toString();
          }
           
            
            EADatabase db = null; 
            EAXmlDS ds = null;
            EAXmlDS ds2 = null;
            try
            {    
                  corpid = EAFunc.NVL(request.getParameter("corpid"),"");
                  corpname = EADbTool.GetSQL("select name from corp where id='"+corpid+"'");
                  itemid = EAFunc.NVL(request.getParameter("itemid"),"");
                  itemtype = EAFunc.NVL(request.getParameter("refid"),"");
                  
                  db = new EADatabase(); 
                  itemname =db.GetSQL("SELECT NAME FROM ITEM WHERE ID='"+itemid+"'");
                  SCInterceptor sc = new SCInterceptor();                 
                  String sql =  "SELECT v_sctype.name 订单类型,UNIT,SMLUNT, SUM(整包数量) 整包数量,SUM(零包数量) 零包数量,SUM(确认整包数量) 确认整包数量,SUM(确认零包数量) 确认零包数量 from "+
                              "(SELECT SCTYPE,"+
                              "ceil(NVL(hisord.qty,0)/ITEM.UNTNUM)-decode(mod(NVL(hisord.qty,0),ITEM.UNTNUM),0,0,1) 整包数量,"+
                              "mod(NVL(hisord.qty,0),ITEM.UNTNUM) 零包数量, "+
                              "ceil(NVL(hisord.rlsqty,0)/ITEM.UNTNUM)-decode(mod(NVL(hisord.rlsqty,0),ITEM.UNTNUM),0,0,1) 确认整包数量,"+
                              "mod(NVL(hisord.rlsqty,0),ITEM.UNTNUM) 确认零包数量,ITEM.UNIT,ITEM.SMLUNT "+
                              " FROM hisord,CORP,ITEM  WHERE hisord.CORP=CORP.GUID AND "+
                              "hisord.ITEM=ITEM.GUID AND CORP.ID='"+corpid+"'  and item.id='"+itemid+"' and hisord.crtusr='"+sUID+"'";
                              if ( kaflag.endsWith("sq"))
                                sql+= "and hisord.subtyp='3' ";
                                else
                              sql+=  "and hisord.subtyp='1' ";
                              sql +=  "and to_date(to_char(hisord.crtdat,'yyyy-mm-dd'),'yyyy-mm-dd')>=to_date('"+y1+"-"+m1+"-"+d1+"','yyyy-mm-dd') "+
                              "and to_date(to_char(hisord.crtdat,'yyyy-mm-dd'),'yyyy-mm-dd')<=to_date('"+y2+"-"+m2+"-"+d2+"','yyyy-mm-dd') ) a, v_sctype "+                             
                              " where a.sctype=v_sctype.id  group by a.sctype ,v_sctype.name,UNIT,SMLUNT order by sctype";
                  ds = EADbTool.QuerySQL(sql);  
                                     
            
            } 
            catch ( EAException e ) 
            { 
                  if ( db!= null ) db.Rollback(); 
                  throw e;
            
            } 
            finally
            { 
                  if (db!= null ) db.Close(); 
            
            } 

          
%>

订单如下:<br>
网点名称：<%=corpname%><br>
业务员：<%=sUsrnam%><br>
商品：<%=itemname%>
<br>
<%
  // xiaoshou  1 5 unit
  // zengpin   2 0  2 0 
  for ( int i=0;i<ds.getRowCount();i++) {
    out.println( ds.getStringAt(i,"订单类型")+ds.getStringAt(i,"整包数量") +ds.getStringAt(i,"unit") +ds.getStringAt(i,"零包数量") +ds.getStringAt(i,"smlunt") );
    out.println( "<br>" );
    out.println( "确认数:"+ds.getStringAt(i,"确认整包数量") +ds.getStringAt(i,"unit") +ds.getStringAt(i,"确认零包数量") +ds.getStringAt(i,"smlunt") );
    out.println( "<br>" );
  }
%>



<a href="j2meDateitemlist.jsp?corpid=<%=corpid%>&y1=<%=y1%>&m1=<%=m1%>&d1=<%=d1%>&y2=<%=y2%>&m2=<%=m2%>&d2=<%=d2%>&kaflag=<%=kaflag%>">返回上页</a>
<br>
<a href="j2memain.jsp">返回主页</a>
</body>
</html>