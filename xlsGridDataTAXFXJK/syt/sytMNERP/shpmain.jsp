<%@ page contentType="text/html;charset=GBK" %>
<%@ page import="com.xlsgrid.net.pub.*,com.xlsgrid.net.web.*,com.xlsgrid.net.tag.*,com.xlsgrid.net.xmldb.*" %>
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
  <H3><span style="font-size: 9pt">��ǰ����״̬ͳ��</span></H3><hr> 
  </font>
  <font style="font-size: 9pt" >

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
      //���ݵ����û���usrid�ӱ�usr��ȡ���ֶ�DEFLOC���û����ڲֿ⣩��ֵ����������Ϊflag
      String date=request.getParameter("DAT_b");
      String day="";
      String subtype="";
     if( request.getParameter("subtype")==null)
     {
        subtype="2";
     }else{
     subtype=request.getParameter("subtype");
     }
     String locid="";
     String M="";
      if(subtype.equals("2")){
      locid="5";
      M="����";
      }
      if(subtype.equals("1")){
      locid="4";
      M="����";
      }
   //   out.print(subtype);
    //  out.print(locid);
      if(date==""||date==null||date.equals("")){
       date=db.GetSQL("select to_char(sysdate,'yyyy-mm-dd')from dual");
       //·�߶�����ǿ��������ڣ������ͻ�������(ȡCORP�������Ӧ����ǰһ�������)
       day=db.GetSQL("select to_char(sysdate,'d') from  dual");
      }else{
       day=db.GetSQL("select to_char(to_date('"+date+"','yyyy-mm-dd')+1-1,'d')from dual");
      }
      %>
      <form method="POST" >
      <br>
  		���ÿ��������ڣ�<input style="width:100; border: 1px solid #014E82; " type=text id=DAT_b name=DAT_b size=20 value="<%=date%>" />
						<img src="../xlsgrid/images/design/forderopen.gif"   onclick='javascript:sel_DAT( document.all("DAT_b") );' onmouseover=" this.style.cursor='hand'; title='���ѡ������'">
      &nbsp;&nbsp;&nbsp;&nbsp;�ͻ������ͣ�<select name="subtype" id="subtype">
                <option value="1" <%if(subtype.equals("1")){%>SELECTED<%}%>>����  </option>
                <option value="2" <%if(subtype.equals("2")){%>SELECTED<%}%>>����  </option>
                </select>
            <input type="SUBMIT" value="��ѯ">
       </form>
     ��������&nbsp;<%=Integer.parseInt(day)-1%>
      <br>
      <hr> 
      <%
      EAXmlDS ds0=db.QuerySQL("select defloc from usr where id='"+usrid+"'");
      if ( ds0.getRowCount()>0 ) 
        flag = ds0.getStringAt(0,"defloc");
      else
        throw new EAException( "�û�"+usrid+"������" );
      //��flagΪ�գ������û����ڲֿ�δ����       
      if(flag.length()==0){
              sOut="δ����";
              out.print(" �����ڵĲֿ�<b>&nbsp;"+sOut+"&nbsp;</b>,");
              //�ӱ�corp�в�ѯ����������ĸ���
              String s1="select count(*) from corp";
              sOut1=db.GetSQL(s1);
              out.print("�����ڵĲֿ⹲��<b>&nbsp;"+sOut1+"&nbsp;</b>������<BR><br>");   
        }else{
              //flag����ֵΪ�������û��Ĳֿ���
              //����flag�ӱ�LOC�в�ѯ���ֿ�����
              String s="select name from loc where id='"+flag+"'";
              sOut=db.GetSQL(s);
              out.print("�����ڵĲֿ�<b>&nbsp;"+sOut+"&nbsp;</b>,");
              String s1="select count(*) from corp where EXTCAT4='"+flag+"' or EXTCAT5='"+flag+"'";
              sOut1=db.GetSQL(s1);
              out.print("�����ڵĲֿ⹲��<b>&nbsp;"+sOut1+"&nbsp;</b>������<BR><br>");    
        }
	          String ss1= " select sum(count1),sum(count4),sum(count2),sum(count3)from ( "+
				          " select count(distinct bilid) count1,0 count2,0 count3,0 count4  from bildtl "+
						  " where BILTYP='SD'"+
						  " AND DAT=to_date('"+date+"','yyyy-mm-dd')"+
						  " AND LOCID LIKE '"+flag+"%'"+
						  " union "+
						  " select 0 count1,0 count2,0 count3,count(distinct bilid) count4  from bildtl "+
						  " where BILTYP='SD'"+
						  " AND DAT=to_date('"+date+"','yyyy-mm-dd')"+
						  " AND LOCID LIKE '"+flag+"%'"+
						  " AND STAT='2'"+
						  " union "+
						  " select 0 count1, count(distinct bilid) count2,0 count3,0 count4  from bildtl"+
						  " where BILTYP='SU'"+
						  " AND DAT=to_date('"+date+"','yyyy-mm-dd')"+
						  " AND LOCID LIKE '"+flag+"%'"+
						  " union "+
						  " select 0 count1,0 count2,count(distinct bilid) count3,0 count4  from bildtl "+
						  " where BILTYP='SU'"+
						  " AND DAT=TO_DATE('"+date+"','yyyy-mm-dd')"+
						  " AND LOCID LIKE '"+flag+"%'"+
						  " AND STAT='2'"+
						  " )";					
	    EAXmlDS dss1=db.QuerySQL(ss1);
		out.println("  �ɳ�����"+dss1.getStringAt(0,0)+"�ţ������Ѻ˵�Ϊ"+dss1.getStringAt(0,1)+"��<br>");
		out.println("�ɳ���ִ����"+dss1.getStringAt(0,2)+"�ţ������Ѻ˵�Ϊ"+dss1.getStringAt(0,3)+"��");
        String s2="select corp.id,corp.name, corp.ads,usr.name,usr.mobile from corp,usrcorp ,usr "+
                  "where corp.guid=usrcorp.corp(+) "+
                  "and usrcorp.usr=usr.guid(+) "+
                  "and to_char(corp.crtdat,'yyyy-mm-dd')='"+date+"' "+
                  "and (corp.EXTCAT4 like'"+flag+"%' or corp.EXTCAT5 like '"+flag+"%')";       
        EAXmlDS ds1=db.QuerySQL(s2);//�鿴���������ӵ��������Ϣ
                    %>
	  <CENTER><br>���������ӵ�������Ϣ��</CENTER>
       </font>
      <TABLE border=0 cellspacing=1 width="100%" style="border: 1px solid #808080" cellpadding="4"  >
          <TR  ><TD bgcolor="#6699FF"><span style="font-size: 9pt">������</span></TD>
					<TD bgcolor="#6699FF">
					<span style="font-size: 9pt">��������</span></TD>
          <TD bgcolor="#6699FF">
					<span style="font-size: 9pt">�����ַ</span></TD>
					<TD bgcolor="#6699FF">
					<span style="font-size: 9pt">����ҵ��Ա</span></TD>
					<TD bgcolor="#6699FF">
					<span style="font-size: 9pt">�绰</span></TD>
				       <TD bgcolor="#6699FF">
					<span style="font-size: 9pt">����·��</span></TD>
					<TD bgcolor="#6699FF">
					<span style="font-size: 9pt">����·��</span></TD>
          </TR><%
          for(int i=0;i<ds1.getRowCount();i++){
            String adr1="../ShowXlsGrid.sp?grdid=SelSHIPSEQ&REFID=1&CORPID="+ds1.getStringAt(i,"ID");
            String adr2="../ShowXlsGrid.sp?grdid=SelSHIPSEQ&REFID=2&CORPID="+ds1.getStringAt(i,"ID");
           %>
          <TR>
          <TD><span style="font-size: 9pt"><%=ds1.getStringAt(i,0)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds1.getStringAt(i,1)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds1.getStringAt(i,2)%></span></TD>
					<TD><span style="font-size: 9pt "><%=ds1.getStringAt(i,3)%></span></TD>
          <TD><span style="font-size: 9pt "><%=ds1.getStringAt(i,4)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr1%>">��ѯ</a></span></TD>
                                 	<TD><span style="font-size: 9pt"><a href="<%=adr2%>">��ѯ</a></span></TD>
          </TR>   
                 
          <%   
              }
          %>
          </TABLE><br><br>
          <font style="font-size: 9pt" >
          <CENTER>�����ͻ�����Ϣ</CENTER>
          </font>
          <TABLE border=0 cellspacing=1 width="100%" style="border: 1px solid #808080" cellpadding="4"> 
          <TR><TD bgcolor="#6699FF">
          <span style="font-size: 9pt">�ͻ������</span></TD><TD bgcolor="#6699FF">
          <span style="font-size: 9pt">�ͻ�����</span></TD><TD bgcolor="#6699FF">
				  <span style="font-size: 9pt" >������</span></TD><TD bgcolor="#6699FF">
				  <span style="font-size: 9pt">��������</span></TD><TD bgcolor="#6699FF">
				  <span style="font-size: 9pt">����/����</span></TD><TD bgcolor="#6699FF">
				  <span style="font-size: 9pt">��/��</span></TD><TD bgcolor="#6699FF">
				  <span style="font-size: 9pt">·��</span></TD><TD bgcolor="#6699FF">
				  <span style="font-size: 9pt">�޸�</span></TD></TR>
          <%
          //�ֻ�������
          String s4="select  b.bilid,b.dat, b.corpid,b.corpnam,c.SHPABL"+subtype+""+day+",c.SHPLIN"+subtype+""+day+" from bilhdr b, corp c  where b.corpid=c.id "+ 
                    "and substr(b.bilid,0,1)='E' "+
    //              "and SHPABL"+subtype+""+day+"=1 "+
                    "and (SHPLIN"+subtype+""+day+"='9999' or SHPLIN"+subtype+""+day+" is null)"+
                    "and to_char(b.dat-1,'yyyy-mm-dd')='"+date+"' "+
                    "and b.acc='"+acc+"' "+
                    "and c.EXTCAT"+locid+" like '"+flag+"%' "+
                    "and not ( b.subtyp='1' and c.extcat7<>'01') and not ( b.subtyp='2' and c.extcat8<>'01') "+
                    "and b.BILTYP='SX' and b.subtyp='"+subtype+"' ";
          EAXmlDS ds4=db.QuerySQL(s4);
          for(int i=0;i<ds4.getRowCount();i++){
          String adr="../ShowXlsGrid.sp?grdid=SelSHIPSEQ&REFID="+subtype+"&CORPID="+ds4.getStringAt(i,"CORPID");
              %>
          <TR>
          <TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,0)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,1)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,2)%></span></TD>
          <TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,3)%></span></TD>
					<TD><span style="font-size: 9pt "><%=M%></span></TD>
          <TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,4)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,5)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr%>">�޸�</a></span></TD>
          </TR>          
          <%  
          }
         //�ֹ�����
          String s6="select  b.bilid,b.dat,b.corpid,b.corpnam,c.SHPABL"+subtype+""+day+",c.SHPLIN"+subtype+""+day+" from bilhdr b, corp c  where b.corpid=c.id "+ 
                    "and substr(b.bilid,0,1)!='E' "+
                    "and (SHPABL"+subtype+""+day+"=0 or SHPLIN"+subtype+""+day+"='9999' or SHPLIN"+subtype+""+day+" is null)"+
                    "and to_char(b.dat-1,'yyyy-mm-dd')='"+date+"' "+
                    "and b.acc='"+acc+"' "+
                    "and c.EXTCAT"+locid+" like '"+flag+"%' "+
                    "and not ( b.subtyp='1' and c.extcat7<>'01') and not ( b.subtyp='2' and c.extcat8<>'01') "+
                    "and b.BILTYP='SX' and b.subtyp='"+subtype+"' ";
          EAXmlDS ds6=db.QuerySQL(s6);
           for(int i=0;i<ds6.getRowCount();i++){
            String adr="../ShowXlsGrid.sp?grdid=SelSHIPSEQ&REFID="+subtype+"&CORPID="+ds6.getStringAt(i,"CORPID");
              %>
          <TR>
          <TD><span style="font-size: 9pt"><%=ds6.getStringAt(i,0)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds6.getStringAt(i,1)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds6.getStringAt(i,2)%></span></TD>
          <TD><span style="font-size: 9pt"><%=ds6.getStringAt(i,3)%></span></TD>
					<TD><span style="font-size: 9pt "><%=M%></span></TD>
          <TD><span style="font-size: 9pt"><%=ds6.getStringAt(i,4)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds6.getStringAt(i,5)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr%>">�޸�</a></span></TD>
          </TR>          
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
