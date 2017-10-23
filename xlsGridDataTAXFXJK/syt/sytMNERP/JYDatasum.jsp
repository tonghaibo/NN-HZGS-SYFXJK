<%@ page contentType="text/html;charset=gb2312" %>
<%@ page import="java.io.*,com.xlsgrid.net.pub.*,com.xlsgrid.net.web.*,com.xlsgrid.net.tag.*,com.xlsgrid.net.xmldb.*" %>
<%
  EAUserinfo usrinfo = com.xlsgrid.net.web.EASession.GetLoginInfo(request)  ;
  
  String usrnam = usrinfo.getUsrnam();
  String logtime = usrinfo.getLogdat();
  String sytid  = usrinfo.getSytid();
  if ( sytid == null || sytid.length()==0 ) 
    sytid = "SERP";
  String grdtyp = EAFunc.NVL(request.getParameter("grdtyp") ,"R" );
  String subtyp = EAFunc.NVL(request.getParameter("subtyp") ,"" );
  String action = EAFunc.NVL(request.getParameter("action") ,"" );
  if ( action.equalsIgnoreCase("update") ) {
    // 刷新数据
    String runsql= "declare "+
      "msg varchar2(4000);"+
      "begin "+
      "  msg:=MoveFromDfxd.MOVTRA('');  "+
      "end;";
    try {
      EADbTool.ExcecutSQL(runsql);
      out.println( "<script>alert('汇总数据成功');</script>" );
    }
    catch ( EAException e ) {
      out.println( "<script>alert('"+e.toString()+"');</script>" );
    }
  }
  String sDat = EADbTool.GetSQL("SELECT to_char(MAX(DAT),'YYYY-MM-DD') FROM ITMSUM@DFXD WHERE DAT<>to_date('"+usrinfo.getLogdat()+"','YYYY-MM-DD')");
  String sUpdateDat = EADbTool.GetSQL("select to_char(max(crtdat),'YYYY-MM-DD HH24:MI') from movlog@dfxd where movtyp='MOVTRA'");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<meta http-equiv="Content-Language" content="zh-cn">
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title><%=usrnam%>的总部查询</title>
<LINK rel=stylesheet type=text/css HREF="../xlsgrid/css/main.css">
<style type='text/css'>

.mybutton{	
cursor:hand;
border: 1px solid #808080;
font-family:宋体;
font-size:9pt; 
background-color:#99CCFF; 
vertical-align:baseline;
height:20;
}

.TdBorderBottom {
	border-bottom-style:solid;
	border-bottom-width:1pt;
}

.TableBorder {
	border-bottom-style:solid; 
	border-bottom-width:1pt;
	border-left-style:solid;
	border-left-width:1pt;
	border-right-style:solid;
	border-right-width:1pt;
	border-top-style:solid;
	border-top-width:1pt;
}

.winLcell {
BORDER-TOP:     #3a77ba 1px solid; 
BORDER-LEFT:    #3a77ba 1px solid;
BORDER-RIGHT:   #3a77ba 0px solid;
BORDER-BOTTOM:  #3a77ba 1px solid;
bgColor:  #ffffff;
}

.winRcell {
BORDER-TOP:     #3a77ba 1px solid; 
BORDER-LEFT:    #3a77ba 0px solid;
BORDER-RIGHT:   #3a77ba 1px solid;
BORDER-BOTTOM:  #3a77ba 1px solid;
bgColor:  #ffffff;
}

.winBcell {
BORDER-TOP:     #3a77ba 0px solid; 
BORDER-LEFT:    #3a77ba 1px solid;
BORDER-RIGHT:   #3a77ba 1px solid;
BORDER-BOTTOM:  #3a77ba 1px solid;
bgColor:  #ffffff;
}
</style>

</head>
<script src="../xlsgrid/js/listobj.js" type="text/jscript" language="jscript"></script>
<script language="JavaScript">
<!--
 function f_showcaiwuItem () {
//var myList = new CList();
//myList.Add("","<IMG border=0 SRC='../xlsgrid/images/icon/icon1.gif'/><BR>资金分析(440)","","javascript:window.open('../BillEntry.sp?grdid=440','','height=600,width=800,toolbar=yes,location=no,status=yes,resizable=yes,top=50,left=112')" );
//myList.Show("caiwuDiv",120,550);
}

 function f_showCustItem () {
//var myList = new CList();
//myList.Add("","<IMG border=0 SRC='../xlsgrid/images/icon/icon1.gif'/><BR>基础报表(225)","","javascript:window.open('../BillEntry.sp?grdid=225','','height=600,width=800,toolbar=yes,location=no,status=yes,resizable=yes,top=50,left=112')" );
//myList.Show("custDiv",120,550);
}

