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
//  ģ�飺������½����ҳ����������;
//  1���г���¼�û����ڵĲֿ⣬
//      ��ѯUSR���DEFLOC,���Ϊ�գ����������ڵĲֿ�û�ж���
//      ˵��:�����ᵽ�ķ��ϵ�½����Ա���ڲֿ������������ָ:
//        CORP���з���������EXTCAT4�����ֿ�(����)��EXTCAT5�����ֿ�(����)�ǲ���Ա���ڲֿ�
//        �����������ڵĲֿ�DEFLOCû�ж��壬���ѯ���е�����
//  2��ͳ�Ʒ��ϵ�½����Ա���ڲֿ������������Ϣ
//      ���ж��ٸ����㣬�����ж��ٸ�����û�з���·�ߣ�SHP11~27�ֶ������һ������9999��Ϊ�գ�˵��������û�з���·�ߣ�
//  3��ͳ�Ʒ��ϵ�½����Ա���ڲֿ�����㣬�ж��ٸ�������ͽ���������
//        ��CORP����CRTDAT�����������
//  4��ͳ���ͻ������ǽ�����ͻ����ļ�¼��,�����ж�����û�������ɳ���
//      ��ѯ��BILHDR��DAT�ǽ����,BILTYP='SX' ACC=����½������,����CORPID���� ����ֿ�ŷ��ϵ�½����Ա���ڲֿ�������
//        ���REFID1�ɳ������ǿյ�,�����ɳ���������9999��ͷ��˵��û�������ɳ���
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
      //���ݵ����û���usrid�ӱ�usr��ȡ���ֶ�DEFLOC���û����ڲֿ⣩��ֵ����������Ϊflag
      String date=request.getParameter("DAT_b");
      String day="";
      if(date==""||date==null||date.equals("")){
       date=db.GetSQL("select to_char(sysdate-1,'yyyy-mm-dd')from dual");
       //·�߶�����ǿ��������ڣ������ͻ�������(ȡCORP�������Ӧ����ǰһ�������)
       day=db.GetSQL("select to_char(sysdate+1-1,'d') from  dual");
      }else{
       day=db.GetSQL("select to_char(to_date('"+date+"','yyyy-mm-dd')+1-1,'d')from dual");
      }
      
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
                 String s2="select corp.id,corp.name, usr.name,usr.mobile from corp,usrcorp ,usr "+
                          "where corp.guid=usrcorp.corp(+) "+
                          "and usrcorp.usr=usr.guid(+) "+
                          "and to_char(corp.crtdat,'yyyy-mm-dd')='"+date+"'";
                   //     "and trunc(corp.crtdat,'dd')=trunc(sysdate,'dd') "; 
                    
              EAXmlDS ds1=db.QuerySQL(s2);//�鿴���������ӵ��������Ϣ
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
 <H3><span style="font-size: 9pt">��ǰ����״̬ͳ��</span></H3><hr> 

  </font>
  <font style="font-size: 9pt" >
  <form method="POST"  >
  		���ý�������ڣ�<input style="width:100; border: 1px solid #014E82; " type=text id=DAT_b name=DAT_b size=20 value="<%=date%>" />
						<img src="../xlsgrid/images/design/forderopen.gif"   onclick='javascript:sel_DAT( document.all("DAT_b") );' onmouseover=" this.style.cursor='hand'; title='���ѡ������'">
            <input type="SUBMIT" value="��ѯ">
  </form>
<CENTER>���������Ӳ���û�ж���·�ߵ�����</CENTER>

  </font>
  <font size="3" >
