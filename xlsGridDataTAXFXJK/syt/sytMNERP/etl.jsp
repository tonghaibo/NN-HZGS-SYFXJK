<%@ page contentType="text/html;charset=GBK" import="com.xlsgrid.net.pub.*,com.syt.serp.mn.*,com.xlsgrid.net.web.*,com.xlsgrid.net.servlet.EAGridAction;"%>
<%
    EADatabase db = null;
    EAUserinfo usrinfo = EASession.GetLoginInfo(request);
    String usrid= usrinfo.getUsrid();
    String acc=usrinfo.getAccid();
    String syt=usrinfo.getSytid();
    //String locid=usrinfo.getLocid();
    String org=usrinfo.getOrgid();
  
    String sql;
    //��ǰ����������Ҫ��ʾ����
    String sItemcnt = "0";
    String sCorpcnt = "0";
    String sMindat = "";
    String sMaxdat = "";
    
    //��ʷ�������������Ҫ��ʾ����
    String hcorpcnt="0";
    String hitemcnt="0";
    String hMindat="";
    String hMaxdat="";
    
    String sAction = EAFunc.NVL( request.getParameter("action"),"");
    String sDat = EAFunc.NVL( request.getParameter("DAT"),"");
    String divide=EAFunc.NVL( request.getParameter("divide"),"");
    String type=EAFunc.NVL( request.getParameter("type"),"1");
    String bascat1ab=EAFunc.NVL( request.getParameter("bascat1ab"),"B");
 
    
    String sNewPriceCount = "0";  // �������µ��۵ļ�¼��
    String sOldPriceCount = "0";  // �������ϵ��۵ļ�¼��

    String sStartTime =  EAFunc.NVL( request.getParameter("STARTTIME"),""); ;
    String sEndTime = EAFunc.NVL( request.getParameter("ENDTIME"),""); ;
    String sLocList= "";
    String sBascat1ABList = "";
    String sNextDat = "";
    String sRelease = "";
    SCInterceptor SCI=new SCInterceptor();
    sRelease = SCI.GetRelease();
    try {
      db = new EADatabase();
      EAXmlDS ds=null;
      sNextDat = db.GetSQL( "select to_char(sysdate+1,'yyyy-mm-dd') dat from dual" );

      if ( sDat.length() == 0 ) {
      	sDat = sNextDat ;
      }
      if (!sDat .equalsIgnoreCase(sNextDat )) {
      	throw new EAException( "���ڱ���������" );
      }
      sNewPriceCount = db.GetSQL("SELECT COUNT(*) FROM CORPITEM WHERE PRICE IS NOT NULL");      
      sOldPriceCount = db.GetSQL("SELECT COUNT(*) FROM CORPITEM WHERE NOTE IS NOT NULL");      
      if ( sAction.equalsIgnoreCase("backup") ) 
      {
         sql="insert into curordbak(guid,item,corp,qty,crtdat,crtusr,sctype,acc,corpsoid) select guid,item,corp,qty,crtdat,crtusr,sctype,acc,corpsoid from curord";
         db.ExcecutSQL(sql); 
         out.println( "...���ݳɹ�������" );
      }
      else if ( sAction.equalsIgnoreCase("start") ) 
      {
         int t,t2;
         
         sql="select to_char(sysdate+1,'yyyy-mm-dd') dat from dual";
         ds=db.QuerySQL(sql);
         
           t=SCI.Import(db,usrid,sDat,bascat1ab);
           if(t==0)
           {
               out.println( "<script language='javascript'>alert('�Բ��𣬵�ǰ����û�к��ʵ�����');</script>" );
           }
           else
           {
               
               out.println( "<script language='javascript'>alert('�����ɹ�,������"+t+"����¼');</script>" );
           }
         
      }
      else if ( sAction.equalsIgnoreCase("divide") ) 
      {
         int t,t2;
         
         t2=SCI.Trans(db,sDat,bascat1ab,usrid);
         if(t2==-1)
         {
            out.println( "<script language='javascript'>alert('��ʾ�������в��ּ�¼û�в���ͻ����ţ�����ϵ����ά����Ա���д���');</script>" );
         }
         else if ( t2==0 ) 
            out.println( "<script language='javascript'>alert('��ʾ��û�пɲ�ֵļ�¼��');</script>" );
         else
         {
            out.println( "<script language='javascript'>alert('�����ɹ�,�����"+t2+"����¼!');</script>" );
         }
      }
      else if ( sAction.equalsIgnoreCase("export") ) 
      {
         int t,t2;
         
         
         t2=SCI.movhisord(db,acc,syt,org,sDat,request,bascat1ab);
         if(t2==0)
         {
             out.println( "<script language='javascript'>alert('û���ҵ�������ݣ�');</script>" );
         }
         else
         {
             out.println( "<script language='javascript'>alert('�����ɹ�,����"+t2+"����¼���뵽�ͻ������ݿ�!');</script>" );
         }      
      }
      else if ( sAction.equalsIgnoreCase("settime") ) 
      {
        if (bascat1ab.length()== 0 ){
		out.println( "��ѡ������AB����" );
        }
 	 else {
	        String sql1 = "update param set name='"+sStartTime+"' where typ='MOBILETIME' and id='START"+bascat1ab+"'";
	        String sql2 = "update param set name='"+sEndTime+"' where typ='MOBILETIME' and id='END"+bascat1ab+"'";
	        int myret= db.ExcecutSQL(sql1);
	        if ( myret == 0 ) {
	        	db.ExcecutSQL("INSERT INTO PARAM(ID,NAME,TYP) VALUES('START"+bascat1ab+"','','MOBILETIME')");
	        	db.ExcecutSQL(sql1);
	        }
	        myret= db.ExcecutSQL(sql2);
	        if ( myret == 0 ) {
	        	db.ExcecutSQL("INSERT INTO PARAM(ID,NAME,TYP) VALUES('END"+bascat1ab+"','','MOBILETIME')");
	        	db.ExcecutSQL(sql2);
	        }
       	 out.println( "�����ֻ�����ʱ�䷶Χ�ɹ�!" );
        }
      }
      else if ( sAction.equalsIgnoreCase("bilhdr_sum") ) // ��bilhdr���
      {
        //String t1 = 
        String sql1 = "update bilhdr a set summny=(select sum(mny) from bildtl b where b.biltyp='SX' and a.bilid = b.bilid and a.acc=b.acc ) where biltyp='SX' and dat=to_date('"+sDat+"','YYYY-MM-DD')";
        String sql2 = "update bilhdr a set sumqty=(select sum(qty) from bildtl b where b.biltyp='SX' and a.bilid = b.bilid and a.acc=b.acc ) where biltyp='SX' and dat=to_date('"+sDat+"','YYYY-MM-DD')";
        db.ExcecutSQL(sql1);
        db.ExcecutSQL(sql2);
	  sql1="update bildtl a set refid3=(select extcat7 from corp b where a.corpid=b.id) where a.biltyp='SX' and subtyp='1' and dat=to_date('"+sDat+"','YYYY-MM-DD')";
	  sql2="update bildtl a set refid3=(select extcat8 from corp b where a.corpid=b.id) where a.biltyp='SX' and subtyp='2' and dat=to_date('"+sDat+"','YYYY-MM-DD')";
        db.ExcecutSQL(sql1);
        db.ExcecutSQL(sql2);
        out.println( "���û�������!" );
        EAFunc.Log("���û�������"+sDat);
      }
      //����ط���ȡ��ÿ����������ƣ���������������¼��ʱ���Լ����¼��ʱ�䣡
      sql="select count(distinct corp) cnt from curord ";
      ds = db.QuerySQL(sql);
      if ( ds.getRowCount() > 0 ) {
        sCorpcnt = ds.getStringAt(0,"cnt");
      }
      sql="select count(distinct item) cnt from curord ";
      ds = db.QuerySQL(sql);
      if ( ds.getRowCount() > 0 ) {
        sItemcnt = ds.getStringAt(0,"cnt");
      }
      sql="select to_char(min(CRTDAT),'YYYY-MM-DD hh24:mi') mindat,to_char(max(CRTDAT),'YYYY-MM-DD hh24:mi') maxdat FROM curord ";
      ds = db.QuerySQL(sql);
      if ( ds.getRowCount() > 0 ) {
        sMindat = ds.getStringAt(0,"mindat");
        sMaxdat = ds.getStringAt(0,"maxdat");
      }
     
      ds.clearDS();
      
      //����ط���ȡ����ʷ�����������������������������¼��ʱ���Լ����¼��ʱ�䣡
      sql="select count(distinct corp) cnt from hisord where dat=to_date('"+sDat+"','YYYY-MM-DD')";
      ds = db.QuerySQL(sql);
      if ( ds.getRowCount() > 0 ) {
        hcorpcnt = ds.getStringAt(0,"cnt");
      }
      sql="select count(distinct item) cnt from hisord where dat=to_date('"+sDat+"','YYYY-MM-DD')";
      ds = db.QuerySQL(sql);
      if ( ds.getRowCount() > 0 ) {
        hitemcnt = ds.getStringAt(0,"cnt");
      }
      /*
      sql="select to_char(min(crtdat),'YYYY-MM-DD hh24:mi') mindat,to_char(max(crtdat),'YYYY-MM-DD hh24:mi') maxdat FROM hisord where to_date(to_char(crtdat))=to_date('"+sDat+"','YYYY-MM-DD')";
      ds = db.QuerySQL(sql);
      if ( ds.getRowCount() > 0 ) {
        hMindat = ds.getStringAt(0,"mindat");
        hMaxdat = ds.getStringAt(0,"maxdat");
      }
      */
      // �õ��ֻ��������Կ�ʼ��ʱ��
      EAXmlDS timeds = db.QuerySQL("select * from param where typ='MOBILETIME'");
      for ( int i=0;i<timeds.getRowCount();i++) {
          String id=timeds.getStringAt(i,"ID");
          String name=timeds.getStringAt(i,"NAME");
          if ( id.equalsIgnoreCase("START"+bascat1ab)  ) 
            sStartTime= name;
          else if ( id.equalsIgnoreCase("END"+bascat1ab) ) 
            sEndTime = name;
      }      

      ds = db.QuerySQL("SELECT ID,NAME FROM V_LOC");
      for ( int i=0;i<ds.getRowCount();i++) {
        sLocList+="<OPTION VALUE=\""+ds.getStringAt(i,"ID")+"\" >"+ds.getStringAt(i,"NAME") ;
      }
	  
      //ds = db.QuerySQL("SELECT ID,NAME FROM V_CORPBASCAT1");
	ds = db.QuerySQL("SELECT ID,NAME FROM V_AB order by id desc");

      for ( int i=0;i<ds.getRowCount();i++) {
      
        sBascat1ABList+="<OPTION VALUE=\""+ds.getStringAt(i,"ID")+"\" ";
        
        if ( bascat1ab.equals( ds.getStringAt(i,"ID") ) ) sBascat1ABList += " selected ";
	sBascat1ABList+=">"+ds.getStringAt(i,"NAME") ;
      }

      db.Close();
   
    }
    catch ( EAException e ) {
      if ( db!=null ) db.Rollback(); 
      out.println( e.toString() );
      //throw e;
    }
    finally {
      if ( db!=null ) db.Close(); 
    }    
