<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.web.*,com.xlsgrid.net.tag.*,com.xlsgrid.net.xmldb.*" %>
<%      
        EAUserinfo usrinfo = null;
        String usrid = "";
        String acc = "";
        try {
          usrinfo = com.xlsgrid.net.web.EASession.GetLoginInfo(request);
          if (usrinfo!=null ) {
            usrid = usrinfo.getUsrid();
            acc=usrinfo.getAccid();
            
          }
        }
        catch ( EAException e ){
          out.println( e.toString() );
        }
///=============================================================================
//  模块：物流登陆的首页，做提醒用途
//  1、列出登录用户所在的仓库，
//      查询USR表的DEFLOC,如果为空，提醒您所在的仓库没有定义
//      说明:以下提到的符合登陆操作员所在仓库的网点条件是指:
//        CORP表中符合条件：EXTCAT4出货仓库(常温)或EXTCAT5出货仓库(低温)是操作员所在仓库
//        如果如果您所在的仓库DEFLOC没有定义，则查询所有的网点
//  2、统计符合登陆操作员所在仓库的网点条件信息
//      共有多少个网点，其中有多少个网点没有分配路线（SHP11~27字段如果有一个等于9999或为空，说明该网点没有分配路线）
//  3、统计符合登陆操作员所在仓库的网点，有多少个是昨天和今天新增的
//        在CORP表中CRTDAT是昨天或今天的
//  4、统计送货日期是今天的送货单的纪录数,其中有多少张没有生成派车单
//      查询出BILHDR中DAT是今天的,BILTYP='SX' ACC=所登陆的帐套,并且CORPID符合 网点仓库号符合登陆操作员所在仓库条件的
//        如果REFID1派车单号是空的,或者派车单号是以9999开头，说明没有生成派车单
//        
///=============================================================================
    EADatabase db = null;
    String flag= "";
    String sOut = "";
    String sOut1 = "";
    String sOut2 = "";
    String sOut3 = "";
    String sOut4 = "";
    String sOut5 = "";
    try {
      db = new EADatabase();
      //根据登入用户的usrid从表usr里取出字段DEFLOC（用户所在仓库）的值，并把它设为flag
      String date=request.getParameter("DAT_b");
      String day="";
      if(date==""||date==null||date.equals("")){
       date=db.GetSQL("select to_char(sysdate-1,'yyyy-mm-dd')from dual");
       //路线定义的是开单的日期，不是送货的日期(取CORP表的数据应该是前一天的数据)
       day=db.GetSQL("select to_char(sysdate+1-1,'d') from  dual");
      }else{
       day=db.GetSQL("select to_char(to_date('"+date+"','yyyy-mm-dd')+1-1,'d')from dual");
      }
      
      EAXmlDS ds0=db.QuerySQL("select defloc from usr where id='"+usrid+"'");
      if ( ds0.getRowCount()>0 ) 
        flag = ds0.getStringAt(0,"defloc");
      else
        throw new EAException( "用户"+usrid+"不存在" );
      //当flag为空，登入用户所在仓库未定义       
      if(flag.length()==0){
              sOut="未定义";
              out.print(" 您所在的仓库<b>&nbsp;"+sOut+"&nbsp;</b>,");
              //从表corp中查询出所有网点的个数
              String s1="select count(*) from corp";
              sOut1=db.GetSQL(s1);
              out.print("您所在的仓库共有<b>&nbsp;"+sOut1+"&nbsp;</b>个网点<BR><br>");
                 String s2="select corp.id,corp.name, usr.name,usr.mobile from corp,usrcorp ,usr "+
                          "where corp.guid=usrcorp.corp(+) "+
                          "and usrcorp.usr=usr.guid(+) "+
                          "and to_char(corp.crtdat,'yyyy-mm-dd')='"+date+"'";
                   //     "and trunc(corp.crtdat,'dd')=trunc(sysdate,'dd') "; 
                    
              EAXmlDS ds1=db.QuerySQL(s2);//查看今天新增加的网点的信息
              %>
<LINK rel=stylesheet type=text/css HREF="xlsgrid/css/main.css">
<LINK rel=stylesheet type=text/css HREF="main_right.css">
<SCRIPT LANGUAGE=javascript>						
						function sel_DAT(obj) {
						  var ret   = window.showModalDialog( "../xlsgrid/jsp/pages/calendardlg.htm","" , "dialogwidth:150pt;dialogheight:150pt" ); 			
						  if ( ret != null &&  ret != "" && ret != undefined) {
						  			  //alert(obj);
						    obj.value = ret ; 
						  }
						}
</SCRIPT>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=GBK">
    <title></title>
  </head>
  <body  background="images/tree_bg.jpg" >
  <font size="3"  >
 <H3><span style="font-size: 9pt">当前工作状态统计</span></H3><hr> 

  </font>
  <font style="font-size: 9pt" >
  <form method="POST"  >
  		设置今天的日期：<input style="width:100; border: 1px solid #014E82; " type=text id=DAT_b name=DAT_b size=20 value="<%=date%>" />
						<img src="../xlsgrid/images/design/forderopen.gif"   onclick='javascript:sel_DAT( document.all("DAT_b") );' onmouseover=" this.style.cursor='hand'; title='点击选择日期'">
            <input type="SUBMIT" value="查询">
  </form>
<CENTER>今天新增加并且没有定义路线的网点</CENTER>

  </font>
  <font size="3" >
<TABLE border=0 cellspacing=3 width="100%"  >
                <TR  ><TD bgcolor="#6699FF"><span style="font-size: 9pt">网点编号</span></TD>
					<TD bgcolor="#6699FF">
					<span style="font-size: 9pt">网点名字</span></TD>
					<TD bgcolor="#6699FF">
					<span style="font-size: 9pt">网点业务员</span></TD>
					<TD bgcolor="#6699FF">
					<span style="font-size: 9pt">电话</span></TD>
					<TD bgcolor="#6699FF">
					<span style="font-size: 9pt">修改</span></TD></TR>
              <%
              for(int i=0;i<ds1.getRowCount();i++){
                     String adr="../xlsgrid/jsp/pages/dbEdit.jsp?flag=V_CUST&grdid=CorpLineModify&grdtyp=M&sytid=MNERP&title=OBJECT&where=ID='"+ds1.getStringAt(i,"ID")+"'";
                    %>
                    <TR>
                    <TD><span style="font-size: 9pt"><%=ds1.getStringAt(i,0)%></span></TD>
                    <TD><span style="font-size: 9pt"><%=ds1.getStringAt(i,1)%></span></TD>
                    <TD><span style="font-size: 9pt"><%=ds1.getStringAt(i,2)%></span></TD>
                    <TD><span style="font-size: 9pt "><%=ds1.getStringAt(i,3)%></span></TD>
                    <TD><span style="font-size: 9pt"><a href="<%=adr%>">修改</a></span></TD>
                    </TR>   
                           
                    <%  
              }
              %></TABLE>
   <font style="font-size: 9pt" >
 	<BR><BR><%    
  //            String s3="select to_char(sysdate,'d') from  dual";
   //           String day=db.GetSQL(s3);
               String s4="select  b.bilid, b.corpid,b.corpnam,c.SHPABL2"+day+",c.SHPLIN2"+day+" from bilhdr b, corp c  where b.corpid=c.id "+ 
                       "and substr(b.bilid,0,1)='E' "+
                       "and SHPABL2"+day+"=1 "+
                       "and (SHPLIN2"+day+"='9999' or SHPLIN2"+day+" is null)"+
                  //    "and trunc(b.dat,'dd')=trunc(sysdate+1,'dd') "+
                       "and to_char(b.dat-1,'yyyy-mm-dd')='"+date+"' "+
                       "and b.acc='"+acc+"' "+
                       "and b.BILTYP='SX' and b.subtyp='2' ";
               EAXmlDS ds4=db.QuerySQL(s4);
              String s5="select  b.bilid, b.corpid,b.corpnam,c.SHPABL1"+day+",c.SHPLIN1"+day+" from bilhdr b, corp c  where b.corpid=c.id "+ 
                       "and substr(b.bilid,0,1)='E' "+
                       "and SHPABL1"+day+"=1 "+
                       "and (SHPLIN1"+day+"='9999' or SHPLIN1"+day+" is null) "+
                  //     "and trunc(b.dat,'dd')=trunc(sysdate+1,'dd') "+
                       "and to_char(b.dat-1,'yyyy-mm-dd')='"+date+"' "+
                       "and b.acc='"+acc+"' "+
                       "and b.BILTYP='SX' and b.subtyp='1' ";
               EAXmlDS ds5=db.QuerySQL(s5);
               String s6="select  b.bilid, b.corpid,b.corpnam,c.SHPABL2"+day+",c.SHPLIN2"+day+" from bilhdr b, corp c  where b.corpid=c.id "+ 
                       "and substr(b.bilid,0,1)!='E' "+
                       "and (SHPABL2"+day+"=0 or SHPLIN2"+day+"='9999' or SHPLIN2"+day+" is null)"+
                //       "and trunc(b.dat,'dd')=trunc(sysdate+1,'dd') "+
                       "and to_char(b.dat-1,'yyyy-mm-dd')='"+date+"' "+
                       "and b.acc='"+acc+"' "+
                       "and b.BILTYP='SX' and b.subtyp='2' ";
               EAXmlDS ds6=db.QuerySQL(s6);
               String s7="select  b.bilid, b.corpid,b.corpnam,c.SHPABL1"+day+",c.SHPLIN1"+day+" from bilhdr b, corp c  where b.corpid=c.id "+ 
                       "and substr(b.bilid,0,1)!='E' "+
                       "and (SHPABL2"+day+"=0 or SHPLIN1"+day+"='9999' or SHPLIN1"+day+" is null)"+
                  //     "and trunc(b.dat,'dd')=trunc(sysdate+1,'dd') "+
                       "and to_char(b.dat-1,'yyyy-mm-dd')='"+date+"' "+
                       "and b.acc='"+acc+"' "+
                       "and b.BILTYP='SX' and b.subtyp='1' ";
               EAXmlDS ds7=db.QuerySQL(s7);
              %><CENTER>明天送货，但没有定义路线或不符合开关的信息</CENTER>

  </font>
  <TABLE border=0 cellspacing=1 width="100%" style="border: 1px solid #808080" cellpadding="4"> 
    <TR><TD bgcolor="#6699FF">
        <span style="font-size: 9pt">送货单编号</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt" >网点编号</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt">网点名称</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt">常温/低温</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt">开/关</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt">路线</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt">修改</span></TD></TR>
                 
              <%
          for(int i=0;i<ds4.getRowCount();i++){
          String adr="../xlsgrid/jsp/pages/dbEdit.jsp?flag=V_CUST&grdid=CorpLineModify&grdtyp=M&sytid=MNERP&title=OBJECT&where=ID='"+ds4.getStringAt(i,"CORPID")+"'";
              %>
          <TR>
          <TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,0)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,1)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,2)%></span></TD>
					<TD><span style="font-size: 9pt ">低温</span></TD>
          <TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,3)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,4)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr%>">修改</a></span></TD>
          </TR>          
          <%  
              }
            for(int i=0;i<ds5.getRowCount();i++){
            String adr="../xlsgrid/jsp/pages/dbEdit.jsp?flag=V_CUST&grdid=CorpLineModify&grdtyp=M&sytid=MNERP&title=OBJECT&where=ID='"+ds5.getStringAt(i,"CORPID")+"'";
              %>
          <TR>
          <TD><span style="font-size: 9pt"><%=ds5.getStringAt(i,0)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds5.getStringAt(i,1)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds5.getStringAt(i,2)%></span></TD>
					<TD><span style="font-size: 9pt ">常温</span></TD>
          <TD><span style="font-size: 9pt"><%=ds5.getStringAt(i,3)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds5.getStringAt(i,4)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr%>">修改</a></span></TD>
          </TR>          
          <%  
              }
        for(int i=0;i<ds6.getRowCount();i++){
            String adr="../xlsgrid/jsp/pages/dbEdit.jsp?flag=V_CUST&grdid=CorpLineModify&grdtyp=M&sytid=MNERP&title=OBJECT&where=ID='"+ds6.getStringAt(i,"CORPID")+"'";
              %>
          <TR>
          <TD><span style="font-size: 9pt"><%=ds6.getStringAt(i,0)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds6.getStringAt(i,1)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds6.getStringAt(i,2)%></span></TD>
					<TD><span style="font-size: 9pt ">低温</span></TD>
          <TD><span style="font-size: 9pt"><%=ds6.getStringAt(i,3)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds6.getStringAt(i,4)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr%>">修改</a></span></TD>
          </TR>          
          <%  
              }
        for(int i=0;i<ds7.getRowCount();i++){
            String adr="../xlsgrid/jsp/pages/dbEdit.jsp?flag=V_CUST&grdid=CorpLineModify&grdtyp=M&sytid=MNERP&title=OBJECT&where=ID='"+ds7.getStringAt(i,"CORPID")+"'";
              %>
          <TR>
          <TD><span style="font-size: 9pt"><%=ds7.getStringAt(i,0)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds7.getStringAt(i,1)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds7.getStringAt(i,2)%></span></TD>
					<TD><span style="font-size: 9pt ">常温</span></TD>
          <TD><span style="font-size: 9pt"><%=ds7.getStringAt(i,3)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds7.getStringAt(i,4)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr%>">修改</a></span></TD>
          </TR>          
          <%  
              }

              %></TABLE>
  <font style="font-size: 9pt" >
 	<%  
         
        }else{//flag的是值为所登入用户的仓库编号
              //根据flag从表LOC中查询出仓库名字
              String s="select name from loc where id='"+flag+"'";
              sOut=db.GetSQL(s);
              out.print("您所在的仓库<b>&nbsp;"+sOut+"&nbsp;</b>,");
              //根据flag从表corp中查询出符合条件的网点个数
              //EXTCAT4出货仓库(常温)或EXTCAT5出货仓库(低温)是操作员所在仓库
              String s1="select count(*) from corp where EXTCAT4='"+flag+"' or EXTCAT5='"+flag+"'";
              sOut1=db.GetSQL(s1);
              out.print("您所在的仓库共有<b>&nbsp;"+sOut1+"&nbsp;</b>个网点<BR><br>");
              String s2="select corp.id,corp.name, usr.name,usr.mobile from corp,usrcorp ,usr "+
                        "where corp.guid=usrcorp.corp(+) "+
                        "and usrcorp.usr=usr.guid(+) "+
                      //  "and trunc(corp.crtdat,'dd')=trunc(sysdate,'dd') "+
                        "and to_char(corp.crtdat,'yyyy-mm-dd')='"+date+"' "+
                        "and (corp.EXTCAT4='"+flag+"' or corp.EXTCAT5='"+flag+"')";
              EAXmlDS ds1=db.QuerySQL(s2);//查看今天新增加的网点的信息
              %><CENTER><br>
	今天新增加的网点信息表</CENTER>

  </font>
<TABLE border=0 cellspacing=1 width="100%" style="border: 1px solid #808080" cellpadding="4"  >
                <TR  ><TD bgcolor="#6699FF"><span style="font-size: 9pt">网点编号</span></TD>
					<TD bgcolor="#6699FF">
					<span style="font-size: 9pt">网点名字</span></TD>
					<TD bgcolor="#6699FF">
					<span style="font-size: 9pt">网点业务员</span></TD>
					<TD bgcolor="#6699FF">
					<span style="font-size: 9pt">电话</span></TD>
					<TD bgcolor="#6699FF">
					<span style="font-size: 9pt">查看</span></TD></TR>              <%
              for(int i=0;i<ds1.getRowCount();i++){
          String adr="../xlsgrid/jsp/pages/dbEdit.jsp?flag=V_CUST&grdid=CorpLineModify&grdtyp=M&sytid=MNERP&title=OBJECT&where=ID='"+ds1.getStringAt(i,"ID")+"'";
              %>
          <TR>
          <TD><span style="font-size: 9pt"><%=ds1.getStringAt(i,0)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds1.getStringAt(i,1)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds1.getStringAt(i,2)%></span></TD>
					<TD><span style="font-size: 9pt "><%=ds1.getStringAt(i,3)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr%>">查询</a></span></TD>
          </TR>   
                 
          <%   
              }
              %></TABLE>
  <font style="font-size: 9pt" >
 	<BR><BR><%    
             // String s3="select to_char(sysdate,'d') from  dual";
             // String day=db.GetSQL(s3);
             // 查询低温 手机上来的
               String s4="select  b.bilid, b.corpid,b.corpnam,c.SHPABL2"+day+",c.SHPLIN2"+day+" from bilhdr b, corp c  where b.corpid=c.id "+ 
                       "and substr(b.bilid,0,1)='E' "+
                  //     "and SHPABL2"+day+"=1 "+
                       "and (SHPLIN2"+day+"='9999' or SHPLIN2"+day+" is null)"+
                     //  "and trunc(b.dat,'dd')=trunc(sysdate+1,'dd') "+
                       "and to_char(b.dat-1,'yyyy-mm-dd')='"+date+"' "+
                       "and b.acc='"+acc+"' "+
                       "and c.EXTCAT5='"+flag+"' "+
                       "and b.BILTYP='SX' and b.subtyp='2' "+
		       "and not ( b.subtyp='1' and c.extcat7<>'01') and not ( b.subtyp='2' and c.extcat8<>'01') ";
              EAXmlDS ds4=db.QuerySQL(s4);
              // 查询常温 手机上来的
              String s5="select  b.bilid, b.corpid,b.corpnam,c.SHPABL1"+day+",c.SHPLIN1"+day+" from bilhdr b, corp c  where b.corpid=c.id "+ 
                       "and substr(b.bilid,0,1)='E' "+
               //        "and SHPABL1"+day+"=1 "+
                       "and (SHPLIN1"+day+"='9999' or SHPLIN1"+day+" is null)"+
                    //   "and trunc(b.dat,'dd')=trunc(sysdate+1,'dd') "+
                      "and to_char(b.dat-1,'yyyy-mm-dd')='"+date+"' "+
                       "and b.acc='"+acc+"' "+
                       "and c.EXTCAT4='"+flag+"' "+
                       "and b.BILTYP='SX' and b.subtyp='1' and 1<0 "+
		       "and not ( b.subtyp='1' and c.extcat7<>'01') and not ( b.subtyp='2' and c.extcat8<>'01') ";
               EAXmlDS ds5=db.QuerySQL(s5);
               // 低温 手工录入的
               String s6="select  b.bilid, b.corpid,b.corpnam,c.SHPABL2"+day+",c.SHPLIN2"+day+" from bilhdr b, corp c  where b.corpid=c.id "+ 
                       "and substr(b.bilid,0,1)!='E' "+
                       "and (SHPABL2"+day+"=0 or SHPLIN2"+day+"='9999' or SHPLIN2"+day+" is null)"+
                      // "and trunc(b.dat,'dd')=trunc(sysdate+1,'dd') "+
                       "and to_char(b.dat-1,'yyyy-mm-dd')='"+date+"' "+
                       "and b.acc='"+acc+"' "+
                       "and c.EXTCAT5='"+flag+"' "+
                       "and b.BILTYP='SX' and b.subtyp='2' "+
		       "and not ( b.subtyp='1' and c.extcat7<>'01') and not ( b.subtyp='2' and c.extcat8<>'01') ";
               EAXmlDS ds6=db.QuerySQL(s6);
               int cnt = ds6.getRowCount();
               String s7="select  b.bilid, b.corpid,b.corpnam,c.SHPABL1"+day+",c.SHPLIN1"+day+" from bilhdr b, corp c  where b.corpid=c.id "+ 
                       "and substr(b.bilid,0,1)!='E' "+
                       "and (SHPABL2"+day+"=0 or SHPLIN1"+day+"='9999' or SHPLIN1"+day+" is null)"+
                      // "and trunc(b.dat,'dd')=trunc(sysdate+1,'dd') "+
                       "and to_char(b.dat-1,'yyyy-mm-dd')='"+date+"' "+
                       "and b.acc='"+acc+"' "+
                       "and c.EXTCAT4='"+flag+"' "+
                       "and b.BILTYP='SX' and b.subtyp='1'  and 1<0 "+
		       "and not ( b.subtyp='1' and c.extcat7<>'01') and not ( b.subtyp='2' and c.extcat8<>'01') ";
               EAXmlDS ds7=db.QuerySQL(s7);
              %><CENTER>明天送货单信息</CENTER>

  </font>
  <TABLE border=0 cellspacing=1 width="100%" style="border: 1px solid #808080" cellpadding="4"> 
    <TR><TD bgcolor="#6699FF">
        <span style="font-size: 9pt">送货单编号</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt" >网点编号</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt">网点名称</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt">常温/低温</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt">开/关</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt">路线</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt">修改</span></TD></TR>
                 
              <%
          for(int i=0;i<ds4.getRowCount();i++){
          String adr="../xlsgrid/jsp/pages/dbEdit.jsp?flag=V_CUST&grdid=CorpLineModify&grdtyp=M&sytid=MNERP&title=OBJECT&where=ID='"+ds4.getStringAt(i,"CORPID")+"'";
              %>
          <TR>
          <TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,0)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,1)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,2)%></span></TD>
					<TD><span style="font-size: 9pt ">低温</span></TD>
          <TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,3)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,4)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr%>">修改</a></span></TD>
          </TR>          
          <%  
              }
            for(int i=0;i<ds5.getRowCount();i++){
            String adr="../xlsgrid/jsp/pages/dbEdit.jsp?flag=V_CUST&grdid=CorpLineModify&grdtyp=M&sytid=MNERP&title=OBJECT&where=ID='"+ds5.getStringAt(i,"CORPID")+"'";
              %>
          <TR>
          <TD><span style="font-size: 9pt"><%=ds5.getStringAt(i,0)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds5.getStringAt(i,1)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds5.getStringAt(i,2)%></span></TD>
					<TD><span style="font-size: 9pt ">常温</span></TD>
          <TD><span style="font-size: 9pt"><%=ds5.getStringAt(i,3)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds5.getStringAt(i,4)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr%>">修改</a></span></TD>
          </TR>          
          <%  
              }
        for(int i=0;i<ds6.getRowCount();i++){
            String adr="../xlsgrid/jsp/pages/dbEdit.jsp?flag=V_CUST&grdid=CorpLineModify&grdtyp=M&sytid=MNERP&title=OBJECT&where=ID='"+ds6.getStringAt(i,"CORPID")+"'";
              %>
          <TR>
          <TD><span style="font-size: 9pt"><%=ds6.getStringAt(i,0)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds6.getStringAt(i,1)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds6.getStringAt(i,2)%></span></TD>
					<TD><span style="font-size: 9pt ">低温</span></TD>
          <TD><span style="font-size: 9pt"><%=ds6.getStringAt(i,3)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds6.getStringAt(i,4)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr%>">修改</a></span></TD>
          </TR>          
          <%  
              }
        for(int i=0;i<ds7.getRowCount();i++){
            String adr="../xlsgrid/jsp/pages/dbEdit.jsp?flag=V_CUST&grdid=CorpLineModify&grdtyp=M&sytid=MNERP&title=OBJECT&where=ID='"+ds7.getStringAt(i,"CORPID")+"'";
              %>
          <TR>
          <TD><span style="font-size: 9pt"><%=ds7.getStringAt(i,0)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds7.getStringAt(i,1)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds7.getStringAt(i,2)%></span></TD>
					<TD><span style="font-size: 9pt ">常温</span></TD>
          <TD><span style="font-size: 9pt"><%=ds7.getStringAt(i,3)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds7.getStringAt(i,4)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr%>">修改</a></span></TD>
          </TR>          
          <%  
              }

              %></TABLE>
  <font style="font-size: 9pt" >
 	<%  
                        
        
        }
     
       }
    catch ( EAException e ) 
    {
      e.Print();
      out.println( e.toString() );
      try{db.Rollback();}catch ( EAException e1 ) {e1.Print();}
      throw new EAException ( e );
      
      
    }
    finally
    {
      try { if (db!=null) db.Close(); } catch ( EAException e ) {}
    }

%>

</font>
</font>
</body>
</html>