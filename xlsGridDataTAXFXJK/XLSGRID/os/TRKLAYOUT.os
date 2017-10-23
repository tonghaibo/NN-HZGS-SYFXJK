function XLSGRID_TRKLAYOUT(){var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );
var webpack = new JavaPackage ( "com.xlsgrid.net.web" );


// 插入日志
// logtyp: 日志分类，比如TRKHDR
// logtypnam: 日志分类,如已读
// guid: 参考编号
// name: 事务的说明，比如新建的事务的标题
// note: 事务的详细内容，删除一个事务的时候，这里保存事务的明细
// prj 项目
function OALOG( db,loginorgid ,loginusrid,logtyp,logtypnam,guid,name,note ,prj ) 
{
	var sql = "insert into OALOG(org,usrid,usrnam,mwtyp,action,bilid,name,note,prj)"+
	       "select a.org,a.id,a.name,'"+logtyp+"','"+logtypnam+"' ,'"+guid+"', '"+name+"','"+note+"','"+prj+"' from usr a where a.id='"+loginusrid +"' and a.org='"+loginorgid +"' ";
	//throw new Exception("log错误:"+sql );
	db.ExcecutSQL(sql);
}

function test()
{
	return txt ;

}




// 得到某个trk的主界面
// 客户端: trkguid 对应trkhdr的guid
function trkquery()
{
	var db = null;
	var msg= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var loginusrid = usrinfo.getUsrid();
	var loginorgid = usrinfo.getusrOrg();	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sql = "select a.noteblob,a.guid,a.id,a.title,a.note,a.prio,to_char(a.crtdat,'YYYY-MM-DD HH24:MI:SS') crttim,b.name crtusr,b.id crtusrid,a.stat,a.dtlusr,a.project,a.filepath,a.filenote,a.imagepath,a.imagenote,a.show,a.selforg from trkhdr a,usr b where a.crtusr=b.id and a.SELFORG=b.org and  a.guid='"+trkguid +"'";
		var ds = db.QuerySQL(sql);
		
		if ( ds.getRowCount() > 0 ) {
			var id = ds.getStringAt(0,"id");
			msg += "<p align=center ><font size=3>"+ds.getStringAt(0,"title")+"</font></p>";
			msg += "<p align=center><font color=#808080>"+ds.getStringAt(0,"crtusr")+" "+ds.getStringAt(0,"crttim")+"</font></p>";
			
			var note = ds.getStringAt(0,"note"); 
			if(note=="") note += db.getBlob2String(sql,"noteblob");
			note = pubpack.EAFunc.Replace(note,"\n","<br>");//替换换行键
			note = pubpack.EAFunc.Replace(note,"\r","<br>");//替换换行键
			note = pubpack.EAFunc.Replace(note,"\u0009","&nbsp;&nbsp;&nbsp;&nbsp;");//替换tab键
			msg += "<font size=2 >"+note+"</font>";
			var filenote = ds.getStringAt(0,"filenote");
//			var filenotes = filenote.split("\");
//			if (filenotes.length>0 )
//				 filenote = filenotes[filenotes.length-1];
			var imagenote = ds.getStringAt(0,"imagenote");
//			var imagenotes = imagenote.split("\\");
//			if ( imagenotes.length>0 ) 
//				imagenote = imagenotes[imagenotes.length-1];
			
			
			var filepath = ds.getStringAt(0,"filepath");
			if ( filepath !="" ) {
				var idx = filenote.indexOf("\\");
				while(idx>=0 ) {
					var idx1 = filenote.indexOf("\\",idx+1);
					if ( idx1>= 0 ) idx = idx1;
					else break;
				}
				if ( idx>=0 ) 
					filenote = filenote.substring(idx+1);
				msg += "<p><font color=#FF0000 >下载附件：<a href=\"downloadFile.sp?unzip=1&filename="+filepath+"\">"+filenote+"</a>&nbsp;<a href=\"downloadFile.sp?format=zip&filename="+filepath+"\">压缩下载</a></font></p>";
			}
			if ( ds.getStringAt(0,"imagepath")!="" ) 
				msg += "<p><font color=#FF0000 >屏幕截图：<a href=\"downloadFile.sp?format=zip&filename="+ds.getStringAt(0,"imagepath")+"\">压缩下载</a>&nbsp;<a href=\"downloadFile.sp?unzip=1&format=rtf&filename="+ds.getStringAt(0,"imagepath")+"\">原始下载</a></font></p>";
				
//			if ( loginusrid ==ds.getStringAt(0,"crtusrid")&& ds.getStringAt(0,"selforg")== loginorgid  )
//				msg+="&nbsp;&nbsp;<a href=\"show.sp?grdid=TRK_TRKDTL&datacc=XLSGRID&guid="+ds.getStringAt(row,"guid")+"\"  target=_blank >编辑</a>";
		
			if ( loginusrid ==ds.getStringAt(0,"crtusrid")&& ds.getStringAt(0,"selforg")== loginorgid  )
				msg+="<p align='right'><a href=\"show.sp?grdid=HDRTRK&datacc=XLSGRID&&edit=modify&id="+ds.getStringAt(0,"id")+"&style=2&dd=0\"  target=_blank >编辑</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href=\"#\" onclick=\"javascript:if(confirm('结束该事务，是否继续？')==1)window.location='XLSGRID.TRKLAYOUT.DelTrk.osp?trkguid="+trkguid+"';\" >删除<a/>&nbsp;&nbsp;"+"</p>";
			else {
				var cnt = 1* db.GetSQL( "select count(*) from OALOG where mwtyp='READ' and bilid='"+trkguid+"' and usrid='"+loginusrid +"' and org='"+loginorgid +"' ");
				if( cnt == 0 ){
					//throw new Excetpion(ds.getStringAt(0,"title"));
					OALOG( db,loginorgid ,loginusrid,"READ","已读",trkguid,ds.getStringAt(0,"title"),"",ds.getStringAt(0,"project") ) ;
					db.Commit();
				}	                
			
			}
		}
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}

// 处理过程
function trkquerydtl()
{
	var db = null;
	var msg= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var loginusrid = usrinfo.getUsrid();
	var loginorgid = usrinfo.getusrOrg();	
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sql = "select a.title,a.pro_note,b.name tousr,to_char(a.crtdat,'YYYY-MM-DD HH24:MI:SS') crttim,c.name crtusr,c.id crtusrid,dtltyp,a.guid ,a.selforg,a.filepath, a.filenote,a.imagepath, a.imagenote "+
		"from trkdtl a , usr b, usr c where a.trkguid='"+trkguid +"' and a.tousr=b.id(+) and a.AIMORG=b.org(+) and a.crtusr=c.id and a.selforg=c.org and NVL(a.dtltyp,' ')<>'2' order by a.crtdat asc";
		var ds = db.QuerySQL(sql);
		if ( ds.getRowCount() == 0 ) msg+="没有处理记录" ;
		for ( var row=0;row<ds.getRowCount();row ++ ) {
			msg +="<p>"+(row+1)+"."+ds.getStringAt(row,"crtusr")+"于"+ds.getStringAt(row,"crttim");
			var dtltyp  = ds.getStringAt(row,"dtltyp");
			var guid = ds.getStringAt(row,"guid");

			if (dtltyp   == "2" ) 
				msg += "发表评论";
			else 
				msg += "处理过，并转发给"+ds.getStringAt(row,"tousr");
			msg +="<br>&nbsp;&nbsp;&nbsp;&nbsp;标题："+ds.getStringAt(row,"title")+"<BR>";

			var note = ds.getStringAt(row,"pro_note");
			if ( note.length() > 0 ) {
				note = pubpack.EAFunc.Replace(note,"\n","<BR>&nbsp;&nbsp;&nbsp;&nbsp;");
				msg +="&nbsp;&nbsp;&nbsp;&nbsp;<font color='#333333'>"+note+"</font>";
			}
			var filepath = ds.getStringAt(row,"filepath");
			var filenote = ds.getStringAt(row,"filenote");
			var imagepath = ds.getStringAt(row,"imagepath");
			var imagenote= ds.getStringAt(row,"imagenote");
			
			if ( filepath!="" ) 
				msg += "<p><font color=#FF0000 size=2>下载附件：<a href=\"downloadFile.sp?unzip=1&filename="+filepath+"\">"+filenote+"</a>&nbsp;<a href=\"downloadFile.sp?format=zip&filename="+filepath+"\">压缩下载</a></font>";
			if ( imagepath !="" ) 
				msg += "<BR><font color=#FF0000 size=2>屏幕截图：<a href=\"downloadFile.sp?format=zip&filename="+imagepath+"\">压缩下载</a>&nbsp;<a href=\"downloadFile.sp?unzip=1&format=rtf&filename="+imagepath+"\">原始下载</a></font>";			
			
			//show.sp?grdid=TRK_TRKDTL&datacc=XLSGRID&guid=28518ADFEFA0FC9DE040007F01006EA8&
			if ( loginusrid ==ds.getStringAt(row,"crtusrid")&& ds.getStringAt(row,"selforg")== loginorgid  )
				msg+="<p align='right'><a href=\"show.sp?grdid=TRK_TRKDTL&datacc=XLSGRID&guid="+guid+"\"  target=_blank >编辑</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href=\"#\" onclick=\"javascript:if(confirm('结束该事务，是否继续？')==1)window.location='XLSGRID.TRKLAYOUT.DelTrkDtl.osp?guid="+guid+"&trkguid="+trkguid+"';\" >删除<a/>&nbsp;&nbsp;";
			msg+="</p>";
		}
			
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}
// 事务的评论，和处理过程类似
function trkquerydtlpl()
{
	var db = null;
	var msg= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var loginusrid = usrinfo.getUsrid();
	var loginorgid = usrinfo.getusrOrg();
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sql = "select a.title,a.pro_note,b.name tousr,to_char(a.crtdat,'YYYY-MM-DD HH24:MI:SS') crttim,c.name crtusr,c.id crtusrid,dtltyp,a.guid ,a.filepath, a.filenote,a.imagepath, a.imagenote ,a.crtusr, a.selforg "+
		"from trkdtl a , usr b, usr c where a.trkguid='"+trkguid +"' and a.tousr=b.id(+) and a.AIMORG=b.org(+) and a.crtusr=c.id and a.selforg=c.org and a.dtltyp='2' order by a.crtdat asc";
		var ds = db.QuerySQL(sql);
		if ( ds.getRowCount() == 0 ) msg+="没有处理记录" ;
		for ( var row=0;row<ds.getRowCount();row ++ ) {
			msg +="<p align='center'><font size='3'>"+ds.getStringAt(row,"title")+"</font></p>";
			msg +="<p align='center'>"+ds.getStringAt(row,"crtusr")+"　"+ds.getStringAt(row,"crttim")+"</p>";
			var note = ds.getStringAt(row,"pro_note");
			var guid = ds.getStringAt(row,"guid");

			if ( note.length() > 0 ) {
				note = pubpack.EAFunc.Replace(note,"\n","<BR>");
				msg +="<font color='#333333'>"+note+"</font>";
			}
			var filepath = ds.getStringAt(row,"filepath");
			var filenote = ds.getStringAt(row,"filenote");
			var imagepath = ds.getStringAt(row,"imagepath");
			var imagenote= ds.getStringAt(row,"imagenote");
			
			if ( filepath!="" ) 
				msg += "<p><font color=#FF0000 size=2>下载附件：<a href=\"downloadFile.sp?unzip=1&filename="+filepath+"\">"+filenote+"</a>&nbsp;<a href=\"downloadFile.sp?format=zip&filename="+filepath+"\">压缩下载</a></font>";
			if ( imagepath !="" ) 
				msg += "<BR><font color=#FF0000 size=2>屏幕截图：<a href=\"downloadFile.sp?format=zip&filename="+imagepath+"\">压缩下载</a>&nbsp;<a href=\"downloadFile.sp?unzip=1&format=rtf&filename="+imagepath+"\">原始下载</a></font>";			

			//show.sp?grdid=TRK_TRKDTL&datacc=XLSGRID&guid=28518ADFEFA0FC9DE040007F01006EA8&
			if ( loginusrid ==ds.getStringAt(row,"crtusrid")&& ds.getStringAt(row,"selforg")== loginorgid  )
				msg+="<p align='right'><a href=\"show.sp?grdid=TRK_TRKDTL&datacc=XLSGRID&guid="+ds.getStringAt(row,"guid")+"\"  target=_blank >编辑</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href=\"#\" onclick=\"javascript:if(confirm('结束该事务，是否继续？')==1)window.location='XLSGRID.TRKLAYOUT.DelTrkDtl.osp?guid="+guid+"&trkguid="+trkguid+"';\" >删除<a/>&nbsp;&nbsp;</p>";
			msg+="<HR>";
		}
			
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}