function f_showMoreButton()
{
//var myList = new CList();
//myList.Add("","<IMG border=0 SRC='../xlsgrid/images/icon/icon11.gif'/><BR>进入帐套","","javascript:window.open('index.htm','','height=600,width=800,toolbar=yes,location=no,status=yes,resizable=yes,top=50,left=112')" );
//myList.Show("moreitem",120,550);
}


 function f_showcheckitem () {
//var myList = new CList();
//myList.Show("checkDiv",120,550);
//setTimeout(f_showcheckitem,60000);
}
  // 显示高级查询窗口
  function f_showlist () {
<%
/*
String sAccid = "";
try{
  EADS ds0 = EAGRDXmlDB.getGrdDSByGrdTyp(sytid,grdtyp);
  EADS ds = new EADS(ds0);
  int nRow = ds.getRowCount();
  // 根据XmlDSListView的要求处理ds
  for ( int i =0 ; i< nRow; i ++ ) {
    String sGrdtyp = ds.getStringAt(i,"MWTYP") ;
    String sSubtyp = ds.getStringAt(i,"CATTYP") ;
	//System.out.println("sSubtyp="+sSubtyp+",subtyp="+subtyp+",loc="+sSubtyp.indexOf(subtyp));
    if ( sGrdtyp.compareToIgnoreCase(grdtyp) == 0 && (subtyp.trim().length()==0 || subtyp.indexOf(","+sSubtyp+",")>=0 ) )     
    {
      String sImgPath = ""+ds.getValueDef(i,"ICON","") ;
      if ( sImgPath.length() == 0 )
          sImgPath = "../xlsgrid/images/icon/icon3.gif" ;
      String sName = ds.getStringAt(i,"NAME");
      String sGrdid =ds.getStringAt(i,"MWID"); 
      ds.setValueAt(i,"NAME","<IMG border=0 SRC='"+sImgPath+ "'/><BR>" + sName+"("+sGrdid+")");
      ds.setValueAt(i,"URL","javascript:window.open('../BillEntry.sp?grdid="+sGrdid+"','','height=600,width=800,toolbar=yes,location=no,status=yes,resizable=yes,top=50,left=112')");
    }
    else {
      ds.DeleteRow(i);
      nRow--;
      i--;
    }
  }
  String str = new XmlDSListView().GetHtml(ds,"listDiv","ID","NAME","[%URL]","[%NOTE]",120,550);
  out.println(str );
}
catch ( EAException e ) {
  if ( request!= null ) 
    request.getSession().setAttribute("XLSGRID_EXCEPTION",new EAException(EAException.errGeneral,"定义的中间件资料不正确：<BR>"+e.toString()));
  if ( response!= null ) 
    response.sendRedirect("xlsweb?action=ShowError");
  else 
    out.println( "<script>alert ( '"+e.toString()+"' )</script>" );
}
*/
%>
  }


-->
</script>

<script language="javascript">
// 初始化
var sodat = "<%=sDat%>";
var podat = "<%=sDat%>";
var selectedorg = "";
function selectorg(orgid,orgname)
{
  selectedorg = orgid;
  f_showinv();
  accname.innerText = orgname;
}

function winonresize()
{
  showMarqueen();
}

function initSoInner(all)
{
  if(all)
  {
  soqty = "soqty";
  somny = "somny";
  }
  else
  {
  soqty = "(soqty - soexqty)";
  somny = "(somny - soexmny)";
  }

}
function initPoInner(all)
{
  if(all)
  {
  poqty = "a.poqty";
  pomny = "a.pomny";
  }
  else
  {
  poqty = "(a.poqty - a.poexqty)";
  pomny = "(a.pomny - a.poexmny)";
  }
}
initSoInner(true);
initPoInner(true);

function soinner(src)
{
  initSoInner(src.checked == true);
  f_showso();
}

function poinner(src)
{
  initPoInner(src.checked == true);
  f_showpo();
}

function OrgSelectChange(src)
{
  var option = src.childNodes[src.selectedIndex]
  selectorg(option.value,option.innerText);
}

