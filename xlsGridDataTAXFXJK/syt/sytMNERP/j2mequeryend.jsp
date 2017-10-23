<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*,java.util.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>查询计划</title>
</head>
<body>
<p align="center"><img src="resource://pages/title.png"><line></p>
<%
             EAXmlDS ds = null;
             String brand = EAFunc.NVL(request.getParameter("brand"),"");
             String itemtype = EAFunc.NVL(request.getParameter("itemtype"),"");
             String sUID = (String)session.getAttribute("sUID");
             String y1 = EAFunc.NVL(request.getParameter("y1"),"");
             String m1 = EAFunc.NVL(request.getParameter("m1"),"");
             String d1 = EAFunc.NVL(request.getParameter("d1"),"");
             String y2 = EAFunc.NVL(request.getParameter("y2"),"");
             String m2 = EAFunc.NVL(request.getParameter("m2"),"");
             String d2 = EAFunc.NVL(request.getParameter("d2"),"");
             String date1 = y1+"-"+m1+"-"+d1;//起始日期
             String date2 = y2+"-"+m2+"-"+d2;//截至日期
             //String bascat = EAFunc.NVL(request.getParameter("bascat"),"");//条线ID
             String number = EAFunc.NVL(request.getParameter("number"),"");//因为传值中会出现中文乱码问题，改为session传值
             String bascat = (String)session.getAttribute("bascat1"+number);
    try
    {
        //EAUserinfo usrinfo = MobileLogin.CheckIfLogin(request);
        //sUID  = usrinfo.getUsrid();
        String sql =  "SELECT a.id,a.name,a.UNIT, SUM(整包数量) 整包数量 from "+
                        "(SELECT item.id,item.name ,item.UNIT ,"+
                        "ceil(NVL(wapplan.qty,0)/ITEM.UNTNUM)-decode(mod(NVL(wapplan.qty,0),ITEM.UNTNUM),0,0,1) 整包数量 "+
                        " FROM wapplan,ITEM  WHERE  "+
                        "wapplan.ITEM=ITEM.GUID   and item.refid='"+itemtype+"' and wapplan.crtusr='"+sUID+"'  "+
                        "and wapplan.dat>=to_date('"+date1+"','yyyy-mm-dd') "+
                        "and wapplan.dat<=to_date('"+date2+"','yyyy-mm-dd') "+
                        " and item.brand='"+brand+"' and wapplan.bascat like '"+bascat+"%')a group by a.id ,a.name,a.UNIT order by a.id";  
		//System.out.println(sUID+ "  "+sql);
        ds = EADbTool.QuerySQL(sql);  
        String str = "";
        int r = ds.getRowCount();
        if( r>0 )
        {
            for ( int i=0;i<r;i++)
            {
              out.println("["+ds.getStringAt(i,"name")+"]"+"<br/>"+ds.getStringAt(i,"整包数量")+ds.getStringAt(i,"UNIT")+"<br/>");
            }
        
        }
		out.print("<a href=\"j2mequerybytype.jsp?y1="+y1+"&m1="+m1+"&d1="+d1+"&y2="+y2+"&m2="+m2+"&d2="+d2+"&number="+number+"\">返回上页</a><br/>");
    }
    catch(EAException e)
    {
     out.print(e.toString());
    
    }
%>
<p align="center">
<a href="j2memain.jsp">返回主页</a><br>
</p>
</body>
</html>