<%@page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.mobile.MobileLogin,com.xlsgrid.net.web.*,com.syt.serp.mn.*,java.util.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF8">
<title>main</title>
</head>
<body>
<% 

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
              String sNo=(String)session.getAttribute("sNo");//session淇濆瓨鐢ㄦ埛鐨勬墜鏈哄彿鐮�
              EAUserinfo usrinfo = EASession.GetLoginInfo(request); 
              // 寰楀埌鐧婚檰鐨刄SER ID
              String sUID  = usrinfo.getUsrid();
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
               String sql="select  distinct c.lonname 缃戠偣鍚嶇О,c.id corpid from hisord h ,item i,corp c where h.item=i.guid and h.corp =c.guid and"+
               " to_date(to_char(h.crtdat,'yyyy-mm-dd'),'yyyy-mm-dd')>=to_date('"+y1+"-"+m1+"-"+d1+"','yyyy-mm-dd')  and to_date(to_char(h.crtdat,'yyyy-mm-dd'),'yyyy-mm-dd')<=to_date('"+y2+"-"+m2+"-"+d2+"','yyyy-mm-dd') and h.crtusr='"+sUID+"'";
              if ( kaflag.equalsIgnoreCase("sq"))
               sql +=" and h.subtyp='3'";
               else
               sql += "and h.subtyp='1'";
               ds = EADbTool.QuerySQL(sql);
               showpage = EAFunc.NVL(request.getParameter("showpage"),"1");
               c = ds.getRowCount();
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
涓嬮〉
</a>
<%}%>
<%if(ishowpage==nPageCount&&nPageCount>1){%>
<a href="Datecorplist.jsp?sUID=<%=sUID%>&amp;showpage=<%=prePage%>&amp;y1=<%=y1%>&amp;m1=<%=m1%>&amp;d1=<%=d1%>&amp;y2=<%=y2%>&amp;m2=<%=m2%>&amp;d2=<%=d2%>&amp;kaflag=<%=kaflag%>">
涓婇〉
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
<a href="j2meDateitemlist.jsp?corpid=<%=ds.getStringAt(i,"corpid")%>&y1=<%=y1%>&m1=<%=m1%>&d1=<%=d1%>&y2=<%=y2%>&m2=<%=m2%>&d2=<%=d2%>&kaflag=<%=kaflag%>"><%=ds.getStringAt(i,"缃戠偣鍚嶇О")%></a><br>
<% } %>	

<%if(ishowpage!=1&&nPageCount>1){%>
<a href="j2meDatecorplist.jsp?sUID=<%=sUID%>&amp;showpage=<%=prePage%>&amp;y1=<%=y1%>&amp;m1=<%=m1%>&amp;d1=<%=d1%>&amp;y2=<%=y2%>&amp;m2=<%=m2%>&amp;d2=<%=d2%>&amp;kaflag=<%=kaflag%>">
涓婇〉
</a>
<%}
if(ishowpage!=nPageCount&&nPageCount>1){%>
<a href="j2meDatecorplist.jsp?sUID=<%=sUID%>&amp;showpage=<%=nextPage%>&amp;y1=<%=y1%>&amp;m1=<%=m1%>&amp;d1=<%=d1%>&amp;y2=<%=y2%>&amp;m2=<%=m2%>&amp;d2=<%=d2%>&amp;kaflag=<%=kaflag%>">
涓嬮〉
</a>
<%}%>
<br>

<a href="j2memain.jsp">杩斿洖涓婚〉</a>
</body>
</html>

