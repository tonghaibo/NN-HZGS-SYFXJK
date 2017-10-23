<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>查询计划</title>
</head>
<body>

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
   try{

//            String sUID=(String)session.getAttribute("sUID");//session保存用户的手机号码
            EAUserinfo usrinfo = EASession.GetLoginInfo(request);
            
            if ( usrinfo ==null ) 
            {
              usrinfo = new EAUserinfo();
              usrinfo.setUsrid(sUID);
    }
     // 得到登陆的USER ID
            //String sUID  = usrinfo.getUsrid();
            String sql =  "SELECT a.id,a.name,a.UNIT, SUM(整包数量) 整包数量 from "+
                          "(SELECT item.id,item.name ,item.UNIT ,"+
                          "ceil(NVL(wapplan.qty,0)/ITEM.UNTNUM)-decode(mod(NVL(wapplan.qty,0),ITEM.UNTNUM),0,0,1) 整包数量 "+
                          " FROM wapplan,ITEM  WHERE  "+
                          "wapplan.ITEM=ITEM.GUID   and item.refid='"+itemtype+"' and wapplan.crtusr='"+sUID+"'  "+
                          "and wapplan.dat>=to_date('"+date1+"','yyyy-mm-dd') "+
                          "and wapplan.dat<=to_date('"+date2+"','yyyy-mm-dd') "+
                          " and item.brand='MN' and wapplan.bascat like '"+bascat+"%')a group by a.id ,a.name,a.UNIT order by a.id"; 

            String sOut = "";
            int pagesize=15;//每页显示条数   
            int pageno = Integer.parseInt(EAFunc.NVL(request.getParameter("showpage"),"1"));
//            out.println("pageno"+pageno);
//            out.print("date1"+date1);
//            out.print("date2"+date2);
//            out.print("number"+number);
            int allRowCount = (int)EADbTool.GetSQLRowCount(sql);
//            out.println("allRowCount"+allRowCount);
            int nPageCount = allRowCount%pagesize==0 ? allRowCount/pagesize : allRowCount/pagesize+1;
//            out.println("nPageCount"+nPageCount);
            EAFunc.assertsFmt(nPageCount>=pageno,"目前没有数据。","");
            ds = EADbTool.pageDS(sql,pageno,pagesize); 
            ds = EADbTool.QuerySQL(EASqlFunc.pageSql(sql,""+pageno,""+pagesize));
            int c = ds.getRowCount();
            out.print(""+pageno+"/"+nPageCount+"　");
            if(pageno==nPageCount)
              out.print("<a href=\"j2menewqueryend.jsp?showpage="+(pageno-1)+"&y1="+y1+"&m1="+m1+"&d1="+d1+"&y2="+y2+"&m2="+m2+"&d2="+d2+"&number="+number+"&itemtype="+itemtype+"\">上页</a></br>");
            if(pageno<nPageCount)
              out.print("<a href=\"j2menewqueryend.jsp?showpage="+(pageno+1)+"&y1="+y1+"&m1="+m1+"&d1="+d1+"&y2="+y2+"&m2="+m2+"&d2="+d2+"&number="+number+"&itemtype="+itemtype+"\">下页</a></br>");
    
            sOut += "<SINGLETABLE name=\"data\" width=\"100%\" COLWIDTH=\"170,50\" FIXEDROW=\"1\" FIXEDCOL=\"1\">" ;
            sOut += "商品,数量~n";
            for ( int i=0;i<c;i ++ ) {
              if ( i!= 0 ) 
                  sOut+="~n";
              sOut += ds.getStringAt(i,"name")+","+ds.getStringAt(i,"整包数量")+ds.getStringAt(i,"UNIT");     
            }
            sOut += "</SINGLETABLE>" ;
            out.print(sOut);
            if(pageno>1)
              out.print("<a href=\"j2menewqueryend.jsp?showpage="+(pageno-1)+"&y1="+y1+"&m1="+m1+"&d1="+d1+"&y2="+y2+"&m2="+m2+"&d2="+d2+"&number="+number+"&itemtype="+itemtype+"\">上页</a></br>");
            if(pageno<nPageCount)
              out.print("<a href=\"j2menewqueryend.jsp?showpage="+(pageno+1)+"&y1="+y1+"&m1="+m1+"&d1="+d1+"&y2="+y2+"&m2="+m2+"&d2="+d2+"&number="+number+"&itemtype="+itemtype+"\">下页</a></br>");
            }
            catch(EAException e)
            {
            out.println(e.toString());
            }
            out.print("<a href=\"j2mequerybytype.jsp?y1="+y1+"&m1="+m1+"&d1="+d1+"&y2="+y2+"&m2="+m2+"&d2="+d2+"&number="+number+"\">返回常低温</a><br/>"); 
%>
</p>
</body>
</html>
