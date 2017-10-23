<%@ page contentType="text/html;charset=UTF8"%>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>bascorplist</title>
</head>
<body>
<% 
              out.println( "<p align=\"center\"><img  src=\"resource://pages/title.png\" ></P><line>" );

              int pagesize=15;//姣忛〉鏄剧ず鏉℃暟
          
              String showpage = "";
              String sMsg="";
              String corpid="";
              String itemid="";
              String y1="";
              String y2="";
              String m1="";
              String m2="";
              String d1="";
              String d2="";
              EAXmlDS ds = null;
              String sUsrnam="";
              String sUID =(String)session.getAttribute("sUID");//session淇濆瓨鐢ㄦ埛鐨勬墜鏈哄彿鐮�
              //EAUserinfo usrinfo = EASession.GetLoginInfo(request); 
              // 寰楀埌鐧婚檰鐨刄SER ID
              //String sUID  = sNo;
              String itemtype="";
              int nextPage = 0;
              int prePage = 0;
              int ishowpage = 0;
              int c=0; 
              int nPageCount=0;
              y1 = EAFunc.NVL(request.getParameter("y1"),"");
              m1 = EAFunc.NVL(request.getParameter("m1"),"");
              d1 = EAFunc.NVL(request.getParameter("d1"),"");
              y2 = EAFunc.NVL(request.getParameter("y2"),"");
              m2 = EAFunc.NVL(request.getParameter("m2"),"");
              d2 = EAFunc.NVL(request.getParameter("d2"),""); 
              String kaflag = EAFunc.NVL(request.getParameter("kaflag"),""); 
              
            //鍒╃敤浼犳潵鐨勬棩鏈熻繘琛屾煡鎵剧綉鐐瑰悕
               String sql="select  distinct c.lonname corpname,c.id corpid from hisord h ,corp c where h.corp =c.guid and"+
//               " to_date(to_char(h.crtdat,'yyyy-mm-dd'),'yyyy-mm-dd')>=to_date('"+y1+"-"+m1+"-"+d1+"','yyyy-mm-dd')"+  
//               " and to_date(to_char(h.crtdat,'yyyy-mm-dd'),'yyyy-mm-dd')<=to_date('"+y2+"-"+m2+"-"+d2+"','yyyy-mm-dd') "+
                 " h.dat>=to_date('"+y1+"-"+m1+"-"+d1+"','yyyy-mm-dd')"+  
               " and h.dat<=to_date('"+y2+"-"+m2+"-"+d2+"','yyyy-mm-dd') "+
               " and h.crtusr='"+sUID+"' and stat = '1'";
              //if ( kaflag.equalsIgnoreCase("sq"))
               //sql +=" and h.subtyp='3'";
              // else
               //sql += "and h.subtyp='1'";
               ds = EADbTool.QuerySQL(sql);
               showpage = EAFunc.NVL(request.getParameter("showpage"),"1");
               c = ds.getRowCount();
              // out.print("CCCC"+c);
               nPageCount = c%pagesize==0?c/pagesize:c/pagesize+1;
                ////瀵圭壒娈婃儏鍐靛垽鏂�
               ishowpage = Integer.parseInt(showpage);
               prePage = ishowpage - 1;
               if(prePage<1) prePage = 1;
                  nextPage = ishowpage + 1;
               if(nextPage>nPageCount) nextPage = nPageCount;
             
%>
<%=showpage%>/<%=nPageCount%>
<%if(ishowpage!=nPageCount&&nPageCount>1){%>
<a href="j2meDatecorplist.jsp?sUID=<%=sUID%>&amp;showpage=<%=nextPage%>&amp;y1=<%=y1%>&amp;m1=<%=m1%>&amp;d1=<%=d1%>&amp;y2=<%=y2%>&amp;m2=<%=m2%>&amp;d2=<%=d2%>&amp;kaflag=<%=kaflag%>">
下页
</a>
<%}%>
<%if(ishowpage==nPageCount&&nPageCount>1){%>
<a href="j2meDatecorplist.jsp?sUID=<%=sUID%>&amp;showpage=<%=prePage%>&amp;y1=<%=y1%>&amp;m1=<%=m1%>&amp;d1=<%=d1%>&amp;y2=<%=y2%>&amp;m2=<%=m2%>&amp;d2=<%=d2%>&amp;kaflag=<%=kaflag%>">
上页
</a>
<%}%>
<br>
<% 
 for( int i=(ishowpage-1)*pagesize;i<pagesize*ishowpage;i++) {
               if(c==0)    //鍒ゆ柇鏄惁鏈夎褰曪紝鑻ユ病鏈夛紝閫�鍑哄惊鐜�
               break;
                if(i==c)   //鍒ゆ柇鏄惁涓烘渶鍚庝竴琛岋紝鑻ユ槸锛岄��鍑哄惊鐜�
                break;
%>	
<img src=\"resource://pages/1.png\"> <a href="j2meDateitemlist.jsp?corpid=<%=ds.getStringAt(i,"corpid")%>&y1=<%=y1%>&m1=<%=m1%>&d1=<%=d1%>&y2=<%=y2%>&m2=<%=m2%>&d2=<%=d2%>&kaflag=<%=kaflag%>"><%=ds.getStringAt(i,"corpname")%></a><br>
<% } %>	

<%if(ishowpage!=1&&nPageCount>1){%>
<a href="j2meDatecorplist.jsp?sUID=<%=sUID%>&amp;showpage=<%=prePage%>&amp;y1=<%=y1%>&amp;m1=<%=m1%>&amp;d1=<%=d1%>&amp;y2=<%=y2%>&amp;m2=<%=m2%>&amp;d2=<%=d2%>&amp;kaflag=<%=kaflag%>">
上页
</a>
<%}
if(ishowpage!=nPageCount&&nPageCount>1){%>
<a href="j2meDatecorplist.jsp?sUID=<%=sUID%>&amp;showpage=<%=nextPage%>&amp;y1=<%=y1%>&amp;m1=<%=m1%>&amp;d1=<%=d1%>&amp;y2=<%=y2%>&amp;m2=<%=m2%>&amp;d2=<%=d2%>&amp;kaflag=<%=kaflag%>">
下页
</a>
<%}%>
<br>
<p align="center">
<a href="j2memain.jsp">返回主页</a>
</p>
</body>
</html>