// 得到某个trk的头信息，主要列在trk主界面的左边，包括有操作按钮
// 客户端: trkguid 对应trkhdr的guid
function trkhdr()
{
	var db = null;
	var msg= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var loginusrid = usrinfo.getUsrid();
	var loginorgid = usrinfo.getusrOrg();
	
	var browser =pubpack.EAFunc.getBroswerType(request);
	

	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sql = "select a.id,a.title,b.id prjid,b.name prjnam,a.prio,e.name trktyp,to_char(a.crtdat,'YYYY-MM-DD HH24:MI:SS') crttim,a.crtusr,d.name statname,a.stat,a.dtlusr,c.name dtlusrnam,a.aimorg,a.project,a.filepath,a.filenote,a.imagepath,a.imagenote,a.show,a.selforg from trkhdr a, prj b,usr c,v_trkstat d,v_trktyp e where a.show=e.id and a.stat=d.id and a.dtlusr=c.id(+) and a.aimorg=c.org(+) and a.project=b.id and a.guid='"+trkguid +"'";
		var ds = db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			var id = ds.getStringAt(0,"id");
			var usrid = ds.getStringAt(0,"DTLUSR");
			var usrorgid = ds.getStringAt(0,"AIMORG");
			var crtid = ds.getStringAt(0,"CRTUSR");
			var crtorgid = ds.getStringAt(0,"SELFORG");
			var show = ds.getStringAt(0,"SHOW");
			var prjid = ds.getStringAt(0,"PRJID");
			var stat = ds.getStringAt(0,"STAT");
			var trktyp = ds.getStringAt(0,"TRKTYP");


			
			msg += "<p align=left><font size=2 color=#808080>项目:"+ds.getStringAt(0,"prjnam")+"<BR>类型："+trktyp+"<BR>编号:"+ds.getStringAt(0,"id")+"<BR>优先级:"+ds.getStringAt(0,"prio")+"<BR>状态:"+ds.getStringAt(0,"statname")+"<BR>流转到:"+ds.getStringAt(0,"dtlusrnam")+"</font></p>" ;
			if (stat != "3" ) {
				if ( loginusrid ==usrid && usrorgid == loginorgid  ){
					if(browser=="4"){
						//msg += "<p align=center>您该处理该事务<BR>【<a href='show.sp?grdid=HDRTRK&hdrordtl=2&hdrguid="+trkguid+"&style="+show +"&prjid="+prjid +"&edit=&dd=' target=_blank>处理事务</a>】" ;
						msg += "<p align=center>您该处理该事务<BR>【<a href='show.sp?grdid=j2me_newtrk&hdrordtl=2&hdrguid="+trkguid+"&style="+show +"&prjid="+prjid +"&edit=&dd=&browser=4' target=_blank>处理事务</a>】" ;
						msg += "<BR>【<a href='show.sp?grdid=j2me_newtrk&hdrordtl=2&hdrguid="+trkguid+"&tousrid="+ds.getStringAt(0,"crtusr")+"&action=reply&style="+show +"&prjid="+prjid +"&edit=&dd=' target=_blank>回复事务</a>】" ;
					}else{
						//msg += "<p align=center>您该处理该事务<BR>【<a href='show.sp?grdid=j2me_newtrk&hdrordtl=2&hdrguid="+trkguid+"&style="+show +"&prjid="+prjid +"&edit=&dd=&browser=4' target=_blank>手机处理事务</a>】" ;

						msg += "<p align=center>您该处理该事务<BR>【<a href='show.sp?grdid=HDRTRK&hdrordtl=2&hdrguid="+trkguid+"&style="+show +"&prjid="+prjid +"&edit=&dd=' target=_blank>处理事务</a>】" ;
						msg += "<BR>【<a href='show.sp?grdid=HDRTRK&hdrordtl=2&hdrguid="+trkguid+"&tousrid="+ds.getStringAt(0,"crtusr")+"&action=reply&style="+show +"&prjid="+prjid +"&edit=&dd=' target=_blank>回复事务</a>】" ;
					}
					
					msg += "<BR>【<a href='show.sp?grdid=HDRTRK&hdrordtl=2&hdrguid="+trkguid+"&tousrid="+ds.getStringAt(0,"dtlusr")+"&action=waiting&style="+show +"&prjid="+prjid +"&edit=&dd=' target=_blank>设为处理中</a>】" ;//todoing=y
					msg+"</p>";

				}
				
				if ( loginusrid ==crtid && usrorgid == crtorgid  ){
					if(browser=="4"){
						msg += "<p align=center>您可以结束该事务<BR>【<a href=\"XLSGRID.TRKLAYOUT.EndTrk.osp?trkguid="+trkguid+"\"  >结束事务</a>】" ;
					}else{
						msg += "<p align=center>您可以结束该事务<BR>【<a href=\"#\" onclick=\"javascript:if(confirm('结束该事务，是否继续？')==1)window.location='XLSGRID.TRKLAYOUT.EndTrk.osp?trkguid="+trkguid+"';\" >结束事务</a>】" ;
					}//msg += "<BR>【<a href='show.sp?grdid=HDRTRK&hdrordtl=2&style="+show +"&edit=&dd=' target=_blank>评分</a>】</p>" ;
				}
			}
			if(browser=="4"){
				msg += "<p align=center>您可以发表评论<BR>【<a href=\"show.sp?grdid=j2me_newtrk&hdrordtl=3&hdrguid="+trkguid+"&style="+show +"&prjid="+prjid +"&edit=&dd=\" >发表评论</a>】</p>" ;
				
			}else{
				msg += "<p align=center>您可以发表评论<BR>【<a href=\"#\" onclick=\"javascript:window.open('show.sp?grdid=HDRTRK&hdrordtl=3&hdrguid="+trkguid+"&style="+show +"&prjid="+prjid +"&edit=&dd=');\">发表评论</a>】</p>" ;
			}
		}
		sql = "select title,pro_note,tousr,to_char(a.crtdat,'YYYY-MM-DD HH24:MI:SS') crttim,crtusr from trkdtl a where trkguid='"+trkguid +"' order by crtdat asc";
		
			
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}

//显示当前位置
function trklocal()//按分类查询的"我的位置"显示
{
	var db = null;
	var msg= "";
	var DATE="";
	try {DATE  = date ;} catch ( e ) {DATE="";}
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sql = "";
		
		// 日期
		if ( DATE!="" ) {
			msg +="创建日期:"+ DATE+"<BR>";
		}
		// 查找项目
		sql = "select '项目:'||b.name name from prj b where b.id = '"+trkprj+"'" ;
		var ds = db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			msg += ds.getStringAt(0,"name")+"<BR>";
		}
		// 查找创建人
		sql = "select '创建人:'||b.name name  from usr b where b.id = '"+trkusr+"'" ;
		ds = db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			msg += ds.getStringAt(0,"name")+"<BR>";
		}
		
		// 查找事务类型
		sql = "select '类型:'||b.name||'<BR>说明:'||b.note||'<BR>' name from trktyp b where b.id = '"+trktyp+"'" ;
		ds = db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			msg += ds.getStringAt(0,"name");
			msg+="<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='show.sp?grdid=HDRTRK&style="+trktyp+"&edit=save&dd=0&prj="+trkprj+"' target=\"_blank\">新增事务>></a>";
		}
		
		
			
		
