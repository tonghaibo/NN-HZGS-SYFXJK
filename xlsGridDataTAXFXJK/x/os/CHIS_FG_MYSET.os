function x_CHIS_FG_MYSET(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");	
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var ret = "";
var pub = new JavaPackage ( "com.xlsgrid.net.pub" );
var EAScript= new JavaPackage ( "com.xlsgrid.net.pub.EAScript");
var baskpack = new JavaPackage ( "com.xlsgrid.net" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web");	
var xmlpack = new JavaPackage ( "com.xlsgrid.net.xmldb");
var layoutpack = new JavaPackage ( "com.xlsgrid.net.layout");
var grdpack = new JavaPackage ( "com.xlsgrid.net.grd");	
var langpack = new JavaPackage ( "java.lang");


//
// 
//
function GetBody(){
var html="
        	<ul class=\"mainmenu\" style=\"display:none;\"></ul>
		<table id=\"PAGE_MAIN_app\" border=\"0\" width=\"100%\"  height=100% id=\"TABLE_MAIN\" cellspacing=\"3\" cellpadding=\"0\" >
			<tr ><!-- 单元格 TABLE-->
			<td  onclick=\"javascript:openWindow('L.sp?id=CHARTCHIS');\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"CENTER\" valign=\"MIDDLE\" style=\"margin:0;border:0;background-color:#1859B7;\" colspan=2>
			<!-- layout item 0_0-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_146.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">体征检测图</font></td></tr></table>
			<!-- end layout item 0_0-->
			</td><!-- 单元格 TABLE-->
			<td  onclick=\"javascript:openWindow('L.sp?id=SVGCHIS');\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"CENTER\" valign=\"MIDDLE\" style=\"margin:0;border:0;background-color:#04AEDA;\">
			<!-- layout item 0_2-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_120.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">病程分析图</font></td></tr></table>
			<!-- end layout item 0_2-->
			</td></tr><tr ><!-- 单元格 TABLE-->
			<td  onclick=\"javascript:openWindow('L.sp?id=ME_BASICCHIS');\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"CENTER\" valign=\"MIDDLE\" style=\"margin:0;border:0;background-color:#00A9EC;\">
			<!-- layout item 1_0-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_119.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">既往病史</font></td></tr></table>
			<!-- end layout item 1_0-->
			</td><!-- 单元格 TABLE-->
			<td  onclick=\"javascript:openWindow('L.sp?id=ME_BASICCHIS');\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"\" valign=\"\" style=\"margin:0;border:0;background-color:#E4696A;\">
			<!-- layout item 1_1-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_47.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">门急诊及住院信息</font></td></tr></table>
			<!-- end layout item 1_1-->
			</td><!-- 单元格 TABLE-->
			<td  onclick=\"javascript:openWindow('L.sp?id=ME_BASICCHIS');\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"\" valign=\"\" style=\"margin:0;border:0;background-color:#00A8EC;\">
			<!-- layout item 1_2-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_134.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">检查检验信息</font></td></tr></table>
			<!-- end layout item 1_2-->
			</td></tr><tr ><!-- 单元格 TABLE-->
			<td  onclick=\"javascript:openWindow('L.sp?id=ME_BASICCHIS');\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"CENTER\" valign=\"MIDDLE\" style=\"margin:0;border:0;background-color:#36729E;\">
			<!-- layout item 2_0-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_111.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">线上诊断</font></td></tr></table>
			<!-- end layout item 2_0-->
			</td><!-- 单元格 TABLE-->
			<td  onclick=\"javascript:openWindow('L.sp?id=ME_BASICCHIS');\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"CENTER\" valign=\"MIDDLE\" style=\"margin:0;border:0;background-color:#AA3F41;\">
			<!-- layout item 2_1-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_112.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">穿戴设备</font></td></tr></table>
			<!-- end layout item 2_1-->
			</td><!-- 单元格 TABLE-->
			<td  onclick=\"javascript:openWindow('L.sp?id=ME_BASICCHIS');\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"\" valign=\"\" style=\"margin:0;border:0;background-color:#04AEDA;\">
			<!-- layout item 2_2-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_136.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">家庭自测数据</font></td></tr></table>
			<!-- end layout item 2_2-->
			</td></tr><tr ><!-- 单元格 TABLE-->
			<td  onclick=\"javascript:openWindow('L.sp?id=LOGINCHIS');\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"CENTER\" valign=\"MIDDLE\" style=\"margin:0;border:0;background-color:#54C104;\">
			<!-- layout item 3_0-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_253.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">注册信息</font></td></tr></table>
			<!-- end layout item 3_0-->
			</td><!-- 单元格 TABLE-->
			<td  onclick=\"javascript:openWindow('L.sp?id=LOGINCHIS');\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"\" valign=\"\" style=\"margin:0;border:0;background-color:#009F3C;\">
			<!-- layout item 3_1-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_150.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">个人信息</font></td></tr></table>


			<!-- end layout item 3_1-->
			</td><!-- 单元格 TABLE-->
			<td  onclick=\"javascript:window.location='L.sp?id=BKLOGINCHIS';\" onmouseover=\"this.style.cursor='hand';\" width=\"0\" height=0 align=\"\" valign=\"\" style=\"margin:0;border:0;background-color:#009F3C;\">
			<!-- layout item 3_1-->
			<table cellpadding=0 cellspacing=0 height=100% width=100%><tr height=80%><td align=center valign=bottom><img  width=\"80\" height=\"80\"  src='sytx/chisimg/icon_26.png'></td></tr><tr height=20%><td align=center style=\"background-color: rgba(66,66,66,0.5);\"><font size=\"3\" color=\"#FFFFFF\">登录系统</font></td></tr></table>


			<!-- end layout item 3_1-->
			</td><!-- 单元格 TABLE-->
			</tr></table>

";
return html;

}
//获取滚动图片
function genSTR(str){

	var sql="";
	var ds="";
	var db=null;
	db = new pubpack.EADatabase();
	var layid="";
	try{
		sql="
			SELECT B.* FROM LAYOBJ A ,LAYOBJDTL B  
			WHERE A.GUID=B.FORMGUID 
			AND A.ID ='CHIS_FGos' AND A.CLS='CHIS'and B.id ='"+str+"'
		";
		ds=db.QuerySQL(sql);
		if(ds.getRowCount()==1){
			layid=ds.getStringAt(0,"VAL");
			return layid; 
		}
	}
	catch(e){ throw new Exception(e);}
	if(db!=null){db.Close();}
}

function getlayout(request,layoutid){
	var db = null;
	var msg= "";
	var objid= pubpack.EAFunc.NVL( request.getParameter("objid"),"") ;
	var skin= pubpack.EAFunc.NVL( request.getParameter("skin"),"") ;
	var hashead = pubpack.EAFunc.NVL( request.getParameter("hashead"),"y") ;
	var deforg =  pubpack.EAFunc.NVL( request.getParameter("thisorgid"),webpack.EAWebDeforg.GetDeforg(request)) ;
	var browsetype = pubpack.EAFunc.getBroswerType( request );
	var sb=new langpack.StringBuffer();
	try{	
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var parent = new x_L();
		parent.GetLayoutHTML(db,request,sb,deforg,layoutid,0,"","");
	}
		catch ( ee ) {
			db.Rollback();
			sb.append(ee.toString());
			//throw new pubpack.EAException ( ee.toString() );
		}
		finally {
			if (db!=null) db.Close();
		}

	return sb.toString();
}

}