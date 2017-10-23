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
    //当前订单库的相关要显示的量
    String sItemcnt = "0";
    String sCorpcnt = "0";
    String sMindat = "";
    String sMaxdat = "";
    
    //历史订单库中相关需要显示的量
    String hcorpcnt="0";
    String hitemcnt="0";
    String hMindat="";
    String hMaxdat="";
    
    String sAction = EAFunc.NVL( request.getParameter("action"),"");
    String sDat = EAFunc.NVL( request.getParameter("DAT"),"");
    String divide=EAFunc.NVL( request.getParameter("divide"),"");
    String type=EAFunc.NVL( request.getParameter("type"),"1");
    String bascat1ab=EAFunc.NVL( request.getParameter("bascat1ab"),"B");
 
    
    String sNewPriceCount = "0";  // 定义了新单价的纪录数
    String sOldPriceCount = "0";  // 定义了老单价的纪录数

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
      	throw new EAException( "日期必须是明天" );
      }
      sNewPriceCount = db.GetSQL("SELECT COUNT(*) FROM CORPITEM WHERE PRICE IS NOT NULL");      
      sOldPriceCount = db.GetSQL("SELECT COUNT(*) FROM CORPITEM WHERE NOTE IS NOT NULL");      
      if ( sAction.equalsIgnoreCase("backup") ) 
      {
         sql="insert into curordbak(guid,item,corp,qty,crtdat,crtusr,sctype,acc,corpsoid) select guid,item,corp,qty,crtdat,crtusr,sctype,acc,corpsoid from curord";
         db.ExcecutSQL(sql); 
         out.println( "...备份成功！！！" );
      }
      else if ( sAction.equalsIgnoreCase("start") ) 
      {
         int t,t2;
         
         sql="select to_char(sysdate+1,'yyyy-mm-dd') dat from dual";
         ds=db.QuerySQL(sql);
         
           t=SCI.Import(db,usrid,sDat,bascat1ab);
           if(t==0)
           {
               out.println( "<script language='javascript'>alert('对不起，当前库中没有合适的数据');</script>" );
           }
           else
           {
               
               out.println( "<script language='javascript'>alert('操作成功,导入了"+t+"条记录');</script>" );
           }
         
      }
      else if ( sAction.equalsIgnoreCase("divide") ) 
      {
         int t,t2;
         
         t2=SCI.Trans(db,sDat,bascat1ab,usrid);
         if(t2==-1)
         {
            out.println( "<script language='javascript'>alert('提示：发现有部分记录没有拆分送货单号，请联系技术维护人员进行处理！');</script>" );
         }
         else if ( t2==0 ) 
            out.println( "<script language='javascript'>alert('提示：没有可拆分的记录！');</script>" );
         else
         {
            out.println( "<script language='javascript'>alert('操作成功,拆分了"+t2+"条记录!');</script>" );
         }
      }
      else if ( sAction.equalsIgnoreCase("export") ) 
      {
         int t,t2;
         
         
         t2=SCI.movhisord(db,acc,syt,org,sDat,request,bascat1ab);
         if(t2==0)
         {
             out.println( "<script language='javascript'>alert('没有找到相关数据！');</script>" );
         }
         else
         {
             out.println( "<script language='javascript'>alert('操作成功,共有"+t2+"条记录插入到送货单数据库!');</script>" );
         }      
      }
      else if ( sAction.equalsIgnoreCase("settime") ) 
      {
        if (bascat1ab.length()== 0 ){
		out.println( "请选择条线AB分类" );
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
       	 out.println( "设置手机报单时间范围成功!" );
        }
      }
      else if ( sAction.equalsIgnoreCase("bilhdr_sum") ) // 给bilhdr求和
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
        out.println( "设置划单结束!" );
        EAFunc.Log("设置划单结束"+sDat);
      }
      //这个地方是取得每个网点的名称，订单的数量，早录入时间以及最后录入时间！
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
      
      //这个地方是取得历史订单网点的数量，订单的数量，早录入时间以及最后录入时间！
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
      // 得到手机报单可以开始的时间
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
     // 仅拆分
    function f_divide() 
    {  
      //alert("hello world");
      form1.action.value="divide";
      form1.submit();
    }
    // 设置时间
    function f_set_time()
    {
      form1.action.value="settime";
      form1.submit();    
    }
    // 设置时间
    function f_sendmsg()
    {
	locid = document.all("locid").value;
	type = document.all("type").value;
	dat = document.all("dat").value;
       bascat1ab = document.all("bascat1ab").value ;
	window.open( "../show.sp?grdid=SendSXToShip&locid="+locid+"&type="+type+"&dat="+dat+"&bascat1ab="+bascat1ab ,"","height=450,width=600,toolbar=no,location=no,status=yes,resizable=yes,top=50,left=112" );
    }
    // 设置时间
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
    //送货单取整
    function f_hisord_qz()
    {
              //window.open( "../show.sp?grdid=HisordCheck&DAT="+document.all("dat").value );
       window.open( "../show.sp?grdid=HisordCheck&DAT="+document.all("dat").value+"&ABTYPE="+document.all("bascat1ab").value);	
    } 
    //送货单取整
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
        <h3>生 成 送 货 单 <%=sRelease%></h3>
        <hr/>
      </td>
  </tr>
  <tr>
      <td>
      <P> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;当前订单库状态表：</P>
      <UL>
        <LI>
          <P>&nbsp;&nbsp;&nbsp; 订单网点总数：
          <%=sCorpcnt%>
          </P>
        </LI>
        <LI>
          <P>&nbsp;&nbsp;&nbsp; 订单商品数量：
            <%= sItemcnt%>&nbsp;
          </P>
        </LI>
        <LI>
          <P>&nbsp;&nbsp;&nbsp; 最早录入时间：
          <%=sMindat%>
            <br/>
          </P>
        </LI>
        <LI>
          <P>&nbsp;&nbsp;&nbsp; 最迟录入时间：
          <%=sMaxdat%>
            <br/>
          </P>
        </LI>
      </UL>
      <hr/>
      </td>
      
      <td>
      <P> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=sDat%>历史订单库状态：</P>
      <UL>
        <LI>
          <P>&nbsp;&nbsp;&nbsp; 订单网点总数：
          <%=hcorpcnt%>
          </P>
        </LI>
        <LI>
          <P>&nbsp;&nbsp;&nbsp; 订单商品数量：
            <%= hitemcnt%>&nbsp;
          </P>
        </LI>
        <LI>
          <P>&nbsp;&nbsp;&nbsp; 最早录入时间：
          <%=hMindat%>
            <br/>
          </P>
        </LI>
        <LI>
          <P>&nbsp;&nbsp;&nbsp; 最迟录入时间：
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
    </SCRIPT>数据库中定义的单价的商品共<%=sNewPriceCount%>条，定义了老系统单价的共<%=sOldPriceCount%>条,请检查确认！