//		var sql = "  SELECT MAX(a.ID) ID,MAX(A.GUID) GUID,"+
//        	"a.name||''||(case MAX(C.COU) when 1 then '-->'||max(c.name)||'' else '' end)||'<BR>'||note||'<BR>&nbsp;&nbsp;&nbsp;&nbsp;<a href=''show.sp?grdid=HDRTRK&style="+trktyp+"&edit=save&dd=0&prj="+trkprj+"''>新增事务>></a>' NAME "+
//        	"FROM (select '类型:'||b.name name,b.guid,b.id,'说明:'||b.note note from trktyp b where b.id = '"+trktyp+"') A,"+
//       		"(select max(d.name) name,count(*) COU from prj d where d.id = '"+trkprj+"' ) C "+
//  		"group by a.name,a.note";
//		var ds = db.QuerySQL(sql);
//		if ( ds.getRowCount() > 0 ) {
//			msg = ds.getStringAt(0,"name");
//		}
//		
	}
	
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}
// 首页的登录信息
function LoginInfo()
{
	var ret= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var usrid = usrinfo.getUsrid();
	var usrorgid = usrinfo.getusrOrg();
	var db = null;
	ret = "欢迎您，"+usrinfo.getUsrnam()+"<BR>";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sql = "select * from( select to_char(crtdat,'MM/DD HH24:MI') tim from usrlog where usrid='"+usrid +"' and org='"+usrorgid +"' and action='登录系统' order by crtdat desc) where rownum<=2 ";
		var ds =db.QuerySQL(sql);
		if ( ds.getRowCount() > 1 ) {
			ret+="您最后一次登录时间是"+ds.getStringAt(1,"TIM") +"<BR>";
		}
		sql = " select count(*) CNT from OALOG where usrid='"+usrid +"' and org='"+usrorgid +"' and ( mwtyp='TRKDTL1' or mwtyp='TRKHDR') and to_char(crtdat,'YYMM')=to_char(sysdate,'YYMM')  ";
		ds =db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			ret+="本月事务处理量"+ds.getStringAt(0,"CNT") +"条 ";
		}
		sql = " select count(*) CNT from OALOG where usrid='"+usrid +"' and org='"+usrorgid +"' and to_char(crtdat,'YYMM')=to_char(sysdate,'YYMM') ";
		ds =db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			ret+="活跃度"+ds.getStringAt(0,"CNT") +"<BR>";
		}
		sql = " select to_char(crtdat,'HH24:MI') TIM from SIGNIN where usrid='"+usrid +"' and org='"+usrorgid +"' and to_char(crtdat,'YYMMDD')=to_char(sysdate,'YYMMDD') order by crtdat asc";
		ds =db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			ret+="今天"+ds.getStringAt(0,"TIM")+"已签到<BR>";
		}
		else 
			ret+="<a href=\"show.sp?grdid=TRK_SIGNIN\"  target=_blank><font color='#FF0000'>您今天没签到，点击签到</font></a>";
		//ret+="&nbsp;";
		//ret+="<form name='fsearch' action='Layout.sp'>&nbsp;<input id=\"query\" style='COLOR: #aaaaaa;border: 1px solid #0A246A; font-family:宋体; font-size:9pt' onfocus=\"if(document.all('query').value=='请输入...')document.all('query').value='';\" size=\"18\" value=\"请输入...\" onclick=\" if(this.value=='请输入...')this.value=''\" name=\"query\">&nbsp;<a href=\"#\" onclick=\"fsearch.submit();\">开始搜索</a>";
		//ret+="<a href=\"#\" onclick=\"fsearch.submit();\">开始搜索</a><input type='hidden' name ='id' value='SearchTrk'>";
		//ret+="<input type='hidden' name ='encoding' value='UTF-8'></form>";
		//		ret+="<form name='fsearch' action='Layout.sp'>&nbsp;<input id=\"query\" style='COLOR: #aaaaaa;border: 1px solid #0A246A; font-family:宋体; font-size:9pt' onfocus=\"if(document.all('query').value=='请输入...')document.all('query').value='';\" size=\"18\" value=\"请输入...\" onclick=\" if(this.value=='请输入...')this.value=''\" name=\"query\">&nbsp;<a href=\"#\" onclick=\"fsearch.submit();\">开始搜索</a><input type='hidden' name ='id' value='SearchTrk'><input type='hidden' name ='ignoreencoding' value='1'><input type='hidden' name ='encoding' value='UTF-8'></form>";

	
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}


	return ret;
}