<TABLE border=0 cellspacing=3 width="100%"  >
                <TR  ><TD bgcolor="#6699FF"><span style="font-size: 9pt">������</span></TD>
					<TD bgcolor="#6699FF">
					<span style="font-size: 9pt">��������</span></TD>
					<TD bgcolor="#6699FF">
					<span style="font-size: 9pt">����ҵ��Ա</span></TD>
					<TD bgcolor="#6699FF">
					<span style="font-size: 9pt">�绰</span></TD>
					<TD bgcolor="#6699FF">
					<span style="font-size: 9pt">�޸�</span></TD></TR>
              <%
              for(int i=0;i<ds1.getRowCount();i++){
                     String adr="../xlsgrid/jsp/pages/dbEdit.jsp?flag=V_CUST&grdid=CorpLineModify&grdtyp=M&sytid=MNERP&title=OBJECT&where=ID='"+ds1.getStringAt(i,"ID")+"'";
                    %>
                    <TR>
                    <TD><span style="font-size: 9pt"><%=ds1.getStringAt(i,0)%></span></TD>
                    <TD><span style="font-size: 9pt"><%=ds1.getStringAt(i,1)%></span></TD>
                    <TD><span style="font-size: 9pt"><%=ds1.getStringAt(i,2)%></span></TD>
                    <TD><span style="font-size: 9pt "><%=ds1.getStringAt(i,3)%></span></TD>
                    <TD><span style="font-size: 9pt"><a href="<%=adr%>">�޸�</a></span></TD>
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
              %><CENTER>�����ͻ�����û�ж���·�߻򲻷��Ͽ��ص���Ϣ</CENTER>

  </font>
  <TABLE border=0 cellspacing=1 width="100%" style="border: 1px solid #808080" cellpadding="4"> 
    <TR><TD bgcolor="#6699FF">
        <span style="font-size: 9pt">�ͻ������</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt" >������</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt">��������</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt">����/����</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt">��/��</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt">·��</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt">�޸�</span></TD></TR>
                 
              <%
          for(int i=0;i<ds4.getRowCount();i++){
          String adr="../xlsgrid/jsp/pages/dbEdit.jsp?flag=V_CUST&grdid=CorpLineModify&grdtyp=M&sytid=MNERP&title=OBJECT&where=ID='"+ds4.getStringAt(i,"CORPID")+"'";
              %>
          <TR>
          <TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,0)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,1)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,2)%></span></TD>
					<TD><span style="font-size: 9pt ">����</span></TD>
          <TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,3)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,4)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr%>">�޸�</a></span></TD>
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
					<TD><span style="font-size: 9pt ">����</span></TD>
          <TD><span style="font-size: 9pt"><%=ds5.getStringAt(i,3)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds5.getStringAt(i,4)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr%>">�޸�</a></span></TD>
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
					<TD><span style="font-size: 9pt ">����</span></TD>
          <TD><span style="font-size: 9pt"><%=ds6.getStringAt(i,3)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds6.getStringAt(i,4)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr%>">�޸�</a></span></TD>
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
					<TD><span style="font-size: 9pt ">����</span></TD>
          <TD><span style="font-size: 9pt"><%=ds7.getStringAt(i,3)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds7.getStringAt(i,4)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr%>">�޸�</a></span></TD>
          </TR>          
          <%  
              }

              %></TABLE>
  <font style="font-size: 9pt" >
 	<%  
         
        }else{//flag����ֵΪ�������û��Ĳֿ���
              //����flag�ӱ�LOC�в�ѯ���ֿ�����
              String s="select name from loc where id='"+flag+"'";
              sOut=db.GetSQL(s);
              out.print("�����ڵĲֿ�<b>&nbsp;"+sOut+"&nbsp;</b>,");
              //����flag�ӱ�corp�в�ѯ�������������������
              //EXTCAT4�����ֿ�(����)��EXTCAT5�����ֿ�(����)�ǲ���Ա���ڲֿ�
              String s1="select count(*) from corp where EXTCAT4='"+flag+"' or EXTCAT5='"+flag+"'";
              sOut1=db.GetSQL(s1);
              out.print("�����ڵĲֿ⹲��<b>&nbsp;"+sOut1+"&nbsp;</b>������<BR><br>");
              String s2="select corp.id,corp.name, usr.name,usr.mobile from corp,usrcorp ,usr "+
                        "where corp.guid=usrcorp.corp(+) "+
                        "and usrcorp.usr=usr.guid(+) "+
                      //  "and trunc(corp.crtdat,'dd')=trunc(sysdate,'dd') "+
                        "and to_char(corp.crtdat,'yyyy-mm-dd')='"+date+"' "+
                        "and (corp.EXTCAT4='"+flag+"' or corp.EXTCAT5='"+flag+"')";
              EAXmlDS ds1=db.QuerySQL(s2);//�鿴���������ӵ��������Ϣ
              %><CENTER><br>
	���������ӵ�������Ϣ��</CENTER>

  </font>
<TABLE border=0 cellspacing=1 width="100%" style="border: 1px solid #808080" cellpadding="4"  >
                <TR  ><TD bgcolor="#6699FF"><span style="font-size: 9pt">������</span></TD>
					<TD bgcolor="#6699FF">
					<span style="font-size: 9pt">��������</span></TD>
					<TD bgcolor="#6699FF">
					<span style="font-size: 9pt">����ҵ��Ա</span></TD>
					<TD bgcolor="#6699FF">
					<span style="font-size: 9pt">�绰</span></TD>
					<TD bgcolor="#6699FF">
					<span style="font-size: 9pt">�鿴</span></TD></TR>              <%
              for(int i=0;i<ds1.getRowCount();i++){
          String adr="../xlsgrid/jsp/pages/dbEdit.jsp?flag=V_CUST&grdid=CorpLineModify&grdtyp=M&sytid=MNERP&title=OBJECT&where=ID='"+ds1.getStringAt(i,"ID")+"'";
              %>
          <TR>
          <TD><span style="font-size: 9pt"><%=ds1.getStringAt(i,0)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds1.getStringAt(i,1)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds1.getStringAt(i,2)%></span></TD>
					<TD><span style="font-size: 9pt "><%=ds1.getStringAt(i,3)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr%>">��ѯ</a></span></TD>
          </TR>   
                 
          <%   
              }
              %></TABLE>
  <font style="font-size: 9pt" >
 	<BR><BR><%    
             // String s3="select to_char(sysdate,'d') from  dual";
             // String day=db.GetSQL(s3);
             // ��ѯ���� �ֻ�������
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
              // ��ѯ���� �ֻ�������
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
               // ���� �ֹ�¼���
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
              %><CENTER>�����ͻ�����Ϣ</CENTER>

  </font>
  <TABLE border=0 cellspacing=1 width="100%" style="border: 1px solid #808080" cellpadding="4"> 
    <TR><TD bgcolor="#6699FF">
        <span style="font-size: 9pt">�ͻ������</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt" >������</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt">��������</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt">����/����</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt">��/��</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt">·��</span></TD><TD bgcolor="#6699FF">
				<span style="font-size: 9pt">�޸�</span></TD></TR>
                 
              <%
          for(int i=0;i<ds4.getRowCount();i++){
          String adr="../xlsgrid/jsp/pages/dbEdit.jsp?flag=V_CUST&grdid=CorpLineModify&grdtyp=M&sytid=MNERP&title=OBJECT&where=ID='"+ds4.getStringAt(i,"CORPID")+"'";
              %>
          <TR>
          <TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,0)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,1)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,2)%></span></TD>
					<TD><span style="font-size: 9pt ">����</span></TD>
          <TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,3)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds4.getStringAt(i,4)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr%>">�޸�</a></span></TD>
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
					<TD><span style="font-size: 9pt ">����</span></TD>
          <TD><span style="font-size: 9pt"><%=ds5.getStringAt(i,3)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds5.getStringAt(i,4)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr%>">�޸�</a></span></TD>
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
					<TD><span style="font-size: 9pt ">����</span></TD>
          <TD><span style="font-size: 9pt"><%=ds6.getStringAt(i,3)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds6.getStringAt(i,4)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr%>">�޸�</a></span></TD>
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
					<TD><span style="font-size: 9pt ">����</span></TD>
          <TD><span style="font-size: 9pt"><%=ds7.getStringAt(i,3)%></span></TD>
					<TD><span style="font-size: 9pt"><%=ds7.getStringAt(i,4)%></span></TD>
					<TD><span style="font-size: 9pt"><a href="<%=adr%>">�޸�</a></span></TD>
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