</P>
<P align="center">送货日期：(默认明天)
  <input type="text" name="DAT" size="20" value="<%=sDat%>"/>
  <img src="../xlsgrid/images/forderopen.gif" onclick="javascript:sel_DATE1();" onmouseover=" this.style.cursor='hand'; title='点击选择日期'"/>&nbsp;&nbsp;
         选择：
           <SELECT NAME="type"  style="width:100 ">
　　　　    <OPTION VALUE="1" <%if(type.equals("1"))out.println("selected='selected'"); %>>&nbsp;&nbsp;常&nbsp;&nbsp;温
　　　　    <OPTION VALUE="2" <%if(type.equals("2"))out.println("selected='selected'"); %>>&nbsp;&nbsp;冷&nbsp;&nbsp;链
           </SELECT>
         &nbsp;条线AB分类：<SELECT NAME="bascat1ab"  style="width:100 ">
　　　　    <%=sBascat1ABList%>
           </SELECT>
           <input type="button" onclick="javascript:window.location='etl.jsp?DAT='+form1.DAT.value+'&type='+form1.type.value+'&bascat1ab='+form1.bascat1ab.value;" name="button2" size="40" value="  刷新 " ><br> <br>
           <input type="button" onclick="javascript:f_backup();" name="com_backup" size="40" value="备份当前手机库"/>&nbsp;
           </P>
		<P align="center">以下动作按顺序完成，不区分常低温</P>
		<P align="center">
           <input type="submit" name="button1" size="40" value="导入"/> <input type="button" onclick="javascript:f_divide();" name="button3" size="40" value="拆分" >
           <input type="button" onclick="javascript:f_hisord_qz();" name="button12" size=40 value="送货单取整">

           <input type="button" onclick="javascript:f_export_hisord();" name="button13" size=40 value="批量生成送货单">&nbsp;
           <!--           <input type="button" onclick="javascript:f_export_dat();" name="button2" size="40" value="  导出数据 " > -->
                      <p align='center'>

           <input type="button" onclick="javascript:f_checkbill();" name="button4" size=40 value="手机自提送货单审核">自提生成送货单后是未核的
           

                      <p align='center'>
           <input type="button" onclick="javascript:f_update_bilhdr_sum();" name="button4" size=40 value="划单结束">注意:在发送到物流之前,一定不要漏做这个步骤!!!</P>
			</P>
		<P align="center">