//按项目分类列表 有全部按钮
function trkprjlist(){
	var DATE="";
	try {DATE  = date ;} catch ( e ) {DATE="";}
	var WORKTYPE="1";
	//当worktype=1:只显示title 2:title,note都显示
	try {WORKTYPE  = worktype ;} catch ( e ) {WORKTYPE="1";}

	var db = null;
	var msg= "";//是显示的html语句
	var url="Layout.sp?id="+id+"&trkusr="+trkusr+"&trktyp="+trktyp+"&worktyp="+worktyp+"&worktype="+WORKTYPE+"&date="+DATE;
	//worktyp   1 待办事务 2 创建的事务 3 日志
	var where="";
	if (worktyp=="1"){
		where =" and b.stat<>'3' and e.id not in ('5','6','7','8','9','10','16','17') ";
	}
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sql = "SELECT A.ID,A.NAME||'('||COUNT(*)||')' NAME,A.GUID ,'"+
		url+"&trkprj='|| A.id  url "+
		"FROM PRJ A,TRKHDR B ,trktyp e,v_trkstat d "+
		"WHERE B.PROJECT=A.ID AND B.SHOW LIKE '"+trktyp+"%' "+
		"and b.crtusr like '"+trkusr+"%'"+
		"and b.dtlusr like '"+trkusr+"%'"+
		"and b.show=e.id "+
		"and  b.stat=d.id  "+
		where +
		"and to_char(b.crtdat,'YYYY-MM-DD HH24:MI:SS') like '%"+DATE+"%'"+
		"GROUP BY A.ID,A.NAME,A.GUID "+
		"ORDER BY A.ID";
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
		msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&trkprj="+"';\">"+"全部"+"</a></td></tr>";//添加全部按钮
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//直接返回html语句

}
//按类型分类列表 有全部按钮
function trktyplist(){
	var DATE="";
	try {DATE  = date ;} catch ( e ) {DATE="";}
	var WORKTYPE="1";
	//当worktype=1:只显示title 2:title,note都显示
	try {WORKTYPE  = worktype ;} catch ( e ) {WORKTYPE="1";}

	var db = null;
	var msg= "";//是显示的html语句
	
	var url="Layout.sp?id="+id+"&trkusr="+trkusr+"&trkprj="+trkprj+"&worktyp="+worktyp+"&worktype="+WORKTYPE+"&date="+DATE;
	//worktyp   1 待办事务 2 创建的事务 3 日志
	var where="";
	if (worktyp=="1"){
		where =" and b.stat<>'3' and e.id not in ('5','6','7','8','9','10','16','17') ";
	}
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sql = "SELECT a.id,' '||A.NAME||'('||COUNT(*)||')' NAME,A.GUID ,'"+
		url+"&trktyp='|| A.id  url "+
		"FROM trktyp A,TRKHDR B,trktyp e,v_trkstat d  "+
		"WHERE B.SHOW=A.ID and b.project like '"+trkprj+"%' "+
		"and b.crtusr like '"+trkusr+"%' "+
		"and b.show=e.id "+
		"and  b.stat=d.id  "+
		where+
		"and to_char(b.crtdat,'YYYY-MM-DD HH24:MI:SS') like '%"+DATE+"%'"+
		"GROUP BY A.ID,A.NAME,A.GUID "+
		"ORDER BY A.ID";
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//编写格式,对齐方式为左对齐,置顶
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
		msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&trktyp=';\">"+"全部"+"</a></td></tr>";//添加全部按钮
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//直接返回html语句

}
//按创建人分类列表 有全部按钮
function trkusrlist(){
	var DATE="";
	try {DATE  = date ;} catch ( e ) {DATE="";}
	var WORKTYPE="1";
	//当worktype=1:只显示title 2:title,note都显示
	try {WORKTYPE  = worktype ;} catch ( e ) {WORKTYPE="1";}
	
	
	var db = null;
	var msg= "";//是显示的html语句
	var url="Layout.sp?id="+id+"&trktyp="+trktyp+"&trkprj="+trkprj+"&worktyp="+worktyp+"&worktype="+WORKTYPE+"&date="+DATE;
	var where="";
	//worktyp   1 待办事务 2 创建的事务 3 日志
	if (worktyp=="1"){
		where =" and b.stat<>'3' and e.id not in ('5','6','7','8','9','10','16','17') ";
	}
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sql = "SELECT distinct max(a.id) id,' '||A.NAME||'('||COUNT(*)||')' NAME,max(A.GUID) guid ,'"+
		url+"&trkusr='|| max(A.id)  url "+
		"FROM v_usr9 A,TRKHDR B ,trktyp e,v_usr9 cc ,v_trkstat d "+
		"WHERE B.crtusr=A.ID and b.project like '"+trkprj+"%' "+
		"and b.show like '"+trktyp+"%'"+
		"and b.show=e.id "+
		"and b.crtusr=cc.id  "+
		"and  b.stat=d.id  "+
		where+
		"and to_char(b.crtdat,'YYYY-MM-DD HH24:MI:SS') like '%"+DATE+"%'"+
		"GROUP BY A.NAME ";
//		"ORDER BY A.ID";
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//编写格式,对齐方式为左对齐,置顶
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
		msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&trkusr=';\">"+"全部"+"</a></td></tr>";//添加全部按钮
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//直接返回html语句

}
//按日期查询
function trkdate(){
	//获取当前日期
	var DATE="";
	try {DATE  = date ;
		if (DATE==""){//当DATE为空时,同时也要设定为默认值
			throw new Exception();//抛出错误执行catch
		}
	} catch ( e ) {
		var db=null;
		var sqldate="select sysdate from dual";
		db = new pubpack.EADatabase();
		var ds = db.QuerySQL(sqldate);
		var dat="";
		if ( ds.getRowCount() > 0 ) 
		dat =  ds.getStringAt(0,"sysdate");
		DATE=dat;
	}
	var url="Layout.sp?id="+id+"&trkusr="+trkusr+"&trktyp="+trktyp+"&trkprj="+trkprj+"&worktyp="+worktyp;
	//throw new Exception(DATE);
	var msg="日期"; 
	msg+="<script language=\"javascript\">
	function dateSubmit(form){
	var DATE=document.getElementsByName(\"date\")[0].value;
	var url=\""+url+"&worktype=2&date=\"+DATE+\"\";
	window.location = url;
	}</script>";
	msg+="<input name=\"date\" type=\"\" value=\""+DATE+"\"> <a href=\"#\" onclick=\"dateSubmit()\">查找</a> ";
	
	
	
	
	//显示最近7天的记录
	var DATE="";
	try {DATE  = date ;} catch ( e ) {DATE="";}
	var WORKTYPE="1";
	//当worktype=1:只显示title 2:title,note都显示
	try {WORKTYPE  = worktype ;} catch ( e ) {WORKTYPE="1";}

	var db = null;
	//var msg= "";//是显示的html语句
	//worktyp=区分用来只显示当前用户的事务
	//worktype 是否显示事务的内容
	var url="Layout.sp?id="+id+"&trkusr="+trkusr+"&trkprj="+trkprj+"&worktyp="+worktyp+"&worktype=2&trktyp="+trktyp;
	var where="";
	if (worktyp=="1"){
		where =" and b.stat<>'3' and e.id not in ('5','6','7','8','9','10','16','17') ";
	}
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sql = "SELECT '' id,' '||to_char(b.crtdat, 'YYYY-MM-DD')||'('||COUNT(*)||')' NAME,'' guid ,'"+
		url+"&date='|| to_char(b.crtdat, 'YYYY-MM-DD')  url "+
		"FROM trktyp A,TRKHDR B,trktyp e,v_trkstat d  "+
		"WHERE B.SHOW=A.ID and b.project like '"+trkprj+"%' "+
		"and b.crtusr like '"+trkusr+"%' "+
		"and b.show like '"+trktyp+"%'"+
		"and b.show=e.id "+
		"and  b.stat=d.id  "+
		where+
		"and to_char(b.crtdat, 'YYYY-MM-DD HH24:MI:SS') > to_char(sysdate-7,'YYYY-MM-DD')"+
		"GROUP BY to_char(b.crtdat, 'YYYY-MM-DD')"+
		"ORDER BY to_char(b.crtdat, 'YYYY-MM-DD') desc";
		//throw new Exception(sql);
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}

		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}


	
	
	return msg;
}
//显示事务的列表,包含有显示title,not,或者只显示title的列表, 当worktype=1:只显示title 2:title,note,处理过程等都显示
function trkall(){ 

	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var loginusrid = usrinfo.getUsrid();
	var loginorgid = usrinfo.getusrOrg();
	var DATE="";
	try {DATE  = date ;} catch ( e ) {DATE="";}
	var WORKTYPE="1";
	//当worktype=1:只显示title 2:title,note都显示
	try {WORKTYPE  = worktype ;} catch ( e ) {WORKTYPE="1";}
	var db = null;
	var msg= "";//是显示的html语句
	//	listtyp:  1 为我的待办事务 2 为我创建的事务 3为 日志
	var sql = "";
	
	sql+="select distinct '●' || a.title || ' ' || to_char(a.crtdat, 'YY/MM/DD') ||
	'    ' || b.name name,
	a.id,
	a.guid,
	'Layout.sp?id=trkquery&trkguid=' || a.guid url,
	a.crtdat,a.note,a.title,b.name crtusr,to_char(a.crtdat,'YYYY-MM-DD HH24:MI:SS') crttim,a.filenote,a.imagenote,a.filepath,
	a.imagepath,a.crtusr crtusrid
	from trkhdr a, usr b";
	
	var where= " where b.id(+) = a.crtusr
	and a.show like '"+trktyp+"%'
	and NVL(a.PROJECT, ' ') like '"+trkprj+"%'
	and NVL(a.crtusr, ' ') like '"+trkusr+"%'
	and to_char(a.crtdat,'YYYY-MM-DD HH24:MI:SS') like '%"+DATE+"%'
	order by a.crtdat desc ";
	sql += where;
	//throw new Exception(sql);
	
//	msg= this.list(sql);
	var url="Layout.sp?id=trkquery";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var ds = db.QuerySQL(sql);
		
		if(WORKTYPE=="1"){
			msg=msg+"<td valign=\"top\">"+
			"<font color=\"#014E82\">"+
			"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
			"<tbody>";//编写格式,对齐方式为左对齐,置顶
			
			//
			for( var i=0 ;i<ds.getRowCount()&&i<=500; i++ ) {
				msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
			}
	//		//msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&guid=';\">"+"全部"+"</a></td></tr>";//添加全部按钮
			msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		}else if(WORKTYPE=="2"){//显示内容和处理过程
			
			for( var i=0 ;i<ds.getRowCount()&&i<=500; i++ ) {
				if ( ds.getRowCount() > 0 ) {
					var id = ds.getStringAt(i,"id");
					msg += "<p align=center><font size=3 >"+ds.getStringAt(i,"title")+"<font></p>";//标题
					msg += "<p align=center><font size=2 color=#808080>"+ds.getStringAt(i,"crtusr")+" "+ds.getStringAt(i,"crttim")+"</font></p>";
					
					var note = ds.getStringAt(i,"note");//内容
					note = pubpack.EAFunc.Replace(note,"\n","<BR>");
					msg += "<font size=2 >"+note+"</font>";
					var filenote = ds.getStringAt(i,"filenote");
					var imagenote = ds.getStringAt(i,"imagenote");
		
					//读取附件
					var filepath = ds.getStringAt(i,"filepath");
					if ( filepath !="" ) {
						var idx = filenote.indexOf("\\");
						while(idx>=0 ) {
							var idx1 = filenote.indexOf("\\",idx+1);
							if ( idx1>= 0 ) idx = idx1;
							else break;
						}
						if ( idx>=0 ) 
							filenote = filenote.substring(idx+1);
						msg += "<p><font color=#FF0000 size=2>下载附件：<a href=\"downloadFile.sp?unzip=1&filename="+filepath+"\">"+filenote+"</a>&nbsp;<a href=\"downloadFile.sp?format=zip&filename="+filepath+"\">压缩下载</a></font></p>";
					}
				}
				//下面的循环显示处理的过程
				var db2 = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
				var sql2 = "select a.title,a.pro_note,b.name tousr,to_char(a.crtdat,'YYYY-MM-DD HH24:MI:SS') crttim,c.name crtusr,c.id crtusrid,dtltyp,a.guid ,a.selforg,a.filepath, a.filenote,a.imagepath, a.imagenote "+
				"from trkdtl a , usr b, usr c where a.trkguid='"+ds.getStringAt(i,"guid") +"' and a.tousr=b.id(+) and a.AIMORG=b.org(+) and a.crtusr=c.id and a.selforg=c.org and NVL(a.dtltyp,' ')<>'2' order by a.crtdat asc";
				
				var ds2 = db2.QuerySQL(sql2);
				//msg +=sql2;
				//if ( ds2.getRowCount() == 0 ) msg+="没有处理记录" ;
				for ( var row=0;row<ds2.getRowCount();row ++ ) {
					
					msg +="<p>"+(row+1)+"."+ds2.getStringAt(row,"crtusr")+"于"+ds2.getStringAt(row,"crttim");
					var dtltyp  = ds2.getStringAt(row,"dtltyp");
					var guid = ds2.getStringAt(row,"guid");
		
					if (dtltyp   == "2" ) 
						msg += "发表评论";
					else 
						msg += "处理过，并转发给"+ds2.getStringAt(row,"tousr");
					msg +="<br>&nbsp;&nbsp;&nbsp;&nbsp;标题："+ds2.getStringAt(row,"title")+"<BR>";
		
					var note = ds2.getStringAt(row,"pro_note");
					if ( note.length() > 0 ) {
						note = pubpack.EAFunc.Replace(note,"\n","<BR>&nbsp;&nbsp;&nbsp;&nbsp;");
						msg +="&nbsp;&nbsp;&nbsp;&nbsp;<font color='#333333'>"+note+"</font>";
					}
					
					var filepath = ds2.getStringAt(row,"filepath");
					var filenote = ds2.getStringAt(row,"filenote");
					var imagepath = ds2.getStringAt(row,"imagepath");
					var imagenote= ds2.getStringAt(row,"imagenote");
					
					if ( filepath!="" ) 
						msg += "<p><font color=#FF0000 size=2>下载附件：<a href=\"downloadFile.sp?unzip=1&filename="+filepath+"\">"+filenote+"</a>&nbsp;<a href=\"downloadFile.sp?format=zip&filename="+filepath+"\">压缩下载</a></font>";
					if ( imagepath !="" ) 
						msg += "<BR><font color=#FF0000 size=2>屏幕截图：<a href=\"downloadFile.sp?format=zip&filename="+imagepath+"\">压缩下载</a>&nbsp;<a href=\"downloadFile.sp?unzip=1&format=rtf&filename="+imagepath+"\">原始下载</a></font>";			
					//return sql2;
					//show.sp?grdid=TRK_TRKDTL&datacc=XLSGRID&guid=28518ADFEFA0FC9DE040007F01006EA8&
//					if ( loginusrid ==ds2.getStringAt(row,"crtusrid")&& ds2.getStringAt(row,"selforg")== loginorgid  )
//						msg+="<p align='right'><a href=\"show.sp?grdid=TRK_TRKDTL&datacc=XLSGRID&guid="+guid+"\"  target=_blank >编辑</a>&nbsp;&nbsp;|&nbsp;&nbsp;<a href=\"#\" onclick=\"javascript:if(confirm('结束该事务，是否继续？')==1)window.location='XLSGRID.TRKLAYOUT.DelTrkDtl.osp?guid="+guid+"&trkguid="+trkguid+"';\" >删除<a/>&nbsp;&nbsp;";
//					msg+="</p>";
					
				}
			}
			

		}
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//直接返回html语句

}