function showMarqueen()
{
  var s='<marquee id=marqueen0 width="210" direction=left scrolldelay=200 onmouseover="stop();" onmouseout="start();" >'
  var b="<a href=\"javascript:selectorg('','全部')\">全部</a>&nbsp;";
  <%
  EADS OrgDs = EADbTool.QuerySQL("select * from v_org@dfxd order by id");//EAXmlDB.getXmlDbDs(EAORGXmlDB.ORG_DB_NAME);
  for(int o=0;o<OrgDs.getRowCount();o++)
  {
    out.print(EAFunc.format(
      "b+=\"<a href=\\\"javascript:selectorg('%s','%s')\\\">%s</a>&nbsp;\"\r\n",
      OrgDs.getStringAt(o,"ID"),OrgDs.getStringAt(o,"NAME"),OrgDs.getStringAt(o,"NAME")) );
  }
  //<a href="">demo</a>
  %>
  var e='</marquee>';
  marqueen0.outerHTML = s+b+e;
  //更新待审核信息
  //updateUnCheckInfo();
}

var XmlDBurl="<%=usrinfo.getHomeURL()%>/XmlDB.sp";
function getsql(sql)
{
  _this.OpenHttpRequest(XmlDBurl,"POST");
  _this.AddHttpRequestParam("sql",sql,0);
  var ret=_this.SendHttpRequest();
  var val="未知";
  if(ret!="")
  {
  _this.XMLDS_Reset();
  _this.XMLDS_Parse(ret);
  val=_this.XMLDS_GetStringAt(0,0);
  }
  return val;
}

function updateUnCheckInfo()
{
  //1. 采购请求
  var sql = "select count(*) from bilhdr@dfxd where biltyp='PR' and stat='6' and acc<>'TS'";
  updateui(null,sql);
//  alert(ret);
  //2. 资金申请
  sql = "select count(*) from bilhdr@dfxd where biltyp='PF' and stat='5' and acc<>'TS'";
  updateui(null,sql);
}

function winonload(){
	//var bkimage = "background=\"../xlsgrid/images/my/greeting.jpg\"";
	//newWin( "w_top11","自定义查询",440,"","<div id='listDiv' />" );
  //document.all("sytDiv").innerHTML = 
  // 显示高级查询
//  f_showCustItem ();
//  f_showcaiwuItem();
//  f_showcheckitem ();
//  f_showlist ();
  f_showMoreButton();
  //return;
  // 销售、采购和库存
  //f_showso();
  //f_showpo();
  f_refreshso(1);
  f_refreshpo(1);
  f_showinv();
  
  //
 loading.runtimeStyle.display = 'none';
 content.runtimeStyle.display = 'block';
  //
  setTimeout(showMarqueen,100);
  //alert('');
}
//
// 在ITMSUM表中得到不是i_dat的最后一天
// flag =-1 上一天 =1 下一天
//
function GetLastDayInItmsum(i_dat,flag)
{
  var sql="SELECT to_char(MAX(DAT),'YYYY-MM-DD') FROM ITMSUM@dfxd WHERE DAT<= LEAST(sysdate-2, to_date('"+i_dat+"','YYYY-MM-DD'))[PLUS]"+flag;
  if (flag > 0 )
    sql="SELECT to_char(MIN(DAT),'YYYY-MM-DD') FROM ITMSUM@dfxd WHERE DAT>=LEAST(sysdate-2, to_date('"+i_dat+"','YYYY-MM-DD'))[PLUS]"+flag;
  var xml=_this.HttpCall( "<%=usrinfo.getHomeURL()%>/XmlDB.sp?sql="+sql );
  _this.XMLDS_Reset();
  _this.XMLDS_Parse(xml);
  var my_dat = "";
  if ( _this.XMLDS_GetRowCount() > 0 ) {
      my_dat = _this.XMLDS_GetStringAt(0,0)
  }
  return my_dat;
}
// 刷新销售板块
// flag =-1 上一天 =1 下一天
function f_refreshso(flag){
  var d = GetLastDayInItmsum(sodat,flag);
  if(!d)
  {
    alert('已到期末或期初。');
    return;
  }
  else
    sodat=d;
  f_showso();
}