&nbsp;<!--<input type="button" onclick="javascript:f_export_bil();" name="button5" size="40" value="  导出送货单 " >&nbsp;--><SELECT NAME="locid" id="locid" style="width:100 ">
            <%=sLocList%>
           </SELECT>
		<BR>
           <input type="button" name="button11" onclick="javascript:f_sendmsg();" size="40" value="发送通知到物流开单已结束"/>
        	（区分条线）</P>
        <P align="center">从<input type="text" name="STARTTIME" id="STARTTIME" size="8" value="<%=sStartTime%>"/> 到 <input type="text" name="ENDTIME" id="ENDTIME" size="8" value="<%=sEndTime%>"/>不能进行报单<input type="button" name="button10" onclick="javascript:f_set_time();" size="40" value="设置"/></P>
        <P align="center">说明：输入格式是6位数字，如从171500到180000表示每天关门时间是17:15:00，到18:00:00开门</P>
		<P align="center">对于不同的条线，可以在选择条线AB分类的时候，点刷新按钮，察看该条线的关门时间</P>
       </form>
      </td>
 </tr>
 
 <tr>
      <td colspan=2>
      <P>说明：</P>
      <P>
        <BR/><b>订单拆分原则：
      </b>
      </P>
      <P>&nbsp;&nbsp;&nbsp; 1. 条线除了便利（KA资料中定义配送方式为“<font color="#FF0000">便利纯冷链配送</font>”即便利）外，所有送货单的常温和低温产品必须分开；
        <BR/>&nbsp;&nbsp;&nbsp; 2. KA资料中定义了“<font color="#FF0000">是否拆分税率</font>”为1（如教育超市、华联超市
		）的，送货单对13和17税率的产品必须分开；
        <BR/>&nbsp;&nbsp;&nbsp; 3. 对于便利和非便利常温, 送货单每张最多显示5行,对于非便利低温 其余每张最多显示14行；
        <BR/>&nbsp;&nbsp;&nbsp; 3. KA资料中定义了&quot;<font color="#FF0000">送货单显示税率标志</font>&quot;的
		并且是常温送货单每张最多显示5行，其余每张最多显示7行，低温送货单每张最多显示14行；
        <BR/>&nbsp;&nbsp;&nbsp; 4. 常温和低温所有送货单备注(按订单类型，如果是销售订单，备注是空，否则为类型的名称)有内容的与无内容的必须分开。
        <BR/>
      </P>
      <P><b>送货单编号方法：</b></P>
      <P>&nbsp;&nbsp;&nbsp; 送货单的前2位或3位是识别库位和销售形态的，后面的流水号位数暂定7位数，中间以下划线隔开，如M1_0001111.所有送货单号前加一个前缀E,目的是与我们现在的送货单不重复。如EY1、EM4，每个库同一形态的号码必须相连，由系统自动生成。
        <BR/>
      不同库位的送货单不能联号。即常、低温送货单和便利送货单必须以四个库的库位和温控等为编号依据，分别为M1、M2、M3、M4、Y1、Y2、Y3、Y4、BL1、BL2、BL3、BL4。</P>
      <P><b>导出送货单格式：</b></P>送货单ID、产品简码、单价、产品数量、单位、备注、税率、规格、客户ID、配送路线编码、送货日期、对方订单号码、说明、出货库、制单人、报单员、制单日期、收货号码
      <BR/>
      <blockquote>
        <P/>
      </blockquote>
      <P>　</P>
      <P>　</P>
      <P>　</P>
  

  </td>
  </tr>  
</table >
</body>
</html>