%>

<html>
<LINK REL=STYLESHEET TYPE='text/css' HREF='../xlsgrid/css/main.css'>
  <SCRIPT LANGUAGE=javascript>
    function f_export_dat()
      {
          var url = 'divide.jsp?dat='+form1.DAT.value+'&type='+form1.type.value;
          window.open(url);
      }
      // backup
    function f_backup() 
    {  
      //alert("hello world");
      form1.action.value="backup";
      form1.submit();
    }    
     // �����
    function f_divide() 
    {  
      //alert("hello world");
      form1.action.value="divide";
      form1.submit();
    }
    // ����ʱ��
    function f_set_time()
    {
      form1.action.value="settime";
      form1.submit();    
    }
    // ����ʱ��
    function f_sendmsg()
    {
	locid = document.all("locid").value;
	type = document.all("type").value;
	dat = document.all("dat").value;
       bascat1ab = document.all("bascat1ab").value ;
	window.open( "../show.sp?grdid=SendSXToShip&locid="+locid+"&type="+type+"&dat="+dat+"&bascat1ab="+bascat1ab ,"","height=450,width=600,toolbar=no,location=no,status=yes,resizable=yes,top=50,left=112" );
    }
    // ����ʱ��
    function f_checkbill()
    {
	dat = document.all("dat").value;
	window.open( "../xlsgrid/jsp/pages/listbill.jsp?&grdid=SX&action=check&where= AND REFNAM2=2 and stat='1' AND DAT=to_date('"+dat+"','YYYY-MM-DD') " ,"","height=450,width=600,toolbar=no,location=no,status=yes,resizable=yes,top=50,left=112" );
    }
    
    function f_export_hisord()
    {
       //alert("hello world");
       form1.action.value="export";
       form1.submit();
    }
    //�ͻ���ȡ��
    function f_hisord_qz()
    {
              //window.open( "../show.sp?grdid=HisordCheck&DAT="+document.all("dat").value );
       window.open( "../show.sp?grdid=HisordCheck&DAT="+document.all("dat").value+"&ABTYPE="+document.all("bascat1ab").value);	
    } 
    //�ͻ���ȡ��
    function f_update_bilhdr_sum()
    {
       //alert("hello world");
       form1.action.value="bilhdr_sum";
       form1.submit();
    }     
    function f_export_bil()
      {
          var url = 'export.jsp?dat='+form1.DAT.value+'&type='+form1.type.value;
          window.open(url);
      }
 </script>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=GBK">
    <title></title>
  </head>
  <body>
  <table width="100%" border="0" cellpadding="10">
  <tr>
     <td colspan="2" align="center">
        <br>
        <h3>�� �� �� �� �� <%=sRelease%></h3>
        <hr/>
      </td>
  </tr>
  <tr>
      <td>
      <P> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ǰ������״̬��</P>
      <UL>
        <LI>
          <P>&nbsp;&nbsp;&nbsp; ��������������
          <%=sCorpcnt%>
          </P>
        </LI>
        <LI>
          <P>&nbsp;&nbsp;&nbsp; ������Ʒ������
            <%= sItemcnt%>&nbsp;
          </P>
        </LI>
        <LI>
          <P>&nbsp;&nbsp;&nbsp; ����¼��ʱ�䣺
          <%=sMindat%>
            <br/>
          </P>
        </LI>
        <LI>
          <P>&nbsp;&nbsp;&nbsp; ���¼��ʱ�䣺
          <%=sMaxdat%>
            <br/>
          </P>
        </LI>
      </UL>
      <hr/>
      </td>
      
      <td>
      <P> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sDat%>��ʷ������״̬��</P>
      <UL>
        <LI>
          <P>&nbsp;&nbsp;&nbsp; ��������������
          <%=hcorpcnt%>
          </P>
        </LI>
        <LI>
          <P>&nbsp;&nbsp;&nbsp; ������Ʒ������
            <%= hitemcnt%>&nbsp;
          </P>
        </LI>
        <LI>
          <P>&nbsp;&nbsp;&nbsp; ����¼��ʱ�䣺
          <%=hMindat%>
            <br/>
          </P>
        </LI>
        <LI>
          <P>&nbsp;&nbsp;&nbsp; ���¼��ʱ�䣺
          <%=hMaxdat%>
            <br/>
          </P>
        </LI>
      </UL>
      <hr/>
      </td>
  </tr>
  
  <tr>
    <td colspan=2>
      <form name="form1" method="POST">
        <input  type="hidden" name="action" value="start"  >
        <P align="center">
     
      <SCRIPT LANGUAGE=javascript>
      <!--
      function sel_DATE1() 
      {
          var ret   = window.showModalDialog( "../xlsgrid/jsp/pages/calendardlg.htm","" , "dialogwidth:150pt;dialogheight:150pt" ); 
          if ( ret != null &&  ret != "" )
          {
          form1.DAT.value = ret ; 
          }
      }
    //-->
    </SCRIPT>���ݿ��ж���ĵ��۵���Ʒ��<%=sNewPriceCount%>������������ϵͳ���۵Ĺ�<%=sOldPriceCount%>��,����ȷ�ϣ�
