function x_html_test(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var tag = new JavaPackage("com.xlsgrid.net.tag");
var xmldsform = new tag.XmlDSForm();
var EAfunc = new pubpack.EAFunc();
//��Ϊ.sp����ʱ�����
//Ԥ���������request,response
function Response()
{
  var ret = "<script language = 'javascript'>
	    	    	function showInfo(str)
	    	    	{
	    	    		for(var i = 0;i <  6;i ++)
	    	    			document.getElementById('topic'+i).style.display = 'none';
	    	    		document.getElementById(str).style.display = 'block';
	    	    	}
	    	    </script>
	    	   <body background='xlsgrid/images/bk.gif'><table>
				<tr>
					<td  align = 'left' style='font-size:13px'  style='cursor:pointer;' onclick='showInfo('topic0')'>�����ڲ�ѯ</td>
				</tr>
				<tr id = topic0 
			    ><td><form name = f0 method='post' action='show.sp?grdid=DIMREP_PC' Target='_right'> 
<LINK rel=stylesheet type=text/css HREF='xlsgrid/css/main-right.css'> 
<script language='javascript' src='xlsgrid/js/main.js' ></Script> 
<table width='100%' border='0' cellpadding='0' cellspacing='1' bgcolor='000000'><tr><td>
<table align='center' border='0' width='100%' cellspacing=1 cellpadding=4 class='EAGRID-TABLE' >
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��ʼ���ڣ�</td>
<td class='EARID-TD' align=left ><SCRIPT LANGUAGE=javascript>
<!--
function sel_STADAT0() {
  var ret   = window.showModalDialog( '/xlsgrid/xlsgrid/jsp/pages/calendardlg.htm','' , 'dialogwidth:150pt;dialogheight:150pt' ); 
  if ( ret != null &&  ret != '' ) {
    f0.STADAT0.value = ret ; 
  }
}
//-->
</SCRIPT>
<input type=text name=STADAT0 size=20 value='2010-11-18' style='width:90;'/>
<img  src='/xlsgrid/xlsgrid/images/forderopen.gif' onclick='javascript:sel_STADAT0();' onmouseover=' this.style.cursor='hand'; title='���ѡ������''>
&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��ֹ���ڣ�</td>
<td class='EARID-TD' align=left ><SCRIPT LANGUAGE=javascript>
<!--
function sel_ENDDAT0() {
  var ret   = window.showModalDialog( '/xlsgrid/xlsgrid/jsp/pages/calendardlg.htm','' , 'dialogwidth:150pt;dialogheight:150pt' ); 
  if ( ret != null &&  ret != '' ) {
    f0.ENDDAT0.value = ret ; 
  }
}
//-->
</SCRIPT>
<input type=text name=ENDDAT0 size=20 value='2010-11-18' style='width:90;'/>
<img  src='/xlsgrid/xlsgrid/images/forderopen.gif' onclick='javascript:sel_ENDDAT0();' onmouseover=' this.style.cursor='hand'; title='���ѡ������''>
&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��Ʒ��ţ�</td>
<td class='EARID-TD' align=left >
<input type='text' name='��Ʒ���0' id='��Ʒ���0' onchange='javacript:SELECTID_ONCHANGE('��Ʒ���0','V_ITEMnam','V_ITEM','xlsgrid-zlt369n','80','/xlsgrid','');' size=20 value=''  style='width:90;'/>
<img onclick='SELECTID_POPWIN('��Ʒ���0','��Ʒ���0nam','V_ITEM','',1,'xlsgrid-zlt369n','80','/xlsgrid','')' onmouseover=' this.style.cursor='hand'; title='ѡ��'' src='/xlsgrid/xlsgrid/images/forderopen.gif' >
<span  name='��Ʒ���0nam' id='��Ʒ���0nam' />&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>������</td>
<td class='EARID-TD' align=left >
<input type='text' name='KA0' id='KA0' onchange='javacript:SELECTID_ONCHANGE('KA0','V_KAnam','V_KA','xlsgrid-zlt369n','80','/xlsgrid','');' size=20 value=''  style='width:90;'/>
<img onclick='SELECTID_POPWIN('KA0','KA0nam','V_KA','',1,'xlsgrid-zlt369n','80','/xlsgrid','')' onmouseover=' this.style.cursor='hand'; title='ѡ��'' src='/xlsgrid/xlsgrid/images/forderopen.gif' >
<span  name='KA0nam' id='KA0nam' />&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��Ʒϵ�У�</td>
<td class='EARID-TD' align=left >
<input type=text name=��Ʒϵ��0 size=20 value='' style='width:90;'/>&nbsp;&nbsp;
</td>
</TABLE>

</td></tr></TABLE>
<br><br><table width='100%' border='0' cellpadding='0' cellspacing='1' >
	            		<tr>
	            		    <td>
	            		    	<input type = 'hidden' id = 'topic' name = 'topic' value = SX1>
	            		    </td>
	            		</tr>
	            		<tr>
	            		    <td>
	            		    	<input type = 'hidden' id = 'sytid' name = 'sytid' value = XLSGRID>
	            		    </td>
	            		</tr>
	            		<tr>
	            		    <td></td>
	            		    <td align = 'right'><input type = 'submit' value = '��ѯ' ></td>
	            		    <!--
	          		    <td align = 'right'><input type = 'button' value = '��ѯ' onclick = 'window.open('show.sp?grdid=DIMREP_PC&topic=SX1&sytid=XLSGRID','_right');'></td>
	          		    -->
	            		</tr>
	            	    </table>
	            	 </form>
	            	 </td>
	            	 </tr>
				<tr>
					<td  align = 'left' style='font-size:13px'  style='cursor:pointer;' onclick='showInfo('topic1')'>���۰���Ʒͳ��</td>
				</tr>
				<tr id = topic1 
			     style='display:none;'><td><form name = f2 method='post' action='show.sp?grdid=DIMREP_PC' Target='_right'> 
<LINK rel=stylesheet type=text/css HREF='xlsgrid/css/main-right.css'> 
<script language='javascript' src='xlsgrid/js/main.js' ></Script> 
<table width='100%' border='0' cellpadding='0' cellspacing='1' bgcolor='000000'><tr><td>
<table align='center' border='0' width='100%' cellspacing=1 cellpadding=4 class='EAGRID-TABLE' >
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��ʼ���ڣ�</td>
<td class='EARID-TD' align=left ><SCRIPT LANGUAGE=javascript>
<!--
function sel_STADAT1() {
  var ret   = window.showModalDialog( '/xlsgrid/xlsgrid/jsp/pages/calendardlg.htm','' , 'dialogwidth:150pt;dialogheight:150pt' ); 
  if ( ret != null &&  ret != '' ) {
    f2.STADAT1.value = ret ; 
  }
}
//-->
</SCRIPT>
<input type=text name=STADAT1 size=20 value='2010-11-18' style='width:90;'/>
<img  src='/xlsgrid/xlsgrid/images/forderopen.gif' onclick='javascript:sel_STADAT1();' onmouseover=' this.style.cursor='hand'; title='���ѡ������''>
&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��ֹ���ڣ�</td>
<td class='EARID-TD' align=left ><SCRIPT LANGUAGE=javascript>
<!--
function sel_ENDDAT1() {
  var ret   = window.showModalDialog( '/xlsgrid/xlsgrid/jsp/pages/calendardlg.htm','' , 'dialogwidth:150pt;dialogheight:150pt' ); 
  if ( ret != null &&  ret != '' ) {
    f2.ENDDAT1.value = ret ; 
  }
}
//-->
</SCRIPT>
<input type=text name=ENDDAT1 size=20 value='2010-11-18' style='width:90;'/>
<img  src='/xlsgrid/xlsgrid/images/forderopen.gif' onclick='javascript:sel_ENDDAT1();' onmouseover=' this.style.cursor='hand'; title='���ѡ������''>
&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��Ʒ��ţ�</td>
<td class='EARID-TD' align=left >
<input type='text' name='��Ʒ���1' id='��Ʒ���1' onchange='javacript:SELECTID_ONCHANGE('��Ʒ���1','V_ITEMnam','V_ITEM','xlsgrid-zlt369n','80','/xlsgrid','');' size=20 value=''  style='width:90;'/>
<img onclick='SELECTID_POPWIN('��Ʒ���1','��Ʒ���1nam','V_ITEM','',1,'xlsgrid-zlt369n','80','/xlsgrid','')' onmouseover=' this.style.cursor='hand'; title='ѡ��'' src='/xlsgrid/xlsgrid/images/forderopen.gif' >
<span  name='��Ʒ���1nam' id='��Ʒ���1nam' />&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>������</td>
<td class='EARID-TD' align=left >
<input type='text' name='KA1' id='KA1' onchange='javacript:SELECTID_ONCHANGE('KA1','V_KAnam','V_KA','xlsgrid-zlt369n','80','/xlsgrid','');' size=20 value=''  style='width:90;'/>
<img onclick='SELECTID_POPWIN('KA1','KA1nam','V_KA','',1,'xlsgrid-zlt369n','80','/xlsgrid','')' onmouseover=' this.style.cursor='hand'; title='ѡ��'' src='/xlsgrid/xlsgrid/images/forderopen.gif' >
<span  name='KA1nam' id='KA1nam' />&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��Ʒϵ�У�</td>
<td class='EARID-TD' align=left >
<input type=text name=��Ʒϵ��1 size=20 value='' style='width:90;'/>&nbsp;&nbsp;
</td>
</TABLE>

</td></tr></TABLE>
<br><br><table width='100%' border='0' cellpadding='0' cellspacing='1' >
	            		<tr>
	            		    <td>
	            		    	<input type = 'hidden' id = 'topic' name = 'topic' value = SX2>
	            		    </td>
	            		</tr>
	            		<tr>
	            		    <td>
	            		    	<input type = 'hidden' id = 'sytid' name = 'sytid' value = XLSGRID>
	            		    </td>
	            		</tr>
	            		<tr>
	            		    <td></td>
	            		    <td align = 'right'><input type = 'submit' value = '��ѯ' ></td>
	            		    <!--
	          		    <td align = 'right'><input type = 'button' value = '��ѯ' onclick = 'window.open('show.sp?grdid=DIMREP_PC&topic=SX1&sytid=XLSGRID','_right');'></td>
	          		    -->
	            		</tr>
	            	    </table>
	            	 </form>
	            	 </td>
	            	 </tr>
				<tr>
					<td  align = 'left' style='font-size:13px'  style='cursor:pointer;' onclick='showInfo('topic2')'>���۰�ҵ����ͳ��</td>
				</tr>
				<tr id = topic2 
			     style='display:none;'><td><form name = f2 method='post' action='show.sp?grdid=DIMREP_PC' Target='_right'> 
<LINK rel=stylesheet type=text/css HREF='xlsgrid/css/main-right.css'> 
<script language='javascript' src='xlsgrid/js/main.js' ></Script> 
<table width='100%' border='0' cellpadding='0' cellspacing='1' bgcolor='000000'><tr><td>
<table align='center' border='0' width='100%' cellspacing=1 cellpadding=4 class='EAGRID-TABLE' >
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��ʼ���ڣ�</td>
<td class='EARID-TD' align=left ><SCRIPT LANGUAGE=javascript>
<!--
function sel_STADAT2() {
  var ret   = window.showModalDialog( '/xlsgrid/xlsgrid/jsp/pages/calendardlg.htm','' , 'dialogwidth:150pt;dialogheight:150pt' ); 
  if ( ret != null &&  ret != '' ) {
    f2.STADAT2.value = ret ; 
  }
}
//-->
</SCRIPT>
<input type=text name=STADAT2 size=20 value='2010-11-18' style='width:90;'/>
<img  src='/xlsgrid/xlsgrid/images/forderopen.gif' onclick='javascript:sel_STADAT2();' onmouseover=' this.style.cursor='hand'; title='���ѡ������''>
&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��ֹ���ڣ�</td>
<td class='EARID-TD' align=left ><SCRIPT LANGUAGE=javascript>
<!--
function sel_ENDDAT2() {
  var ret   = window.showModalDialog( '/xlsgrid/xlsgrid/jsp/pages/calendardlg.htm','' , 'dialogwidth:150pt;dialogheight:150pt' ); 
  if ( ret != null &&  ret != '' ) {
    f2.ENDDAT2.value = ret ; 
  }
}
//-->
</SCRIPT>
<input type=text name=ENDDAT2 size=20 value='2010-11-18' style='width:90;'/>
<img  src='/xlsgrid/xlsgrid/images/forderopen.gif' onclick='javascript:sel_ENDDAT2();' onmouseover=' this.style.cursor='hand'; title='���ѡ������''>
&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��Ʒ��ţ�</td>
<td class='EARID-TD' align=left >
<input type='text' name='��Ʒ���2' id='��Ʒ���2' onchange='javacript:SELECTID_ONCHANGE('��Ʒ���2','V_ITEMnam','V_ITEM','xlsgrid-zlt369n','80','/xlsgrid','');' size=20 value=''  style='width:90;'/>
<img onclick='SELECTID_POPWIN('��Ʒ���2','��Ʒ���2nam','V_ITEM','',1,'xlsgrid-zlt369n','80','/xlsgrid','')' onmouseover=' this.style.cursor='hand'; title='ѡ��'' src='/xlsgrid/xlsgrid/images/forderopen.gif' >
<span  name='��Ʒ���2nam' id='��Ʒ���2nam' />&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>������</td>
<td class='EARID-TD' align=left >
<input type='text' name='KA2' id='KA2' onchange='javacript:SELECTID_ONCHANGE('KA2','V_KAnam','V_KA','xlsgrid-zlt369n','80','/xlsgrid','');' size=20 value=''  style='width:90;'/>
<img onclick='SELECTID_POPWIN('KA2','KA2nam','V_KA','',1,'xlsgrid-zlt369n','80','/xlsgrid','')' onmouseover=' this.style.cursor='hand'; title='ѡ��'' src='/xlsgrid/xlsgrid/images/forderopen.gif' >
<span  name='KA2nam' id='KA2nam' />&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��Ʒϵ�У�</td>
<td class='EARID-TD' align=left >
<input type=text name=��Ʒϵ��2 size=20 value='' style='width:90;'/>&nbsp;&nbsp;
</td>
</TABLE>

</td></tr></TABLE>
<br><br><table width='100%' border='0' cellpadding='0' cellspacing='1' >
	            		<tr>
	            		    <td>
	            		    	<input type = 'hidden' id = 'topic' name = 'topic' value = SX4>
	            		    </td>
	            		</tr>
	            		<tr>
	            		    <td>
	            		    	<input type = 'hidden' id = 'sytid' name = 'sytid' value = XLSGRID>
	            		    </td>
	            		</tr>
	            		<tr>
	            		    <td></td>
	            		    <td align = 'right'><input type = 'submit' value = '��ѯ' ></td>
	            		    <!--
	          		    <td align = 'right'><input type = 'button' value = '��ѯ' onclick = 'window.open('show.sp?grdid=DIMREP_PC&topic=SX1&sytid=XLSGRID','_right');'></td>
	          		    -->
	            		</tr>
	            	    </table>
	            	 </form>
	            	 </td>
	            	 </tr>
				<tr>
					<td  align = 'left' style='font-size:13px'  style='cursor:pointer;' onclick='showInfo('topic3')'>���۰���������ͳ��</td>
				</tr>
				<tr id = topic3 
			     style='display:none;'><td><form name = f3 method='post' action='show.sp?grdid=DIMREP_PC' Target='_right'> 
<LINK rel=stylesheet type=text/css HREF='xlsgrid/css/main-right.css'> 
<script language='javascript' src='xlsgrid/js/main.js' ></Script> 
<table width='100%' border='0' cellpadding='0' cellspacing='1' bgcolor='000000'><tr><td>
<table align='center' border='0' width='100%' cellspacing=1 cellpadding=4 class='EAGRID-TABLE' >
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��ʼ���ڣ�</td>
<td class='EARID-TD' align=left ><SCRIPT LANGUAGE=javascript>
<!--
function sel_STADAT3() {
  var ret   = window.showModalDialog( '/xlsgrid/xlsgrid/jsp/pages/calendardlg.htm','' , 'dialogwidth:150pt;dialogheight:150pt' ); 
  if ( ret != null &&  ret != '' ) {
    f3.STADAT3.value = ret ; 
  }
}
//-->
</SCRIPT>
<input type=text name=STADAT3 size=20 value='2010-11-18' style='width:90;'/>
<img  src='/xlsgrid/xlsgrid/images/forderopen.gif' onclick='javascript:sel_STADAT3();' onmouseover=' this.style.cursor='hand'; title='���ѡ������''>
&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��ֹ���ڣ�</td>
<td class='EARID-TD' align=left ><SCRIPT LANGUAGE=javascript>
<!--
function sel_ENDDAT3() {
  var ret   = window.showModalDialog( '/xlsgrid/xlsgrid/jsp/pages/calendardlg.htm','' , 'dialogwidth:150pt;dialogheight:150pt' ); 
  if ( ret != null &&  ret != '' ) {
    f3.ENDDAT3.value = ret ; 
  }
}
//-->
</SCRIPT>
<input type=text name=ENDDAT3 size=20 value='2010-11-18' style='width:90;'/>
<img  src='/xlsgrid/xlsgrid/images/forderopen.gif' onclick='javascript:sel_ENDDAT3();' onmouseover=' this.style.cursor='hand'; title='���ѡ������''>
&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��Ʒ��ţ�</td>
<td class='EARID-TD' align=left >
<input type='text' name='��Ʒ���3' id='��Ʒ���3' onchange='javacript:SELECTID_ONCHANGE('��Ʒ���3','V_ITEMnam','V_ITEM','xlsgrid-zlt369n','80','/xlsgrid','');' size=20 value=''  style='width:90;'/>
<img onclick='SELECTID_POPWIN('��Ʒ���3','��Ʒ���3nam','V_ITEM','',1,'xlsgrid-zlt369n','80','/xlsgrid','')' onmouseover=' this.style.cursor='hand'; title='ѡ��'' src='/xlsgrid/xlsgrid/images/forderopen.gif' >
<span  name='��Ʒ���3nam' id='��Ʒ���3nam' />&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>������</td>
<td class='EARID-TD' align=left >
<input type='text' name='KA3' id='KA3' onchange='javacript:SELECTID_ONCHANGE('KA3','V_KAnam','V_KA','xlsgrid-zlt369n','80','/xlsgrid','');' size=20 value=''  style='width:90;'/>
<img onclick='SELECTID_POPWIN('KA3','KA3nam','V_KA','',1,'xlsgrid-zlt369n','80','/xlsgrid','')' onmouseover=' this.style.cursor='hand'; title='ѡ��'' src='/xlsgrid/xlsgrid/images/forderopen.gif' >
<span  name='KA3nam' id='KA3nam' />&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��Ʒϵ�У�</td>
<td class='EARID-TD' align=left >
<input type=text name=��Ʒϵ��3 size=20 value='' style='width:90;'/>&nbsp;&nbsp;
</td>
</TABLE>

</td></tr></TABLE>
<br><br><table width='100%' border='0' cellpadding='0' cellspacing='1' >
	            		<tr>
	            		    <td>
	            		    	<input type = 'hidden' id = 'topic' name = 'topic' value = SX5>
	            		    </td>
	            		</tr>
	            		<tr>
	            		    <td>
	            		    	<input type = 'hidden' id = 'sytid' name = 'sytid' value = XLSGRID>
	            		    </td>
	            		</tr>
	            		<tr>
	            		    <td></td>
	            		    <td align = 'right'><input type = 'submit' value = '��ѯ' ></td>
	            		    <!--
	          		    <td align = 'right'><input type = 'button' value = '��ѯ' onclick = 'window.open('show.sp?grdid=DIMREP_PC&topic=SX1&sytid=XLSGRID','_right');'></td>
	          		    -->
	            		</tr>
	            	    </table>
	            	 </form>
	            	 </td>
	            	 </tr>
				<tr>
					<td  align = 'left' style='font-size:13px'  style='cursor:pointer;' onclick='showInfo('topic4')'>���۰���������ͳ��</td>
				</tr>
				<tr id = topic4 
			     style='display:none;'><td><form name = f4 method='post' action='show.sp?grdid=DIMREP_PC' Target='_right'> 
<LINK rel=stylesheet type=text/css HREF='xlsgrid/css/main-right.css'> 
<script language='javascript' src='xlsgrid/js/main.js' ></Script> 
<table width='100%' border='0' cellpadding='0' cellspacing='1' bgcolor='000000'><tr><td>
<table align='center' border='0' width='100%' cellspacing=1 cellpadding=4 class='EAGRID-TABLE' >
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��ʼ���ڣ�</td>
<td class='EARID-TD' align=left ><SCRIPT LANGUAGE=javascript>
<!--
function sel_STADAT4() {
  var ret   = window.showModalDialog( '/xlsgrid/xlsgrid/jsp/pages/calendardlg.htm','' , 'dialogwidth:150pt;dialogheight:150pt' ); 
  if ( ret != null &&  ret != '' ) {
    f4.STADAT4.value = ret ; 
  }
}
//-->
</SCRIPT>
<input type=text name=STADAT4 size=20 value='2010-11-18' style='width:90;'/>
<img  src='/xlsgrid/xlsgrid/images/forderopen.gif' onclick='javascript:sel_STADAT4();' onmouseover=' this.style.cursor='hand'; title='���ѡ������''>
&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��ֹ���ڣ�</td>
<td class='EARID-TD' align=left ><SCRIPT LANGUAGE=javascript>
<!--
function sel_ENDDAT4() {
  var ret   = window.showModalDialog( '/xlsgrid/xlsgrid/jsp/pages/calendardlg.htm','' , 'dialogwidth:150pt;dialogheight:150pt' ); 
  if ( ret != null &&  ret != '' ) {
    f4.ENDDAT4.value = ret ; 
  }
}
//-->
</SCRIPT>
<input type=text name=ENDDAT4 size=20 value='2010-11-18' style='width:90;'/>
<img  src='/xlsgrid/xlsgrid/images/forderopen.gif' onclick='javascript:sel_ENDDAT4();' onmouseover=' this.style.cursor='hand'; title='���ѡ������''>
&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��Ʒ��ţ�</td>
<td class='EARID-TD' align=left >
<input type='text' name='��Ʒ���4' id='��Ʒ���4' onchange='javacript:SELECTID_ONCHANGE('��Ʒ���4','V_ITEMnam','V_ITEM','xlsgrid-zlt369n','80','/xlsgrid','');' size=20 value=''  style='width:90;'/>
<img onclick='SELECTID_POPWIN('��Ʒ���4','��Ʒ���4nam','V_ITEM','',1,'xlsgrid-zlt369n','80','/xlsgrid','')' onmouseover=' this.style.cursor='hand'; title='ѡ��'' src='/xlsgrid/xlsgrid/images/forderopen.gif' >
<span  name='��Ʒ���4nam' id='��Ʒ���4nam' />&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>������</td>
<td class='EARID-TD' align=left >
<input type='text' name='KA4' id='KA4' onchange='javacript:SELECTID_ONCHANGE('KA4','V_KAnam','V_KA','xlsgrid-zlt369n','80','/xlsgrid','');' size=20 value=''  style='width:90;'/>
<img onclick='SELECTID_POPWIN('KA4','KA4nam','V_KA','',1,'xlsgrid-zlt369n','80','/xlsgrid','')' onmouseover=' this.style.cursor='hand'; title='ѡ��'' src='/xlsgrid/xlsgrid/images/forderopen.gif' >
<span  name='KA4nam' id='KA4nam' />&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��Ʒϵ�У�</td>
<td class='EARID-TD' align=left >
<input type=text name=��Ʒϵ��4 size=20 value='' style='width:90;'/>&nbsp;&nbsp;
</td>
</TABLE>

</td></tr></TABLE>
<br><br><table width='100%' border='0' cellpadding='0' cellspacing='1' >
	            		<tr>
	            		    <td>
	            		    	<input type = 'hidden' id = 'topic' name = 'topic' value = SX6>
	            		    </td>
	            		</tr>
	            		<tr>
	            		    <td>
	            		    	<input type = 'hidden' id = 'sytid' name = 'sytid' value = XLSGRID>
	            		    </td>
	            		</tr>
	            		<tr>
	            		    <td></td>
	            		    <td align = 'right'><input type = 'submit' value = '��ѯ' ></td>
	            		    <!--
	          		    <td align = 'right'><input type = 'button' value = '��ѯ' onclick = 'window.open('show.sp?grdid=DIMREP_PC&topic=SX1&sytid=XLSGRID','_right');'></td>
	          		    -->
	            		</tr>
	            	    </table>
	            	 </form>
	            	 </td>
	            	 </tr>
				<tr>
					<td  align = 'left' style='font-size:13px'  style='cursor:pointer;' onclick='showInfo('topic5')'>���۰�ϵ��ͳ��</td>
				</tr>
				<tr id = topic5 
			     style='display:none;'><td><form name = f5 method='post' action='show.sp?grdid=DIMREP_PC' Target='_right'> 
<LINK rel=stylesheet type=text/css HREF='xlsgrid/css/main-right.css'> 
<script language='javascript' src='xlsgrid/js/main.js' ></Script> 
<table width='100%' border='0' cellpadding='0' cellspacing='1' bgcolor='000000'><tr><td>
<table align='center' border='0' width='100%' cellspacing=1 cellpadding=4 class='EAGRID-TABLE' >
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��ʼ���ڣ�</td>
<td class='EARID-TD' align=left ><SCRIPT LANGUAGE=javascript>
<!--
function sel_STADAT5() {
  var ret   = window.showModalDialog( '/xlsgrid/xlsgrid/jsp/pages/calendardlg.htm','' , 'dialogwidth:150pt;dialogheight:150pt' ); 
  if ( ret != null &&  ret != '' ) {
    f5.STADAT5.value = ret ; 
  }
}
//-->
</SCRIPT>
<input type=text name=STADAT5 size=20 value='2010-11-18' style='width:90;'/>
<img  src='/xlsgrid/xlsgrid/images/forderopen.gif' onclick='javascript:sel_STADAT5();' onmouseover=' this.style.cursor='hand'; title='���ѡ������''>
&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��ֹ���ڣ�</td>
<td class='EARID-TD' align=left ><SCRIPT LANGUAGE=javascript>
<!--
function sel_ENDDAT5() {
  var ret   = window.showModalDialog( '/xlsgrid/xlsgrid/jsp/pages/calendardlg.htm','' , 'dialogwidth:150pt;dialogheight:150pt' ); 
  if ( ret != null &&  ret != '' ) {
    f5.ENDDAT5.value = ret ; 
  }
}
//-->
</SCRIPT>
<input type=text name=ENDDAT5 size=20 value='2010-11-18' style='width:90;'/>
<img  src='/xlsgrid/xlsgrid/images/forderopen.gif' onclick='javascript:sel_ENDDAT5();' onmouseover=' this.style.cursor='hand'; title='���ѡ������''>
&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��Ʒ��ţ�</td>
<td class='EARID-TD' align=left >
<input type='text' name='��Ʒ���5' id='��Ʒ���5' onchange='javacript:SELECTID_ONCHANGE('��Ʒ���5','V_ITEMnam','V_ITEM','xlsgrid-zlt369n','80','/xlsgrid','');' size=20 value=''  style='width:90;'/>
<img onclick='SELECTID_POPWIN('��Ʒ���5','��Ʒ���5nam','V_ITEM','',1,'xlsgrid-zlt369n','80','/xlsgrid','')' onmouseover=' this.style.cursor='hand'; title='ѡ��'' src='/xlsgrid/xlsgrid/images/forderopen.gif' >
<span  name='��Ʒ���5nam' id='��Ʒ���5nam' />&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>������</td>
<td class='EARID-TD' align=left >
<input type='text' name='KA5' id='KA5' onchange='javacript:SELECTID_ONCHANGE('KA5','V_KAnam','V_KA','xlsgrid-zlt369n','80','/xlsgrid','');' size=20 value=''  style='width:90;'/>
<img onclick='SELECTID_POPWIN('KA5','KA5nam','V_KA','',1,'xlsgrid-zlt369n','80','/xlsgrid','')' onmouseover=' this.style.cursor='hand'; title='ѡ��'' src='/xlsgrid/xlsgrid/images/forderopen.gif' >
<span  name='KA5nam' id='KA5nam' />&nbsp;&nbsp;
</td>
<TR  class='EAGRID-TR'>
<td  class='EARID-TD' align=right>��Ʒϵ�У�</td>
<td class='EARID-TD' align=left >
<input type=text name=��Ʒϵ��5 size=20 value='' style='width:90;'/>&nbsp;&nbsp;
</td>
</TABLE>

</td></tr></TABLE>
<br><br><table width='100%' border='0' cellpadding='0' cellspacing='1' >
	            		<tr>
	            		    <td>
	            		    	<input type = 'hidden' id = 'topic' name = 'topic' value = SX3>
	            		    </td>
	            		</tr>
	            		<tr>
	            		    <td>
	            		    	<input type = 'hidden' id = 'sytid' name = 'sytid' value = XLSGRID>
	            		    </td>
	            		</tr>
	            		<tr>
	            		    <td></td>
	            		    <td align = 'right'><input type = 'submit' value = '��ѯ' ></td>
	            		    <!--
	          		    <td align = 'right'><input type = 'button' value = '��ѯ' onclick = 'window.open('show.sp?grdid=DIMREP_PC&topic=SX1&sytid=XLSGRID','_right');'></td>
	          		    -->
	            		</tr>
	            	    </table>
	            	 </form>
	            	 </td>
	            	 </tr></table> 
	   	  </body>";
	   	   return ret ;
}
}