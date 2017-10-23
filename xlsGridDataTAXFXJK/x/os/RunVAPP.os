function x_RunVAPP(){var pub = new JavaPackage ( "com.xlsgrid.net.pub" );
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

function loadFlowSvg() 
{
	var usrinfo = web.EASession.GetLoginInfo(request);
	var filename = pub.EAOption.dynaDataRoot+ pub.EAOption.get("xmldb.file.grddb")+"/syt" + syt + "/" + filename;
	var svg = pub.EAFunc.readFile(filename);
	
// 	for ( var i=0;i<24;i++ ) 
// 		pub.EADbTool.ExcecutSQL("insert into param( typ,id,name ) values('HH','"+i+"','"+i+"点' ) ");
// 	for ( var i=0;i<60;i++ ) 
// 		pub.EADbTool.ExcecutSQL("insert into param( typ,id,name ) values('MM','"+i+"','"+i+"分' ) ");
	
	return svg;
}
//页面BODY处理完毕后事件
//sb里面是body元素及前面的head内容
//bodysb里面是body的innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{

}

//添加额外html
//afterBodyHtml事件后触发，已过时，建议用afterBodyHtml事件进行处理
function addBottomHtml(mwobj,request,sb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	var db = null;
	
	
	var msg= "";
	var vappid = pubpack.EAFunc.NVL( request.getParameter("vappid"),"");
	var thissytid = pubpack.EAFunc.NVL( request.getParameter("thissytid"),"");
	if ( vappid == ""||thissytid =="" ) {
		sb.append("<script>alert('传入的vappid,thissytid参数不能为空')</script>");
		
	}
	else {
		try {
			db = new pubpack.EADatabase();	// 如果连接到其他数据库, new pubvar pack.EADatabase(“dbname”)
			var sql = "select * from vapp where id='"+vappid+"' and sytid='"+thissytid+"'";
			var ds = db.QuerySQL(sql);
			if ( ds.getRowCount() == 0 ) {
				sb.append("<script>alert('该虚拟化应用ID("+vappid+")不存在')</script>");
			}	
			else {
				var fulls = "FALSE"; if ( ds.getStringDef(0,"APPFULLSCR","")=="1" ) fulls ="TRUE";
				var appurl = ds.getStringDef(0,"APPURL","");
				var vapphost = ds.getStringDef(0,"SERVERNAME","localhost");
				var vappusrid = ds.getStringDef(0,"USRID","administrator");
				var vappusrpwd = ds.getStringDef(0,"USERPWD","administrator");
				try {
					
					var gotods = db.QuerySQL("select * from vapp_user where useflg='1' and usrguid=(select guid from usr where id='"+usrinfo.getUsrid()+"' and org='"+usrinfo.getOrgid()+"')" );
					
					if ( gotods.getRowCount()>0 ) {
						vappusrid = gotods.getStringAt(0,"USRID");
						vappusrpwd = gotods.getStringAt(0,"USERPWD");
						vapphost = gotods.getStringAt(0,"HOSTIP");
						
					}
				}
				catch( ee ) {//可能是没有建立该表
					try{db.ExcecutSQL("create table VAPP_USER ( GUID CHAR(32) default SYS_GUID()  not null ,USRID VARCHAR2(256),USERPWD VARCHAR2(256),	HOSTIP VARCHAR2(256),	USEFLG CHAR(1) default '0',	USRGUID CHAR(32) )");
					}catch ( eee ) {}
				}
				//5,2,3790,3959   #version=6.1.7601.17514
				appurl=pubpack.EAFunc.Replace(appurl, "/", "\\\\"); //style=\"display:none\"
				sb.append("<table align=center valign=middle name=\"tab_vapp\" id=\"tab_vapp\" border=\"0\" width=\"100%\" cellspacing=\"0\" bgcolor=\"#C0C0C0\" height=\"100%\" ><tr><td align=\"center\">
					<OBJECT name=\"VAPP\"
					CLASSID=\"CLSID:7584c670-2274-4efb-b00b-d6aaba6d3850\"
					CODEBASE=\"msrdp.cab\"  
					WIDTH=\""+ds.getStringDef(0,"APPWIDTH","800")+"\"   
					HEIGHT=\""+ds.getStringDef(0,"APPHEIGHT","600")+"\" border=\"1\">
					</OBJECT>
					</td></tr></table>
					<script language=\"javascript\">
					function LoadVAPP(){

						try {
							VAPP.DesktopWidth=\""+ds.getStringDef(0,"APPWIDTH","800")+"\"; //远程桌面的宽和高
							VAPP.DesktopHeight=\""+ds.getStringDef(0,"APPHEIGHT","600")+"\";
							VAPP.FullScreen=\""+fulls +"\";
							VAPP.server=\""+vapphost +"\";
							VAPP.UserName =\""+vappusrid+"\";
							
							VAPP.AdvancedSettings2.ClearTextPassword=\""+vappusrpwd +"\";
							VAPP.AdvancedSettings2.RedirectDrives=\"FALSE\";
							VAPP.AdvancedSettings2.RedirectPrinters=\"TRUE\";
							VAPP.AdvancedSettings2.RedirectPorts=\"FALSE\";
							VAPP.AdvancedSettings2.RedirectSmartCards=\"FALSE\";
							
							VAPP.SecuredSettings.StartProgram = \""+appurl+"\";
							VAPP.Connect();
							
						}
						catch ( e ) {
							try {
								
								VAPP.FullScreen = true;
								VAPP.DesktopWidth = \""+ds.getStringDef(0,"APPWIDTH","800")+"\";
								VAPP.DesktopHeight = \""+ds.getStringDef(0,"APPHEIGHT","600")+"\";
								VAPP.Width = \""+ds.getStringDef(0,"APPWIDTH","800")+"\";
								VAPP.Height = \""+ds.getStringDef(0,"APPHEIGHT","600")+"\";
								
								//Device redirection options
								VAPP.AdvancedSettings2.RedirectDrives  = false;
								VAPP.AdvancedSettings2.RedirectPrinters= true;
								VAPP.AdvancedSettings2.RedirectPorts= false;
								VAPP.AdvancedSettings2.RedirectSmartCards = false;
								
								//Set Settings and passed RDP File Content
								VAPP.VAPPShell.PublicMode = false;
								VAPP.VAPPShell.RdpFileContents = unescape(appurl);
								VAPP.authenticationlevel = 2;
								VAPP.negotiatesecuritylayer = 1;
								VAPP.promptforcredentials = 0;
								
								//Set User Credentials
								VAPP.TransportSettings2.GatewayDomain = vapphost ;
								VAPP.TransportSettings2.GatewayUsername = vappusrid;
								//VAPP.TransportSettings2.GatewayPassword = vappusrpwd ;
								
								
								//Execute the RDP Object
								VAPP.VAPPShell.Launch()
							
							}
							catch ( ee ) {
							
								alert ( \"VAPP环境运行出错，请确认是否客户端控件是否安装，以及本站点已加入到可信站点。\" + e);
							}
						}
						
					
						
					}
					</script> " );
				sb.append("<script> var G_VAPPID='"+vappid+"';var G_VAPPNAME='"+ds.getStringDef(0,"NAME","") +"';</script>");
			}
		}
		catch ( ee ) {
			db.Rollback();
			throw new pubpack.EAException ( ee.toString() );
		}
		finally {
			if (db!=null) db.Close();
		}
	}
	
  

}

}