</P>
<P align="center">�ͻ����ڣ�(Ĭ������)
  <input type="text" name="DAT" size="20" value="<%=sDat%>"/>
  <img src="../xlsgrid/images/forderopen.gif" onclick="javascript:sel_DATE1();" onmouseover=" this.style.cursor='hand'; title='���ѡ������'"/>&nbsp;&nbsp;
         ѡ��
           <SELECT NAME="type"  style="width:100 ">
��������    <OPTION VALUE="1" <%if(type.equals("1"))out.println("selected='selected'"); %>>&nbsp;&nbsp;��&nbsp;&nbsp;��
��������    <OPTION VALUE="2" <%if(type.equals("2"))out.println("selected='selected'"); %>>&nbsp;&nbsp;��&nbsp;&nbsp;��
           </SELECT>
         &nbsp;����AB���ࣺ<SELECT NAME="bascat1ab"  style="width:100 ">
��������    <%=sBascat1ABList%>
           </SELECT>
           <input type="button" onclick="javascript:window.location='etl.jsp?DAT='+form1.DAT.value+'&type='+form1.type.value+'&bascat1ab='+form1.bascat1ab.value;" name="button2" size="40" value="  ˢ�� " ><br> <br>
           <input type="button" onclick="javascript:f_backup();" name="com_backup" size="40" value="���ݵ�ǰ�ֻ���"/>&nbsp;
           </P>
		<P align="center">���¶�����˳����ɣ������ֳ�����</P>
		<P align="center">
           <input type="submit" name="button1" size="40" value="����"/> <input type="button" onclick="javascript:f_divide();" name="button3" size="40" value="���" >
           <input type="button" onclick="javascript:f_hisord_qz();" name="button12" size=40 value="�ͻ���ȡ��">

           <input type="button" onclick="javascript:f_export_hisord();" name="button13" size=40 value="���������ͻ���">&nbsp;
           <!--           <input type="button" onclick="javascript:f_export_dat();" name="button2" size="40" value="  �������� " > -->
                      <p align='center'>

           <input type="button" onclick="javascript:f_checkbill();" name="button4" size=40 value="�ֻ������ͻ������">���������ͻ�������δ�˵�
           

                      <p align='center'>
           <input type="button" onclick="javascript:f_update_bilhdr_sum();" name="button4" size=40 value="��������">ע��:�ڷ��͵�����֮ǰ,һ����Ҫ©���������!!!</P>
			</P>
		<P align="center">