// 显示销售板块
function f_showso(){
    //var sql="SELECT substr(B.NAME,1,4) as 公司,to_char(NVL(A.QTY,0),'9999999999.00') as 销售量,to_char(NVL(A.SOQTY_MONTH,0),'9999999999.00') as 本月累计,to_char(NVL(A.MNY,0),'9999999999.00') as 销售额,to_char(NVL(A.SOMNY_MONTH,0),'9999999999.00') as 本月累计,''  FROM ";
    var sql="SELECT org,substr(B.NAME,1,4) as 公司,'' tip0,LTRIM(to_char(NVL(A.QTY,0),'9999999999.00')) as 销售量,'' tip1,LTRIM(to_char(NVL(A.SOQTY_MONTH,0),'9999999999.00')) as 本月累计数量,'' tip2,LTRIM(to_char(NVL(A.MNY,0),'9999999999.00')) as 销售额,'' tip3,LTRIM(to_char(NVL(A.SOMNY_MONTH,0),'9999999999.00')) as 本月累计金额,'' tip4 FROM ";
    sql+="( ";
    sql+="select org,SUM(QTY) QTY,SUM(MNY) MNY,SUM(SOQTY_MONTH) SOQTY_MONTH,SUM(SOMNY_MONTH) SOMNY_MONTH from ";
    sql+="( ";
    sql+="select ORG,sum(NVL(("+soqty+"/b.untnum*b.tonnum),0)) QTY,SUM(NVL("+somny+",0)) MNY,0 SOQTY_MONTH,0 SOMNY_MONTH ";
    sql+="from ITMSUM@dfxd a,ITEM@dfxd b ";
    sql+="where a.ITEM([PLUS]) = b.GUID and a.org <> 'TS' and a.DAT=TO_DATE('"+sodat+"','YYYY-MM-DD') ";
    sql+=" and b.id like '00[PERCENT]'  ";
    sql+="GROUP BY ORG ";
    sql+="union ";
    sql+="select ORG,0 QTY,0 MNY,SUM(NVL(("+soqty+"/b.untnum*b.tonnum),0)) SOQTY_MONTH,SUM(NVL("+somny+",0)) SOMNY_MONTH ";
    sql+="from ITMSUM@dfxd a,ITEM@dfxd b ";
    sql+="where a.ITEM([PLUS]) = b.GUID and a.org <> 'TS' and to_char(a.DAT,'YYMM')=to_char(TO_DATE('"+sodat+"','YYYY-MM-DD'),'YYMM') ";
    sql+=" and b.id like '00[PERCENT]' ";
    sql+="GROUP BY ORG ";
    sql+=") ";
    sql+="GROUP BY ORG " ;
    sql+=") A , V_ORG@dfxd B ";
    sql+="WHERE a.org([PLUS])=b.id ";  //[PLUS]是+，在web传递中会转义
    sql+="ORDER BY B.ID";

    var ret = f_showtable(sql,"../SelectGridParameter.sp?grdtyp=R&sytid=SERP&grdid=3002&COMNAM=");
    document.all("SOTEXT").innerHTML = ret;
    dissodate.innerHTML = sodat;
}
// 刷新采购板块
// flag =-1 上一天 =1 下一天
function f_refreshpo(flag){
  var d = GetLastDayInItmsum(podat,flag);
  if(!d)
  {
    alert('已到期末或期初。'); 
    return;
  }
  else
    podat=d;
  //podat = GetLastDayInItmsum(podat,flag);
  f_showpo();
}