//远程调用结束一个事务
//输入参数：trkguid
function EndTrk()
{

	var db = null;
	var msg= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var loginusrid = usrinfo.getUsrid();
	var loginorgid = usrinfo.getusrOrg();
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var ret =db.ExcecutSQL("update trkhdr set stat='3' where guid='"+trkguid+"'");
		db.ExcecutSQL("update trkhdr set stat='3' where guid='"+trkguid+"'");
		var ds = db.QuerySQL( "select title,project from trkhdr where guid='"+trkguid+"'");
		OALOG( db,loginorgid ,loginusrid,"ENDTRK","结束事务",trkguid,ds.getStringAt(0,"title"),"" ,ds.getStringAt(0,"project") ) ;
                  
		msg += "操作成功，更新了"+ret+"笔记录<BR><a href=\"javascript:window.location='Layout.sp?id=trkquery&trkguid="+trkguid+"';\">点击返回</a>" ; 
		db.Commit();			
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}

//远程调用删除一个事务
//输入参数：trkguid
function DelTrk()
{

	var db = null;
	var msg= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var loginusrid = usrinfo.getUsrid();
	var loginorgid = usrinfo.getusrOrg();
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var ds = db.QuerySQL( "select title,note,project from trkhdr where guid='"+trkguid+"'" );
		if ( ds.getRowCount() > 0 ) {
			OALOG( db,loginorgid ,loginusrid,"DELTRKHDR","删除事务",trkguid,ds.getStringAt(0,"title"),ds.getStringAt(0,"note") ,ds.getStringAt(0,"project")  ) ;
		}
                
                var ret =db.ExcecutSQL("delete from trkhdr  where guid='"+trkguid+"'");
		
		msg += "操作成功，更新了"+ret+"笔记录<BR><a href=\"javascript:window.location='Layout.sp?id=trkquery&trkguid="+trkguid+"';\">点击返回</a>" ; 
		db.Commit();			
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}
//远程调用删除一个事务
//输入参数：trkguid
function DelTrkDtl()
{

	var db = null;
	var msg= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var loginusrid = usrinfo.getUsrid();
	var loginorgid = usrinfo.getusrOrg();
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var ds = db.QuerySQL( "select title,pro_note note,dtltyp,project from trkdtl where guid='"+guid+"'" );
		if ( ds.getRowCount() > 0 ) {
			if ( ds.getStringAt(0,"dtltyp")=="2" ) 
				OALOG( db,loginorgid ,loginusrid,"DELTRKDTL1","删除评论",guid,ds.getStringAt(0,"title"),ds.getStringAt(0,"note"),ds.getStringAt(0,"project")  ) ;
			else OALOG( db,loginorgid ,loginusrid,"DELTRKDTL1","删除处理记录",guid,ds.getStringAt(0,"title"),ds.getStringAt(0,"note"),ds.getStringAt(0,"project")  ) ;
		}

		
		var ret =db.ExcecutSQL("delete from trkdtl  where guid='"+guid+"'");
		
		msg += "操作成功，更新了"+ret+"笔记录<BR><a href=\"javascript:window.location='Layout.sp?id=trkquery&trkguid="+trkguid+"';\">点击返回</a>" ; 
		db.Commit();			
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}