&nbsp;<!--<input type="button" onclick="javascript:f_export_bil();" name="button5" size="40" value="  �����ͻ��� " >&nbsp;--><SELECT NAME="locid" id="locid" style="width:100 ">
            <%=sLocList%>
           </SELECT>
		<BR>
           <input type="button" name="button11" onclick="javascript:f_sendmsg();" size="40" value="����֪ͨ�����������ѽ���"/>
        	���������ߣ�</P>
        <P align="center">��<input type="text" name="STARTTIME" id="STARTTIME" size="8" value="<%=sStartTime%>"/> �� <input type="text" name="ENDTIME" id="ENDTIME" size="8" value="<%=sEndTime%>"/>���ܽ��б���<input type="button" name="button10" onclick="javascript:f_set_time();" size="40" value="����"/></P>
        <P align="center">˵���������ʽ��6λ���֣����171500��180000��ʾÿ�����ʱ����17:15:00����18:00:00����</P>
		<P align="center">���ڲ�ͬ�����ߣ�������ѡ������AB�����ʱ�򣬵�ˢ�°�ť���쿴�����ߵĹ���ʱ��</P>
       </form>
      </td>
 </tr>
 
 <tr>
      <td colspan=2>
      <P>˵����</P>
      <P>
        <BR/><b>�������ԭ��
      </b>
      </P>
      <P>&nbsp;&nbsp;&nbsp; 1. ���߳��˱�����KA�����ж������ͷ�ʽΪ��<font color="#FF0000">��������������</font>�����������⣬�����ͻ����ĳ��º͵��²�Ʒ����ֿ���
        <BR/>&nbsp;&nbsp;&nbsp; 2. KA�����ж����ˡ�<font color="#FF0000">�Ƿ���˰��</font>��Ϊ1����������С���������
		���ģ��ͻ�����13��17˰�ʵĲ�Ʒ����ֿ���
        <BR/>&nbsp;&nbsp;&nbsp; 3. ���ڱ����ͷǱ�������, �ͻ���ÿ�������ʾ5��,���ڷǱ������� ����ÿ�������ʾ14�У�
        <BR/>&nbsp;&nbsp;&nbsp; 3. KA�����ж�����&quot;<font color="#FF0000">�ͻ�����ʾ˰�ʱ�־</font>&quot;��
		�����ǳ����ͻ���ÿ�������ʾ5�У�����ÿ�������ʾ7�У������ͻ���ÿ�������ʾ14�У�
        <BR/>&nbsp;&nbsp;&nbsp; 4. ���º͵��������ͻ�����ע(���������ͣ���������۶�������ע�ǿգ�����Ϊ���͵�����)�����ݵ��������ݵı���ֿ���
        <BR/>
      </P>
      <P><b>�ͻ�����ŷ�����</b></P>
      <P>&nbsp;&nbsp;&nbsp; �ͻ�����ǰ2λ��3λ��ʶ���λ��������̬�ģ��������ˮ��λ���ݶ�7λ�����м����»��߸�������M1_0001111.�����ͻ�����ǰ��һ��ǰ׺E,Ŀ�������������ڵ��ͻ������ظ�����EY1��EM4��ÿ����ͬһ��̬�ĺ��������������ϵͳ�Զ����ɡ�
        <BR/>
      ��ͬ��λ���ͻ����������š������������ͻ����ͱ����ͻ����������ĸ���Ŀ�λ���¿ص�Ϊ������ݣ��ֱ�ΪM1��M2��M3��M4��Y1��Y2��Y3��Y4��BL1��BL2��BL3��BL4��</P>
      <P><b>�����ͻ�����ʽ��</b></P>�ͻ���ID����Ʒ���롢���ۡ���Ʒ��������λ����ע��˰�ʡ���񡢿ͻ�ID������·�߱��롢�ͻ����ڡ��Է��������롢˵���������⡢�Ƶ��ˡ�����Ա���Ƶ����ڡ��ջ�����
      <BR/>
      <blockquote>
        <P/>
      </blockquote>
      <P>��</P>
      <P>��</P>
      <P>��</P>
  

  </td>
  </tr>  
</table >
</body>
</html>