// 显示采购
function f_showpo(){
    var sql="SELECT org,substr(B.NAME,1,4) as 公司,'' tip0,LTRIM(to_char(NVL(A.QTY,0),'9999999999.00')) as 采购量,'' tip1,LTRIM(to_char(NVL(A.SOQTY_MONTH,0),'9999999999.00')) as 本月累计数量,'' tip2,LTRIM(to_char(NVL(A.MNY,0),'9999999999.00')) as 采购额,'' tip3,LTRIM(to_char(NVL(A.SOMNY_MONTH,0),'9999999999.00')) as 本月累计金额,'' tip4 FROM ";
    sql+="( ";
    sql+="select org,SUM(QTY) QTY,SUM(MNY) MNY,SUM(SOQTY_MONTH) SOQTY_MONTH,SUM(SOMNY_MONTH) SOMNY_MONTH from ";
    sql+="( ";
    sql+="select ORG,sum(NVL(("+poqty+"/b.untnum*b.tonnum),0)) QTY,SUM(NVL("+pomny+",0)) MNY,0 SOQTY_MONTH,0 SOMNY_MONTH ";
    sql+="from ITMSUM@dfxd a,ITEM@dfxd b ";
    sql+="where a.ITEM([PLUS]) = b.GUID and a.org <> 'TS' and a.DAT=TO_DATE('"+podat+"','YYYY-MM-DD') ";
    sql+=" and b.id like '00[PERCENT]' ";
    sql+="GROUP BY ORG ";
    sql+="union ";
    sql+="select ORG,0 QTY,0 MNY,SUM(NVL(("+poqty+"/b.untnum*b.tonnum),0)) SOQTY_MONTH,SUM(NVL("+pomny+",0)) SOMNY_MONTH ";
    sql+="from ITMSUM@dfxd a,ITEM@dfxd b ";
    sql+="where a.ITEM([PLUS]) = b.GUID and a.org <> 'TS' and to_char(a.DAT,'YYMM')=to_char(TO_DATE('"+podat+"','YYYY-MM-DD'),'YYMM') ";
    sql+=" and b.id like '00[PERCENT]' ";
    sql+="GROUP BY ORG ";
    sql+=") ";
    sql+="GROUP BY ORG " ;
    sql+=") A , V_ORG@dfxd B ";
    sql+="WHERE a.org([PLUS])=b.id ";  //[PLUS]是+，在web传递中会转义
    sql+="ORDER BY B.ID";

    var ret = f_showtable(sql,"../SelectGridParameter.sp?grdtyp=R&sytid=SERP&grdid=2002&COMNAM=");
    document.all("POTEXT").innerHTML = ret+"<div align=right>以上数据不包括采购预估</div>";
    dispodate.innerHTML = podat;
}
// 显示库存板块
function f_showinv(){
    //在库,'仓库的实际在库库存'
    //在途,'采购合同未到货的吨数'
    //未提,'销售开单未提货
    //赊销,'赊销未结算'
    //代储代销
    var sql="SELECT substr(NAME,1,4) as 大类,'' tip0,to_char(NVL(INVQTY,0),'9999999999.00') as 在库,'' tip1,to_char(NVL(ONORDQTY,0),'9999999999.00') as 在途,'' tip2,to_char(NVL(ONRLSQTY,0),'9999999999.00') as 未提,'' tip3,to_char(NVL(ONSXQTY,0),'9999999999.00') as 赊销,'赊销未结算' tip4,";
    sql+=" to_char(NVL(ONSAVQTY,0)[PLUS]NVL(ONSUBQTY,0),'9999999999.00') as 代储代销,'其中:代储'||NVL(ONSAVQTY,0)||'吨,代销:'||NVL(ONSUBQTY,0)||'吨' tip5,to_char(NVL(SUMQTY,0),'9999999999.00') as 合计,'' tip6 FROM ";
    sql+="( ";
    sql+=" select C.ID,C.NAME,SUM(INVQTY/b.untnum*b.tonnum) AS INVQTY,SUM(ONSAVQTY/b.untnum*b.tonnum) AS ONSAVQTY,SUM(ONRLSQTY/b.untnum*b.tonnum) AS ONRLSQTY,SUM(ONSXQTY/b.untnum*b.tonnum) AS ONSXQTY,SUM(ONORDQTY/b.untnum*b.tonnum) AS ONORDQTY,SUM((INVQTY[PLUS]ONORDQTY-ONSAVQTY-ONSUBQTY-ONRLSQTY)/b.untnum*b.tonnum) AS SUMQTY,SUM(ONSUBQTY/b.untnum*b.tonnum) as ONSUBQTY ";
    sql+=" from INVHQ@dfxd O , ITEM@dfxd B, V_ITEMCLASS@dfxd C ";
    sql+=" WHERE O.ITEM([PLUS])=b.GUID AND substr(B.REFID,1,4) =C.ID ";  //[PLUS]是+，在web传递中会转义
    sql+=" and O.org <> 'TS' AND LENGTH(c.id)=4 and substr(C.id,1,2) ='00' and O.org like '"+selectedorg+"[PERCENT]'";
    sql+=" GROUP BY C.ID,C.NAME " ;
    sql+=" )  ";
    sql+="ORDER BY ID";



    //debugger
    var ret = f_showtable(sql);
//说明：在库指仓库实物库存，在途指采购未到货，未提指销售未未提，赊销指赊销未结算，代储指代其他公司储存，代销指代其他公司销售。<BR>
    document.all("INVTEXT").innerHTML = ret+"合计=在库+在途-未提-代储-代销";//-赊销
}

