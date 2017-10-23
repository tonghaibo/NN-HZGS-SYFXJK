<%@ page contentType="text/html;charset=GBK"%>
<%@ page import="java.io.*,com.xlsgrid.net.pub.*,com.xlsgrid.net.web.*,com.xlsgrid.net.tag.*,com.xlsgrid.net.xmldb.*" %>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=GBK">
    <title>送货单批量生成销售单</title>
    <LINK rel=stylesheet type=text/css HREF="../xlsgrid/css/main.css">
<SCRIPT LANGUAGE=javascript>
<!--
  function sel_keyvalue(key,obj1,obj2) 
  {
        var ret   = window.showModalDialog( "../xlsgrid/jsp/pages/selectBox.jsp?flag="+key, obj2 , "dialogwidth:650pt;dialogheight:420pt" ); 
        //ret='dkdk';
        if ( ret.value ) 
        {
        obj1.value = ret ; 
        // form1.id.value = ret ; 
        }
  }
   
  function sel_DATE1() 
  {
        var ret   = window.showModalDialog( "../xlsgrid/jsp/pages/calendardlg.htm","" , "dialogwidth:150pt;dialogheight:150pt" ); 
        if ( ret != null &&  ret != "" )
        {
            form1.DAT.value = ret ; 
         }
  }
  
  function batchconv()
  {
       if(!form1.KA.value)
        {
          alert("请先选择一个KA");
          return;
        }
        if(!form1.DAT.value)
        {
          alert("请选择日期");
          return;
        }
        
       datflwframe._this.XMLDS_SetCurrentDsID(datflwframe.xmlds);
       var param = new Object;
       param.bilflwid = 'SX2SO';
       param.KA=form1.KA.value;
       param.dat=form1.DAT.value;
      // alert(param.KA+param.dat);
       param.bilxml = datflwframe._this.XMLDS_GetXml();       
      // var msg = datflwframe.invokeOSFuncExt("batchconv",param);        
  }   
  
  function query()
  {
    //datflwframe.filter();
     //where = window.showModalDialog(vurl ,param, "dialogwidth:480pt;dialogheight:400pt;resizable:yes ;");
    
    var tem=form1.KA.value;
   
    
    datflwframe.where ="and refid1=\'"+form1.KA.value+"\' and srcbildat=to_date(\'"+form1.DAT.value+"\'"+",\'"+"yyyy-mm-dd"+"\')";
   // alert(datflwframe.where);
    if(!datflwframe.where)
    return;
    datflwframe.curpage = 1;
    datflwframe.clearolddata();
    datflwframe.loaddatflw();
  }   
  
  function windowonload()
  {
        
        datflwframe.location = "../ShowXlsGrid.sp?grdid=SelBilFlw&sytid=x&datflw=SD2SU&callfunc=manquery&forceMappedmode=0"; 
  } 
//-->
</SCRIPT>
</head>

<body onload="windowonload()">  
<center>
<table border="0" width="98%" height="95%" cellspacing="0" cellpadding="0">
   <tr>
    <td height="32" >
      <table border="0" width="100%" id="table4" cellspacing="0" >
        <tr>
          <td align='center'>
          <form name="form1" >
            <font color="#4791C5">             
            KA:<select id="KA" name="KA">
            <%
            EADatabase db = null;
            String id=null;
            String name=null;
            
            try
            {
               EAXmlDS ds=null;
             
               db = new EADatabase();
               String sql="select distinct id,id||' '||name from v_ka ";
               ds=db.QuerySQL(sql);
               for(int  i=0;i<ds.getRowCount();i++)
               {
                 id=ds.getStringAt(i,0);
                 name=ds.getStringAt(i,1);
                 out.print("<option value="+id+" >"+name+" </option>");
               }
               
            }
             catch ( EAException e )
             {
                 if ( db!=null ) db.Rollback(); 
                 throw e;
             }
             finally 
             {
               if ( db!=null ) db.Close(); 
             }    
              %>  
            </select>
            日期：<input type="text" name="DAT" size="20" />
            <img src="../xlsgrid/images/forderopen.gif" onclick="javascript:sel_DATE1();" onmouseover=" this.style.cursor='hand'; title='点击选择日期'"/>&nbsp;&nbsp;
           
            <input type=button onclick="query();" value="条件查询" />
            <input type=button onclick="batchconv();" value="批量转换" />
            </font>
            </br>
            </form>
          </td>
        </tr>
      </table>
  </td>
 </tr>
 <tr>
   <td>
     <iframe id=datflwframe frameborder=0 width="100%" height="100%"></iframe>
   </td>
 </tr>
</table>
</center>
</body>
</html>