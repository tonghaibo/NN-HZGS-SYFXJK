function x_RunVAPPSVGFORM(){var pub = new JavaPackage ( "com.xlsgrid.net.pub" );
var web = new JavaPackage ( "com.xlsgrid.net.web" );
var pubpack = new JavaPackage ( "com.xlsgrid.net.pub" );

function loadFlowSvg() 
{
	var usrinfo = web.EASession.GetLoginInfo(request);
	var filename = pub.EAOption.dynaDataRoot+ pub.EAOption.get("xmldb.file.grddb")+"/syt" + syt + "/" + filename;
	var svg = pub.EAFunc.readFile(filename);
	
// 	for ( var i=0;i<24;i++ ) 
// 		pub.EADbTool.ExcecutSQL("insert into param( typ,id,name ) values('HH','"+i+"','"+i+"��' ) ");
// 	for ( var i=0;i<60;i++ ) 
// 		pub.EADbTool.ExcecutSQL("insert into param( typ,id,name ) values('MM','"+i+"','"+i+"��' ) ");
	
	return svg;
}
//ҳ��BODY������Ϻ��¼�
//sb������bodyԪ�ؼ�ǰ���head����
//bodysb������body��innerHTML
function afterBodyHtml(mwobj,request,sb,bodysb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var bodysb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{

}

//��Ӷ���html
//afterBodyHtml�¼��󴥷����ѹ�ʱ��������afterBodyHtml�¼����д���
function addBottomHtml(mwobj,request,sb,usrinfo)
//var mwobj=grd.EAMidWareBase();var request=javax.servlet.http.HttpServletRequest();var sb = new java.lang.StringBuffer();var usrinfo = new web.EAUserinfo();
{
	var db = null;
	var msg= "";
	var vappid = pubpack.EAFunc.NVL( request.getParameter("vappid"),"");
	var thissytid = pubpack.EAFunc.NVL( request.getParameter("thissytid"),"");
	if ( vappid == ""||thissytid =="" ) {
		sb.append("<script>alert('�����vappid,thissytid��������Ϊ��')</script>");

	}
	else {
		try {
			db = new pubpack.EADatabase();	// ������ӵ��������ݿ�, new pubpack.EADatabase(��dbname��)
			var sql = "select * from vapp where id='"+vappid+"' and sytid='"+thissytid+"'";
			var ds = db.QuerySQL(sql);
			if ( ds.getRowCount() == 0 ) {
				sb.append("<script>alert('�����⻯Ӧ��ID("+vappid+")������')</script>");
			}	
			else {
				var fulls = "FALSE"; if ( ds.getStringDef(0,"APPFULLSCR","")=="1" ) fulls ="TRUE";
				var appurl = ds.getStringDef(0,"APPURL","");
				appurl=pubpack.EAFunc.Replace(appurl, "/", "\\\\"); //style=\"display:none\"
				sb.append("<div name=\"tab_vapp\" id=\"tab_vapp\" align=left >
					<OBJECT name=\"VAPP\"
					CLASSID=\"CLSID:7584c670-2274-4efb-b00b-d6aaba6d3850\"
					CODEBASE=\"msrdp.cab\" 
					WIDTH=\""+ds.getStringDef(0,"APPWIDTH","800")+"\"   
					HEIGHT=\""+ds.getStringDef(0,"APPHEIGHT","600")+"\">
					</OBJECT>
					</div>
					<script language=\"javascript\">
					function LoadVAPP(){
						VAPP.DesktopWidth=\""+ds.getStringDef(0,"APPWIDTH","800")+"\"; //Զ������Ŀ�͸�
						VAPP.DesktopHeight=\""+ds.getStringDef(0,"APPHEIGHT","600")+"\";
						VAPP.FullScreen=\""+fulls +"\";
						VAPP.server=\""+ds.getStringDef(0,"SERVERNAME","localhost")+"\";
						VAPP.UserName =\""+ds.getStringDef(0,"USRID","administrator")+"\";
						VAPP.AdvancedSettings2.ClearTextPassword=\""+ds.getStringDef(0,"USERPWD","administrator")+"\";
						VAPP.AdvancedSettings2.RedirectDrives=\"FALSE\";
						VAPP.AdvancedSettings2.RedirectPrinters=\"FALSE\";
						VAPP.AdvancedSettings2.RedirectPorts=\"FALSE\";
						VAPP.AdvancedSettings2.RedirectSmartCards=\"FALSE\";
						VAPP.SecuredSettings.StartProgram = \""+appurl+"\";
					
						VAPP.Connect();
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