function sumfields()
{
  var cols = _this.XMLDS_GetColumnCount();
  var rows = _this.XMLDS_GetRowCount();
  var sums=new Array();
  var c;
  var r;
  for(c=1;c<cols;c++)
  {
    sums[c] = 0;
    for(r=0;r<rows;r++)
    {
      sums[c] += 1.0 * _this.XMLDS_GetStringAt(r,c);
    }
  }
  r = _this.XMLDS_AddRow(_this.XMLDS_GetRowCount()-1,'');
  _this.XMLDS_SetStringAt(r,0,"合计：");
  for(c=1;c<cols;c++)
  {
    _this.XMLDS_SetStringAt(r,c,sums[c]);
  }
  
}
// 点击alert 某sql的所有数据
function f_alert (sql)
{
  var url = "<%=usrinfo.getHomeURL()%>/XmlDB.sp?sql="+sql;
  _this.OpenHttpRequest(url,"POST");
  _this.AddHttpRequestParam("sql",sql,0);
  xml=_this.SendHttpRequest();
  _this.CloseHttpRequest();
  _this.XMLDS_Reset();
  _this.XMLDS_Parse(xml);
  
}

//如果link非空，则把第0列的值附加到link后，且不显示第0列
function f_showtable (sql,link)
{
  // 画表格及填数据	  
  var TabH = "<table width='95%' align='center' bordercolor='#000000' class='TableBorder' cellpadding='5' cellspacing='0'>" ;
  var TabE = "</table>" ;
  var str = "" ;
  var TdbgColor = "" ;
  var TdAlign = "" ;
  var url = "<%=usrinfo.getHomeURL()%>/XmlDB.sp?sql="+sql;
  _this.OpenHttpRequest(url,"POST");
  _this.AddHttpRequestParam("sql",sql,0);
  xml=_this.SendHttpRequest();
  _this.CloseHttpRequest();
  _this.XMLDS_Reset();
  _this.XMLDS_Parse(xml);
  sumfields();  
    var p0 = 1;
    if(!link) 
      p0=0;
    else
    {
    _this.XMLDS_SetStringAt(_this.XMLDS_GetRowCount()-1,1,_this.XMLDS_GetStringAt(_this.XMLDS_GetRowCount()-1,0));
    _this.XMLDS_SetStringAt(_this.XMLDS_GetRowCount()-1,0,'-1');
    }
  var colcnt = _this.XMLDS_GetColumnCount();
  var rowcnt = _this.XMLDS_GetRowCount();  
  for ( var i=0;i<rowcnt;i++){
  
    str += "<tr height='25' bgcolor='"+TdbgColor+"'>" ;
    if ( i==0 ) {
      TdbgColor = "#d6dff7";	
      str += "<tr height='25' bgcolor='"+TdbgColor+"'>" ;
      for( j=p0;j<colcnt;j++) {
        //设置单元格对齐方式
        if ( j == 0 )
          TdAlign = "center" ;
        else
          TdAlign = "right" ;
        str += "<td align='"+TdAlign+"' class='TdBorderBottom'>" + _this.XMLDS_GetColumnName(j) + "</td>" ;
         j++; // 从第2个开始跳过tip
      }    
    }
    //设置表格行背景色
    if ( i%2 == 0 )
      TdbgColor = "#F2F5FD" ;
    else
      TdbgColor = "#ffffff" ;
  
    str += "<tr height='25' bgcolor='"+TdbgColor+"'>" ;
    var lf = _this.XMLDS_GetStringAt(i,0) != "";  
    for(var j=p0;j<colcnt;j++)
    {
      //设置单元格对齐方式
      if ( j == 0 )
        TdAlign = "center" ;
      else
        TdAlign = "right" ;
//                    onclick="window.location='RepInput.do?orgid=3&id=220&xlsfile=T220.xls';" 
//                    onmouseout="this.style.backgroundColor='#E6F0F7';" > 
      str += "<td align='"+TdAlign+"' onmouseover=\"this.style.backgroundColor='#D3E5FA'; this.style.cursor='hand'; title='"+_this.XMLDS_GetStringAt(i,j+1)+"';\" onmouseout=\"this.style.backgroundColor='"+TdbgColor+"';\" class='TdBorderBottom' >";
      //if(i<_this.XMLDS_GetRowCount()-1)
         if(p0 && (j==p0) && lf) str+= "<A href=# onclick=window.open('"+link + _this.XMLDS_GetStringAt(i,0)+"');>";
      str += _this.XMLDS_GetStringAt(i,j);
      if(p0 && (j==p0) && lf) str += "</A>";
      str += "</td>" ;
      j++; // 从第2个开始跳过tip

    }
    str += "</tr>\n" ;
  }  
  //绘制数据表格外的表格样式
  var DataTab = TabH + str + TabE ;
  var strTemp = "";
  strTemp+="<table border=\"0\" width=\"100%\"cellspacing=\"0\" id=\"table5\" height=\"200\">";
  strTemp+="	<tr>";
  strTemp+="		<td style=\"border-left: 1px solid #3A77BA; border-right: 1px solid #3A77BA; border-bottom: 1px solid #3A77BA; \" bgcolor=\"#FFFFFF\"  valign=\"top\">";
  strTemp+="			<table width=\"100%\" cellspacing=\"6\"><tr><td><font color=\"#014E82\">"+DataTab+"</font> </td></tr></table>";
  strTemp+="　	</td>";
  strTemp+="	</tr>";
  strTemp+="</table>";
  
  return strTemp;
}