//我的待办事务,我创建的事务,日志的显示列表
function trkmylist(){
	
	var db = null;
	var msg= "";//是显示的html语句
	//	listtyp:  1 为我的待办事务 2 为我创建的事务 3为 日志
	var sql = "";
	if(trkusr=="curusr"){//只显示当前用户
		var usr=web.EASession.GetLoginInfo(request);//获取当前用户信息
		trkusr=usr.getUsrid();
	}
	
	
	if(worktyp=="1"){
		sql="select a.title|| ' '||cc.name ||to_char(a.crtdat,'mm/dd hh24:mi') name,substr(a.note,1,25) note ,"+
		"a.guid ,a.id,'Layout.sp?id=trkquery&trkguid='||a.guid url"+
		" from  "+
		"trkhdr a,v_usr c ,trktyp e,v_usr cc "+
		"where "+
		"a.dtlusr=c.id  and a.AIMORG=c.orgid and a.crtusr=cc.id  and a.AIMORG=cc.orgid "+
//		"and c.id=lower('"+usrid+"')   "+
//		"and c.orgid='"+orgid+"'"+
		"and a.show =e.id   "+
		"and a.stat<>'3' "+//-- 0：新建，1：处理中，2：已处理，3：处理完，4：未处理"+
		"and e.id not in ('5','6','7','8','9','10','16','17') "+
		"and a.project like '"+trkprj+"%' "+
		"and a.show like '"+trktyp+"%' "+
		"and a.dtlusr like '"+trkusr+"%'"+
		"order by to_char(a.crtdat,'yyyy-mm-dd hh24:mi:ss') desc ";

	}else if(worktyp=="2"){
		sql="select a.title|| ' '||to_char(a.crtdat,'mm/dd')||' -》'||c.name||' 状态'||d.name name,substr(a.note,1,25) note ,"+
		"a.guid ,a.id,'Layout.sp?id=trkquery&trkguid='||a.guid url"+
		" from  "+
		"trkhdr a,v_usr c ,trktyp e,v_usr cc, v_trkstat d "+
		"where "+
		"a.dtlusr=c.id  and a.AIMORG=c.orgid and a.crtusr=cc.id  and a.SELFORG=cc.orgid "+
		"and a.stat=d.id "+
//		"and cc.id=lower('[%SYS_USRID]')   "+
//		"and cc.orgid='[%SYS_ORGID]'"+
		"and a.show like'"+trktyp+"%'"+
		"and a.project like'"+trkprj+"%'"+
		"and a.crtusr like '"+trkusr+"%'"+
		"and a.show =e.id   "+
		""+
		"order by to_char(a.crtdat,'yyyy-mm-dd hh24:mi:ss') desc ";
	}else if(worktyp=="3"){
		sql="select  distinct ''||a.usrnam ||'  '||to_char(a.crtdat,'mm/dd hh24:mi')||'  '||a.action||substr(a.name,1,16)   name, "+
		"a.guid,a.usrid id,a.crtdat "+
		",'Layout.sp?id=trkquery&guid='||a.bilid||'&trkguid='||a.bilid url "+
		"from OALOG a ,trkhdr b where mwtyp in( 'TRKHDR','TRKDTL1','TRKDTL2','ENDTRK' ) "+
		" and "+
		" b.guid=a.bilid "+
		"and b.show like'"+trktyp+"%'"+
		"and b.project like'"+trkprj+"%'"+
		"and b.crtusr like '"+trkusr+"%'"+
		
		"order by crtdat desc"; 
	}
	
	//throw new Exception(sql);
	

	var url="Layout.sp?id=trkquery";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//编写格式,对齐方式为左对齐,置顶
		var ds = db.QuerySQL(sql);
		//
		for( var i=0 ;i<ds.getRowCount()&&i<=500; i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
//		msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&guid=';\">"+"全部"+"</a></td></tr>";//添加全部按钮
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//直接返回html语句

}


//搜索事务结果的列表
function searchtrk(){ 
	
	var db = null;
	var msg= "";//是显示的html语句
	//	listtyp:  1 为我的待办事务 2 为我创建的事务 3为 日志
	var sql = "";
	var	querywhere = " and (";
			var str=query.split(" ");
			  //throw new Exception(str);
			for(var i=0;i<str.length();i++)    
			{	
				if(i==0){
					querywhere+="  lower( concat(UTL_RAW.CAST_TO_VARCHAR2(a.noteblob),concat(a.title,concat(a.note,to_char(a.crtdat,'yyyy-mm-dd'))))) like lower('%"+str[i]+"%')"; 
				}else{
					querywhere+=" and lower( concat(UTL_RAW.CAST_TO_VARCHAR2(a.noteblob),concat(a.title,concat( a.note,to_char(a.crtdat,'yyyy-mm-dd'))))) like lower('%"+str[i]+"%')"; 
				}
			} 
		querywhere+=") ";
	
	
	sql="SELECT A.id ,";//查询事务的sql语句
		sql+="a.title|| ' '||cc.name||'('||d.name ||')'||to_char(a.crtdat,'yyyy/mm/dd hh24:mi') name,";
		sql+="A.GUID,";
		sql+="'Layout.sp?id=trkquery&trkguid='||a.guid url ";

		sql+="FROM  TRKHDR A,v_usr c ,trktyp e,v_usr cc,trktyp d ";
		sql+="where ";
		sql+="a.dtlusr=c.id(+)  and a.AIMORG=c.orgid(+) and a.crtusr=cc.id  and a.AIMORG=cc.orgid ";
		sql+="and a.show =e.id ";
		sql+="and d.id=a.show ";
		sql+="and a.PROJECT like '"+trkprj+"%'";
		sql+="and a.show like '"+trktyp+"%'";
		sql+="and a.crtusr like '"+crtusr+"%'";
		sql+=querywhere;
		sql+=" order by a.crtdat desc ";
	
	var querywhere = "  (";//查询函数库的sql的条件语句
			var str=query.split(" ");
			  //throw new Exception(str);
			for(var i=0;i<str.length();i++)    
			{	
				if(i==0){
					querywhere+="  lower( concat(a.name,concat(a.note,to_char(a.crtdat,'yyyy-mm-dd')))) like lower('%"+str[i]+"%')"; 
				}else{
					querywhere+=" and lower( concat(a.name,concat( a.note,to_char(a.crtdat,'yyyy-mm-dd')))) like lower('%"+str[i]+"%')"; 
				}
			} 
		querywhere+=") ";
	
	
	var sqlapi="select '' id,'' guid,a.name name,'Layout.sp?id=apiquery&apiguid='||a.guid url from FUNCLIST a where "+querywhere;
	
	//throw new Exception(sqlapi+"|"+sql);
	
//	msg= this.list(sql);
	var url="Layout.sp?id=trkquery";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//编写格式,对齐方式为左对齐,置顶
//		var ds = db.QuerySQL(sqlapi);
//		//
//		for( var i=0 ;i<ds.getRowCount()&&i<=100; i++ ) {
//			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
//		}
//		msg += "<tr><td width=100%  >------------------------------</td></tr>";
		
		
		var ds = db.QuerySQL(sql);
		//
		for( var i=0 ;i<ds.getRowCount()&&i<=500; i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
//		//msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&guid=';\">"+"全部"+"</a></td></tr>";//添加全部按钮
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//直接返回html语句

}
//显示搜索事务的条件
function searchquery(){
	var db = null;
	db = new pubpack.EADatabase();
	var msg= "全部结果 <br> 关键字 \""+query+"\" </br>";//是显示的html语句
	var sql=""; 
	// 查找项目
		sql = "select '项目:'||b.name name from prj b where b.id = '"+trkprj+"'" ;
		var ds = db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			msg += ds.getStringAt(0,"name")+"<BR>";
		}
	// 查找创建人
		sql = "select '创建人:'||b.name name  from usr b where b.id = '"+crtusr+"'" ;
		ds = db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			msg += ds.getStringAt(0,"name")+"<BR>";
		}
		
	// 查找事务类型
		sql = "select '类型:'||b.name||'<BR>说明:'||b.note||'<BR>' name from trktyp b where b.id = '"+trktyp+"'" ;
		ds = db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			msg += ds.getStringAt(0,"name");
			msg+="<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='show.sp?grdid=HDRTRK&style="+trktyp+"&edit=save&dd=0&prj="+trkprj+"' target=\"_blank\">新增事务>></a>";
		}

	return msg;
}
//搜索事务的按项目分类列表 有全部按钮
function searchprjlist(){
	var db = null;
	var msg= "";//是显示的html语句
	var url="Layout.sp?id=SearchTrk&query="+query+""+"&crtusr="+crtusr+"&trktyp="+trktyp;//单击的链接
	var sql="";
	var querywhere="";
	var category="";//分类的查询条件
	// //添加查询条件
	querywhere = " and (";
			var str=query.split(" ");
			  //throw new Exception(str);
			for(var i=0;i<str.length();i++)    
			{	
				if(i==0){
					querywhere+="  lower( concat(B.title,concat(B.note,to_char(b.crtdat,'yyyy-mm-dd')))) like lower('%"+str[i]+"%')"; 
				}else{
					querywhere+=" and lower( concat(B.title,concat( B.note,to_char(b.crtdat,'yyyy-mm-dd')))) like lower('%"+str[i]+"%')"; 
				}
			} 
		querywhere+=") ";
	category = "and b.crtusr like '"+crtusr+"%'"+
			"and b.show like '"+trktyp+"%'";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sql = "select * from (";
				sql+="SELECT A.ID,A.NAME||'('||COUNT(*)||')' NAME,A.GUID ,'"+
					url+"&trkprj='|| A.id  url "+
					"FROM PRJ A,TRKHDR B ,v_usr c ,v_usr cc "+
					"WHERE B.PROJECT=A.ID "+
					" and c.id= b.crtusr  "+
					" and cc.id(+)= b.dtlusr "+
					" and b.AIMORG=c.orgid "+
					" and b.AIMORG=cc.orgid(+) "+
					category;
					
				sql+=querywhere;
				
				sql+="GROUP BY A.ID,A.NAME,A.GUID "+
				"ORDER BY A.ID";
		sql+=") a";
		
		sql+=" union ";
		sql+="select '' id ,"+
                " '全部 ' || '(' || COUNT(*) || ')' NAME , "+
                " '' guid, "+
                " '"+url+"&trkprj=' url "+
		"from TRKHDR B, v_usr c, v_usr cc WHERE   "+
		"c.id = b.crtusr "+
		"and cc.id(+) = b.dtlusr "+
		"and b.AIMORG = c.orgid  "+
		"and b.AIMORG = cc.orgid(+) "+
		category;
           	sql+=querywhere;
		
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//
		
		//throw new Exception(sql);
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
		//msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&trkprj="+"';\">"+"全部"+"</a></td></tr>";//添加全部按钮
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//直接返回html语句

}

//搜索事务的按事务类型分类列表 有全部按钮
function searchtyplist(){
	var db = null;
	var msg= "";//是显示的html语句
	var url="Layout.sp?id=SearchTrk&query="+query+""+"&crtusr="+crtusr+"&trkprj="+trkprj;//单击的链接
	var sql="";
	var querywhere = "";
	var category = "";//分类查询条件
	// //添加查询条件
	querywhere = " and (";
			var str=query.split(" ");
			  //throw new Exception(str);
			for(var i=0;i<str.length();i++)    
			{	
				if(i==0){
					querywhere+="  lower( concat(B.title,concat(B.note,to_char(b.crtdat,'yyyy-mm-dd')))) like lower('%"+str[i]+"%')"; 
				}else{
					querywhere+=" and lower( concat(B.title,concat(B.note,to_char(b.crtdat,'yyyy-mm-dd')))) like lower('%"+str[i]+"%')"; 
				}
			} 
		querywhere+=") ";
	category = "and b.crtusr like '"+crtusr+"%'"+
			"and b.project like '"+trkprj+"%'";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sql = "select * from (";
				sql+="SELECT A.ID,A.NAME||'('||COUNT(*)||')' NAME,A.GUID ,'"+
					url+"&trktyp='|| A.id  url "+
					"FROM trktyp A,TRKHDR B ,v_usr c ,v_usr cc "+
					"WHERE B.show=A.ID "+
					" and c.id= b.crtusr  "+
					" and cc.id(+)= b.dtlusr "+
					" and b.AIMORG=c.orgid "+
					" and b.AIMORG=cc.orgid(+) "+
					category;
				
				sql+=querywhere;
				
				sql+="GROUP BY A.ID,A.NAME,A.GUID "+
				"ORDER BY A.ID";
		sql+=") a";
		
		sql+=" union ";
		sql+="select '' id ,"+
                " '全部 ' || '(' || COUNT(*) || ')' NAME , "+
                " '' guid, "+
                " '"+url+"&trktyp=' url "+
		"from TRKHDR B, v_usr c, v_usr cc WHERE   "+
		"c.id = b.crtusr "+
		"and cc.id(+) = b.dtlusr "+
		"and b.AIMORG = c.orgid  "+
		"and b.AIMORG = cc.orgid(+) "+
		category;
           	sql+=querywhere;
		
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//
		
		//throw new Exception(sql);
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
		//msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&trkprj="+"';\">"+"全部"+"</a></td></tr>";//添加全部按钮
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//直接返回html语句

}
//搜索事务的创建人分类列表 有全部按钮
function searchcrtusrlist(){ 
	var db = null;
	var msg= "";//是显示的html语句
	var url="Layout.sp?id=SearchTrk&query="+query+""+"&trktyp="+trktyp+"&trkprj="+trkprj;//单击的链接
	var sql="";
	var querywhere = "";
	var category = "";//分类查询条件
	// //添加查询条件
	querywhere = " and (";
			var str=query.split(" ");
			  //throw new Exception(str);
			for(var i=0;i<str.length();i++)    
			{	
				if(i==0){
					querywhere+="  lower( concat(B.title,concat(B.note,to_char(b.crtdat,'yyyy-mm-dd')))) like lower('%"+str[i]+"%')"; 
				}else{
					querywhere+=" and lower( concat(B.title,concat(B.note,to_char(b.crtdat,'yyyy-mm-dd')))) like lower('%"+str[i]+"%')"; 
				}
			} 
		querywhere+=") ";
	category = "and b.show like '"+trktyp+"%'"+
			"and b.project like '"+trkprj+"%'";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sql = "select * from (";
				sql+="SELECT A.ID,A.NAME||'('||COUNT(*)||')' NAME,A.GUID ,'"+
					url+"&crtusr='|| A.id  url "+
					"FROM v_usr9 A,TRKHDR B ,v_usr c ,v_usr cc "+
					"WHERE B.crtusr=A.ID "+
					" and c.id= b.crtusr  "+
					" and cc.id(+)= b.dtlusr "+
					" and b.AIMORG=c.orgid "+
					" and b.AIMORG=cc.orgid(+) "+
					category;
				
				sql+=querywhere;
				
				sql+="GROUP BY A.ID,A.NAME,A.GUID "+
				"ORDER BY A.ID";
		sql+=") a";
		
		sql+=" union ";
		sql+="select '' id ,"+
                " '全部 ' || '(' || COUNT(*) || ')' NAME , "+
                " '' guid, "+
                " '"+url+"&crtusr=' url "+
		"from TRKHDR B, v_usr c, v_usr cc WHERE   "+
		"c.id = b.crtusr "+
		"and cc.id(+) = b.dtlusr "+
		"and b.AIMORG = c.orgid  "+
		"and b.AIMORG = cc.orgid(+) "+
		category;
           	sql+=querywhere;
		
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//
		
		//throw new Exception(sql);
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
		//msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&trkprj="+"';\">"+"全部"+"</a></td></tr>";//添加全部按钮
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//直接返回html语句

}

