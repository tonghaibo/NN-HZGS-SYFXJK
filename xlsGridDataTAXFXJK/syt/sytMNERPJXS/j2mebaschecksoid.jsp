<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>main</title>
</head>
<body>
<%
        out.println( "<p align=\"center\"><img border=\"0\" src=\"resource://pages/title.png\" ></P><line>" );
        response.setHeader("Pragma","No-cache"); 
        response.setHeader("Cache-Control","no-cache"); 
        response.setDateHeader("Expires", 0);   
        String sUsrnam="";
        String y1 = "";
        String m1 = "";
        String d1 = "";
        String y2 = "";
        String m2 = "";
        String d2 = "";
        String corpguid = "";
        EAXmlDS ds = null;
        String corpsoid = "";
        String corpid = "";
        String sOut = "";
        String sOut1 = "";
        String sOut2 = "";
        String sUID  = (String)session.getAttribute("sUID");
        try
        {
          //EAUserinfo usrinfo = MobileLogin.CheckIfLogin(request);
          // 得到登陆的USER ID
          sUsrnam= EADbTool.GetSQL("SELECT NAME FROM USR WHERE id='"+sUID+"'");
          y1 = EAFunc.NVL(request.getParameter("y1"),"");
          m1 = EAFunc.NVL(request.getParameter("m1"),"");
          d1 = EAFunc.NVL(request.getParameter("d1"),"");
          y2 = EAFunc.NVL(request.getParameter("y2"),"");
          m2 = EAFunc.NVL(request.getParameter("m2"),"");
          d2 = EAFunc.NVL(request.getParameter("d2"),""); 
          corpsoid = EAFunc.NVL(request.getParameter("corpsoid"),"");        
          corpid = EAFunc.NVL(request.getParameter("corpid"),"");  
          corpguid = EADbTool.GetSQL("select guid from corp where id='"+corpid+"'");
          String sql = "select shtnam as 商品,sctype 分类,ceil(qty/untnum)-decode(mod(qty,untnum),0,0,1)||unit||mod(qty,untnum)||smlunt as 数量 "+
                  "from ( "+
                  "select i.shtnam ,i.untnum,i.unit,i.smlunt,c.name sctype,sum(qty) qty "+
                  "from item i,hisord h,v_sctype c where h.sctype=c.id and h.item=i.guid and h.crtusr='"+sUID+"' and h.subtyp='2'"+
                  " and to_date(to_char(h.crtdat,'yyyy-mm-dd'),'yyyy-mm-dd')>=to_date('"+y1+"-"+m1+"-"+d1+"','yyyy-mm-dd') "+
                  "and to_date(to_char(h.crtdat,'yyyy-mm-dd'),'yyyy-mm-dd')<=to_date('"+y2+"-"+m2+"-"+d2+"','yyyy-mm-dd') "+
                  " and h.corp='"+corpguid+"'";
      if ( corpsoid.length() < 1 ) sql +=" and h.corpsoid is null " ;
      else sql+= "and h.corpsoid='"+corpsoid+"'" ;	  
      sql += " group by i.id,i.refid,i.sortid,i.shtnam,i.untnum,i.unit,i.smlunt,c.name order by i.refid,i.sortid )";
      ds = EADbTool.QuerySQL(sql);
      String sql1 = "select distinct item from hisord where crtusr='"+sUID+"' and "+
                   " to_date(to_char(crtdat,'yyyy-mm-dd'),'yyyy-mm-dd')>=to_date('"+y1+"-"+m1+"-"+d1+"','yyyy-mm-dd') "+
                  "and to_date(to_char(crtdat,'yyyy-mm-dd'),'yyyy-mm-dd')<=to_date('"+y2+"-"+m2+"-"+d2+"','yyyy-mm-dd') ";
      if ( corpsoid.length() < 1 ) sql1 +=" and corpsoid is null " ;
      else sql1 += "and corpsoid='"+corpsoid+"'" ;         
      
      int cc = EADbTool.QuerySQL(sql1).getRowCount();

      int c = ds.getRowCount();
      sOut +="共"+cc+"个品种<br/>";                 
      for ( int i=0;i<c;i ++ ) {
          sOut1 += ds.getStringAt(i,"商品")+":<br/>"+ds.getStringAt(i,"分类")+ds.getStringAt(i,"数量")+"<br/>";     
      }
          sOut2 +="<br/><a href=\"j2mebascorpsoid.jsp?y1="+y1+"&amp;m1="+m1+"&amp;d1="+d1+"&amp;y2="+y2+"&amp;m2="+m2+"&amp;d2="+d2+"&amp;corpid="+corpid+"\">返回上页</a>";          
          //sOut +="<br/><a href=\"main.jsp\">返回主页</a>";
		  out.println(sOut);
        }
        catch(EAException e)
        {		
          out.println("发生错误："+e.toString());
          out.println("<br/><a href='j2melogin.jsp'>重新登录</a>");
        }
%>
<p align="center">
商品汇总</br>
<%=sOut%></br>
</p>
<p align="left">
<%=sOut1%></br>
</p>
<line>
<p align="center">
<%=sOut2%> <a href="j2memain.jsp">返回主页</a>
</p>
</body>
</html>