function selectsoday(typ)
{
  d = window.showModalDialog('selectDay.jsp');
  if(!d)
    return;
  if(typ=='so')
  {
    sodat=d;
    f_showso();
  }
  else
  {
    podat=d;
    f_showpo();
  }
}
</script>

<body topmargin="0" leftmargin="0" onload="javascript:winonload();"  onresize="javascript:winonresize();">
<table width="100%" height="100%" bgcolor="#2547BC"><tr><td>
<table align="center" border="0" cellspacing="1" background="images/bg_grid.gif" cellspacing="0">
	<tr>
		<td align="center" height="60" background="" >
    <img src="images/bananer.gif"/><input type='button' onclick='javascript:window.location="login.jsp";' value='退出登录' name='B1' style="border:1px solid #7F9DB9; width:60px; padding-left:4px; padding-right:4px; padding-top:1px; padding-bottom:1px; background-image: url(../xlsgrid/images/bluebk.gif);"/>
    </td>
	</tr>
	<tr>
		<td align="left" valign="top" colspan="2" bgcolor="#FFFFFF" height="290">
<div id=loading style="display:block" ><center>正在载入数据，请稍等.....</center></div>
		<table id=content style='display:none' border="0" width="100%" id="table3" height="269" cellspacing="3" cellpadding="2">
			<tr>
				<td width="676" bgcolor="#D1E2FE" align="left" valign="top">
				  <TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
				    <tr>
				      <td width="30">
				        <img border="0" src="../xlsgrid/images/my/bartop.jpg" width="30" height="14"/>
				      </td>
				      <td width="100%" align="center">&nbsp;最后汇总时间：<%=sUpdateDat%>&nbsp;<a href="javascript:if(confirm('重新汇总全国各地数据，会花费一点时间，一般情况下，系统会在中午和晚上执行，现在是否继续？')==1)window.location='Datasum.jsp?action=update';">点击这里汇总</a></td>
				      <td align="right">
				        <img border="0" src="../xlsgrid/images/my/bartop.jpg" width="30" height="14"/>
				      </td>
				    </tr>
				    <TR bgcolor="#ffffff">
				      <TD class="winLcell" height="23" colspan="2">
				        <IMG height="9" src="images/tutu10.gif" width="9" border="0"/><a name="销售统计"></a>销售统计&nbsp;&nbsp;[ 
				        <A href="javascript:f_refreshso(-1);">上一天&nbsp;</A><a id='dissodate'/> 
				        <A href="javascript:f_refreshso(1);">&nbsp;下一天</A>]
				      <a href="#"> <IMG onclick="selectsoday('so');" src="../xlsgrid/images/forderopen.gif" border="0"/> </a>   &nbsp;&nbsp;
				        <input onclick="soinner(event.srcElement)" type="checkbox" checked/>含内部交易</input>
                </TD>
				      <TD class="winRcell">
				        <IMG height="15" src="../xlsgrid/images/my/barright.jpg" width="22" align="right" border="0"/>
				      </TD>
				    </TR>
				    <TR bgcolor="#ffffff">
				      <TD colspan="3" class="winBcell" id='SOTEXT'>　</TD>
				    </TR>
				  </TABLE>
          <br>
				  <TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
				    <TR bgcolor="#ffffff">
				      <TD class="winLcell" height="23" colspan="2">
				        <IMG height="9" src="images/tutu10.gif" width="9" border="0"/><a name="采购统计"></a>采购统计&nbsp;&nbsp;[ 
				        <A href="javascript:f_refreshpo(-1);">上一天&nbsp;</A><a id='dispodate'/>
				        <A href="javascript:f_refreshpo(1);">&nbsp;下一天</A>]
                <a href=#><IMG onclick='selectsoday("po");' src="../xlsgrid/images/forderopen.gif" border="0"/></a>
                 &nbsp;&nbsp;
                 <input onclick="poinner(event.srcElement)" type="checkbox" checked>含内部交易</input>
				      </TD>
				      <TD class="winRcell">
				        <IMG height="15" src="../xlsgrid/images/my/barright.jpg" width="22" align="right" border="0"/>
				      </TD>
				    </TR>
				    <TR bgcolor="#ffffff">
				      <TD id='POTEXT' colspan="3" class="winBcell">　</TD>
				    </TR>
				  </TABLE>
          <br>
          <TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
				    <TR bgcolor="#ffffff">
				      <TD class="winLcell" height="23" colspan="2">
				        <IMG height="9" src="images/tutu10.gif" width="9" border="0"/><a name="库存统计"></a>[<a id="accname">全部</a>]存库统计&nbsp;
                <%
          // 以下显示为下拉式表列,条件是记录数小于listmaxcount(20)行
       
          out.print("<select id=orglist onchange=OrgSelectChange(orglist)>");
          String tmpId = "", tmpName = "";
          out.print("<option>全部</option>");
          for ( int i = 0 ; i < OrgDs.getRowCount(); i ++ ) {
             tmpId = OrgDs.getStringAt(i,"ID");
             tmpName = OrgDs.getStringAt(i,"NAME");
             out.print("<option value='" + tmpId + "'>" + tmpName  + "</OPTION>");              
          }
          out.print("\n</select>");
                %>
                <a id=marqueen0 />
				      </TD>
				      <TD class="winRcell">
				        <IMG height="15" src="../xlsgrid/images/my/barright.jpg" width="22" align="right" border="0"/>
				      </TD>
				    </TR>
				    <TR bgcolor="#ffffff">
				      <TD id="INVTEXT" colspan="3" class="winBcell">　</TD>
				    </TR>
				    </TABLE>
          <div id=moreitem >　</div>
				</td>
				<td bgcolor="#D1E2FE" valign="top" width="302" height='10%' colspan="2">
				  <TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
				    <tr>
				      <td width="30">
				        <img border="0" src="../xlsgrid/images/my/bartop.jpg" width="30" height="14"/>
				      </td>
				      <td width="100%" align="center">　</td>
				      <td align="right">
				        <img border="0" src="../xlsgrid/images/my/bartop.jpg" width="30" height="14"/>
				      </td>
				    </tr>
				  </TABLE>
				  <TABLE width="100%" border="0" cellspacing="0" cellpadding="0">
				    <TR bgcolor="#ffffff">
				      <TD class="winLcell" height="23" colspan="2">
				        <IMG height="9" src="images/tutu10.gif" width="9" border="0"/>目录 
				      </TD>
				      <TD class="winRcell">
				        <IMG height="15" src="../xlsgrid/images/my/barright.jpg" width="22" align="right" border="0"/>
				      </TD>
				    </TR>
				    <TR bgcolor="#ffffff">
				      <TD colspan="3" class="winBcell" >
				        
				        <div id="checkDiv">
							<blockquote>
								<BR>1、<a href="#销售统计">销售统计</a></BR><BR>2、<a href="#采购统计">采购统计</a><BR>
								<BR>3、<a href="#库存统计">库存统计</a><BR>
							</blockquote>
						</div>
				      </TD>
				    </TR>
				  </TABLE>
				  <br/>
				  </td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</td></tr></table>
<OBJECT id=_this width="0" height="0" style="LEFT: 0px; WIDTH: 0px; TOP: 0px; HEIGHT: 0px"
  classid=clsid:37CC6FCD-9BF5-4433-B3F3-576E08025EA8
  CODEBASE=\"activex/xlsGrid.ocx\">
      <PARAM NAME=_Version VALUE=65536>
    <PARAM NAME=_ExtentX VALUE=9684>
    <PARAM NAME=_ExtentY VALUE=5080>
    <PARAM NAME=_StockProps VALUE=0>
</OBJECT>
</body>
</html>