// 得到某个api的主界面
// 客户端: apiguid 对应FUNCLIST的guid
function apiquery()
{
	var db = null;
	var msg= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var loginusrid = usrinfo.getUsrid();
	var loginorgid = usrinfo.getusrOrg();	
	try {
	
		//msg += "<p align=center><B><font size=3 >"+ds.getStringAt(0,"title")+"<font></B></p>";
		//msg += "<p align=center><font size=2 color=#808080>"+ds.getStringAt(0,"crtusr")+" "+ds.getStringAt(0,"crttim")+"</font></p>";
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sql = "select a.SAMPLE,a.PARAMETER,a.PARAMNOTE,a.FUNCTION,a.return,a.note,a.name,a.FUNCNOTE,a.CRTDAT,a.id from FUNCLIST a where a.guid='"+apiguid+"'";
		//throw new Exception(sql);
		var ds = db.QuerySQL(sql);
		
		if ( ds.getRowCount() > 0 ) {
			var id = ds.getStringAt(0,"id");
			//if(ds.getStringAt(0,"name")!="")
				msg += "<p align=center><B><font size=3 >"+ds.getStringAt(0,"name")+"<font></B></p>";
			//msg += "<p align=center><font size=2 color=#808080>"+"创建日期 "+ds.getStringAt(0,"CRTDAT")+"</font></p>";
			msg += "<font size=2 ><br>"+"名称:<font size=2 color='#333333'> "+ds.getStringAt(0,"FUNCTION")+"</font>";
			msg += "<font size=2 ><br>"+"</font>方法定义:<font size=2 color='#333333'>"+ds.getStringAt(0,"FUNCNOTE")+"</font>";
			msg += "<br>"+"返回值:<font size=2 color='#333333'>"+ds.getStringAt(0,"return")+"</font>";
			msg += "<br>"+"功能说明:</font>";
			var note = ds.getStringAt(0,"note");
			note = pubpack.EAFunc.Replace(note,"\n","<br>");//替换换行键
			note = pubpack.EAFunc.Replace(note,"\r","<br>");//替换换行键
			note = pubpack.EAFunc.Replace(note,"\u0009","&nbsp;&nbsp;&nbsp;&nbsp;");//替换tab键
			msg += "<br><font size=2 color='#333333'>"+note+"</font>";
			
			
			//var id = ds.getStringAt(0,"id");
			var note = ds.getStringAt(0,"PARAMETER");
			note = pubpack.EAFunc.Replace(note,"\n","<br>");//替换换行键
			note = pubpack.EAFunc.Replace(note,"\r","<br>");//替换换行键
			note = pubpack.EAFunc.Replace(note,"\u0009","&nbsp;&nbsp;&nbsp;&nbsp;");//替换tab键
			msg += "<br><p align=left><font size=2  >参数:<font size=2 color='#333333'>"+note+"</font></p>";
			//msg += "<p align=center><font size=1 color=#808080>"+" "+ds.getStringAt(0,"PARAMNOTE")+"</font></p>";
			
			var PARAMNOTE = ds.getStringAt(0,"PARAMNOTE");
			PARAMNOTE = pubpack.EAFunc.Replace(PARAMNOTE,"\n","<br>");//替换换行键
			PARAMNOTE = pubpack.EAFunc.Replace(PARAMNOTE,"\r","<br>");//替换换行键
			PARAMNOTE = pubpack.EAFunc.Replace(PARAMNOTE,"\u0009","&nbsp;&nbsp;&nbsp;&nbsp;");//替换tab键
			//throw new Exception(note+"");
			msg += "<br><font size=2>参数说明:</font><br><font size=2 color='#333333'>"+PARAMNOTE+"</font>";
			
			var note = ds.getStringAt(0,"SAMPLE");
			note = pubpack.EAFunc.Replace(note,"\n","<br>");//替换换行键
			note = pubpack.EAFunc.Replace(note,"\r","<br>");//替换换行键
			note = pubpack.EAFunc.Replace(note,"\u0009","&nbsp;&nbsp;&nbsp;&nbsp;");//替换tab键
			//throw new Exception(note+"");
			msg += "<br><font size=2 >例子:</font><br><font size=2 color='#333333'"+note+"</font>";

		}
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}
// 得到某个api的类别,属性
function apiqueryclass()
{
	var db = null;
	var msg= "";
	var usrinfo = webpack.EASession.GetLoginInfo(request);
	var loginusrid = usrinfo.getUsrid();
	var loginorgid = usrinfo.getusrOrg();	
	try {

		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sql = "select a.guid,a.function, a.class, D.NAME flag, a.RLSNO, C.NAME lang, b.name SUBTYP, a.id
			  from FUNCLIST a ,V_FUNCSUBTYP B,V_FUNCLANG c,V_FUNCFLAG d 
			 where c.id(+)=a.lang and d.id(+)=a.flag AND B.ID(+)=A.SUBTYP and a.guid='"+apiguid+"'";
		//throw new Exception(sql);
		var ds = db.QuerySQL(sql);
		
		if ( ds.getRowCount() > 0 ) {
			var id = ds.getStringAt(0,"id");
			msg +="<font color=#014E82 size=2>";
			msg +="语言:"+ ds.getStringAt(0,"LANG")+"<br>";
			//msg +="名称:"+ ds.getStringAt(0,"function")+"<br>";
			msg +="类名:"+ ds.getStringAt(0,"class")+"<br>";
			msg +="标志:"+ ds.getStringAt(0,"flag")+"<br>";
			msg +="分类:"+ ds.getStringAt(0,"SUBTYP")+"<br>";
			msg +="支持版本:"+ ds.getStringAt(0,"RLSNO")+"<br>";
			msg +="</font></p>";

			var guid = ds.getStringAt(0,"guid");
			msg+="<p align=center><a href='show.sp?grdid=ACTIVEX&guid="+guid+"'>编辑</a></p>";

		}
		
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;
}


//搜索函数库api的列表
function searchapi(){ 
	
	var db = null;
	var msg= "";//是显示的html语句
	//	listtyp:  1 为我的待办事务 2 为我创建的事务 3为 日志
	var sql = "";
	var querywhere = "  (";//查询函数库的sql的条件语句
			var str=query.split(" ");
			  //throw new Exception(str);
			for(var i=0;i<str.length();i++)    
			{	
				if(i==0){
					querywhere+="  lower( concat(a.function, concat(a.name,concat(a.note,to_char(a.crtdat,'yyyy-mm-dd'))))) like lower('%"+str[i]+"%')"; 
				}else{
					querywhere+=" and lower( concat(a.function, concat(a.name,concat( a.note,to_char(a.crtdat,'yyyy-mm-dd'))))) like lower('%"+str[i]+"%')"; 
				}
			} 
		querywhere+=") ";
	var category = " and decode(a.lang,null,' ',a.lang) like '"+apilang+"%'"+
			"and decode(a.flag,null,' ', a.flag) like '"+apiflag+"%'"+
			"and decode(a.subtyp,null,' ', a.subtyp) like'"+apisubtyp+"%'";
	
	var sqlapi="select '' id,'' guid,'●'||a.function||'  (类名:'||a.CLASS||')'||'('||c.name||')'||'<br> &nbsp; '||a.name  name,'Layout.sp?id=apiquery&apiguid='||a.guid url from FUNCLIST a , V_FUNCSUBTYP B, V_FUNCLANG c, V_FUNCFLAG d
			 where c.id(+) = a.lang
			   and d.id(+) = a.flag
			   AND B.ID(+) = A.SUBTYP and "+querywhere+category;
	
	//throw new Exception(sqlapi);
	
	var url="Layout.sp?id=trkquery";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//编写格式,对齐方式为左对齐,置顶
		var ds = db.QuerySQL(sqlapi);
		//
		for( var i=0 ;i<ds.getRowCount()&&i<=500; i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
		//msg += "<tr><td width=100%  >------------------------------</td></tr>";
		//		//msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&guid=';\">"+"全部"+"</a></td></tr>";//添加全部按钮
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//直接返回html语句

}
//搜索api的语言分类列表 有全部按钮
function searchapilanglist(){
	var db = null;
	var msg= "";//是显示的html语句
	var url="Layout.sp?id=SearchAPI&query="+query+""+"&apiflag="+apiflag+"&apisubtyp="+apisubtyp;//单击的链接
	var sql="";
	var querywhere = "";
	var category = "";//分类查询条件
	// //添加查询条件
	var querywhere = "  (";//查询函数库的sql的条件语句
			var str=query.split(" ");
			  //throw new Exception(str);
			for(var i=0;i<str.length();i++)    
			{	
				if(i==0){
					querywhere+="  lower( concat(a.function, concat(a.name,concat(a.note,to_char(a.crtdat,'yyyy-mm-dd'))))) like lower('%"+str[i]+"%')"; 
				}else{
					querywhere+=" and lower( concat(a.function, concat(a.name,concat( a.note,to_char(a.crtdat,'yyyy-mm-dd'))))) like lower('%"+str[i]+"%')"; 
				}
			} 
		querywhere+=") ";
	category = //"and decode(a.lang,null,' ',a.lang) like '"+apilang+"%'"+
			"and decode(a.flag,null,' ', a.flag) like '"+apiflag+"%'"+
			"and decode(a.subtyp,null,' ', a.subtyp) like'"+apisubtyp+"%'";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sql = "select * from (";
				sql+="SELECT c.ID,c.NAME||'('||COUNT(*)||')' NAME,c.GUID ,'"+
					url+"&apilang='|| c.id  url "+
					"from FUNCLIST a , V_FUNCSUBTYP B, V_FUNCLANG c, V_FUNCFLAG d
					 where c.id(+) = a.lang
					   and d.id(+) = a.flag
					   AND B.ID(+) = A.SUBTYP "+
					category;
				
				sql+=" and "+querywhere;
				
				sql+="GROUP BY c.ID,c.NAME,c.GUID "+
				"ORDER BY c.ID";
		sql+=") a";
		
		sql+=" union ";
		sql+="select '' id ,"+
                " '全部 ' || '(' || COUNT(*) || ')' NAME , "+
                " '' guid, "+
                " '"+url+"&apilang=' url "+
		"from FUNCLIST a , V_FUNCSUBTYP B, V_FUNCLANG c, V_FUNCFLAG d
					 where c.id(+) = a.lang
					   and d.id(+) = a.flag
					   AND B.ID(+) = A.SUBTYP "+
		category;
           	sql+=" and "+querywhere;

		
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//
		
		//throw new Exception(sql);
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
		//msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&trkprj="+"';\">"+"全部"+"</a></td></tr>";//添加全部按钮
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//直接返回html语句

}
//搜索api的标志分类列表 有全部按钮
function searchapiflaglist(){
	var db = null;
	var msg= "";//是显示的html语句
	var url="Layout.sp?id=SearchAPI&query="+query+""+"&apilang="+apilang+"&apisubtyp="+apisubtyp;//单击的链接

	var sql="";
	var querywhere = "";
	var category = "";//分类查询条件
	// //添加查询条件
	var querywhere = "  (";//查询函数库的sql的条件语句
			var str=query.split(" ");
			  //throw new Exception(str);
			for(var i=0;i<str.length();i++)    
			{	
				if(i==0){
					querywhere+="  lower( concat(a.function, concat(a.name,concat(a.note,to_char(a.crtdat,'yyyy-mm-dd'))))) like lower('%"+str[i]+"%')"; 
				}else{
					querywhere+=" and lower( concat(a.function, concat(a.name,concat( a.note,to_char(a.crtdat,'yyyy-mm-dd'))))) like lower('%"+str[i]+"%')"; 
				}
			} 
		querywhere+=") ";
	category = "and decode(a.lang,null,' ',a.lang) like '"+apilang+"%'"+
			//"and decode(a.flag,null,' ', a.flag) like '"+apiflag+"%'"+
			"and decode(a.subtyp,null,' ', a.subtyp) like'"+apisubtyp+"%'";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sql = "select * from (";
				sql+="SELECT d.ID,d.NAME||'('||COUNT(*)||')' NAME,d.GUID ,'"+
					url+"&apiflag='|| d.id  url "+
					"from FUNCLIST a , V_FUNCSUBTYP B, V_FUNCLANG c, V_FUNCFLAG d
					 where c.id(+) = a.lang
					   and d.id(+) = a.flag
					   AND B.ID(+) = A.SUBTYP "+
					category;
				
				sql+=" and "+querywhere;

				
				sql+="GROUP BY d.ID,d.NAME,d.GUID "+
				"ORDER BY d.ID";
		sql+=") a";
		
		sql+=" union ";
		sql+="select '' id ,"+
                " '全部 ' || '(' || COUNT(*) || ')' NAME , "+
                " '' guid, "+
                " '"+url+"&apiflag=' url "+
		"from FUNCLIST a , V_FUNCSUBTYP B, V_FUNCLANG c, V_FUNCFLAG d
					 where c.id(+) = a.lang
					   and d.id(+) = a.flag
					   AND B.ID(+) = A.SUBTYP "+
		category;
           	sql+=" and "+querywhere;

		
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//
		
		//throw new Exception(sql);
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
		//msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&trkprj="+"';\">"+"全部"+"</a></td></tr>";//添加全部按钮
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//直接返回html语句

}
//搜索api按分类列表 有全部按钮
function searchAPIsubtyplist(){
	var db = null;
	var msg= "";//是显示的html语句
	var url="Layout.sp?id=SearchAPI&query="+query+""+"&apiflag="+apiflag+"&apilang="+apilang;//单击的链接
	var sql="";
	var querywhere = "";
	var category = "";//分类查询条件
	// //添加查询条件
	var querywhere = "  (";//查询函数库的sql的条件语句
			var str=query.split(" ");
			  //throw new Exception(str);
			for(var i=0;i<str.length();i++)    
			{	
				if(i==0){
					querywhere+="  lower( concat(a.function, concat(a.name,concat(a.note,to_char(a.crtdat,'yyyy-mm-dd'))))) like lower('%"+str[i]+"%')"; 
				}else{
					querywhere+=" and lower( concat(a.function, concat(a.name,concat( a.note,to_char(a.crtdat,'yyyy-mm-dd'))))) like lower('%"+str[i]+"%')"; 
				}
			} 
		querywhere+=") ";
	category = "and decode(a.lang,null,' ',a.lang) like '"+apilang+"%'"+
			"and decode(a.flag,null,' ', a.flag) like '"+apiflag+"%'";
			//"and decode(a.subtyp,null,' ', a.subtyp) like'"+apisubtyp+"%'";
	try {
		db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubpack.EADatabase(“dbname”)
		var sql = "select * from (";
				sql+="SELECT b.ID,b.NAME||'('||COUNT(*)||')' NAME,b.GUID ,'"+
					url+"&apisubtyp='|| b.id  url "+
					"from FUNCLIST a , V_FUNCSUBTYP B, V_FUNCLANG c, V_FUNCFLAG d
					 where c.id(+) = a.lang
					   and d.id(+) = a.flag
					   AND B.ID(+) = A.SUBTYP "+
					category;
				
				sql+=" and "+querywhere;

				
				sql+="GROUP BY b.ID,b.NAME,b.GUID "+
				"ORDER BY b.ID";
		sql+=") a";
		sql+=" union ";
		sql+="select '' id ,"+
                " '全部 ' || '(' || COUNT(*) || ')' NAME , "+
                " '' guid, "+
                " '"+url+"&apisubtyp=' url "+
		"from FUNCLIST a , V_FUNCSUBTYP B, V_FUNCLANG c, V_FUNCFLAG d
					 where c.id(+) = a.lang
					   and d.id(+) = a.flag
					   AND B.ID(+) = A.SUBTYP "+
		category;
           	sql+=" and "+querywhere;

		
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";//
		
		//throw new Exception(sql);
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+ds.getStringAt(i,"url")+"';\">"+ds.getStringAt(i,"name")+"</a></td></tr>";
		}
		//msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&trkprj="+"';\">"+"全部"+"</a></td></tr>";//添加全部按钮
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//直接返回html语句

}
//显示搜索api的条件
function searchapiquery(){
	var db = null;
	db = new pubpack.EADatabase();
	var msg= "全部结果 <br> 关键字 \""+query+"\" </br>";//是显示的html语句
	var sql=""; 
	// 查找项目
		sql = "select '语言:'||b.name name from V_FUNCLANG b where b.id = '"+apilang+"'" ;
		var ds = db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			msg += ds.getStringAt(0,"name")+"<BR>";
		}
	// 查找创建人
		sql = "select '标志:'||b.name name  from V_FUNCFLAG b where b.id = '"+apiflag+"'" ;
		ds = db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			msg += ds.getStringAt(0,"name")+"<BR>";
		}
		
	// 查找事务类型
		sql = "select '类型:'||b.name||'<BR>说明:'||b.note||'<BR>' name from V_FUNCSUBTYP b where b.id = '"+apisubtyp+"'" ;
		ds = db.QuerySQL(sql);
		if ( ds.getRowCount() > 0 ) {
			msg += ds.getStringAt(0,"name");
			//msg+="<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='show.sp?grdid=HDRTRK&style="+trktyp+"&edit=save&dd=0&prj="+trkprj+"' target=\"_blank\">新增事务>></a>";
		}

	return msg;
}

//手机端快捷新增事务的列表
function wapNewTrklist(){
	//return "";
	var db = null;
	var msg= "";//是显示的html语句
	
	//var url="Layout.sp?id=SearchAPI&query="+query+""+"&apilang="+apilang+"&apisubtyp="+apisubtyp;//单击的链接

	var sql="select name,url,id,guid from SYSURL where refid='3A事务快速新增' order by seqid";
	
	try{ 
		msg=msg+"<td valign=\"top\">"+
		"<font color=\"#014E82\">"+
		"<table width=\"100%\" align=\"left\" border=\"0\" cellpadding=\"1\">"+
		"<tbody>";
		
		db = new pubpack.EADatabase();
		var ds = db.QuerySQL(sql);
		for( var i=0 ;i<ds.getRowCount(); i++ ) {
			if(i!=0&&(i%2=="0")){
				msg = msg+"<br>";
			}
			msg = msg + "<a href='"+ds.getStringAt(i,"url")+"'>"+ds.getStringAt(i,"name")+"</a>";
			msg += "&nbsp;&nbsp;&nbsp;&nbsp;";
		}
		
		//msg = msg+"<tr> <td width=100%  ><a href='#' onclick=\"javascript:window.location='"+url+"&trkprj="+"';\">"+"全部"+"</a></td></tr>";//添加全部按钮
		msg=msg+"</tbody>"+"</table>"+"</font>"+"</td>";
		
	}
	catch ( ee ) {
		db.Rollback();
		throw new pubpack.EAException ( ee.toString() );
	}
	finally {
		if (db!=null) db.Close();
	}
	return msg;//直接返回html语句

}




}