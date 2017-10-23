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
              String name = "";
              String corpid = "";
              String sUsrnam="";
              EAXmlDS ds = null;
              String y1="";
              String y2="";
              String m1="";
              String m2="";
              String d1="";
              String d2="";
              String sNo=(String)session.getAttribute("sNo");//session保存用户的手机号码
              int  pagesize = 1000;
              String showpage = EAFunc.NVL(request.getParameter("showpage"),"1");
              String kaflag = EAFunc.NVL(request.getParameter("kaflag"),"");
              String count = "";//取出的记录数
              int c=0; 
              int nPageCount=0;
              EAUserinfo usrinfo = EASession.GetLoginInfo(request); 
              sNo = usrinfo.getUsrid();

              y1 = EAFunc.NVL(request.getParameter("y1"),"");
              m1 = EAFunc.NVL(request.getParameter("m1"),"");
              d1 = EAFunc.NVL(request.getParameter("d1"),"");
              y2 = EAFunc.NVL(request.getParameter("y2"),"");
              m2 = EAFunc.NVL(request.getParameter("m2"),"");
              d2 = EAFunc.NVL(request.getParameter("d2"),"");
               // 得到登陆的USER ID
              String sUID  = usrinfo.getUsrid();
              name = EAFunc.NVL(request.getParameter("name"),"");
              corpid = EAFunc.NVL(request.getParameter("corpid"),"");
              String sql = "select distinct i.id,substrb(i.shtnam,1,12) shtnam ,i.sortid,i.refid from item i,corp c, hisord h where h.item=i.guid and h.corp=c.guid and c.id='"+corpid+"' and "+
              " to_date(to_char(h.crtdat,'yyyy-mm-dd'),'yyyy-mm-dd')>=to_date('"+y1+"-"+m1+"-"+d1+"','yyyy-mm-dd')  and to_date(to_char(h.crtdat,'yyyy-mm-dd'),'yyyy-mm-dd')<=to_date('"+y2+"-"+m2+"-"+d2+"','yyyy-mm-dd') and h.crtusr='"+sUID+"' ";
              if ( kaflag.equalsIgnoreCase("sq"))
              sql+="and h.subtyp='3' order by i.sortid";
              else
              sql+="and h.subtyp='1' order by i.sortid";

              ds = EADbTool.QuerySQL(sql);
              //String nu = ds.getStringAt(0,"shtnam");
              
              c = ds.getRowCount();
            
              nPageCount = c%pagesize==0?c/pagesize:c/pagesize+1;
              int ishowpage = Integer.parseInt(showpage);
              int prePage = ishowpage - 1;
              if(prePage<1) prePage = 1;
              int nextPage = ishowpage + 1;
              if(nextPage>nPageCount) nextPage = nPageCount;

%>
<%=showpage%>/<%=nPageCount%>
<%if(ishowpage!=nPageCount&&nPageCount>1){%>
<a href="j2meDateitemlist.jsp?sUID=<%=sUID%>&showpage=<%=nextPage%>&corpid=<%=corpid%>&y1=<%=y1%>&m1=<%=m1%>&d1=<%=d1%>&y2=<%=y2%>&m2=<%=m2%>&d2=<%=d2%>&kaflag=<%=kaflag%>">
下页
</a>
<%}%>
<%if(ishowpage==nPageCount&&nPageCount>1){%>
<a href="j2meDateitemlist.jsp?sUID=<%=sUID%>&showpage=<%=prePage%>&corpid=<%=corpid%>&y1=<%=y1%>&m1=<%=m1%>&d1=<%=d1%>&y2=<%=y2%>&m2=<%=m2%>&d2=<%=d2%>&kaflag=<%=kaflag%>">
上页
</a>
<%}%>
<br/>
<%  
for(int i=(ishowpage-1)*pagesize;i<pagesize*ishowpage;i++)
{
              if(c==0)    //判断有没有记录，若没有，退出
                   break;
              if (i==c)   //判断是否为最后一行，若是，退出
                   break;
%>
<a href="j2mescquery.jsp?itemid=<%=ds.getStringAt(i,"id")%>&refid=<%=ds.getStringAt(i,"refid")%>&corpid=<%=corpid%>&y1=<%=y1%>&m1=<%=m1%>&d1=<%=d1%>&y2=<%=y2%>&m2=<%=m2%>&d2=<%=d2%>&kaflag=<%=kaflag%>"><%=ds.getStringAt(i,"shtnam")%></a><br>
<%}%>
<%if(ishowpage!=1&&nPageCount>1){%>
<a href="j2meDateitemlist.jsp?sUID=<%=sUID%>&amp;showpage=<%=prePage%>&amp;corpid=<%=corpid%>&amp;y1=<%=y1%>&amp;m1=<%=m1%>&amp;d1=<%=d1%>&amp;y2=<%=y2%>&amp;m2=<%=m2%>&amp;d2=<%=d2%>&amp;kaflag=<%=kaflag%>">
上页
</a>
<%}
if(ishowpage!=nPageCount&&nPageCount>1){%>
<a href="j2meDateitemlist.jsp?sUID=<%=sUID%>&amp;showpage=<%=nextPage%>&amp;corpid=<%=corpid%>&amp;y1=<%=y1%>&amp;m1=<%=m1%>&amp;d1=<%=d1%>&amp;y2=<%=y2%>&amp;m2=<%=m2%>&amp;d2=<%=d2%>&amp;kaflag=<%=kaflag%>">
下页
</a>
<%}%>
<a href="j2meDatecorplist.jsp?corpid=<%=corpid%>&amp;y1=<%=y1%>&amp;m1=<%=m1%>&amp;d1=<%=d1%>&amp;y2=<%=y2%>&amp;m2=<%=m2%>&amp;d2=<%=d2%>&amp;kaflag=<%=kaflag%>">返回上页</a><br/>

<a href="j2memain.jsp">返回主页</a>

</p>
</body>
</html>